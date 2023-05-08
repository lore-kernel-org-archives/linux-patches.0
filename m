Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07E9168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B5AC433EF;
	Mon,  8 May 2023 10:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543433;
	bh=RT7JMNLVIVZFoyk9MkqvppZ5D3T+QHCHLlgkN2MaAuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJeGkrvOPOj36XmzZ3Yz5BV28QbHpE3qppu2tqT+cOB2gWm//23vsATE3nbNhfV93
	 9kG/8p25rROjeoWFbHZBABBtQp/cPQMjUr8XODcYrptwFEsKHQmMGiZVhULGKh48p5
	 Z8xdL4OHzwLv9p8dUUM1nteWnF5+a+OZ8V7hrt2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	=?UTF-8?q?M=C3=A5rten=20Lindahl?= <marten.lindahl@axis.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.3 089/694] ubifs: Fix memory leak in do_rename
Date: Mon,  8 May 2023 11:38:44 +0200
Message-Id: <20230508094435.424365131@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mårten Lindahl <marten.lindahl@axis.com>

commit 3a36d20e012903f45714df2731261fdefac900cb upstream.

If renaming a file in an encrypted directory, function
fscrypt_setup_filename allocates memory for a file name. This name is
never used, and before returning to the caller the memory for it is not
freed.

When running kmemleak on it we see that it is registered as a leak. The
report below is triggered by a simple program 'rename' that renames a
file in an encrypted directory:

  unreferenced object 0xffff888101502840 (size 32):
    comm "rename", pid 9404, jiffies 4302582475 (age 435.735s)
    backtrace:
      __kmem_cache_alloc_node
      __kmalloc
      fscrypt_setup_filename
      do_rename
      ubifs_rename
      vfs_rename
      do_renameat2

To fix this we can remove the call to fscrypt_setup_filename as it's not
needed.

Fixes: 278d9a243635f26 ("ubifs: Rename whiteout atomically")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mårten Lindahl <marten.lindahl@axis.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -358,7 +358,6 @@ static struct inode *create_whiteout(str
 	umode_t mode = S_IFCHR | WHITEOUT_MODE;
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	struct fscrypt_name nm;
 
 	/*
 	 * Create an inode('nlink = 1') for whiteout without updating journal,
@@ -369,10 +368,6 @@ static struct inode *create_whiteout(str
 	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
 		dentry, mode, dir->i_ino);
 
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 0, &nm);
-	if (err)
-		return ERR_PTR(err);
-
 	inode = ubifs_new_inode(c, dir, mode, false);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -395,7 +390,6 @@ out_inode:
 	make_bad_inode(inode);
 	iput(inode);
 out_free:
-	fscrypt_free_filename(&nm);
 	ubifs_err(c, "cannot create whiteout file, error %d", err);
 	return ERR_PTR(err);
 }


