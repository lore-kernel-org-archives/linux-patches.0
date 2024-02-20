Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B682DF9F;
	Tue, 20 Feb 2024 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464932; cv=none; b=tPtwytD7PoW92SzLuURH+c3wVnTHmt2IUGfKJbK9OcleM97JWc2zNCmoBVX8OzjRvg3agZnJgM1OmawcHqlygJb3LlsirxTR4rW7bb1BIXenOWJGfAt2iAIV8ltwRtOYDinG9grdPlsyFPpHzCrsEZi49xMX9jXojlyEaIoKp30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464932; c=relaxed/simple;
	bh=T8UNv6+UuN6PT6qia4cZtbsoLt7aiAvL2z8Ee2L3pQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa3q3oCzCMstYGWSep5vVBkZc4E2WyLkaj+9cpmgvKrrcXAkyLO50JFvwMKB+UbBh59kW6bnNMrn+EJF8022f9laX+vDYlJprl+D9w/kYQgdmx/1uM57CqZsCmBdZlKMab2/PQ2BMc7st/ZktylOOtQLQdMiRsjbK+Khcmfz2Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ/G65UV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ/G65UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA30AC433F1;
	Tue, 20 Feb 2024 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464932;
	bh=T8UNv6+UuN6PT6qia4cZtbsoLt7aiAvL2z8Ee2L3pQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ/G65UVAfOAX+oQnaBmnTVyih4lRR7a9p4XOx2AF7K9xkpmdevh7FnyPPCrYKofS
	 horZnM/mmlDV4oQLOiNk+YYfaG7k63e+54vVMghJPiIGvE8OEPq2eN1MVYLCI8qjao
	 RCRsAcW0mp7GNuewidLjVRWpp7Tgs7urn1Vgzs8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 182/309] eventfs: Do ctx->pos update for all iterations in eventfs_iterate()
Date: Tue, 20 Feb 2024 21:55:41 +0100
Message-ID: <20240220205638.845772808@linuxfoundation.org>
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

commit 1e4624eb5a0ecaae0d2c4e3019bece119725bb98 upstream.

The ctx->pos was only updated when it added an entry, but the "skip to
current pos" check (c--) happened for every loop regardless of if the
entry was added or not. This inconsistency caused readdir to be incorrect.

It was due to:

	for (i = 0; i < ei->nr_entries; i++) {

		if (c > 0) {
			c--;
			continue;
		}

		mutex_lock(&eventfs_mutex);
		/* If ei->is_freed then just bail here, nothing more to do */
		if (ei->is_freed) {
			mutex_unlock(&eventfs_mutex);
			goto out;
		}
		r = entry->callback(name, &mode, &cdata, &fops);
		mutex_unlock(&eventfs_mutex);

		[..]
		ctx->pos++;
	}

But this can cause the iterator to return a file that was already read.
That's because of the way the callback() works. Some events may not have
all files, and the callback can return 0 to tell eventfs to skip the file
for this directory.

for instance, we have:

 # ls /sys/kernel/tracing/events/ftrace/function
format  hist  hist_debug  id  inject

and

 # ls /sys/kernel/tracing/events/sched/sched_switch/
enable  filter  format  hist  hist_debug  id  inject  trigger

Where the function directory is missing "enable", "filter" and
"trigger". That's because the callback() for events has:

static int event_callback(const char *name, umode_t *mode, void **data,
			  const struct file_operations **fops)
{
	struct trace_event_file *file = *data;
	struct trace_event_call *call = file->event_call;

[..]

	/*
	 * Only event directories that can be enabled should have
	 * triggers or filters, with the exception of the "print"
	 * event that can have a "trigger" file.
	 */
	if (!(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)) {
		if (call->class->reg && strcmp(name, "enable") == 0) {
			*mode = TRACE_MODE_WRITE;
			*fops = &ftrace_enable_fops;
			return 1;
		}

		if (strcmp(name, "filter") == 0) {
			*mode = TRACE_MODE_WRITE;
			*fops = &ftrace_event_filter_fops;
			return 1;
		}
	}

	if (!(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE) ||
	    strcmp(trace_event_name(call), "print") == 0) {
		if (strcmp(name, "trigger") == 0) {
			*mode = TRACE_MODE_WRITE;
			*fops = &event_trigger_fops;
			return 1;
		}
	}
[..]
	return 0;
}

Where the function event has the TRACE_EVENT_FL_IGNORE_ENABLE set.

This means that the entries array elements for "enable", "filter" and
"trigger" when called on the function event will have the callback return
0 and not 1, to tell eventfs to skip these files for it.

Because the "skip to current ctx->pos" check happened for all entries, but
the ctx->pos++ only happened to entries that exist, it would confuse the
reading of a directory. Which would cause:

 # ls /sys/kernel/tracing/events/ftrace/function/
format  hist  hist  hist_debug  hist_debug  id  inject  inject

The missing "enable", "filter" and "trigger" caused ls to show "hist",
"hist_debug" and "inject" twice.

Update the ctx->pos for every iteration to keep its update and the "skip"
update consistent. This also means that on error, the ctx->pos needs to be
decremented if it was incremented without adding something.

Link: https://lore.kernel.org/all/20240104150500.38b15a62@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20240104220048.172295263@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 493ec81a8fb8e ("eventfs: Stop using dcache_readdir() for getdents()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -722,6 +722,8 @@ static int eventfs_iterate(struct file *
 			continue;
 		}
 
+		ctx->pos++;
+
 		if (ei_child->is_freed)
 			continue;
 
@@ -729,13 +731,12 @@ static int eventfs_iterate(struct file *
 
 		dentry = create_dir_dentry(ei, ei_child, ei_dentry);
 		if (!dentry)
-			goto out;
+			goto out_dec;
 		ino = dentry->d_inode->i_ino;
 		dput(dentry);
 
 		if (!dir_emit(ctx, name, strlen(name), ino, DT_DIR))
-			goto out;
-		ctx->pos++;
+			goto out_dec;
 	}
 
 	for (i = 0; i < ei->nr_entries; i++) {
@@ -746,6 +747,8 @@ static int eventfs_iterate(struct file *
 			continue;
 		}
 
+		ctx->pos++;
+
 		entry = &ei->entries[i];
 		name = entry->name;
 
@@ -753,7 +756,7 @@ static int eventfs_iterate(struct file *
 		/* If ei->is_freed then just bail here, nothing more to do */
 		if (ei->is_freed) {
 			mutex_unlock(&eventfs_mutex);
-			goto out;
+			goto out_dec;
 		}
 		r = entry->callback(name, &mode, &cdata, &fops);
 		mutex_unlock(&eventfs_mutex);
@@ -762,19 +765,23 @@ static int eventfs_iterate(struct file *
 
 		dentry = create_file_dentry(ei, i, ei_dentry, name, mode, cdata, fops);
 		if (!dentry)
-			goto out;
+			goto out_dec;
 		ino = dentry->d_inode->i_ino;
 		dput(dentry);
 
 		if (!dir_emit(ctx, name, strlen(name), ino, DT_REG))
-			goto out;
-		ctx->pos++;
+			goto out_dec;
 	}
 	ret = 1;
  out:
 	srcu_read_unlock(&eventfs_srcu, idx);
 
 	return ret;
+
+ out_dec:
+	/* Incremented ctx->pos without adding something, reset it */
+	ctx->pos--;
+	goto out;
 }
 
 /**


