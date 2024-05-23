Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BE314A61E;
	Thu, 23 May 2024 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470102; cv=none; b=d2im8R2U0Y/sM0Pgcxa9qRZ/403L1g1lPJlMohUQEpDk9TweIUa9MWKf6kmUSvTGJ1tZNPK3fymk6roHcyhzDtTVR9Nh2A5i7/wBUHWlLDlxL9+u2EFDbWxcAIYqOl4JUECz4nGQEBOSsdUY3q8SMUiVgnVUTDTaGADmEAmeguk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470102; c=relaxed/simple;
	bh=3AsO0W86twZBnCxJDvq+2bnnSJwpOe6D6G9K4dyL+MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYkaMUMdSmk9X+co1uM6qkYTieoFiMbzrX8ysCVHwmOmBiy2Ch6zZm/N/HeucoiSYV2EPZ2FtkSyALGWhs5FV5ZOOPzO0uycQ1krTvZVkvEnYiscZ5MW4YnWOGeG0R7yMwFUGru7cuulnf7cc0T5vE4qGkheivl1VfBRZs7OizM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSTGCjCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSTGCjCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FBFC32781;
	Thu, 23 May 2024 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470102;
	bh=3AsO0W86twZBnCxJDvq+2bnnSJwpOe6D6G9K4dyL+MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSTGCjCocTp590Egr3mxeVj0H3N4d+RXfAGJHsk6x+P/Vih+57ymk/dG8wJvHzXUR
	 ohFwVFXX96bxvkoDF0h6z2aESYpw/IHdTbq/ep8xJ4x9dvT86+m56chCU5P4aQkrEG
	 yAyS3doaJT0VuiWKB+41jWXYJQ0zJqxGu2lYZU/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 08/18] tracing: Consolidate trace_add/remove_event_call back to the nolock functions
Date: Thu, 23 May 2024 15:12:31 +0200
Message-ID: <20240523130326.048256449@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 7e1413edd6194a9807aa5f3ac0378b9b4b9da879 upstream.

The trace_add/remove_event_call_nolock() functions were added to allow
the tace_add/remove_event_call() code be called when the event_mutex
lock was already taken. Now that all callers are done within the
event_mutex, there's no reason to have two different interfaces.

Remove the current wrapper trace_add/remove_event_call()s and rename the
_nolock versions back to the original names.

Link: http://lkml.kernel.org/r/154140866955.17322.2081425494660638846.stgit@devbox

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/trace_events.h     |    2 --
 kernel/trace/trace_events.c      |   30 ++++--------------------------
 kernel/trace/trace_events_hist.c |    6 +++---
 3 files changed, 7 insertions(+), 31 deletions(-)

--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -529,8 +529,6 @@ extern int trace_event_raw_init(struct t
 extern int trace_define_field(struct trace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
-extern int trace_add_event_call_nolock(struct trace_event_call *call);
-extern int trace_remove_event_call_nolock(struct trace_event_call *call);
 extern int trace_add_event_call(struct trace_event_call *call);
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2312,7 +2312,8 @@ __trace_early_add_new_event(struct trace
 struct ftrace_module_file_ops;
 static void __add_event_to_tracers(struct trace_event_call *call);
 
-int trace_add_event_call_nolock(struct trace_event_call *call)
+/* Add an additional event_call dynamically */
+int trace_add_event_call(struct trace_event_call *call)
 {
 	int ret;
 	lockdep_assert_held(&event_mutex);
@@ -2327,17 +2328,6 @@ int trace_add_event_call_nolock(struct t
 	return ret;
 }
 
-/* Add an additional event_call dynamically */
-int trace_add_event_call(struct trace_event_call *call)
-{
-	int ret;
-
-	mutex_lock(&event_mutex);
-	ret = trace_add_event_call_nolock(call);
-	mutex_unlock(&event_mutex);
-	return ret;
-}
-
 /*
  * Must be called under locking of trace_types_lock, event_mutex and
  * trace_event_sem.
@@ -2383,8 +2373,8 @@ static int probe_remove_event_call(struc
 	return 0;
 }
 
-/* no event_mutex version */
-int trace_remove_event_call_nolock(struct trace_event_call *call)
+/* Remove an event_call */
+int trace_remove_event_call(struct trace_event_call *call)
 {
 	int ret;
 
@@ -2398,18 +2388,6 @@ int trace_remove_event_call_nolock(struc
 
 	return ret;
 }
-
-/* Remove an event_call */
-int trace_remove_event_call(struct trace_event_call *call)
-{
-	int ret;
-
-	mutex_lock(&event_mutex);
-	ret = trace_remove_event_call_nolock(call);
-	mutex_unlock(&event_mutex);
-
-	return ret;
-}
 
 #define for_each_event(event, start, end)			\
 	for (event = start;					\
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -980,7 +980,7 @@ static int register_synth_event(struct s
 	call->data = event;
 	call->tp = event->tp;
 
-	ret = trace_add_event_call_nolock(call);
+	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_warn("Failed to register synthetic event: %s\n",
 			trace_event_name(call));
@@ -989,7 +989,7 @@ static int register_synth_event(struct s
 
 	ret = set_synth_event_print_fmt(call);
 	if (ret < 0) {
-		trace_remove_event_call_nolock(call);
+		trace_remove_event_call(call);
 		goto err;
 	}
  out:
@@ -1004,7 +1004,7 @@ static int unregister_synth_event(struct
 	struct trace_event_call *call = &event->call;
 	int ret;
 
-	ret = trace_remove_event_call_nolock(call);
+	ret = trace_remove_event_call(call);
 
 	return ret;
 }


