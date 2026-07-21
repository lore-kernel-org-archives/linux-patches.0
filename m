Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F453EEAC7;
	Tue, 21 Jul 2026 19:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661530; cv=none; b=fx/sJbepH5FnCGJpBKJYrhEALqh853Av8CYoJvIovJiQyMbx2IkaSSdJfIpW+T1YBKMqeBmVINJob3Jo25JW2WrWs3e8K5OOGamGX8YkvDKmStSjT7C8hbWWca2zvcx3yCZocQByIdtj1i8ZJU01NMTjMqGe7kNJ6ki4nwvdGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661530; c=relaxed/simple;
	bh=eK7YGQ2LGZx9ZPwpKCv8cCcE1AkCoL83YofzA1qrKzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIrZ7lL/CqGZ4MMWt8VWXIfUM5kMi6ZiucZmRQ9RMGMRsdyKy4Hp1kwsdEwDvzswsDsnHwWYnfIq57GpcKj2KffTjpsjXWYQI9HHfZYrL5IS47av50zBRnQ2csVUij3a3OnxYFQDtSxnVehRl0D8CCSsi4SlLARa4Eqm9suwd/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTaDwbaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTaDwbaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B832A1F000E9;
	Tue, 21 Jul 2026 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661529;
	bh=148ljArkhV59Z6NVzQdl3mtDU+KLZDzebTSWFKSjTgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTaDwbazbkda2KoXUFkZLxvHjTJ77hr1AygY0qIOxXrMkqT1uyptCYz7UVu3IF1Gt
	 5tMw+J0i9eM04IRw42/P4I6EJnXV4AZi2MHnpwuH171ZBEMGwPORJkicXwwaI/nbBD
	 yowmfX+e3cKaKhtfNrk7cp5ihM0+4jlRqTS7V+ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0102/1276] nilfs2: fix backing_dev_info reference leak
Date: Tue, 21 Jul 2026 17:09:05 +0200
Message-ID: <20260721152448.377687848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eca79cca3803df..7ed64df82d1bde 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1062,8 +1062,6 @@ nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_gran = 1;
 	sb->s_max_links = NILFS_LINK_MAX;
 
-	sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
-
 	err = load_nilfs(nilfs, sb);
 	if (err)
 		goto failed_nilfs;
-- 
2.53.0



