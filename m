Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3DF347512;
	Wed, 20 May 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297340; cv=none; b=nebV38ZuyR2NXWqcN6jUvghfbnccZwyuXhb/3ynCswDUguQOaZw+98KBeD0xuR54emY+vo5CcdJSS4jt7BZaCFFZ7j7gmoXRZI/dUODCnRIffttrw8HIMrNHxDMQLfrAPCCoSgIVi3QqTUa8yGJ27OG4m9WQe6so7QT5AK/QZ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297340; c=relaxed/simple;
	bh=Fi18PsZ44FndpZ1IFXwn2vLbNW0x+zRU7lW2qG5oAtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc49eLuJg4n7kXjNuL99Qr30dXRC8bChwVj/Bm3uO91JuywShNJq22tq0xaUJ73ap9zsL9Uea28t4ujtWDomsYqJpAtYEpfugLtMdNyOOuvyoEUNMSve7fkIVcUsYUgn55NEW12DGkevzaQRyxHo9C4Wa7Lg90qT1C/HCAPclPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QalYpRWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QalYpRWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245EF1F0089A;
	Wed, 20 May 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297338;
	bh=NVTcdb3FiKJ5zpdN9NdxEAGlFzTy+nxUe1ifEo9XUm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QalYpRWYr4DxVqoUHALLKpAYzImgFKTSSY4oHyN9CkG1kczUW4cnm76AKDAkyrQIB
	 DPkgPEKMTfZIwF146iOK8Zt8bbz3hmL9oWOHHEg7PajlxXSLEneMlo8AG026yg8e/O
	 hFp6zMbfcCAIMRiuvJWPcF+sU19XZyTzhUxojBBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1142/1146] eventfs: Simplify code using guard()s
Date: Wed, 20 May 2026 18:23:12 +0200
Message-ID: <20260520162214.100461112@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 4d9b262031ffef203243e53577a90ae6e1090e67 ]

Use guard(mutex), scoped_guard(mutex) and guard(src) to simplify the code
and remove a lot of the jumps to "out:" labels.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250604151625.250d13e1@gandalf.local.home
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: f67950b2887f ("eventfs: Use list_add_tail_rcu() for SRCU-protected children list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   96 +++++++++++++++++------------------------------
 1 file changed, 36 insertions(+), 60 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -180,29 +180,25 @@ static int eventfs_set_attr(struct mnt_i
 	const char *name;
 	int ret;
 
-	mutex_lock(&eventfs_mutex);
+	guard(mutex)(&eventfs_mutex);
 	ei = dentry->d_fsdata;
-	if (ei->is_freed) {
-		/* Do not allow changes if the event is about to be removed. */
-		mutex_unlock(&eventfs_mutex);
+	/* Do not allow changes if the event is about to be removed. */
+	if (ei->is_freed)
 		return -ENODEV;
-	}
 
 	/* Preallocate the children mode array if necessary */
 	if (!(dentry->d_inode->i_mode & S_IFDIR)) {
 		if (!ei->entry_attrs) {
 			ei->entry_attrs = kzalloc_objs(*ei->entry_attrs,
 						       ei->nr_entries, GFP_NOFS);
-			if (!ei->entry_attrs) {
-				ret = -ENOMEM;
-				goto out;
-			}
+			if (!ei->entry_attrs)
+				return -ENOMEM;
 		}
 	}
 
 	ret = simple_setattr(idmap, dentry, iattr);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	/*
 	 * If this is a dir, then update the ei cache, only the file
@@ -225,8 +221,6 @@ static int eventfs_set_attr(struct mnt_i
 			}
 		}
 	}
- out:
-	mutex_unlock(&eventfs_mutex);
 	return ret;
 }
 
@@ -530,26 +524,24 @@ static struct dentry *eventfs_root_looku
 	struct tracefs_inode *ti;
 	struct eventfs_inode *ei;
 	const char *name = dentry->d_name.name;
-	struct dentry *result = NULL;
 
 	ti = get_tracefs(dir);
 	if (WARN_ON_ONCE(!(ti->flags & TRACEFS_EVENT_INODE)))
 		return ERR_PTR(-EIO);
 
-	mutex_lock(&eventfs_mutex);
+	guard(mutex)(&eventfs_mutex);
 
 	ei = ti->private;
 	if (!ei || ei->is_freed)
-		goto out;
+		return NULL;
 
 	list_for_each_entry(ei_child, &ei->children, list) {
 		if (strcmp(ei_child->name, name) != 0)
 			continue;
 		/* A child is freed and removed from the list at the same time */
 		if (WARN_ON_ONCE(ei_child->is_freed))
-			goto out;
-		result = lookup_dir_entry(dentry, ei, ei_child);
-		goto out;
+			return NULL;
+		return lookup_dir_entry(dentry, ei, ei_child);
 	}
 
 	for (int i = 0; i < ei->nr_entries; i++) {
@@ -563,14 +555,12 @@ static struct dentry *eventfs_root_looku
 
 		data = ei->data;
 		if (entry->callback(name, &mode, &data, &fops) <= 0)
-			goto out;
+			return NULL;
+
+		return lookup_file_dentry(dentry, ei, i, mode, data, fops);
 
-		result = lookup_file_dentry(dentry, ei, i, mode, data, fops);
-		goto out;
 	}
- out:
-	mutex_unlock(&eventfs_mutex);
-	return result;
+	return NULL;
 }
 
 /*
@@ -586,7 +576,6 @@ static int eventfs_iterate(struct file *
 	struct eventfs_inode *ei;
 	const char *name;
 	umode_t mode;
-	int idx;
 	int ret = -EINVAL;
 	int ino;
 	int i, r, c;
@@ -600,16 +589,13 @@ static int eventfs_iterate(struct file *
 
 	c = ctx->pos - 2;
 
-	idx = srcu_read_lock(&eventfs_srcu);
+	guard(srcu)(&eventfs_srcu);
 
-	mutex_lock(&eventfs_mutex);
-	ei = READ_ONCE(ti->private);
-	if (ei && ei->is_freed)
-		ei = NULL;
-	mutex_unlock(&eventfs_mutex);
-
-	if (!ei)
-		goto out;
+	scoped_guard(mutex, &eventfs_mutex) {
+		ei = READ_ONCE(ti->private);
+		if (!ei || ei->is_freed)
+			return -EINVAL;
+	}
 
 	/*
 	 * Need to create the dentries and inodes to have a consistent
@@ -624,21 +610,19 @@ static int eventfs_iterate(struct file *
 		entry = &ei->entries[i];
 		name = entry->name;
 
-		mutex_lock(&eventfs_mutex);
 		/* If ei->is_freed then just bail here, nothing more to do */
