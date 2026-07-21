Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2E3B6BF4;
	Tue, 21 Jul 2026 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665993; cv=none; b=O2XNfga1wLRB3M6+GZ0lI2avsirdHxfiXmTyiBOgIg8WOoMdenWA7y75xR2lA5YrWFLUM2Ff+1T7eDgvWGBqBdpJX8gNElVmCiVZN5MpdSns37dxIYbkCk2ueTzW8PfnClmVfMwPEmIAHsd+8NOo94S7j3dcdC3LuNwOgXR0p3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665993; c=relaxed/simple;
	bh=rmBH8pPC8Tr8bsVPBBkwwSKH0WkQir/tlfeOKyJ+ZE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmP6plifnn4Eo3MLzc0AEYm8+7OSgqHeh9lhVKisqfyoMUZJXjjN7g+I2NBsJfwraxuAPTlRj5QR5QG+kiAn2xrIElz9RZru40Lf+pryu0o7Ogl6DkXKTgIL0vm3S/5bHYeKlAJYDURvBUQTZEkRQtTR3sHR3EXEoQ6V76Q9yC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5f/yZq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5f/yZq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010B71F000E9;
	Tue, 21 Jul 2026 20:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665992;
	bh=VM+x3tDeXUvvIPczeCunb3bASCxlv2UjUNfrgg3oa7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w5f/yZq7cCtWt8d2nAsDTtsCld0GliCqI751ixiffYhwwmQChtVmjRjblJV45aS2j
	 C982H5UrLn+VzYi2RMkSDzQuPMywB+X92TDUg7pzmTRIqnOQWKFcpx2o6iCwDUJUUs
	 y4HJjt9kWkjRYocmsohIIxWp76BhtBLuOocRUsKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0515/1266] configfs: fix lockless traversals of ->s_children
Date: Tue, 21 Jul 2026 17:15:52 +0200
Message-ID: <20260721152453.373520529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 9b9e8bb81c41fd27e7b57a1c936fde140548535f ]

Having the parent directory locked protects entries from removal
by another thread, but it does *not* protect cursors from being
moved around by lseek() - or freed, for that matter.

Fixes: 6f6107640625 ("configfs: Introduce configfs_dirent_lock")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 54 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index c3fac94f66f212..972fb89ad22140 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -225,15 +225,16 @@ static int configfs_dirent_exists(struct configfs_dirent *parent_sd,
 {
 	struct configfs_dirent * sd;
 
+	spin_lock(&configfs_dirent_lock);
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_element) {
-			const unsigned char *existing = configfs_get_name(sd);
-			if (strcmp(existing, new))
-				continue;
-			else
+			if (strcmp(configfs_get_name(sd), new) == 0) {
+				spin_unlock(&configfs_dirent_lock);
 				return -EEXIST;
+			}
 		}
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	return 0;
 }
@@ -551,11 +552,28 @@ static void configfs_detach_rollback(struct dentry *dentry)
 			configfs_detach_rollback(sd->s_dentry);
 }
 
+/*
+ * Find the next non-cursor.  configfs_dirent_lock held by caller.
+ */
+static struct configfs_dirent *next_dirent(struct configfs_dirent *parent,
+					   struct configfs_dirent *last)
+{
+	struct configfs_dirent *s;
+
+	s = list_prepare_entry(last, &parent->s_children, s_sibling);
+
+	list_for_each_entry_continue(s, &parent->s_children, s_sibling) {
+		if (s->s_element)
+			return s;
+	}
+	return NULL;
+}
+
 static void detach_attrs(struct config_item * item)
 {
 	struct dentry * dentry = dget(item->ci_dentry);
-	struct configfs_dirent * parent_sd;
-	struct configfs_dirent * sd, * tmp;
+	struct configfs_dirent *parent_sd;
+	struct configfs_dirent *sd, *next;
 
 	if (!dentry)
 		return;
@@ -564,15 +582,19 @@ static void detach_attrs(struct config_item * item)
 		 dentry->d_name.name);
 
 	parent_sd = dentry->d_fsdata;
-	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
-		if (!sd->s_element || !(sd->s_type & CONFIGFS_NOT_PINNED))
+
+	spin_lock(&configfs_dirent_lock);
+	for (sd = next_dirent(parent_sd, NULL); sd; sd = next) {
+		next = next_dirent(parent_sd, sd);
+		if (!(sd->s_type & CONFIGFS_NOT_PINNED))
 			continue;
-		spin_lock(&configfs_dirent_lock);
 		list_del_init(&sd->s_sibling);
 		spin_unlock(&configfs_dirent_lock);
 		configfs_drop_dentry(sd, dentry);
 		configfs_put(sd);
+		spin_lock(&configfs_dirent_lock);
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/**
 	 * Drop reference from dget() on entrance.
@@ -621,18 +643,20 @@ static void detach_groups(struct config_group *group)
 	struct dentry * dentry = dget(group->cg_item.ci_dentry);
 	struct dentry *child;
 	struct configfs_dirent *parent_sd;
-	struct configfs_dirent *sd, *tmp;
+	struct configfs_dirent *sd, *next;
 
 	if (!dentry)
 		return;
 
 	parent_sd = dentry->d_fsdata;
-	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
-		if (!sd->s_element ||
-		    !(sd->s_type & CONFIGFS_USET_DEFAULT))
+	spin_lock(&configfs_dirent_lock);
+	for (sd = next_dirent(parent_sd, NULL); sd; sd = next) {
+		next = next_dirent(parent_sd, sd);
+		if (!(sd->s_type & CONFIGFS_USET_DEFAULT))
 			continue;
 
 		child = sd->s_dentry;
+		spin_unlock(&configfs_dirent_lock);
 
 		inode_lock(d_inode(child));
 
@@ -644,7 +668,9 @@ static void detach_groups(struct config_group *group)
 
 		d_delete(child);
 		dput(child);
+		spin_lock(&configfs_dirent_lock);
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/**
 	 * Drop reference from dget() on entrance.
@@ -1096,6 +1122,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 	struct configfs_dirent *p;
 	struct configfs_dirent *ret = NULL;
 
+	spin_lock(&configfs_dirent_lock);
 	list_for_each_entry(p, &root_sd->s_children, s_sibling) {
 		if (p->s_type & CONFIGFS_DIR &&
 		    p->s_element == subsys_item) {
@@ -1103,6 +1130,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 			break;
 		}
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	return ret;
 }
-- 
2.53.0



