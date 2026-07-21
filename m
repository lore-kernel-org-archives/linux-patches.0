Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6710E46D098;
	Tue, 21 Jul 2026 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661986; cv=none; b=qBRv0Kg+r/SefjZu/o7/MXoW7NEnexuiTE0GcFtHkp20/eSUvcFhZMcB1bH4wMQmP2+sleTJds/ARaW2WE9pnuvcuWhs1uaAeSY67ML/6lHwf3cxMiYdcAqDj0V/AD+g4rRPXVQFHKQvthnExIdzLMxysu7QM9M4dVy1hKXSF4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661986; c=relaxed/simple;
	bh=WKKNxeyvoj36N0ByMaCrOU354BE0ij8cBcZq47mRDQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig+0IXu0gSEhnGcJYCvrYWsErk6VJD5S+5je5IHYmtiKLA14GTjDIvqvcGs1/Qvz7bstaAKrnwGGbvJXr4Otu7935N5vx0L/4jnsVsmYfrL9pk2AUlC1LUWBjEc3w/oezVpuuJ3XJ8q4XtzdMfCKCQTfCzukETUx0C94+XnA5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpfERNXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpfERNXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD2A1F000E9;
	Tue, 21 Jul 2026 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661985;
	bh=XOvfpbdiXFRPFHYsafB3adqply1J6My41t2sWPwG2Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpfERNXZ0L39t5simf5P1siPHdmwN0dgicKxiZv+6pLQu9wQi9CfksrigNyjNGlLA
	 6aFirbQRhWD7y4K+18YJwOQTpKM7t7eo2JCXWefE6pJDe9MCRCYKnUAGK5V8OveFIh
	 4AXYFddF3jKrWy+ipqz4EdHNOwUjMARgHz+FN1rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0271/1276] configfs: fix lockless traversals of ->s_children
Date: Tue, 21 Jul 2026 17:11:54 +0200
Message-ID: <20260721152452.143676675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 47123ac17b0573..248d70b26f3d07 100644
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
@@ -631,18 +653,20 @@ static void detach_groups(struct config_group *group)
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
 
@@ -654,7 +678,9 @@ static void detach_groups(struct config_group *group)
 
 		d_delete(child);
 		dput(child);
+		spin_lock(&configfs_dirent_lock);
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/**
 	 * Drop reference from dget() on entrance.
@@ -1106,6 +1132,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 	struct configfs_dirent *p;
 	struct configfs_dirent *ret = NULL;
 
+	spin_lock(&configfs_dirent_lock);
 	list_for_each_entry(p, &root_sd->s_children, s_sibling) {
 		if (p->s_type & CONFIGFS_DIR &&
 		    p->s_element == subsys_item) {
@@ -1113,6 +1140,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 			break;
 		}
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	return ret;
 }
-- 
2.53.0



