Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2720054F86;
	Mon,  1 Apr 2024 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986689; cv=none; b=mgd4YITkoLbiTNDSNEscnknWhw3qj6ZcMHiBr2OfWU0VZE+vj/aEW/Zm+RrcjGdYS2cfI7FJSmMrj9DcHbQHGavZMTfceCO6Lvn8cN9WmL7s/5vQTxcqKnosCtfbkR6FIywvcRhci2GPEeLob7MfuNwvC1tvSRC9REvLPTNHb2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986689; c=relaxed/simple;
	bh=kJtQcoBlJ8eQBE5FniSQQJwGzpB+vzcNZT8noRVcSbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ylotr9+l6Y4I14zx3c8S3/R33tXhvO1QiIRvCYVWtm1NaKLQT9GQooFkWoInqvqkNEI+Sn2iP+YDQbMtvSnyDSs6+h+bBC/KvU8XcNtsoC/ajcRMs6F+yvV2yiDXchEkr9TmVthppkaI22owz5C/e847fswMqoD2m8U2Aqeqv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fdrjxlu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fdrjxlu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5787BC433C7;
	Mon,  1 Apr 2024 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986688;
	bh=kJtQcoBlJ8eQBE5FniSQQJwGzpB+vzcNZT8noRVcSbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fdrjxlu3XxYB3mcm+wApSAsFngKOfryB3tJqpUMq1KkMszMYtZ9+/MMNmQQfWi6Ih
	 aPlzBfr+l6BS3WT4NH5q/hWTDmskGJUz2sSTiZ1pKSNH4g2LPSxh9I5bwFxZPTN9y6
	 T2xLVdvxSsKulRWHGIuTR+AgTNYW4njDKlvK2nmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/399] ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path
Date: Mon,  1 Apr 2024 17:40:19 +0200
Message-ID: <20240401152550.767746241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index e413a9cf8ee38..6b3db00d9b121 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1134,6 +1134,8 @@ static int ubifs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	dir_ui->ui_size = dir->i_size;
 	mutex_unlock(&dir_ui->ui_mutex);
 out_inode:
+	/* Free inode->i_link before inode is marked as bad. */
+	fscrypt_free_inode(inode);
 	make_bad_inode(inode);
 	iput(inode);
 out_fname:
-- 
2.43.0



