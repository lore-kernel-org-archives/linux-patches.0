Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541C5196D90;
	Thu,  6 Jun 2024 14:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683667; cv=none; b=owpv7PSx33O14CrrSXWCim6yrRh2BxvEd0HjV4pJnMrai6t/tvmX0cdSj4KUvLmdQtZMAwUe/st7l51uC8sfMqGwLwwNIbXPqGYvVhUTgMtVyZolyWnmKbNSMHCTAxjMCXT+s5CBtzB9jhBNhepZCffGr5cHslLjMtoReU0vQo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683667; c=relaxed/simple;
	bh=hW9t5STaZj9wdX+JzmK5zosJGo7lEpDnDV2uVWy4qAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGpU01VqNEyiCcb0w0O17UZSfwnta9Tg0uGEs2j2iMXVF76Uh+Gf5C3P6y+WvvvoiRGqzqNjM5wsIh8U5SHT/sk2dQgAZdNwMPyzNJkxj016xTbFM1yJiM1bGxliVhMdmL/VmftNmlWC7wK2S6g1jjvQgu2B+FPWfPDTRmEMe1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcXutyEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcXutyEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E8DC2BD10;
	Thu,  6 Jun 2024 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683667;
	bh=hW9t5STaZj9wdX+JzmK5zosJGo7lEpDnDV2uVWy4qAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcXutyEdp1uJPk4wtarHvetY2+SPIFU/xXfE6iv2ReM+g46NvWxdWu+xnaVNk5VYX
	 7f74RpwM3stStFRSnqbb9yDr+FDHX0aFMm9oZYaDVn8lhSpRLvCAtdHqnn9ovk9jUO
	 0uP+WY8ELcG84D4t5H72RMWwKLST8Gi+eekKO7+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 553/744] eventfs: Create eventfs_root_inode to store dentry
Date: Thu,  6 Jun 2024 16:03:45 +0200
Message-ID: <20240606131750.194303597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit c3137ab6318d56370dd5541ebf027ddfc0c8557c ]

Only the root "events" directory stores a dentry. There's no reason to
hold a dentry pointer for every eventfs_inode as it is never set except
for the root "events" eventfs_inode.

Create a eventfs_root_inode structure that holds the events_dir dentry.
The "events" eventfs_inode *is* special, let it have its own descriptor.

