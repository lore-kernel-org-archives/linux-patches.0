Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9B472530;
	Tue, 21 Jul 2026 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665672; cv=none; b=KHQY10G9+rRtfkfXD++Xgf5a0/pLi5MdcHgqALBuUxY7ppwOPHo5SJ8O1q0zLHUPCc7P0UIc4KoqUVdXfdhhexXm9TedLwKu3O0hMB7I35DCqG3jlCwraSd6aFtESaXuPkEG2YLAbp/8sFUn7z7kEpzcDINcdyIHT3/uTcGjr1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665672; c=relaxed/simple;
	bh=EfdYXe/PfDIQcZQqVO6Ym/Y0hvrcMWRgNCQw/5EwRko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXSOPlUAYMXnJfinRgBkNSPMfXpyfr71XPfJNc/izV/bY0SJtYkLV2FWqaisIlx44WRCRS/+IeYpWBkO5KBOnmhTBhOhZmgGw758E5dvR9AwIHsRjsAsj45mg3m6dV66J9E/83KRfZKuCoWnvCqLQ+4nSAdhGaZhq5TvhzvMp+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0xnbKc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0xnbKc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45CE1F00A3D;
	Tue, 21 Jul 2026 20:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665668;
	bh=4Vos7CoB/OO6qxY2VfEVoQ4IrMcSljRuVZX7XHUDDr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0xnbKc3d5vfCsDwyb1IOB1mDCzZDp2GAc+KhAbLR5FgiKpfLerBcnz+Uz5tLWRTe
	 9uwftPjxdhoAOxJltIHGtA8RS0wZb5hPLIn0Xyy+SXKCsPuEcbnS/MNpk+5GdQ8Hu3
	 P+89ILsp5QVVjIi+1QlB2a3DnQVPLeLVZbPOdBWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0391/1266] nilfs2: fix backing_dev_info reference leak
Date: Tue, 21 Jul 2026 17:13:48 +0200
Message-ID: <20260721152450.576816435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 665f192a2a11384cb7dc1be5f87d16438522a4ed ]

setup_bdev_super() already initializes sb->s_bdev and takes a
reference on the block device backing_dev_info when assigning sb->s_bdi.

nilfs_fill_super() takes another reference to the same
backing_dev_info and stores it in sb->s_bdi again. The extra
reference is not paired with a matching bdi_put(), since
generic_shutdown_super() releases sb->s_bdi only once.

Drop the redundant bdi_get() in nilfs_fill_super(). The single
reference taken by setup_bdev_super() is enough and is released
during superblock shutdown.

Fixes: c1e012ea9e83 ("nilfs2: use setup_bdev_super to de-duplicate the mount code")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index a5d1fa4e7552f6..e14039ac792fe0 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1086,8 +1086,6 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
-
 	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
-- 
2.53.0



