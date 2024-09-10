Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D89846444;
	Tue, 10 Sep 2024 09:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961729; cv=none; b=p7brAQSLJQAtP2QEyqjEUzB2pxINDmt4+nGV1bpABGyLiXi/5DwQkJAiHCKHpDJlNOYjLf+v5IMulG17SgpAD4RmU2eMaXlYQdicuSfLiCMUOu1DnD9I3iSjfhEtkOYgUlKiIFFi2QBbA2ZvgWSXqHULP5RwfrkbkW8wBS6K2G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961729; c=relaxed/simple;
	bh=Kd0ygde/BKqhmZE63zqcxmSHlk2iGcbxDJEcc8Ptx38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnNY+G3r32kQEY7RLkSDD2dnvyDBMqzdOzcwiy6h9o72yMoyP3QkPCxLq1g9JD6Dk7A1H8Kb9nqHqRBEFScr99NCjsW0UA/rvTJ+N3KaJ6CyMIylX0a5IIwGuRzkt/fvOVYukIThhj2lAjlWk7xtLESiF6IL4gRy/HjEtJKEXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jniku4xY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jniku4xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C31C4CEC6;
	Tue, 10 Sep 2024 09:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961729;
	bh=Kd0ygde/BKqhmZE63zqcxmSHlk2iGcbxDJEcc8Ptx38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jniku4xYFdgdYUlubSSV004Q+yndLr+2DLjjG9rc0+ZOn53jUup1e0fegY6L9ZU7G
	 O1/A/NYGv9DYSZZ8ZxdST9afTQipTp3a0sHJKtqNxly5m8K8SoBq/MSavbA/5GrbAx
	 txLFTP8nhfhMkIzEMwVWei8BYKb2U3HvqzEkWiws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 132/375] fs: dont copy to userspace under namespace semaphore
Date: Tue, 10 Sep 2024 11:28:49 +0200
Message-ID: <20240910092626.864478505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit cb54ef4f050e7c504ed87114276a296d727e918a ]

Don't copy mount ids to userspace while holding the namespace semaphore.
We really shouldn't do that and I've gone through lenghts avoiding that
in statmount() already.

Limit the number of mounts that can be retrieved in one go to 1 million
mount ids. That's effectively 10 times the default limt of 100000 mounts
that we put on each mount namespace by default. Since listmount() is an
iterator limiting the number of mounts retrievable in one go isn't a
problem as userspace can just pick up where they left off.

Karel menti_ned that libmount will probably be reading the mount table
in "in small steps, 512 nodes per request. Nobody likes a tool that
takes too long in the kernel, and huge servers are unusual use cases.
Libmount will very probably provide API to define size of the step (IDs
per request)."

Reported-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/r/20240610-frettchen-liberal-a9a5c53865f8@brauner
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 98 ++++++++++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 42 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5a51315c6678..57311ecbdf5a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5047,55 +5047,81 @@ static struct mount *listmnt_next(struct mount *curr)
 	return node_to_mount(rb_next(&curr->mnt_node));
 }
 
-static ssize_t do_listmount(struct mount *first, struct path *orig,
-			    u64 mnt_parent_id, u64 __user *mnt_ids,
-			    size_t nr_mnt_ids, const struct path *root)
+static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
+			    size_t nr_mnt_ids)
 {
-	struct mount *r;
+	struct path root;
+	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+	struct path orig;
+	struct mount *r, *first;
 	ssize_t ret;
 
+	rwsem_assert_held(&namespace_sem);
+
+	get_fs_root(current->fs, &root);
+	if (mnt_parent_id == LSMT_ROOT) {
+		orig = root;
+	} else {
+		orig.mnt = lookup_mnt_in_ns(mnt_parent_id, ns);
+		if (!orig.mnt) {
+			ret = -ENOENT;
+			goto err;
+		}
+		orig.dentry = orig.mnt->mnt_root;
+	}
+
 	/*
 	 * Don't trigger audit denials. We just want to determine what
 	 * mounts to show users.
 	 */
-	if (!is_path_reachable(real_mount(orig->mnt), orig->dentry, root) &&
-	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &root) &&
+	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err;
+	}
 
