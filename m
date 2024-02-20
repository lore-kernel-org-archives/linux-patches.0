Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA4151CD8;
	Tue, 20 Feb 2024 21:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464273; cv=none; b=c+B559oxCymxcr8HiDcGGxbqxRPmzKg2PX7XxA+beNkZl9ShFBSTm4kTHc7AwxuZ/OmG4BTN0bUBm8pzNTr49NGb07BkJe0FpjPUTNXakGmRW2kADo3VQwqxhF1W3koSTFdzkn1QPE+GOZjCxXczDP25XiKWFYwSSWnJO8OAGr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464273; c=relaxed/simple;
	bh=HPyp0efrx9BsLaqa7jq5CvXAk2dKdM0fYEfePFetvAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjuNFecE5yOgoLRlaRIBbTqjaSfA8A/ejmkI8RFlqpYkXDYkKiho9mDIkAHxwcmxRB/j3vV4UWVrqO1U1ah+3MQgFqmbur5K1MUOt2S10MEPlNVj8V+mKY74IfFEycMpC/IN5Wiy++7y4cH6GIcI3SvO4DElxV7SOJrlCtS1mcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haF9EyhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haF9EyhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B52EC433F1;
	Tue, 20 Feb 2024 21:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464273;
	bh=HPyp0efrx9BsLaqa7jq5CvXAk2dKdM0fYEfePFetvAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haF9EyhFqiLFeM4n8hC312CW+F/i+hYgDdVQqmIvpEhFey+Wzt78HehFAJqrf6ADZ
	 h88X6X94hAQlFIOYdLUo+pZOfZL2o0e4QQYPXMZOvt+JR6BzyZqM/6kI4g3k0hSVcm
	 4/IW8JBJt19IFQiISZFuV5UlkM5YSfmeE97fFR1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <akaher@vmware.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 277/331] eventfs: Hold eventfs_mutex when calling callback functions
Date: Tue, 20 Feb 2024 21:56:33 +0100
Message-ID: <20240220205646.605764717@linuxfoundation.org>
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

commit 44365329f8219fc379097c2c9a75ff53f123764f upstream.

