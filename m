Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7578517B505;
	Wed,  5 Mar 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197966; cv=none; b=gu1b3vGHYBIfhh+SLG07Dfrw0sgIi5qIHtiOoah0wUW3vs71HTDtNJ/NOa6J5UNtFHtsUVQRWJQ46B3cWSPFgSnIbnHE7N8LUEc+94E6MKQNiOpCVmX4gi3F9/hB0jnBj/Xmf+EQffBQypZs+sn+uEZt4VbyKgpRP5uqgJVKNOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197966; c=relaxed/simple;
	bh=Rjwgc6urj7P2AunRGSxBVwRTaU4gIMf+ekI6eea2mY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7nAXYPYvdBkXlXUejqA9LPKyHqiskofEeCFzU+QkMRW4JGIcxM1LoHTt6YdAH2mOcQ0beZbis6XX5P9EnvslxcyBwXZcLZpQvb9shUgZkI9J3nCUJKt9CZVBDy4OUC1ggCDxt1I5hM7DbpqlP5hk5OQ6H64AwlIEKSdy4RBe9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SddQwdq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SddQwdq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E956DC4CED1;
	Wed,  5 Mar 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197966;
	bh=Rjwgc6urj7P2AunRGSxBVwRTaU4gIMf+ekI6eea2mY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SddQwdq1acnjSvZe+0gytF290vbufGk/fnKrE4YGKEnjaDvcAGUVeRxd9/VOK2vlm
	 Vd1zBLor8Wukrfj4aumzIVMp/WXVr8unYmcTt+NOOT7ot8apJTCS0aUyuJnfDje5nX
	 QcAQuPncTqz3dG7UlxEVJ2fiRydiRwmISJoR88mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/150] NFSv4: Fix a deadlock when recovering state on a sillyrenamed file
Date: Wed,  5 Mar 2025 18:47:28 +0100
Message-ID: <20250305174504.581869717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8f8df955f078e1a023ee55161935000a67651f38 ]

If the file is sillyrenamed, and slated for delete on close, it is
possible for a server reboot to triggeer an open reclaim, with can again
race with the application call to close(). When that happens, the call
to put_nfs_open_context() can trigger a synchronous delegreturn call
which deadlocks because it is not marked as privileged.

Instead, ensure that the call to nfs4_inode_return_delegation_on_close()
catches the delegreturn, and schedules it asynchronously.

Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: adb4b42d19ae ("Return the delegation when deleting sillyrenamed files")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/nfs/delegation.h |  1 +
 fs/nfs/nfs4proc.c   |  3 +++
 3 files changed, 41 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 035ba52742a50..4db912f562305 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -780,6 +780,43 @@ int nfs4_inode_return_delegation(struct inode *inode)
 	return 0;
 }
 
+/**
+ * nfs4_inode_set_return_delegation_on_close - asynchronously return a delegation
+ * @inode: inode to process
+ *
+ * This routine is called to request that the delegation be returned as soon
+ * as the file is closed. If the file is already closed, the delegation is
+ * immediately returned.
+ */
+void nfs4_inode_set_return_delegation_on_close(struct inode *inode)
+{
+	struct nfs_delegation *delegation;
+	struct nfs_delegation *ret = NULL;
+
+	if (!inode)
+		return;
+	rcu_read_lock();
+	delegation = nfs4_get_valid_delegation(inode);
+	if (!delegation)
+		goto out;
+	spin_lock(&delegation->lock);
+	if (!delegation->inode)
+		goto out_unlock;
+	if (list_empty(&NFS_I(inode)->open_files) &&
+	    !test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+		/* Refcount matched in nfs_end_delegation_return() */
+		ret = nfs_get_delegation(delegation);
+	} else
+		set_bit(NFS_DELEGATION_RETURN_IF_CLOSED, &delegation->flags);
+out_unlock:
+	spin_unlock(&delegation->lock);
+	if (ret)
+		nfs_clear_verifier_delegated(inode);
+out:
+	rcu_read_unlock();
+	nfs_end_delegation_return(inode, ret, 0);
+}
+
 /**
  * nfs4_inode_return_delegation_on_close - asynchronously return a delegation
  * @inode: inode to process
diff --git a/fs/nfs/delegation.h b/fs/nfs/delegation.h
index 71524d34ed207..8ff5ab9c5c256 100644
--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -49,6 +49,7 @@ void nfs_inode_reclaim_delegation(struct inode *inode, const struct cred *cred,
 				  unsigned long pagemod_limit, u32 deleg_type);
 int nfs4_inode_return_delegation(struct inode *inode);
 void nfs4_inode_return_delegation_on_close(struct inode *inode);
+void nfs4_inode_set_return_delegation_on_close(struct inode *inode);
 int nfs_async_inode_return_delegation(struct inode *inode, const nfs4_stateid *stateid);
 void nfs_inode_evict_delegation(struct inode *inode);
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 405f17e6e0b45..e7bc99c69743c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3898,8 +3898,11 @@ nfs4_atomic_open(struct inode *dir, struct nfs_open_context *ctx,
 
 static void nfs4_close_context(struct nfs_open_context *ctx, int is_sync)
 {
+	struct dentry *dentry = ctx->dentry;
 	if (ctx->state == NULL)
 		return;
+	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
+		nfs4_inode_set_return_delegation_on_close(d_inode(dentry));
 	if (is_sync)
 		nfs4_close_sync(ctx->state, _nfs4_ctx_to_openmode(ctx));
 	else
-- 
2.39.5



