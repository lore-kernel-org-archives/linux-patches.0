Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A2F207E14;
	Tue,  8 Apr 2025 11:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111475; cv=none; b=K8Tyi3yAJr162mIrxkCmUmt3fQw7CZ+lUrrGUGqv0zTAHJNCxjulz+pOmDZDIUnALSzfXE8C/nkc7yhyYU8ihDdwaVbobEzUgbrHVNDijF5uH6dbWdC29bDCnj6ZYoGyYudQdBIybPAoZMG8y6AXTTLwmSnLjZPAZqddhQuf1HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111475; c=relaxed/simple;
	bh=1YM1ePZbmXFaEEJnQGnsfpkLAR1DAq1QWuVECotLMOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/YktyOdcLvtzSnHJevqFHnsfNSIjKOsrzwKv1Srf6x2SMmTnZvUKx30AHwNG9T/2imbIMjFP8fSWnayIm+gLBY62s79+nYm9Me1+m5D1jCDCF2LGzjW0+wxuAc8Zz6EJukLXE5yy/1J2opmThQ09qCAhwYWFvKFm8MRmUnBtmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ky0JpLRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ky0JpLRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96985C4CEE5;
	Tue,  8 Apr 2025 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111474;
	bh=1YM1ePZbmXFaEEJnQGnsfpkLAR1DAq1QWuVECotLMOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ky0JpLRwNOx2EXWUYmqNfR5BxSadiBDCnSP0SGE9fpZ2nKy2iw35Fj512qvaUTVWq
	 2PH81/nR/520hUFGeppvy5jUfBAiaPNGqctpij0psmqq3c4cKw6WOSDrvcWz6MqFeT
	 T0EACHgHtUYk2KZjwb12O9S3k68TC+WsNWeam3as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 444/731] fs/ntfs3: Factor out ntfs_{create/remove}_proc_root()
Date: Tue,  8 Apr 2025 12:45:41 +0200
Message-ID: <20250408104924.601239118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit c5a396295370fa99ddc0c4c4d25f8a3ee4f013d8 ]

Introduce ntfs_create_proc_root()/ntfs_remove_proc_root() for
create/remove "/proc/fs/ntfs3".

Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 1d1a7e252549 ("fs/ntfs3: Fix 'proc_info_root' leak when init ntfs failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 415492fc655ac..66047cf0e6e81 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -586,9 +586,24 @@ static void ntfs_remove_procdir(struct super_block *sb)
 	remove_proc_entry(sb->s_id, proc_info_root);
 	sbi->procdir = NULL;
 }
+
+static void ntfs_create_proc_root(void)
+{
+	proc_info_root = proc_mkdir("fs/ntfs3", NULL);
+}
+
+static void ntfs_remove_proc_root(void)
+{
+	if (proc_info_root) {
+		remove_proc_entry("fs/ntfs3", NULL);
+		proc_info_root = NULL;
+	}
+}
 #else
 static void ntfs_create_procdir(struct super_block *sb) {}
 static void ntfs_remove_procdir(struct super_block *sb) {}
+static void ntfs_create_proc_root(void) {}
+static void ntfs_remove_proc_root(void) {}
 #endif
 
 static struct kmem_cache *ntfs_inode_cachep;
@@ -1866,10 +1881,7 @@ static int __init init_ntfs_fs(void)
 	if (IS_ENABLED(CONFIG_NTFS3_LZX_XPRESS))
 		pr_info("ntfs3: Read-only LZX/Xpress compression included\n");
 
-#ifdef CONFIG_PROC_FS
-	/* Create "/proc/fs/ntfs3" */
-	proc_info_root = proc_mkdir("fs/ntfs3", NULL);
-#endif
+	ntfs_create_proc_root();
 
 	err = ntfs3_init_bitmap();
 	if (err)
@@ -1903,11 +1915,7 @@ static void __exit exit_ntfs_fs(void)
 	unregister_filesystem(&ntfs_fs_type);
 	unregister_as_ntfs_legacy();
 	ntfs3_exit_bitmap();
-
-#ifdef CONFIG_PROC_FS
-	if (proc_info_root)
-		remove_proc_entry("fs/ntfs3", NULL);
-#endif
+	ntfs_remove_proc_root();
 }
 
 MODULE_LICENSE("GPL");
-- 
2.39.5