The callback function that is used to create inodes and dentries is not
protected by anything and the data that is passed to it could become
stale. After eventfs_remove_dir() is called by the tracing system, it is
free to remove the events that are associated to that directory.
Unfortunately, that means the callbacks must not be called after that.

     CPU0				CPU1
     ----				----
 eventfs_root_lookup() {
				 eventfs_remove_dir() {
				      mutex_lock(&event_mutex);
				      ei->is_freed = set;
				      mutex_unlock(&event_mutex);
				 }
				 kfree(event_call);

    for (...) {
      entry = &ei->entries[i];
      r = entry->callback() {
          call = data;		// call == event_call above
          if (call->flags ...)

 [ USE AFTER FREE BUG ]

The safest way to protect this is to wrap the callback with:

 mutex_lock(&eventfs_mutex);
 if (!ei->is_freed)
     r = entry->callback();
 else
     r = -1;
 mutex_unlock(&eventfs_mutex);

This will make sure that the callback will not be called after it is
freed. But now it needs to be known that the callback is called while
holding internal eventfs locks, and that it must not call back into the
eventfs / tracefs system. There's no reason it should anyway, but document
that as well.

Link: https://lore.kernel.org/all/CA+G9fYu9GOEbD=rR5eMR-=HJ8H6rMsbzDC2ZY5=Y50WpWAE7_Q@mail.gmail.com/
Link: https://lkml.kernel.org/r/20231101172649.906696613@goodmis.org

Cc: Ajay Kaher <akaher@vmware.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   22 ++++++++++++++++++++--
 include/linux/tracefs.h  |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -615,7 +615,13 @@ static struct dentry *eventfs_root_looku
 		entry = &ei->entries[i];
 		if (strcmp(name, entry->name) == 0) {
 			void *cdata = data;
-			r = entry->callback(name, &mode, &cdata, &fops);
+			mutex_lock(&eventfs_mutex);
+			/* If ei->is_freed, then the event itself may be too */
+			if (!ei->is_freed)
+				r = entry->callback(name, &mode, &cdata, &fops);
+			else
+				r = -1;
+			mutex_unlock(&eventfs_mutex);
 			if (r <= 0)
 				continue;
 			ret = simple_lookup(dir, dentry, flags);
@@ -749,7 +755,13 @@ static int dcache_dir_open_wrapper(struc
 		void *cdata = data;
 		entry = &ei->entries[i];
 		name = entry->name;
-		r = entry->callback(name, &mode, &cdata, &fops);
+		mutex_lock(&eventfs_mutex);
+		/* If ei->is_freed, then the event itself may be too */
+		if (!ei->is_freed)
+			r = entry->callback(name, &mode, &cdata, &fops);
+		else
+			r = -1;
+		mutex_unlock(&eventfs_mutex);
 		if (r <= 0)
 			continue;
 		d = create_file_dentry(ei, i, parent, name, mode, cdata, fops, false);
@@ -819,6 +831,10 @@ static int dcache_readdir_wrapper(struct
  *   data = A pointer to @data, and the callback may replace it, which will
  *         cause the file created to pass the new data to the open() call.
  *   fops = the fops to use for the created file.
+ *
+ * NB. @callback is called while holding internal locks of the eventfs
+ *     system. The callback must not call any code that might also call into
+ *     the tracefs or eventfs system or it will risk creating a deadlock.
  */
 struct eventfs_inode *eventfs_create_dir(const char *name, struct eventfs_inode *parent,
 					 const struct eventfs_entry *entries,
@@ -878,6 +894,8 @@ struct eventfs_inode *eventfs_create_dir
  * @data: The default data to pass to the files (an entry may override it).
  *
  * This function creates the top of the trace event directory.
+ *
+ * See eventfs_create_dir() for use of @entries.
  */
 struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry *parent,
 						const struct eventfs_entry *entries,
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -23,9 +23,52 @@ struct file_operations;
 
 struct eventfs_file;
 
+/**
+ * eventfs_callback - A callback function to create dynamic files in eventfs
+ * @name: The name of the file that is to be created
+ * @mode: return the file mode for the file (RW access, etc)
+ * @data: data to pass to the created file ops
+ * @fops: the file operations of the created file
+ *
+ * The evetnfs files are dynamically created. The struct eventfs_entry array
+ * is passed to eventfs_create_dir() or eventfs_create_events_dir() that will
+ * be used to create the files within those directories. When a lookup
+ * or access to a file within the directory is made, the struct eventfs_entry
+ * array is used to find a callback() with the matching name that is being
+ * referenced (for lookups, the entire array is iterated and each callback
+ * will be called).
+ *
+ * The callback will be called with @name for the name of the file to create.
+ * The callback can return less than 1 to indicate  that no file should be
+ * created.
+ *
+ * If a file is to be created, then @mode should be populated with the file
+ * mode (permissions) for which the file is created for. This would be
+ * used to set the created inode i_mode field.
+ *
+ * The @data should be set to the data passed to the other file operations
+ * (read, write, etc). Note, @data will also point to the data passed in
+ * to eventfs_create_dir() or eventfs_create_events_dir(), but the callback
+ * can replace the data if it chooses to. Otherwise, the original data
+ * will be used for the file operation functions.
+ *
+ * The @fops should be set to the file operations that will be used to create
+ * the inode.
+ *
+ * NB. This callback is called while holding internal locks of the eventfs
+ *     system. The callback must not call any code that might also call into
+ *     the tracefs or eventfs system or it will risk creating a deadlock.
+ */
 typedef int (*eventfs_callback)(const char *name, umode_t *mode, void **data,
 				const struct file_operations **fops);
 
+/**
+ * struct eventfs_entry - dynamically created eventfs file call back handler
+ * @name:	Then name of the dynamic file in an eventfs directory
+ * @callback:	The callback to get the fops of the file when it is created
+ *
+ * See evenfs_callback() typedef for how to set up @callback.
+ */
 struct eventfs_entry {
 	const char			*name;
 	eventfs_callback		callback;


