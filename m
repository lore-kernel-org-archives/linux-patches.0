Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1546AA6B;
	Tue, 21 Jul 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648369; cv=none; b=HprCAvwZ06uR5dRs03OQO+S9/Eh7HPKI0YBRi/zUXa3twIuw0Ztu/jiUZ4rR+MX08nn2NQe4leToe/3hx+lVMWGoKk0nd8BwXqD0syg6G6mun35XxJ68OjPHkOqfDsGDZtovqjd4Gn1s+pMenBiTKktc66Qgd65c5mfGmv9PDkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648369; c=relaxed/simple;
	bh=fbi9aT0qK1dcRCRxIRcWSSt90QRCKF1a+N51XrGiAIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa5k3Ql8xwxxl2wRo7uUyMDzHz2jVzXMPup3N+FcsUyY1qPEtuVcrDOaSptwkH7l2QApdPenTC4VV5Be7dllKWrE8b/f4fGoixecn401ruZJSy6hgtUWpd12Od+nDoxEtatinvc16JaOufKYbiTuMmkx3t7tnlB+gHmWuPJN2AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bt6e8duS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bt6e8duS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9AD1F000E9;
	Tue, 21 Jul 2026 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648368;
	bh=bMUN7hHRA8O580WDTZBfhYzfmtfk8vvLGeVGUPDw2QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bt6e8duS/O+OsCXp4T6smqT9Pz6w7/n7TSVx+4slAi3r2l3Wtv/Bk8OcN8x1pWggk
	 sl+54h/+cxQwOa5VAHS/Hn7jZnTxTF9BthM3USxmYyV0rerAgvsBwgxYjgvl8+nOhu
	 2Q2S//1ZpC/Ov15yXc7EK+jEmsWdLINnVzuMl0l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0171/2077] nilfs2: fix backing_dev_info reference leak
Date: Tue, 21 Jul 2026 16:57:24 +0200
Message-ID: <20260721152556.721437358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7aa5ef8606cdd4..893a504cb80c8a 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1070,8 +1070,6 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
-
 	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
-- 
2.53.0



