Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF231C3733;
	Thu,  6 Jun 2024 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683663; cv=none; b=AlnykLNX/pIwz2Nt4rYZNMHUNcfSCAlRN/1gmmkRVrOFtfSaEFPokPpCpr7S2U2eaJ3FTwXerZtzSq6R4Y2fqeuKPY53oefzGod2GMoM93fa3vHSM8c3aNFW4WZxXU456ZHZ2jq4ZIRE2MaUZITolHTTfjj0wL3DMGe3lbl7qf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683663; c=relaxed/simple;
	bh=39eTZJN+tx7DhLpwo1W46pEssXtrGaC8It8bfJHIZKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdT2/cB2pZtK0yf7mNshNDNseIMIRG6bjEcMS2DXf4mEPgQm//JTWUpcHTQ6X7hJZ4cFWhzamfUr/FtqYMqH/CjISwjIbVyq+X7fexaT2Hl0ObShVRMjqCbDfol6h+YJauhhElD/FBJJGnIq2yJ1aHZSwhqR+EJehGPRs5ozjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UziZYrgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UziZYrgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE68C2BD10;
	Thu,  6 Jun 2024 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683663;
	bh=39eTZJN+tx7DhLpwo1W46pEssXtrGaC8It8bfJHIZKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UziZYrgWWV1gcveKGjIif9YHPyzUCn98DdIbwHYJFwWrcj1M1jLXydO2NOJkmpc/a
	 +em4ZG9kaa2I2UpbZ6xAVr2QKWNHc3CHLQXCbOHU8nlfxi3ii4ARVuMvNK7YWS348T
	 /dKR3zqQOdavcVIvTdhkDnxNg48AUKosBJWsTDQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 546/744] eventfs: Do not differentiate the toplevel events directory
Date: Thu,  6 Jun 2024 16:03:38 +0200
Message-ID: <20240606131749.960457866@linuxfoundation.org>
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

[ Upstream commit d53891d348ac3eceaf48f4732a1f4f5c0e0a55ce ]

The toplevel events directory is really no different than the events
directory of instances. Having the two be different caused
inconsistencies and made it harder to fix the permissions bugs.

Make all events directories act the same.

Link: https://lore.kernel.org/linux-trace-kernel/20240502200905.846448710@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 8186fff7ab649 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 29 ++++++++---------------------
 fs/tracefs/internal.h    |  7 +++----
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 56d1741fe0413..47228de4c17af 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -57,7 +57,6 @@ enum {
 	EVENTFS_SAVE_MODE	= BIT(16),
 	EVENTFS_SAVE_UID	= BIT(17),
 	EVENTFS_SAVE_GID	= BIT(18),
-	EVENTFS_TOPLEVEL	= BIT(19),
 };
 
 #define EVENTFS_MODE_MASK	(EVENTFS_SAVE_MODE - 1)
@@ -182,14 +181,10 @@ static int eventfs_set_attr(struct mnt_idmap *idmap, struct dentry *dentry,
 	return ret;
 }
 
-static void update_top_events_attr(struct eventfs_inode *ei, struct super_block *sb)
+static void update_events_attr(struct eventfs_inode *ei, struct super_block *sb)
 {
 	struct inode *root;
 
-	/* Only update if the "events" was on the top level */
-	if (!ei || !(ei->attr.mode & EVENTFS_TOPLEVEL))
-		return;
-
 	/* Get the tracefs root inode. */
 	root = d_inode(sb->s_root);
 	ei->attr.uid = root->i_uid;
@@ -202,10 +197,10 @@ static void set_top_events_ownership(struct inode *inode)
 	struct eventfs_inode *ei = ti->private;
 
 	/* The top events directory doesn't get automatically updated */
-	if (!ei || !ei->is_events || !(ei->attr.mode & EVENTFS_TOPLEVEL))
+	if (!ei || !ei->is_events)
 		return;
 
-	update_top_events_attr(ei, inode->i_sb);
+	update_events_attr(ei, inode->i_sb);
 
 	if (!(ei->attr.mode & EVENTFS_SAVE_UID))
 		inode->i_uid = ei->attr.uid;
@@ -234,7 +229,7 @@ static int eventfs_permission(struct mnt_idmap *idmap,
 	return generic_permission(idmap, inode, mask);
 }
 
-static const struct inode_operations eventfs_root_dir_inode_operations = {
+static const struct inode_operations eventfs_dir_inode_operations = {
 	.lookup		= eventfs_root_lookup,
 	.setattr	= eventfs_set_attr,
 	.getattr	= eventfs_get_attr,
@@ -302,7 +297,7 @@ static struct eventfs_inode *eventfs_find_events(struct dentry *dentry)
 		// Walk upwards until you find the events inode
 	} while (!ei->is_events);
 
-	update_top_events_attr(ei, dentry->d_sb);
+	update_events_attr(ei, dentry->d_sb);
 
 	return ei;
 }
@@ -406,7 +401,7 @@ static struct dentry *lookup_dir_entry(struct dentry *dentry,
 	update_inode_attr(dentry, inode, &ei->attr,
 			  S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
 
-	inode->i_op = &eventfs_root_dir_inode_operations;
+	inode->i_op = &eventfs_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
 	/* All directories will have the same inode number */
@@ -755,14 +750,6 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	uid = d_inode(dentry->d_parent)->i_uid;
 	gid = d_inode(dentry->d_parent)->i_gid;
 
-	/*
-	 * If the events directory is of the top instance, then parent
-	 * is NULL. Set the attr.mode to reflect this and its permissions will
-	 * default to the tracefs root dentry.
-	 */
-	if (!parent)
-		ei->attr.mode = EVENTFS_TOPLEVEL;
-
 	/* This is used as the default ownership of the files and directories */
 	ei->attr.uid = uid;
 	ei->attr.gid = gid;
@@ -771,13 +758,13 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	INIT_LIST_HEAD(&ei->list);
 
 	ti = get_tracefs(inode);
-	ti->flags |= TRACEFS_EVENT_INODE | TRACEFS_EVENT_TOP_INODE;
+	ti->flags |= TRACEFS_EVENT_INODE;
 	ti->private = ei;
 
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	inode->i_uid = uid;
 	inode->i_gid = gid;
-	inode->i_op = &eventfs_root_dir_inode_operations;
+	inode->i_op = &eventfs_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
 	dentry->d_fsdata = get_ei(ei);
diff --git a/fs/tracefs/internal.h b/fs/tracefs/internal.h
index 824cbe83679cc..b79ab2827b504 100644
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -4,10 +4,9 @@
 
 enum {
 	TRACEFS_EVENT_INODE		= BIT(1),
-	TRACEFS_EVENT_TOP_INODE		= BIT(2),
-	TRACEFS_GID_PERM_SET		= BIT(3),
-	TRACEFS_UID_PERM_SET		= BIT(4),
-	TRACEFS_INSTANCE_INODE		= BIT(5),
+	TRACEFS_GID_PERM_SET		= BIT(2),
+	TRACEFS_UID_PERM_SET		= BIT(3),
+	TRACEFS_INSTANCE_INODE		= BIT(4),
 };
 
 struct tracefs_inode {
-- 
2.43.0



