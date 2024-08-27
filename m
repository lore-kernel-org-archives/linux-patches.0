Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3598E1C3F17;
	Tue, 27 Aug 2024 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772261; cv=none; b=f0UWACK2n1mDDe/3Z1nEbQKoJMqFgRWe/b2HVSreqSuoZ6BiRVv9SHA/8ucaSqrF90OOYWXwDWpnSf7VZhTMpP8KtHff13Y0N/MPEJsSyuegrZI4BWuQ4BdaA/kv8ZkzfQS8JeeBM75qtn9YCFi0f1wNLELNJbZg6PMzlIGpxW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772261; c=relaxed/simple;
	bh=+80s9FWsOsH8/UJemULJ7cV55rNNvSfXnKxwZ3ENxp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkKkioWkUbKYGCtnRCT3ABMn/v/5J68XDyzP946osRHcNCvFfbLteroRvO2SWyBJLy03v2kuZilTC6BQ87Qfax2Lyx/InLUanYP7WIqn5p5caG+fjuV/qkiUxyP3j7hWQAF7bHs/awWReLZTsr33/6JJ3VXanBFSdoXTPgpl17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5KsCf7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5KsCf7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E0CC61069;
	Tue, 27 Aug 2024 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772261;
	bh=+80s9FWsOsH8/UJemULJ7cV55rNNvSfXnKxwZ3ENxp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5KsCf7X2KVpNkRSbyYT4TLDGQ0OsmQpfeUuKLE+sS0kvdw4GxSdf8drpq+Iujnxy
	 9nePhGUJFfzacvODb5rk+PZpx9v4VSxGeCg3+eOWzj6lrJX3dAIQukJiv+W9rQkp7x
	 qOBbfulbBbp9cA2dSE4YZXqZBFlSr9t1zSXFkpto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/321] fuse: fix UAF in rcu pathwalks
Date: Tue, 27 Aug 2024 16:37:49 +0200
Message-ID: <20240827143844.359694392@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 053fc4f755ad43cf35210677bcba798ccdc48d0c ]

->permission(), ->get_link() and ->inode_get_acl() might dereference
->s_fs_info (and, in case of ->permission(), ->s_fs_info->fc->user_ns
as well) when called from rcu pathwalk.

Freeing ->s_fs_info->fc is rcu-delayed; we need to make freeing ->s_fs_info
and dropping ->user_ns rcu-delayed too.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c   |  3 +--
 fs/fuse/fuse_i.h |  1 +
 fs/fuse/inode.c  | 15 +++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index c7d882a9fe339..295344a462e1d 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -474,8 +474,7 @@ static int cuse_send_init(struct cuse_conn *cc)
 
 static void cuse_fc_release(struct fuse_conn *fc)
 {
-	struct cuse_conn *cc = fc_to_cc(fc);
-	kfree_rcu(cc, fc.rcu);
+	kfree(fc_to_cc(fc));
 }
 
 /**
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 253b9b78d6f13..66c2a99994683 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -872,6 +872,7 @@ struct fuse_mount {
 
 	/* Entry on fc->mounts */
 	struct list_head fc_entry;
+	struct rcu_head rcu;
 };
 
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f19bdd7cbd779..64618548835b4 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -925,6 +925,14 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
+static void delayed_release(struct rcu_head *p)
+{
+	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
+
+	put_user_ns(fc->user_ns);
+	fc->release(fc);
+}
+
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
@@ -936,13 +944,12 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fiq->ops->release)
 			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
-		put_user_ns(fc->user_ns);
 		bucket = rcu_dereference_protected(fc->curr_bucket, 1);
 		if (bucket) {
 			WARN_ON(atomic_read(&bucket->count) != 1);
 			kfree(bucket);
 		}
-		fc->release(fc);
+		call_rcu(&fc->rcu, delayed_release);
 	}
 }
 EXPORT_SYMBOL_GPL(fuse_conn_put);
@@ -1356,7 +1363,7 @@ EXPORT_SYMBOL_GPL(fuse_send_init);
 void fuse_free_conn(struct fuse_conn *fc)
 {
 	WARN_ON(!list_empty(&fc->devices));
-	kfree_rcu(fc, rcu);
+	kfree(fc);
 }
 EXPORT_SYMBOL_GPL(fuse_free_conn);
 
@@ -1895,7 +1902,7 @@ static void fuse_sb_destroy(struct super_block *sb)
 void fuse_mount_destroy(struct fuse_mount *fm)
 {
 	fuse_conn_put(fm->fc);
-	kfree(fm);
+	kfree_rcu(fm, rcu);
 }
 EXPORT_SYMBOL(fuse_mount_destroy);
 
-- 
2.43.0



