Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C658322524;
	Tue, 26 Aug 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207783; cv=none; b=GOttzZRqfU7h3dszcJN8eHH5ZuSQZZeZzmIsFLMejZTX4swPi5K8LN7CtebYi1k4ZgQ7hFMCaJ4UtDKUyMMsiR4lXrGPtjZYutXsiNjGE7ymlSXYVHbZE05XTzP2I9p6atk3v/ZSjkViyPw4zIPs64SdtHmMxl/4Iu70oC32hBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207783; c=relaxed/simple;
	bh=v3+rEVZ6zRIRGt1/ZAgvIxgfDJSx7UBb68BwYBk3uGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4RPztT0UgzyjSKIwqb+Kp5Sg2oq11rdK1gcTB8ab4arRrnkXbrIXUvvtTE4mrO8sBW2zEYBvLy367n87Li3gYMbnl51yNSyWjq4NJr0UvkBLbjtoRgnbyGizuUP6VmsuPOFNEpQ/1xP1csD4Olq3kai7vpgyvR98KXdYwfaG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2aLceT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2aLceT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17353C4CEF1;
	Tue, 26 Aug 2025 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207783;
	bh=v3+rEVZ6zRIRGt1/ZAgvIxgfDJSx7UBb68BwYBk3uGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2aLceT0kclPnR1tHiYS8goCPEBXd07NVMctk8W9b6fxLamjoBxOh7TxkP2APZEDa
	 vuqIeJp8PYmAulo4UHfCpX4oBcoFatIDLDhQxE/H5uNpGyngHAjQgui8Xwj98Aii0f
	 ajDia60OAEL6nubMtsVYebBBgRCUO5ChSF39IikI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 285/457] libfs: massage path_from_stashed() to allow custom stashing behavior
Date: Tue, 26 Aug 2025 13:09:29 +0200
Message-ID: <20250826110944.422906547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit bda3f1608d993419fa247dc11263fc931ceca58a ]

* Add a callback to struct stashed_operations so it's possible to
  implement custom behavior for pidfs and allow for it to return errors.

* Teach stashed_dentry_get() to handle error pointers.

Link: https://lore.kernel.org/20250618-work-pidfs-persistent-v2-2-98f3456fd552@kernel.org
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0b2d71a7c826 ("pidfs: Fix memory leak in pidfd_info()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/internal.h |  3 +++
 fs/libfs.c    | 27 ++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 393f6c5c24f6..22ba066d1dba 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -322,12 +322,15 @@ struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
 struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
 void mnt_idmap_put(struct mnt_idmap *idmap);
 struct stashed_operations {
+	struct dentry *(*stash_dentry)(struct dentry **stashed,
+				       struct dentry *dentry);
 	void (*put_data)(void *data);
 	int (*init_inode)(struct inode *inode, void *data);
 };
 int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 		      struct path *path);
 void stashed_dentry_prune(struct dentry *dentry);
+struct dentry *stash_dentry(struct dentry **stashed, struct dentry *dentry);
 struct dentry *stashed_dentry_get(struct dentry **stashed);
 /**
  * path_mounted - check whether path is mounted
diff --git a/fs/libfs.c b/fs/libfs.c
index 972b95cc7433..5b936ee71892 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2126,6 +2126,8 @@ struct dentry *stashed_dentry_get(struct dentry **stashed)
 	dentry = rcu_dereference(*stashed);
 	if (!dentry)
 		return NULL;
+	if (IS_ERR(dentry))
+		return dentry;
 	if (!lockref_get_not_dead(&dentry->d_lockref))
 		return NULL;
 	return dentry;
@@ -2174,8 +2176,7 @@ static struct dentry *prepare_anon_dentry(struct dentry **stashed,
 	return dentry;
 }
 
-static struct dentry *stash_dentry(struct dentry **stashed,
-				   struct dentry *dentry)
+struct dentry *stash_dentry(struct dentry **stashed, struct dentry *dentry)
 {
 	guard(rcu)();
 	for (;;) {
@@ -2216,12 +2217,15 @@ static struct dentry *stash_dentry(struct dentry **stashed,
 int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 		      struct path *path)
 {
-	struct dentry *dentry;
+	struct dentry *dentry, *res;
 	const struct stashed_operations *sops = mnt->mnt_sb->s_fs_info;
 
 	/* See if dentry can be reused. */
-	path->dentry = stashed_dentry_get(stashed);
-	if (path->dentry) {
+	res = stashed_dentry_get(stashed);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+	if (res) {
+		path->dentry = res;
 		sops->put_data(data);
 		goto out_path;
 	}
@@ -2232,8 +2236,17 @@ int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 		return PTR_ERR(dentry);
 
 	/* Added a new dentry. @data is now owned by the filesystem. */
-	path->dentry = stash_dentry(stashed, dentry);
-	if (path->dentry != dentry)
+	if (sops->stash_dentry)
+		res = sops->stash_dentry(stashed, dentry);
+	else
+		res = stash_dentry(stashed, dentry);
+	if (IS_ERR(res)) {
+		dput(dentry);
+		return PTR_ERR(res);
+	}
+	path->dentry = res;
+	/* A dentry was reused. */
+	if (res != dentry)
 		dput(dentry);
 
 out_path:
-- 
2.50.1



