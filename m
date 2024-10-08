Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472121DE4CB;
	Tue,  8 Oct 2024 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394169; cv=none; b=F2df9f619cpWSuLMxKLxdpETtu9FBf8hu6e1hPsoc3+kU5LIHpP7ssax0rKvFOcE9dgAXAQMHms9BI9WhK9FhFNwHiYMYvPk1ZND5jRdEePtARiiOG7WWV9Va5rgJo5wmHVP3l+VrtIwnjLY/9t4ZIaz4Iw8dKYZdTT5v56nfz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394169; c=relaxed/simple;
	bh=J9K22ArcGlpDKFm0zKGAZydCBNfxBMCSUQnu4OO7Acs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e01AxisjbX67J3nKi9l2rDEJXzLchzU5mOT3ZKTSYfvODfpFOhz4+6shU2cNR22VW9vQemj7DDph+JGn7hChNuVEdVPegK+lWw3NgMg51Nzag7g/N2cidho+KRBMcLoED/btvWE6vN4QfCV32FDTlZXAhuzuJ2w7KMf9uNxPooY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dT0l3Zhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dT0l3Zhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9103C4CECD;
	Tue,  8 Oct 2024 13:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394169;
	bh=J9K22ArcGlpDKFm0zKGAZydCBNfxBMCSUQnu4OO7Acs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dT0l3Zhkze+DvfeHsa5FPvHaDbWBPly8i3DhBHf8NpJtzKqbSYqFOxdAJkXnOvD4A
	 j4tfZ1DJ2lo97PyUYXwBr8igpSO++9H43uc2mzpIkYVfIprTqTnxjso0OflXVm2daI
	 nO2cFKpmyc/MJQbARdMgovjEdvcMEv+2JBRQ5QdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Richard Weinberger <richard@nod.at>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 368/386] ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path
Date: Tue,  8 Oct 2024 14:10:13 +0200
Message-ID: <20241008115643.866904777@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 6379b44cdcd67f5f5d986b73953e99700591edfa ]

For error handling path in ubifs_symlink(), inode will be marked as
bad first, then iput() is invoked. If inode->i_link is initialized by
fscrypt_encrypt_symlink() in encryption scenario, inode->i_link won't
be freed by callchain ubifs_free_inode -> fscrypt_free_inode in error
handling path, because make_bad_inode() has changed 'inode->i_mode' as
'S_IFREG'.
Following kmemleak is easy to be reproduced by injecting error in
ubifs_jnl_update() when doing symlink in encryption scenario:
 unreferenced object 0xffff888103da3d98 (size 8):
  comm "ln", pid 1692, jiffies 4294914701 (age 12.045s)
  backtrace:
   kmemdup+0x32/0x70
   __fscrypt_encrypt_symlink+0xed/0x1c0
   ubifs_symlink+0x210/0x300 [ubifs]
   vfs_symlink+0x216/0x360
   do_symlinkat+0x11a/0x190
   do_syscall_64+0x3b/0xe0
There are two ways fixing it:
 1. Remove make_bad_inode() in error handling path. We can do that
    because ubifs_evict_inode() will do same processes for good
    symlink inode and bad symlink inode, for inode->i_nlink checking
    is before is_bad_inode().
 2. Free inode->i_link before marking inode bad.
Method 2 is picked, it has less influence, personally, I think.

Cc: stable@vger.kernel.org
Fixes: 2c58d548f570 ("fscrypt: cache decrypted symlink target in ->i_link")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
(cherry picked from commit 6379b44cdcd67f5f5d986b73953e99700591edfa)
[Vegard: CVE-2024-26972; no conflicts]
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1126,6 +1126,8 @@ out_cancel:
 	dir_ui->ui_size = dir->i_size;
 	mutex_unlock(&dir_ui->ui_mutex);
 out_inode:
+	/* Free inode->i_link before inode is marked as bad. */
+	fscrypt_free_inode(inode);
 	make_bad_inode(inode);
 	iput(inode);
 out_fname:


