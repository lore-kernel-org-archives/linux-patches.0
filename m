Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4784196D90;
	Thu,  6 Jun 2024 14:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683667; cv=none; b=PHQ3PcsxOTvhLOx/IeyP3zlfPsHRtfdCMH+PylZ9cBsMIS7itGm4z6WITUvw/ptC3VCU1uYjLufpLMcESwEDfRfiN3mQjZCdfTUeK1Sc3IOR6pOhvJ/93z1R5ZRsBuw75V7w4eLPWCuUSy3r+fUIzSurklkl628BZs2DyBP+6Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683667; c=relaxed/simple;
	bh=QFVHbQ/ZdIXNl5ymhwklX/UtLee3WymPp7pGSxZuXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jG8X1ngQhjm/C8z8deomae0LZdqH3v+OtxO+9twvJ/GA3yABpFh5e+u8pmHgBQEjAW81D8RaAZmyiw/Qmu3ycnJSosgxs0wqlZYEqUuWRs5Jh/FCXv4XVq14jiC8rPeloNwmCdi/6vv4HNZzbHxW4s78RuGwvfwl2zmKCQ6pZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaL8A0mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaL8A0mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BE2C2BD10;
	Thu,  6 Jun 2024 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683667;
	bh=QFVHbQ/ZdIXNl5ymhwklX/UtLee3WymPp7pGSxZuXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaL8A0mY9RnsJuHAyrvohnIaoyNk80CA+DCwqYKMmZzmiDGdU/pmYqUmDqYrAT10I
	 n52oOtuXfilxSfcba7AOSAdJUMLVdae+rdeS3nqS2rV8qEU36jrAKq1wC8sxllaC33
	 cPRgD1uoWX/j49dXJMUWR7sjE5Pyl9kJPD+ZoMkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tze-nan wu <Tze-nan.Wu@mediatek.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 554/744] eventfs/tracing: Add callback for release of an eventfs_inode
Date: Thu,  6 Jun 2024 16:03:46 +0200
Message-ID: <20240606131750.227122575@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit b63db58e2fa5d6963db9c45df88e60060f0ff35f ]

Synthetic events create and destroy tracefs files when they are created
and removed. The tracing subsystem has its own file descriptor
representing the state of the events attached to the tracefs files.
There's a race between the eventfs files and this file descriptor of the
tracing system where the following can cause an issue:

With two scripts 'A' and 'B' doing:

  Script 'A':
    echo "hello int aaa" > /sys/kernel/tracing/synthetic_events
    while :
    do
      echo 0 > /sys/kernel/tracing/events/synthetic/hello/enable
    done

  Script 'B':
    echo > /sys/kernel/tracing/synthetic_events

Script 'A' creates a synthetic event "hello" and then just writes zero
into its enable file.

Script 'B' removes all synthetic events (including the newly created
"hello" event).

What happens is that the opening of the "enable" file has:

 {
	struct trace_event_file *file = inode->i_private;
	int ret;

	ret = tracing_check_open_get_tr(file->tr);
 [..]

But deleting the events frees the "file" descriptor, and a "use after
free" happens with the dereference at "file->tr".

The file descriptor does have a reference counter, but there needs to be a
way to decrement it from the eventfs when the eventfs_inode is removed
that represents this file descriptor.

Add an optional "release" callback to the eventfs_entry array structure,
that gets called when the eventfs file is about to be removed. This allows
for the creating on the eventfs file to increment the tracing file
descriptor ref counter. When the eventfs file is deleted, it can call the
release function that will call the put function for the tracing file
descriptor.

This will protect the tracing file from being freed while a eventfs file
that references it is being opened.

Link: https://lore.kernel.org/linux-trace-kernel/20240426073410.17154-1-Tze-nan.Wu@mediatek.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240502090315.448cba46@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: Tze-nan wu <Tze-nan.Wu@mediatek.com>
Tested-by: Tze-nan Wu (吳澤南) <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c    | 23 +++++++++++++++++++++--
 include/linux/tracefs.h     |  3 +++
 kernel/trace/trace_events.c | 12 ++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 6d3a11b0c606a..a598fec065684 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -83,10 +83,17 @@ enum {
 static void release_ei(struct kref *ref)
 {
 	struct eventfs_inode *ei = container_of(ref, struct eventfs_inode, kref);
+	const struct eventfs_entry *entry;
 	struct eventfs_root_inode *rei;
 
 	WARN_ON_ONCE(!ei->is_freed);
 
+	for (int i = 0; i < ei->nr_entries; i++) {
+		entry = &ei->entries[i];
+		if (entry->release)
+			entry->release(entry->name, ei->data);
+	}
+
 	kfree(ei->entry_attrs);
 	kfree_const(ei->name);
 	if (ei->is_events) {
@@ -111,6 +118,18 @@ static inline void free_ei(struct eventfs_inode *ei)
 	}
 }
 
+/*
+ * Called when creation of an ei fails, do not call release() functions.
+ */
+static inline void cleanup_ei(struct eventfs_inode *ei)
+{
+	if (ei) {
+		/* Set nr_entries to 0 to prevent release() function being called */
+		ei->nr_entries = 0;
+		free_ei(ei);
+	}
+}
+
 static inline struct eventfs_inode *get_ei(struct eventfs_inode *ei)
 {
 	if (ei)
@@ -737,7 +756,7 @@ struct eventfs_inode *eventfs_create_dir(const char *name, struct eventfs_inode
 
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {
-		free_ei(ei);
+		cleanup_ei(ei);
 		ei = NULL;
 	}
 	return ei;
@@ -830,7 +849,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	return ei;
 
  fail:
-	free_ei(ei);
+	cleanup_ei(ei);
 	tracefs_failed_creating(dentry);
 	return ERR_PTR(-ENOMEM);
 }
diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
index 7a5fe17b6bf9c..d03f746587167 100644
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -62,6 +62,8 @@ struct eventfs_file;
 typedef int (*eventfs_callback)(const char *name, umode_t *mode, void **data,
 				const struct file_operations **fops);
 
+typedef void (*eventfs_release)(const char *name, void *data);
+
 /**
  * struct eventfs_entry - dynamically created eventfs file call back handler
  * @name:	Then name of the dynamic file in an eventfs directory
@@ -72,6 +74,7 @@ typedef int (*eventfs_callback)(const char *name, umode_t *mode, void **data,
 struct eventfs_entry {
 	const char			*name;
 	eventfs_callback		callback;
+	eventfs_release			release;
 };
 
 struct eventfs_inode;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 99f1308122866..2ae0f2807438a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2518,6 +2518,14 @@ static int event_callback(const char *name, umode_t *mode, void **data,
 	return 0;
 }
 
+/* The file is incremented on creation and freeing the enable file decrements it */
+static void event_release(const char *name, void *data)
+{
+	struct trace_event_file *file = data;
+
+	event_file_put(file);
+}
+
 static int
 event_create_dir(struct eventfs_inode *parent, struct trace_event_file *file)
 {
@@ -2532,6 +2540,7 @@ event_create_dir(struct eventfs_inode *parent, struct trace_event_file *file)
 		{
 			.name		= "enable",
 			.callback	= event_callback,
+			.release	= event_release,
 		},
 		{
 			.name		= "filter",
@@ -2600,6 +2609,9 @@ event_create_dir(struct eventfs_inode *parent, struct trace_event_file *file)
 		return ret;
 	}
 
+	/* Gets decremented on freeing of the "enable" file */
+	event_file_get(file);
+
 	return 0;
 }
 
-- 
2.43.0