-		if (ei->is_freed) {
-			mutex_unlock(&eventfs_mutex);
-			goto out;
+		scoped_guard(mutex, &eventfs_mutex) {
+			if (ei->is_freed)
+				return -EINVAL;
+			r = entry->callback(name, &mode, &cdata, &fops);
 		}
-		r = entry->callback(name, &mode, &cdata, &fops);
-		mutex_unlock(&eventfs_mutex);
 		if (r <= 0)
 			continue;
 
 		ino = EVENTFS_FILE_INODE_INO;
 
 		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
-			goto out;
+			return -EINVAL;
 	}
 
 	/* Subtract the skipped entries above */
@@ -661,19 +645,13 @@ static int eventfs_iterate(struct file *
 
 		ino = eventfs_dir_ino(ei_child);
 
-		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
-			goto out_dec;
+		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR)) {
+			/* Incremented ctx->pos without adding something, reset it */
+			ctx->pos--;
+			return -EINVAL;
+		}
 	}
-	ret = 1;
- out:
-	srcu_read_unlock(&eventfs_srcu, idx);
-
-	return ret;
-
- out_dec:
-	/* Incremented ctx->pos without adding something, reset it */
-	ctx->pos--;
-	goto out;
+	return 1;
 }
 
 /**
@@ -730,11 +708,10 @@ struct eventfs_inode *eventfs_create_dir
 	INIT_LIST_HEAD(&ei->children);
 	INIT_LIST_HEAD(&ei->list);
 
-	mutex_lock(&eventfs_mutex);
-	if (!parent->is_freed)
-		list_add_tail(&ei->list, &parent->children);
-	mutex_unlock(&eventfs_mutex);
-
+	scoped_guard(mutex, &eventfs_mutex) {
+		if (!parent->is_freed)
+			list_add_tail(&ei->list, &parent->children);
+	}
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {
 		cleanup_ei(ei);
@@ -880,9 +857,8 @@ void eventfs_remove_dir(struct eventfs_i
 	if (!ei)
 		return;
 
-	mutex_lock(&eventfs_mutex);
+	guard(mutex)(&eventfs_mutex);
 	eventfs_remove_rec(ei, 0);
-	mutex_unlock(&eventfs_mutex);
 }
 
 /**


