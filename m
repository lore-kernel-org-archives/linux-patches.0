Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB2D415F00;
	Tue, 21 Jul 2026 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656441; cv=none; b=YuYW9m8H+UnKoDEuxXdQYOCDUHuooSTOPcUeJ9cyYF9euAfGAprXOZsN8u1ihOH5vQFJ3dDaqlj1M6JvqDKGqkLJ9zmsj/YEzSAp9MLKFIPRgRR/a1qd7HLtiqxEdLOZlYfekM2DD9vxtpuNm5C0URlO0SyYY/262fCW4p51Wgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656441; c=relaxed/simple;
	bh=ch5JXnnbpJX+sOOt2uMSH2Be3UQVQRiYCRiETUS83s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbzZ5ZNPbV1dOMyvQ8pSGkzDPQnh++fw4f4hPWFfR+Ba4NI7sj5weXDSNx5zzHNQ8F2tah/+WgWdmAK/2u3IawCwDYs37xKEIp5eMm8e3Wj85OYEkI+37G0RPPEGFHwOjTe9j7/Bw2MVI83m+ERELBasHWyha3ZM5kj6rBFQKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl1ODbIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl1ODbIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A011F000E9;
	Tue, 21 Jul 2026 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656439;
	bh=ljA2IY7tUHnqZyZNoF/ReQw65kWrRBrm2KDk6yGJlBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fl1ODbICXBVk51Bc5LEQM1eBISBGN4QPJphm5PIioaehYXL8fGYe+zWUsu+gXYfWV
	 9o4u2otBe/TlD2wb/KfWWmJvPmIESYeygEBDfQNnYm6R8mthm+rHIBH3W6apVV9see
	 j4WVVDjWByA3ZRVA5bumtrgltVuQlB0oNll+RkGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0389/1611] configfs: fix lockless traversals of ->s_children
Date: Tue, 21 Jul 2026 17:08:25 +0200
Message-ID: <20260721152523.967667549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 2898973f202a12..68203952766e67 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -235,15 +235,16 @@ static int configfs_dirent_exists(struct dentry *dentry)
 	const unsigned char *new = dentry->d_name.name;
 	struct configfs_dirent *sd;
 
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
@@ -569,11 +570,28 @@ static void configfs_detach_rollback(struct dentry *dentry)
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
@@ -582,15 +600,19 @@ static void detach_attrs(struct config_item * item)
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
@@ -649,18 +671,20 @@ static void detach_groups(struct config_group *group)
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
 
@@ -672,7 +696,9 @@ static void detach_groups(struct config_group *group)
 
 		d_delete(child);
 		dput(child);
+		spin_lock(&configfs_dirent_lock);
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	/**
 	 * Drop reference from dget() on entrance.
@@ -1124,6 +1150,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 	struct configfs_dirent *p;
 	struct configfs_dirent *ret = NULL;
 
+	spin_lock(&configfs_dirent_lock);
 	list_for_each_entry(p, &root_sd->s_children, s_sibling) {
 		if (p->s_type & CONFIGFS_DIR &&
 		    p->s_element == subsys_item) {
@@ -1131,6 +1158,7 @@ configfs_find_subsys_dentry(struct configfs_dirent *root_sd,
 			break;
 		}
 	}
+	spin_unlock(&configfs_dirent_lock);
 
 	return ret;
 }
-- 
2.53.0



