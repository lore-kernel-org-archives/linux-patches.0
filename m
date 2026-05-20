Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF65A29B8D0;
	Wed, 20 May 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299686; cv=none; b=FMFD77xwXvjy4oFVh9Zblm9i9jpt2P0aSY6K+Hcwtzfq1r7+tatyZNEVXeRHH3soTemuzIJzO1y9+s3HryeFlNwN8/d0l2OWtKU/DT37AQpzNd+AHPCA39sWPSCmPgd9idQUJAMkH/c8XD7ow34Ib5UiwiAffDC7GHPla8CqVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299686; c=relaxed/simple;
	bh=U6nuTh943wv3rPJdYuIbDH6zcre1rCcvNKTe4jMkv4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLjHR601tUqyT05ihpNjpM5pA89fx0I79w6vpk6+1Z3Y6CzPzFYpeJsF6ZZfAYAPadjVjvXB7PBqSsjI09fDVr+leZ3rG0GpvKB5xg10qPUJTd3HmHXtAhcMF+6fnCNPZ0kfyD3tIA//wyEvOP5mqu0tFffk7YJG1Vo/wH1Xr44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHbHX1rE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHbHX1rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9EF1F000E9;
	Wed, 20 May 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299684;
	bh=mJB/089myfVlYur9I1VA2YfQyi1nZB5bRnCamA5Jmqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHbHX1rEZc5jPlZGfoObVd0DBBBXT427KdmDXAkL5n6Y+xxGsBsHJ84nJYEStmGdb
	 RZh4gQfN5Vufc5iF4Ef9xjvm0z+LZQlMYyVLNE9NR+6Nmc0ozg0M/G6HTCdz4LO/g8
	 BCMFUAn/5jvwXcp1Wh7e6yJ4bjIsFbxXteYDWhYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 866/957] fuse: fix race when disposing stale dentries
Date: Wed, 20 May 2026 18:22:29 +0200
Message-ID: <20260520162153.347426483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit cb8d2bdcb8241b66ca4ac4868f20e12cd6881ebc ]

In fuse_dentry_tree_work() just before d_dispose_if_unused() the dentry
could get evicted, resulting in UAF.

Move unlocking dentry_hash[i].lock to after the dispose.  To do this,
fuse_dentry_tree_del_node() needs to be moved from fuse_dentry_prune() to
fuse_dentry_release() to prevent an ABBA deadlock.

The lock ordering becomes:

 -> dentry_bucket.lock
    -> dentry.d_lock

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Closes: https://lore.kernel.org/all/20251206014242.GO1712166@ZenIV/
Fixes: ab84ad597386 ("fuse: new work queue to periodically invalidate expired dentries")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260114145344.468856-2-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 1e2c1af1beb3 ("fuse: make sure dentry is evicted if stale")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 98b174bd802f0..b7a6a5b6bbc8a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -172,8 +172,8 @@ static void fuse_dentry_tree_work(struct work_struct *work)
 			if (time_after64(get_jiffies_64(), fd->time)) {
 				rb_erase(&fd->node, &dentry_hash[i].tree);
 				RB_CLEAR_NODE(&fd->node);
-				spin_unlock(&dentry_hash[i].lock);
 				d_dispose_if_unused(fd->dentry, &dispose);
+				spin_unlock(&dentry_hash[i].lock);
 				cond_resched();
 				spin_lock(&dentry_hash[i].lock);
 			} else
@@ -464,18 +464,12 @@ static int fuse_dentry_init(struct dentry *dentry)
 	return 0;
 }
 
-static void fuse_dentry_prune(struct dentry *dentry)
+static void fuse_dentry_release(struct dentry *dentry)
 {
 	struct fuse_dentry *fd = dentry->d_fsdata;
 
 	if (!RB_EMPTY_NODE(&fd->node))
 		fuse_dentry_tree_del_node(dentry);
-}
-
-static void fuse_dentry_release(struct dentry *dentry)
-{
-	struct fuse_dentry *fd = dentry->d_fsdata;
-
 	kfree_rcu(fd, rcu);
 }
 
@@ -512,7 +506,6 @@ const struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
 	.d_delete	= fuse_dentry_delete,
 	.d_init		= fuse_dentry_init,
-	.d_prune	= fuse_dentry_prune,
 	.d_release	= fuse_dentry_release,
 	.d_automount	= fuse_dentry_automount,
 };
-- 
2.53.0