-	ret = security_sb_statfs(orig->dentry);
+	ret = security_sb_statfs(orig.dentry);
 	if (ret)
-		return ret;
+		goto err;
+
+	if (!last_mnt_id)
+		first = node_to_mount(rb_first(&ns->mounts));
+	else
+		first = mnt_find_id_at(ns, last_mnt_id + 1);
 
 	for (ret = 0, r = first; r && nr_mnt_ids; r = listmnt_next(r)) {
 		if (r->mnt_id_unique == mnt_parent_id)
 			continue;
-		if (!is_path_reachable(r, r->mnt.mnt_root, orig))
+		if (!is_path_reachable(r, r->mnt.mnt_root, &orig))
 			continue;
-		if (put_user(r->mnt_id_unique, mnt_ids))
-			return -EFAULT;
+		*mnt_ids = r->mnt_id_unique;
 		mnt_ids++;
 		nr_mnt_ids--;
 		ret++;
 	}
+err:
+	path_put(&root);
 	return ret;
 }
 
-SYSCALL_DEFINE4(listmount, const struct mnt_id_req __user *, req, u64 __user *,
-		mnt_ids, size_t, nr_mnt_ids, unsigned int, flags)
+SYSCALL_DEFINE4(listmount, const struct mnt_id_req __user *, req,
+		u64 __user *, mnt_ids, size_t, nr_mnt_ids, unsigned int, flags)
 {
-	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
+	u64 *kmnt_ids __free(kvfree) = NULL;
+	const size_t maxcount = 1000000;
 	struct mnt_id_req kreq;
-	struct mount *first;
-	struct path root, orig;
-	u64 mnt_parent_id, last_mnt_id;
-	const size_t maxcount = (size_t)-1 >> 3;
 	ssize_t ret;
 
 	if (flags)
 		return -EINVAL;
 
+	/*
+	 * If the mount namespace really has more than 1 million mounts the
+	 * caller must iterate over the mount namespace (and reconsider their
+	 * system design...).
+	 */
 	if (unlikely(nr_mnt_ids > maxcount))
-		return -EFAULT;
+		return -EOVERFLOW;
 
 	if (!access_ok(mnt_ids, nr_mnt_ids * sizeof(*mnt_ids)))
 		return -EFAULT;
@@ -5103,33 +5129,21 @@ SYSCALL_DEFINE4(listmount, const struct mnt_id_req __user *, req, u64 __user *,
 	ret = copy_mnt_id_req(req, &kreq);
 	if (ret)
 		return ret;
-	mnt_parent_id = kreq.mnt_id;
-	last_mnt_id = kreq.param;
 
-	down_read(&namespace_sem);
-	get_fs_root(current->fs, &root);
-	if (mnt_parent_id == LSMT_ROOT) {
-		orig = root;
-	} else {
-		ret = -ENOENT;
-		orig.mnt = lookup_mnt_in_ns(mnt_parent_id, ns);
-		if (!orig.mnt)
-			goto err;
-		orig.dentry = orig.mnt->mnt_root;
-	}
-	if (!last_mnt_id)
-		first = node_to_mount(rb_first(&ns->mounts));
-	else
-		first = mnt_find_id_at(ns, last_mnt_id + 1);
+	kmnt_ids = kvmalloc_array(nr_mnt_ids, sizeof(*kmnt_ids),
+				  GFP_KERNEL_ACCOUNT);
+	if (!kmnt_ids)
+		return -ENOMEM;
+
+	scoped_guard(rwsem_read, &namespace_sem)
+		ret = do_listmount(kreq.mnt_id, kreq.param, kmnt_ids, nr_mnt_ids);
+
+	if (copy_to_user(mnt_ids, kmnt_ids, ret * sizeof(*mnt_ids)))
+		return -EFAULT;
 
-	ret = do_listmount(first, &orig, mnt_parent_id, mnt_ids, nr_mnt_ids, &root);
-err:
-	path_put(&root);
-	up_read(&namespace_sem);
 	return ret;
 }
 
-
 static void __init init_mount_tree(void)
 {
 	struct vfsmount *mnt;
-- 
2.43.0



