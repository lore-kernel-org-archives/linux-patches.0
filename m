Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E895B15D5CD;
	Tue, 18 Jun 2024 12:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714826; cv=none; b=gp01v1T1jha+nUpjCip/m6BomaDJElZYyQO0zhFhHdW80dc31q7RcwjzTy0VbmsPsc0KTs4UdeygtAei7It+6v9nFQVzWkmISbd4fAxY3hS5UbXuMU/CzFSSboi4UF7UIRI666vEKRph/mboLSOK/X14DATXPIQhE+2sUr1Pu3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714826; c=relaxed/simple;
	bh=oYkQNewLh0PZokbi+7oPQMQIKWkT8bT8cNzn6bwcGjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRtnznhwOP6cjw75Q2i8bXSVi5zl2esBd7NNelV6rP7aarI6t3MyvtWgNTiISeIjeR7HHuU1Ix8KXmGRF33EmOh3LT1Fb9pmwJZH4rxT7ujXjOoovXWtH+D7OM1GGlHSNbwHRC1SlN5v6sDjr77UYe9KOLJBotqNLM6Wvp3p5DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKd5fSJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKd5fSJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF2C3277B;
	Tue, 18 Jun 2024 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714825;
	bh=oYkQNewLh0PZokbi+7oPQMQIKWkT8bT8cNzn6bwcGjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKd5fSJRj2o/1cdRfVd0b//rK3HdeYAn8oKLLG4ztRTCWr+F4FbQ+vQ+aWncAAIYu
	 nTJdS7wByGjtQOCTBqtNkm0m7S3ROFeODdi5/8IEn0xhq6F6Na4v6GHwQg6L6OLGjp
	 CU3B39tN3FlScrem5XxhVYoup0XiL+lSlk0Wv87w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/770] nfsd: allow filesystems to opt out of subtree checking
Date: Tue, 18 Jun 2024 14:29:13 +0200
Message-ID: <20240618123411.137659962@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit ba5e8187c55555519ae0b63c0fb681391bc42af9 ]

When we start allowing NFS to be reexported, then we have some problems
when it comes to subtree checking. In principle, we could allow it, but
it would mean encoding parent info in the filehandles and there may not
be enough space for that in a NFSv3 filehandle.

To enforce this at export upcall time, we add a new export_ops flag
that declares the filesystem ineligible for subtree checking.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/nfs/exporting.rst | 12 ++++++++++++
 fs/nfs/export.c                             |  2 +-
 fs/nfsd/export.c                            |  6 ++++++
 include/linux/exportfs.h                    |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index cbe542ad52333..960be64446cb9 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -190,3 +190,15 @@ following flags are defined:
     this on filesystems that have an expensive ->getattr inode operation,
     or when atomicity between pre and post operation attribute collection
     is impossible to guarantee.
+
+  EXPORT_OP_NOSUBTREECHK - disallow subtree checking on this fs
+    Many NFS operations deal with filehandles, which the server must then
+    vet to ensure that they live inside of an exported tree. When the
+    export consists of an entire filesystem, this is trivial. nfsd can just
+    ensure that the filehandle live on the filesystem. When only part of a
+    filesystem is exported however, then nfsd must walk the ancestors of the
+    inode to ensure that it's within an exported subtree. This is an
+    expensive operation and not all filesystems can support it properly.
+    This flag exempts the filesystem from subtree checking and causes
+    exportfs to get back an error if it tries to enable subtree checking
+    on it.
diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 8f4c528865c57..b9ba306bf9120 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -171,5 +171,5 @@ const struct export_operations nfs_export_ops = {
 	.encode_fh = nfs_encode_fh,
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
-	.flags = EXPORT_OP_NOWCC,
+	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK,
 };
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 21e404e7cb68c..81e7bb12aca69 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -408,6 +408,12 @@ static int check_export(struct inode *inode, int *flags, unsigned char *uuid)
 		return -EINVAL;
 	}
 
+	if (inode->i_sb->s_export_op->flags & EXPORT_OP_NOSUBTREECHK &&
+	    !(*flags & NFSEXP_NOSUBTREECHECK)) {
+		dprintk("%s: %s does not support subtree checking!\n",
+			__func__, inode->i_sb->s_type->name);
+		return -EINVAL;
+	}
 	return 0;
 
 }
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index e7de0103a32e8..2fcbab0f6b612 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -214,6 +214,7 @@ struct export_operations {
 	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
 			     int nr_iomaps, struct iattr *iattr);
 #define	EXPORT_OP_NOWCC		(0x1)	/* Don't collect wcc data for NFSv3 replies */
+#define	EXPORT_OP_NOSUBTREECHK	(0x2)	/* Subtree checking is not supported! */
 	unsigned long	flags;
 };
 
-- 
2.43.0



