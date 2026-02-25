Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E221D5141;
	Wed, 25 Feb 2026 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983509; cv=none; b=Y9J28LOjMch+8JS7ZrIgsiAGlKb6jWtw7DPU25j/lq+aRyhyNlQWwypMscGNPOD7KMNNcW3ZQy8FWHox9/LJBY+dJLgSVSolwGk7GxK/xpugv2ZN+51eFy2cHDQzE1gZraxPjKo9fjA6ku0AIpooQwaKofGG/0eOW3LFgLP2iGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983509; c=relaxed/simple;
	bh=MiNK1y/cjldeRorKjqniF/c0H2sTJtGk79riODAl1XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teauH7TxEvkTA7smpFEdiaOkcHSoTZsYW1i5jaONHC0Otq+fqwxiHIXs6q7MqCTjCBBCnN9KwIYQxamleiUsYAxqv3tdqx876VS+zRFNxRav+H+QRBXPaWZ2Su9N34p57zNvPEMPvoqXkAfk1r+PUCRFRjlki4BiS/s2+uAtk9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgUe0lEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgUe0lEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BA1C19424;
	Wed, 25 Feb 2026 01:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983509;
	bh=MiNK1y/cjldeRorKjqniF/c0H2sTJtGk79riODAl1XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgUe0lENwlh3XK57F4rOsHgqovI00L6rS5vGjbpW4cN2wuHE8+4gimblQ6yvTSe+P
	 FU+vdGlPrS9jTl4KEvC74Z6w3y4JJ6P05s5epoQQTiaEjSGJ8Yvdfy3rC0GTIXpy7U
	 rMnOprQ3I59aWaClRxOG/f52y2i+qNnfHZJM0V9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+23aee7afc440fe803545@syzkaller.appspotmail.com,
	Baokun Li <libaokun1@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 616/781] fs/ntfs3: fix ntfs_mount_options leak in ntfs_fill_super()
Date: Tue, 24 Feb 2026 17:22:05 -0800
Message-ID: <20260225012414.910464549@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit f7edab0cee03a1cbe0e55a7bcab8d2d8b6b74278 ]

In ntfs_fill_super(), the fc->fs_private pointer is set to NULL without
first freeing the memory it points to. This causes the subsequent call to
ntfs_fs_free() to skip freeing the ntfs_mount_options structure.

This results in a kmemleak report:

  unreferenced object 0xff1100015378b800 (size 32):
    comm "mount", pid 582, jiffies 4294890685
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 ed ff ed ff 00 04 00 00  ................
    backtrace (crc ed541d8c):
      __kmalloc_cache_noprof+0x424/0x5a0
      __ntfs_init_fs_context+0x47/0x590
      alloc_fs_context+0x5d8/0x960
      __x64_sys_fsopen+0xb1/0x190
      do_syscall_64+0x50/0x1f0
      entry_SYSCALL_64_after_hwframe+0x76/0x7e

This issue can be reproduced using the following commands:
        fallocate -l 100M test.file
        mount test.file /tmp/test

Since sbi->options is duplicated from fc->fs_private and does not
directly use the memory allocated for fs_private, it is unnecessary to
set fc->fs_private to NULL.

Additionally, this patch simplifies the code by utilizing the helper
function put_mount_options() instead of open-coding the cleanup logic.

Reported-by: syzbot+23aee7afc440fe803545@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23aee7afc440fe803545
Fixes: aee4d5a521e9 ("ntfs3: fix double free of sbi->options->nls and clarify ownership of fc->fs_private")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 8b0cf0ed4f72c..0567a3b224ed3 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -705,9 +705,7 @@ static void ntfs_put_super(struct super_block *sb)
 	ntfs_set_state(sbi, NTFS_DIRTY_CLEAR);
 
 	if (sbi->options) {
-		unload_nls(sbi->options->nls);
-		kfree(sbi->options->nls_name);
-		kfree(sbi->options);
+		put_mount_options(sbi->options);
 		sbi->options = NULL;
 	}
 
@@ -1253,7 +1251,6 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		}
 	}
 	sbi->options = options;
-	fc->fs_private = NULL;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
@@ -1679,9 +1676,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 out:
 	/* sbi->options == options */
 	if (options) {
-		unload_nls(options->nls);
-		kfree(options->nls_name);
-		kfree(options);
+		put_mount_options(sbi->options);
 		sbi->options = NULL;
 	}
 
-- 
2.51.0



