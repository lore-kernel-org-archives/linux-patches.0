Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120A7E116;
	Wed, 21 Feb 2024 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521948; cv=none; b=OhGtU1bo56cjOnRg/0roXPk6QwhHTlPpaUU6RMrW9MGgxhqDkwre6pDR9gakNMJvbnUlfvI1+5vOxbeQCTX4Edus8KLqA5FggTPszi/fMZR6TMC7wNGOGZUDtvWFD//I/Hzz4kNhzeXP81wHWJ08WRjFxOV8aPzt8tMPqFHDFeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521948; c=relaxed/simple;
	bh=DruuK8lV+5McDMUXieEgMIu2TvmrjZl3bfo6b6ysuAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DucRH5iDtpyh+I88li/4kxqe1qjeBJe/cfoRBg5By0k3xrAmxEYWmHkfJSS7GwzZ1HbPsprtlWIuCvcW6pJAwC5/IoKpl4G+u7MNLF4O/FLAk/ZblYGKctJRiTmyjygskiNgi/QhrU7g/ZwAOCqLsmYsC71n8yzpEE5UpFYgEws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj8vyLvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj8vyLvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F390C433F1;
	Wed, 21 Feb 2024 13:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521947;
	bh=DruuK8lV+5McDMUXieEgMIu2TvmrjZl3bfo6b6ysuAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj8vyLvq7ji4O95I0Q45KLDW1O2kHd+LTVrz+PzW9yRHIZp5R30XYpKCjKE+UPETq
	 AE/zmWUuV8uMu/D2/ulG3t2lMz6/ZEmtWw7zfSNRY49uFI3sCpFmdv/p/5pyilw9oq
	 LsAGDxqHUhdqm3GTmo7/3wLDURImtHeAug76fXcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.15 038/476] ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path
Date: Wed, 21 Feb 2024 14:01:29 +0100
Message-ID: <20240221130009.349050082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 1e022216dcd248326a5bb95609d12a6815bca4e2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1225,6 +1225,8 @@ out_cancel:
 	dir_ui->ui_size = dir->i_size;
 	mutex_unlock(&dir_ui->ui_mutex);
 out_inode:
+	/* Free inode->i_link before inode is marked as bad. */
+	fscrypt_free_inode(inode);
 	make_bad_inode(inode);
 	iput(inode);
 out_fname:


