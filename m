Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23982DF9F;
	Tue, 20 Feb 2024 21:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464146; cv=none; b=GJqxdDbDg/UIYfhGARfSRUWv3lLW4Asi9YEMJlxX5NudKovQ8eYvE5gNPJ7EqKx5YwgLDnvH+x24GbcSHoTJWgJ9c8h+vpvsSFC38zu0omUZPnW33mcelVe0KBSfzA4qlrBUd3jq0IKs0vDcmpPAEDookFHRJX9Vwck9vSmVGAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464146; c=relaxed/simple;
	bh=4HCcs6ZyiBNQBIzzTjNBV1I11u0JEmc8MmkFcc1M7+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hks565zYRfO1chgHw32H3W2vYJH6X3HJRvzcDhRgM3ocldMuwB4vplWd8wAZAopdM2V4FPe+YpKpOpSMQdypcQOw/+8U4iNqBawUc/AO8izSFAqzwVLkv/a3X4QdJjDJnVgSsoxWhIZpuYuj2n/WUgGpVNao2kMjSSIVgWwETcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdEI9TXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdEI9TXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2288DC43390;
	Tue, 20 Feb 2024 21:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464146;
	bh=4HCcs6ZyiBNQBIzzTjNBV1I11u0JEmc8MmkFcc1M7+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdEI9TXV8Ydx3KG+cJPiol4duAk7P0x85VfnGlr3BR4kNbe22wAojxEWRSEc5tX3x
	 AlrvB+yWCKVSpvHt8N4LJHII3/FlvOQ7eS2b8pvL5aj2IUIQuryiV7enIFW/2skNkv
	 dz6jADMCRnFU1e3mL8qgJmuF/21qJbu8zKeHuMro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 265/331] eventfs: Use eventfs_remove_events_dir()
Date: Tue, 20 Feb 2024 21:56:21 +0100
Message-ID: <20240220205646.205664386@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 2819f23ac12ce93ff79ca7a54597df9a4a1f6331 upstream.

The update to removing the eventfs_file changed the way the events top
level directory was handled. Instead of returning a dentry, it now returns
the eventfs_inode. In this changed, the removing of the events top level
directory is not much different than removing any of the other
directories. Because of this, the removal just called eventfs_remove_dir()
instead of eventfs_remove_events_dir().

Although eventfs_remove_dir() does the clean up, it misses out on the
dget() of the ei->dentry done in eventfs_create_events_dir(). It makes
more sense to match eventfs_create_events_dir() with a specific function
eventfs_remove_events_dir() and this specific function can then perform
the dput() to the dentry that had the dget() when it was created.

Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310051743.y9EobbUr-lkp@intel.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c    |   19 +++++++------------
 include/linux/tracefs.h     |    1 +
 kernel/trace/trace_events.c |    2 +-
 3 files changed, 9 insertions(+), 13 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -901,22 +901,17 @@ void eventfs_remove_dir(struct eventfs_i
 }
 
 /**
- * eventfs_remove_events_dir - remove eventfs dir or file from list
- * @dentry: events's dentry to be removed.
+ * eventfs_remove_events_dir - remove the top level eventfs directory
+ * @ei: the event_inode returned by eventfs_create_events_dir().
  *
- * This function remove events main directory
+ * This function removes the events main directory
  */
-void eventfs_remove_events_dir(struct dentry *dentry)
+void eventfs_remove_events_dir(struct eventfs_inode *ei)
 {
-	struct tracefs_inode *ti;
+	struct dentry *dentry = ei->dentry;
 
-	if (!dentry || !dentry->d_inode)
-		return;
+	eventfs_remove_dir(ei);
 
-	ti = get_tracefs(dentry->d_inode);
-	if (!ti || !(ti->flags & TRACEFS_EVENT_INODE))
-		return;
-
-	d_invalidate(dentry);
+	/* Matches the dget() from eventfs_create_events_dir() */
 	dput(dentry);
 }
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -41,6 +41,7 @@ struct eventfs_inode *eventfs_create_dir
 					 const struct eventfs_entry *entries,
 					 int size, void *data);
 
+void eventfs_remove_events_dir(struct eventfs_inode *ei);
 void eventfs_remove_dir(struct eventfs_inode *ei);
 
 struct dentry *tracefs_create_file(const char *name, umode_t mode,
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3893,7 +3893,7 @@ int event_trace_del_tracer(struct trace_
 
 	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
-	eventfs_remove_dir(tr->event_dir);
+	eventfs_remove_events_dir(tr->event_dir);
 	up_write(&trace_event_sem);
 
 	tr->event_dir = NULL;


