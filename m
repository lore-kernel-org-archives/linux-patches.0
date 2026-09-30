Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD72853D9FD;
	Wed, 30 Sep 2026 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790100; cv=none; b=aNZrATd8WhCzNAtJ7X4uVhHfFAQLH23vRD9N68PpVZ3BcINccTnAbWSRdvvVfv7xgCMMf/t2Y+5dMFFUEO2ZbXLsNWgEgMls6F3AKVMbwYpy8ryLHQ3ATdw4v6w3EyvFn4XAtZfpNk0f3lyMejUu2inu9TpNbcrKJARXhDmoRxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790100; c=relaxed/simple;
	bh=EZ6p/hoNSxOveJde/io7KogN1OqT36cVtvB9hEQ0RrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQfZXybnCAjSItyix63Ulxn/1zmHVwqyJiCqx/xI1BVYkIlYpN3Sg2TL5SpRSKud/XTDA/4SdsF0aHcY7/fPq+aYmrqTw5qAPTNNlAjU93SqY0UK7G2xJAalEeji1MfnvPQedfxgwatrPY6t5V/LDkBlM3Uf/xPOPDnVEx/SDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzti+1Gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzti+1Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334041F000FF;
	Wed, 30 Sep 2026 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790098;
	bh=W5e618cC6UT9JCT5HwtcNJXHuhijrcNSsss9hHjMgX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzti+1GunA2loF+thxtcU9uKKVODBl9X3iyhwKk3+lBRgB88Z0P8RnJkkXsJTcfKd
	 Wr8BOMcRWPG6YhJs4MskXu0j6Hx6SjEPzTLxMnww/NvuqFUKPmhHUEZcUJy7SMPnh/
	 G5n7d4atg78Y1B8mX5kS6OY0ESAJa3ILy22HdZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 710/877] configfs: pin the symlink targets dirent instead of chasing ->ci_dentry
Date: Wed, 30 Sep 2026 17:27:01 +0200
Message-ID: <20260930152430.004859501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Almpanis <vasilisalmpanis@gmail.com>

[ Upstream commit a7c1290eef60711c10289c056ad32ed1f2b47b12 ]

create_link() reads the target's configfs_dirent from
item->ci_dentry->d_fsdata, relying on the item reference taken by
get_target().  That reference pins the item, not its dentry: the dentry is
pinned by DCACHE_PERSISTENT, which configfs_remove_dir() releases via
simple_rmdir() while the item is still alive.  A symlink racing with rmdir
of its target can therefore find ->ci_dentry freed and its dirent
released, triggering WARN_ON(!atomic_read(&sd->s_count)) in configfs_get().

Take the dirent in get_target() as well, under ->d_lock and atomically
with the item reference, and pass it down to create_link().  A hashed
dentry has not been killed yet, so its ->d_fsdata reference keeps the
dirent alive there.

Cc: stable@vger.kernel.org
Fixes: 7063fbf22611 ("[PATCH] configfs: User-driven configuration filesystem")
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Tested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260730093435.195441-2-vasilisalmpanis@gmail.com
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/symlink.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -76,9 +76,9 @@ static int configfs_get_target_path(stru
 
 static int create_link(struct config_item *parent_item,
 		       struct config_item *item,
+		       struct configfs_dirent *target_sd,
 		       struct dentry *dentry)
 {
-	struct configfs_dirent *target_sd = item->ci_dentry->d_fsdata;
 	char *body;
 	int ret;
 
@@ -115,6 +115,7 @@ static int create_link(struct config_ite
 
 
 static int get_target(const char *symname, struct config_item **target,
+		      struct configfs_dirent **target_sd,
 		      struct super_block *sb)
 {
 	struct path path __free(path_put) = {};
@@ -125,7 +126,20 @@ static int get_target(const char *symnam
 		return ret;
 	if (path.dentry->d_sb != sb)
 		return -EPERM;
-	*target = configfs_get_config_item(path.dentry);
+	/*
+	 * A hashed dentry guarantees that neither the item nor the dirent
+	 * have been released yet, as removals unhash before dropping.
+	 * Grab both references here. An item reference alone would not keep
+	 * ->ci_dentry alive.
+	 */
+	spin_lock(&path.dentry->d_lock);
+	if (!d_unhashed(path.dentry)) {
+		struct configfs_dirent *sd = path.dentry->d_fsdata;
+
+		*target = config_item_get(sd->s_element);
+		*target_sd = configfs_get(sd);
+	}
+	spin_unlock(&path.dentry->d_lock);
 	if (!*target)
 		return -ENOENT;
 	return 0;
@@ -139,6 +153,7 @@ int configfs_symlink(struct mnt_idmap *i
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item = NULL;
+	struct configfs_dirent *target_sd = NULL;
 	const struct config_item_type *type;
 
 	sd = dentry->d_parent->d_fsdata;
@@ -182,7 +197,7 @@ int configfs_symlink(struct mnt_idmap *i
 	 *  AV, a thoroughly annoyed bastard.
 	 */
 	inode_unlock(dir);
-	ret = get_target(symname, &target_item, dentry->d_sb);
+	ret = get_target(symname, &target_item, &target_sd, dentry->d_sb);
 	inode_lock(dir);
 	if (ret)
 		goto out_put;
@@ -196,13 +211,14 @@ int configfs_symlink(struct mnt_idmap *i
 		ret = type->ct_item_ops->allow_link(parent_item, target_item);
 	if (!ret) {
 		mutex_lock(&configfs_symlink_mutex);
-		ret = create_link(parent_item, target_item, dentry);
+		ret = create_link(parent_item, target_item, target_sd, dentry);
 		mutex_unlock(&configfs_symlink_mutex);
 		if (ret && type->ct_item_ops->drop_link)
 			type->ct_item_ops->drop_link(parent_item,
 						     target_item);
 	}
 
+	configfs_put(target_sd);
 	config_item_put(target_item);
 
 out_put:


