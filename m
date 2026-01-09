Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDE735B137;
	Fri,  9 Jan 2026 12:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961930; cv=none; b=Kkd2gfj0Fsu55MrzzVtlznaFxVi6nvMnVcKP3oF1/r3GUVvYJbe485bO7n4sKA1FGLAWiZgwtUe2xvhR3+WwsFV/4PL8oz2N9WT1rTqhZsFiXyCdUsn1nsdPBZEKiifxzNb6Twut3psL7gtPEBZSCI2dB7EOMu3Yt9Gl3afyU7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961930; c=relaxed/simple;
	bh=OHEqSBqujSU5m3IkGRxPUSalXFfQOWCSxiD56tD7sgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+chF7dOasQ1u1wwFjlMKcHd2mmWS0K5UAtjvNRl8w5Qj/uNsJLrhlGpOTE+/2iRhWjroT/I76jKnRuUxmZwl3qT//H48uRo0BDfn5vzBdiRv3Hy4SGNsJgkS+CSGqqPGX68HMOPYWEH44ZX71j/cJYq1nsLbVHxBiyIRWEEgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2urEJZ1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2urEJZ1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4138C4CEF1;
	Fri,  9 Jan 2026 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961930;
	bh=OHEqSBqujSU5m3IkGRxPUSalXFfQOWCSxiD56tD7sgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2urEJZ1KiMJbK/7CTXJTd9Em+++VZBuAoHauHh8TXRiwQWnPKcW8b/uL37Tqql2OE
	 xR4xQK7ogkWJYyTxhiEILyTX59I9JO3F4NcFJBkQPUu0Vmq9Bn3eusNMuk4g/xRVHL
	 Q3vPgsmf1H2w51rjbCU5/8JClHg7mHpWqH0eeA6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Lambert <alambert48@gatech.edu>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/634] NFS: Avoid changing nlink when file removes and attribute updates race
Date: Fri,  9 Jan 2026 12:37:45 +0100
Message-ID: <20260109112124.476620582@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit bd4928ec799b31c492eb63f9f4a0c1e0bb4bb3f7 ]

If a file removal races with another operation that updates its
attributes, then skip the change to nlink, and just mark the attributes
as being stale.

Reported-by: Aiden Lambert <alambert48@gatech.edu>
Fixes: 59a707b0d42e ("NFS: Ensure we revalidate the inode correctly after remove or rename")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 3c98049912dfd..b54c92d8e2730 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1891,13 +1891,15 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode)
+static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
+	struct nfs_inode *nfsi = NFS_I(inode);
+
 	spin_lock(&inode->i_lock);
 	/* drop the inode if we're reasonably sure this is the last link */
-	if (inode->i_nlink > 0)
+	if (inode->i_nlink > 0 && gencount == nfsi->attr_gencount)
 		drop_nlink(inode);
-	NFS_I(inode)->attr_gencount = nfs_inc_attr_generation_counter();
+	nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	nfs_set_cache_invalid(
 		inode, NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
 			       NFS_INO_INVALID_NLINK);
@@ -1911,8 +1913,9 @@ static void nfs_drop_nlink(struct inode *inode)
 static void nfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
 		nfs_complete_unlink(dentry, inode);
-		nfs_drop_nlink(inode);
+		nfs_drop_nlink(inode, gencount);
 	}
 	iput(inode);
 }
@@ -2465,9 +2468,11 @@ static int nfs_safe_remove(struct dentry *dentry)
 
 	trace_nfs_remove_enter(dir, dentry);
 	if (inode != NULL) {
+		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
+
 		error = NFS_PROTO(dir)->remove(dir, dentry);
 		if (error == 0)
-			nfs_drop_nlink(inode);
+			nfs_drop_nlink(inode, gencount);
 	} else
 		error = NFS_PROTO(dir)->remove(dir, dentry);
 	if (error == -ENOENT)
@@ -2672,6 +2677,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
+	unsigned long new_gencount = 0;
 	struct dentry *dentry = NULL;
 	struct rpc_task *task;
 	bool must_unblock = false;
@@ -2724,6 +2730,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		} else {
 			block_revalidate(new_dentry);
 			must_unblock = true;
+			new_gencount = NFS_I(new_inode)->attr_gencount;
 			spin_unlock(&new_dentry->d_lock);
 		}
 
@@ -2763,7 +2770,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 			new_dir, new_dentry, error);
 	if (!error) {
 		if (new_inode != NULL)
-			nfs_drop_nlink(new_inode);
+			nfs_drop_nlink(new_inode, new_gencount);
 		/*
 		 * The d_move() should be here instead of in an async RPC completion
 		 * handler because we need the proper locks to move the dentry.  If
-- 
2.51.0