Link: https://lore.kernel.org/linux-trace-kernel/20240201161617.658992558@goodmis.org

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: b63db58e2fa5 ("eventfs/tracing: Add callback for release of an eventfs_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 65 +++++++++++++++++++++++++++++++++-------
 fs/tracefs/internal.h    |  2 --
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 47228de4c17af..6d3a11b0c606a 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -35,6 +35,17 @@ static DEFINE_MUTEX(eventfs_mutex);
 /* Choose something "unique" ;-) */
 #define EVENTFS_FILE_INODE_INO		0x12c4e37
 
+struct eventfs_root_inode {
+	struct eventfs_inode		ei;
+	struct dentry			*events_dir;
+};
+
+static struct eventfs_root_inode *get_root_inode(struct eventfs_inode *ei)
+{
+	WARN_ON_ONCE(!ei->is_events);
+	return container_of(ei, struct eventfs_root_inode, ei);
+}
+
 /* Just try to make something consistent and unique */
 static int eventfs_dir_ino(struct eventfs_inode *ei)
 {
@@ -72,12 +83,18 @@ enum {
 static void release_ei(struct kref *ref)
 {
 	struct eventfs_inode *ei = container_of(ref, struct eventfs_inode, kref);
+	struct eventfs_root_inode *rei;
 
 	WARN_ON_ONCE(!ei->is_freed);
 
 	kfree(ei->entry_attrs);
 	kfree_const(ei->name);
-	kfree_rcu(ei, rcu);
+	if (ei->is_events) {
+		rei = get_root_inode(ei);
+		kfree_rcu(rei, ei.rcu);
+	} else {
+		kfree_rcu(ei, rcu);
+	}
 }
 
 static inline void put_ei(struct eventfs_inode *ei)
@@ -418,19 +435,43 @@ static struct dentry *lookup_dir_entry(struct dentry *dentry,
 	return NULL;
 }
 
+static inline struct eventfs_inode *init_ei(struct eventfs_inode *ei, const char *name)
+{
+	ei->name = kstrdup_const(name, GFP_KERNEL);
+	if (!ei->name)
+		return NULL;
+	kref_init(&ei->kref);
+	return ei;
+}
+
 static inline struct eventfs_inode *alloc_ei(const char *name)
 {
 	struct eventfs_inode *ei = kzalloc(sizeof(*ei), GFP_KERNEL);
+	struct eventfs_inode *result;
 
 	if (!ei)
 		return NULL;
 
-	ei->name = kstrdup_const(name, GFP_KERNEL);
-	if (!ei->name) {
+	result = init_ei(ei, name);
+	if (!result)
 		kfree(ei);
+
+	return result;
+}
+
+static inline struct eventfs_inode *alloc_root_ei(const char *name)
+{
+	struct eventfs_root_inode *rei = kzalloc(sizeof(*rei), GFP_KERNEL);
+	struct eventfs_inode *ei;
+
+	if (!rei)
 		return NULL;
-	}
-	kref_init(&ei->kref);
+
+	rei->ei.is_events = 1;
+	ei = init_ei(&rei->ei, name);
+	if (!ei)
+		kfree(rei);
+
 	return ei;
 }
 
@@ -719,6 +760,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 						int size, void *data)
 {
 	struct dentry *dentry = tracefs_start_creating(name, parent);
+	struct eventfs_root_inode *rei;
 	struct eventfs_inode *ei;
 	struct tracefs_inode *ti;
 	struct inode *inode;
@@ -731,7 +773,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
-	ei = alloc_ei(name);
+	ei = alloc_root_ei(name);
 	if (!ei)
 		goto fail;
 
@@ -740,10 +782,11 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 		goto fail;
 
 	// Note: we have a ref to the dentry from tracefs_start_creating()
-	ei->events_dir = dentry;
+	rei = get_root_inode(ei);
+	rei->events_dir = dentry;
+
 	ei->entries = entries;
 	ei->nr_entries = size;
-	ei->is_events = 1;
 	ei->data = data;
 
 	/* Save the ownership of this directory */
@@ -846,13 +889,15 @@ void eventfs_remove_dir(struct eventfs_inode *ei)
  */
 void eventfs_remove_events_dir(struct eventfs_inode *ei)
 {
+	struct eventfs_root_inode *rei;
 	struct dentry *dentry;
 
-	dentry = ei->events_dir;
+	rei = get_root_inode(ei);
+	dentry = rei->events_dir;
 	if (!dentry)
 		return;
 
-	ei->events_dir = NULL;
+	rei->events_dir = NULL;
 	eventfs_remove_dir(ei);
 
 	/*
diff --git a/fs/tracefs/internal.h b/fs/tracefs/internal.h
index b79ab2827b504..f704d8348357e 100644
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -39,7 +39,6 @@ struct eventfs_attr {
  * @children:	link list into the child eventfs_inode
  * @entries:	the array of entries representing the files in the directory
  * @name:	the name of the directory to create
- * @events_dir: the dentry of the events directory
  * @entry_attrs: Saved mode and ownership of the @d_children
  * @data:	The private data to pass to the callbacks
  * @attr:	Saved mode and ownership of eventfs_inode itself
@@ -57,7 +56,6 @@ struct eventfs_inode {
 	struct list_head		children;
 	const struct eventfs_entry	*entries;
 	const char			*name;
-	struct dentry			*events_dir;
 	struct eventfs_attr		*entry_attrs;
 	void				*data;
 	struct eventfs_attr		attr;
-- 
2.43.0



