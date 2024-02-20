Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B316C2DF9F;
	Tue, 20 Feb 2024 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464922; cv=none; b=Am4VVwxYDOTTJD5AEbGbQqOXdJdqBUVqLB/V3UWtOhrewlvp/l6OuLuga8otcCpNXg1bnuuzeA1lH4vRBTpbJ8E78nvghVlMruAhiyJMuU4brQWqzjl9plXTtT71S7Yr6I8nO1dbE6Q8EFbOFTxMTil+/V97g0/FyIhRSUE7NuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464922; c=relaxed/simple;
	bh=tGAI2Bs/Rxf24ING7WFYPxeDSbRbtV3hpaZtSBxTJNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8Rl7K2oC4TtD9YHvrSBXo8yyaOLdb5Ky8bGK5MDEbPweyrP42Tb20R2FSvt4exVahogMgNSqGAxYNDO3lp5c1G4UXtBr2O9lRT7XS7Jhj4GDTj07CePlInyZKXK9VLTo+VBPI7GPgwvsRDMlRL/+vqsImcxTvgr/fns1omHMNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjM8oQpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjM8oQpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20454C433C7;
	Tue, 20 Feb 2024 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464922;
	bh=tGAI2Bs/Rxf24ING7WFYPxeDSbRbtV3hpaZtSBxTJNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjM8oQpe/1JrvG1VayoQXtsftBbAQ6esohUrzBPD5V33IfKVQhobTrRl+Y8BrMk3r
	 qe+Qa7Aasy1qIduWzR5lZ/WCQZ2lqwW5NA7LvQsIaVqC0n5kNEQmjJdPrqpijZCac2
	 LymBq003F2lqs2zaW+hnDu2monEPte9m65kT7wB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ajay Kaher <akaher@vmware.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 179/309] eventfs: Remove "lookup" parameter from create_dir/file_dentry()
Date: Tue, 20 Feb 2024 21:55:38 +0100
Message-ID: <20240220205638.751672319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit b0f7e2d739b4aac131ea1662d086a07775097b05 upstream.

The "lookup" parameter is a way to differentiate the call to
create_file/dir_dentry() from when it's just a lookup (no need to up the
dentry refcount) and accessed via a readdir (need to up the refcount).

But reality, it just makes the code more complex. Just up the refcount and
let the caller decide to dput() the result or not.

Link: https://lore.kernel.org/linux-trace-kernel/20240103102553.17a19cea@gandalf.local.home
Link: https://lore.kernel.org/linux-trace-kernel/20240104015435.517502710@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   55 +++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -419,16 +419,14 @@ void eventfs_set_ei_status_free(struct t
  * @mode: The mode of the file.
  * @data: The data to use to set the inode of the file with on open()
  * @fops: The fops of the file to be created.
- * @lookup: If called by the lookup routine, in which case, dput() the created dentry.
  *
  * Create a dentry for a file of an eventfs_inode @ei and place it into the
- * address located at @e_dentry. If the @e_dentry already has a dentry, then
- * just do a dget() on it and return. Otherwise create the dentry and attach it.
+ * address located at @e_dentry.
  */
 static struct dentry *
 create_file_dentry(struct eventfs_inode *ei, int idx,
 		   struct dentry *parent, const char *name, umode_t mode, void *data,
-		   const struct file_operations *fops, bool lookup)
+		   const struct file_operations *fops)
 {
 	struct eventfs_attr *attr = NULL;
 	struct dentry **e_dentry = &ei->d_children[idx];
@@ -443,9 +441,7 @@ create_file_dentry(struct eventfs_inode
 	}
 	/* If the e_dentry already has a dentry, use it */
 	if (*e_dentry) {
-		/* lookup does not need to up the ref count */
-		if (!lookup)
-			dget(*e_dentry);
+		dget(*e_dentry);
 		mutex_unlock(&eventfs_mutex);
 		return *e_dentry;
 	}
@@ -470,13 +466,12 @@ create_file_dentry(struct eventfs_inode
 		 * way to being freed, don't return it. If e_dentry is NULL
 		 * it means it was already freed.
 		 */
-		if (ei->is_freed)
+		if (ei->is_freed) {
 			dentry = NULL;
-		else
+		} else {
 			dentry = *e_dentry;
-		/* The lookup does not need to up the dentry refcount */
-		if (dentry && !lookup)
 			dget(dentry);
+		}
 		mutex_unlock(&eventfs_mutex);
 		return dentry;
 	}
@@ -494,9 +489,6 @@ create_file_dentry(struct eventfs_inode
 	}
 	mutex_unlock(&eventfs_mutex);
 
-	if (lookup)
-		dput(dentry);
-
 	return dentry;
 }
 
