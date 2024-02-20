Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7170151CD8;
	Tue, 20 Feb 2024 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464362; cv=none; b=sh4f/bjnuvq/NKwR1owa8eNZp6O9GEAHq8T8dNuYX7zRmibUOI0grsQv4MMASkvHFMECxw4uCYyT61tOXGvvehmohDiAFpOoLkVNVovAl2xIi+APzlc9Y9MKAu+SOulBL78lLJYRAiYxa97/XmewfQAW92vFqM8mq/wfCJ0PDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464362; c=relaxed/simple;
	bh=wv5y0MNYWKUyR8xWf9uz3ALHQ22oY4+dScZfwpKYW2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdcKXEUC566vG83GRkZ+vd1r14E4tpiPuk28bDp7552TtqqiQS5dQa6qrRuy9cVBb8KSwXAEAg8jekoJYbFvAZDhKw1yIc1y71Wa1xbg6Nes1N/oRq/8gMBA59tn7T6vMsGpHd8FqvqNRO0WKm5JAmCZcSAydxTf7eWZOT3P+Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6w0WnaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6w0WnaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D463C433F1;
	Tue, 20 Feb 2024 21:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464362;
	bh=wv5y0MNYWKUyR8xWf9uz3ALHQ22oY4+dScZfwpKYW2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6w0WnaObwcEhGEBeW1CaKRVvV0sIJ079rp3jWBxFt8DC1ZxAnAWZ8OSMMXT4eQgu
	 ycVSm+Ja0vlr0s3mGjiUtnOBaago9dsrgmlWlz9jL/AQW0O/svl49edzxKvMH/oCAk
	 Eyt0fY+AvKg2Uz3/WwXpWX/7bo7FNwKibkOP1YPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 306/331] tracefs: Avoid using the ei->dentry pointer unnecessarily
Date: Tue, 20 Feb 2024 21:57:02 +0100
Message-ID: <20240220205647.768246445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 99c001cb617df409dac275a059d6c3f187a2da7a upstream.

The eventfs_find_events() code tries to walk up the tree to find the
event directory that a dentry belongs to, in order to then find the
eventfs inode that is associated with that event directory.

However, it uses an odd combination of walking the dentry parent,
looking up the eventfs inode associated with that, and then looking up
the dentry from there.  Repeat.

But the code shouldn't have back-pointers to dentries in the first
place, and it should just walk the dentry parenthood chain directly.

Similarly, 'set_top_events_ownership()' looks up the dentry from the
eventfs inode, but the only reason it wants a dentry is to look up the
superblock in order to look up the root dentry.

But it already has the real filesystem inode, which has that same
superblock pointer.  So just pass in the superblock pointer using the
information that's already there, instead of looking up extraneous data
that is irrelevant.

Link: https://lore.kernel.org/linux-trace-kernel/202401291043.e62e89dc-oliver.sang@intel.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240131185512.638645365@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: c1504e510238 ("eventfs: Implement eventfs dir creation functions")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -156,33 +156,30 @@ static int eventfs_set_attr(struct mnt_i
 	return ret;
 }
 
-static void update_top_events_attr(struct eventfs_inode *ei, struct dentry *dentry)
+static void update_top_events_attr(struct eventfs_inode *ei, struct super_block *sb)
 {
-	struct inode *inode;
+	struct inode *root;
 
 	/* Only update if the "events" was on the top level */
 	if (!ei || !(ei->attr.mode & EVENTFS_TOPLEVEL))
 		return;
 
 	/* Get the tracefs root inode. */
-	inode = d_inode(dentry->d_sb->s_root);
-	ei->attr.uid = inode->i_uid;
-	ei->attr.gid = inode->i_gid;
+	root = d_inode(sb->s_root);
+	ei->attr.uid = root->i_uid;
+	ei->attr.gid = root->i_gid;
 }
 
 static void set_top_events_ownership(struct inode *inode)
 {
 	struct tracefs_inode *ti = get_tracefs(inode);
 	struct eventfs_inode *ei = ti->private;
-	struct dentry *dentry;
 
 	/* The top events directory doesn't get automatically updated */
 	if (!ei || !ei->is_events || !(ei->attr.mode & EVENTFS_TOPLEVEL))
 		return;
 
-	dentry = ei->dentry;
-
-	update_top_events_attr(ei, dentry);
+	update_top_events_attr(ei, inode->i_sb);
 
 	if (!(ei->attr.mode & EVENTFS_SAVE_UID))
 		inode->i_uid = ei->attr.uid;
@@ -235,8 +232,10 @@ static struct eventfs_inode *eventfs_fin
 
 	mutex_lock(&eventfs_mutex);
 	do {
-		/* The parent always has an ei, except for events itself */
-		ei = dentry->d_parent->d_fsdata;
+		// The parent is stable because we do not do renames
+		dentry = dentry->d_parent;
+		// ... and directories always have d_fsdata
+		ei = dentry->d_fsdata;
 
 		/*
 		 * If the ei is being freed, the ownership of the children
@@ -246,12 +245,11 @@ static struct eventfs_inode *eventfs_fin
 			ei = NULL;
 			break;
 		}
-
-		dentry = ei->dentry;
+		// Walk upwards until you find the events inode
 	} while (!ei->is_events);
 	mutex_unlock(&eventfs_mutex);
 
-	update_top_events_attr(ei, dentry);
+	update_top_events_attr(ei, dentry->d_sb);
 
 	return ei;
 }