@@ -529,13 +521,12 @@ static void eventfs_post_create_dir(stru
  * @pei: The eventfs_inode parent of ei.
  * @ei: The eventfs_inode to create the directory for
  * @parent: The dentry of the parent of this directory
- * @lookup: True if this is called by the lookup code
  *
  * This creates and attaches a directory dentry to the eventfs_inode @ei.
  */
 static struct dentry *
 create_dir_dentry(struct eventfs_inode *pei, struct eventfs_inode *ei,
-		  struct dentry *parent, bool lookup)
+		  struct dentry *parent)
 {
 	struct dentry *dentry = NULL;
 
@@ -547,11 +538,9 @@ create_dir_dentry(struct eventfs_inode *
 		return NULL;
 	}
 	if (ei->dentry) {
-		/* If the dentry already has a dentry, use it */
+		/* If the eventfs_inode already has a dentry, use it */
 		dentry = ei->dentry;
-		/* lookup does not need to up the ref count */
-		if (!lookup)
-			dget(dentry);
+		dget(dentry);
 		mutex_unlock(&eventfs_mutex);
 		return dentry;
 	}
@@ -571,7 +560,7 @@ create_dir_dentry(struct eventfs_inode *
 		 * way to being freed.
 		 */
 		dentry = ei->dentry;
-		if (dentry && !lookup)
+		if (dentry)
 			dget(dentry);
 		mutex_unlock(&eventfs_mutex);
 		return dentry;
@@ -591,9 +580,6 @@ create_dir_dentry(struct eventfs_inode *
 	}
 	mutex_unlock(&eventfs_mutex);
 
-	if (lookup)
-		dput(dentry);
-
 	return dentry;
 }
 
@@ -618,8 +604,8 @@ static struct dentry *eventfs_root_looku
 	struct eventfs_inode *ei;
 	struct dentry *ei_dentry = NULL;
 	struct dentry *ret = NULL;
+	struct dentry *d;
 	const char *name = dentry->d_name.name;
-	bool created = false;
 	umode_t mode;
 	void *data;
 	int idx;
@@ -655,13 +641,10 @@ static struct dentry *eventfs_root_looku
 		ret = simple_lookup(dir, dentry, flags);
 		if (IS_ERR(ret))
 			goto out;
-		create_dir_dentry(ei, ei_child, ei_dentry, true);
-		created = true;
-		break;
-	}
-
-	if (created)
+		d = create_dir_dentry(ei, ei_child, ei_dentry);
+		dput(d);
 		goto out;
+	}
 
 	for (i = 0; i < ei->nr_entries; i++) {
 		entry = &ei->entries[i];
@@ -679,8 +662,8 @@ static struct dentry *eventfs_root_looku
 			ret = simple_lookup(dir, dentry, flags);
 			if (IS_ERR(ret))
 				goto out;
-			create_file_dentry(ei, i, ei_dentry, name, mode, cdata,
-					   fops, true);
+			d = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
+			dput(d);
 			break;
 		}
 	}
@@ -797,9 +780,10 @@ static int dcache_dir_open_wrapper(struc
 	inode_lock(parent->d_inode);
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
-		d = create_dir_dentry(ei, ei_child, parent, false);
+		d = create_dir_dentry(ei, ei_child, parent);
 		if (d) {
 			ret = add_dentries(&dentries, d, cnt);
+			dput(d);
 			if (ret < 0)
 				break;
 			cnt++;
@@ -819,9 +803,10 @@ static int dcache_dir_open_wrapper(struc
 		mutex_unlock(&eventfs_mutex);
 		if (r <= 0)
 			continue;
-		d = create_file_dentry(ei, i, parent, name, mode, cdata, fops, false);
+		d = create_file_dentry(ei, i, parent, name, mode, cdata, fops);
 		if (d) {
 			ret = add_dentries(&dentries, d, cnt);
+			dput(d);
 			if (ret < 0)
 				break;
 			cnt++;


