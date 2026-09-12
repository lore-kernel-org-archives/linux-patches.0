Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C18399354;
	Sat, 12 Sep 2026 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243309; cv=none; b=e+dVTy7l77/2YJAoYGOVQd/uNYk1/CyN+Zu+ch0+Tp3TKNpvYv0NAh+eP6mMF+zXENqpZQjrdhagbkselZfjr/0o0jstoxN5YRC1B6JiY+gLcDqIDKSxAajMI4Bkfw0dqSHwNFSGbGOYqiPL2mNf4byVw+C0vNZPJUrh6Ftu2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243309; c=relaxed/simple;
	bh=ECnjq64IE07O+KYZRfGmfVI7yvmOpxcbu8nwBNpT4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQIRCLp/hiTthTIjj2pCYJoR7BFwMv6Af3xQXe90z8YApFdAIGibUCMvvwNANkXSLC5b2WofVNCQE2CR1NdupDy6FnTfXyFMxG9LB43gy/s/G+tKHVrvpZjlSAX3+yxyjgAAZduMoFzDCBpYNtk1hcMmsuOFbpaFl/zR+ioiDnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb1MROzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb1MROzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CE61F000FF;
	Sat, 12 Sep 2026 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243307;
	bh=dB9EywfWEVClDaZcrPSTx445xC3EPodEfA1d+jHOcAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zb1MROzhePA6tX5c6jZIpyEyY7ckcMlXsJCfqiQEyDXfKs8I4EGw9Rnn8zjLzCvbO
	 e8qoz3r51HhkHxlWzKZaZBtcrVal5SgwYlVMjtPvDgeb9R3Om8/zv9TKvgmhsskFt+
	 t3FAnReYXhvVmfOn/o0cc2hUlvyqQVGvi5YsFAGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 711/798] tracing: Add DYNAMIC flag for dynamic events
Date: Sat, 12 Sep 2026 09:05:39 +0200
Message-ID: <20260912065533.382387754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 8b0e6c744fef6462382041b30878c91f15069fc6 ]

To differentiate between static and dynamic events, add a new flag
DYNAMIC to the event flags that all dynamic events have set. This will
allow to differentiate when attaching to a dynamic event from a static
event.

Static events have a mod pointer that references the module they were
created in (or NULL for core kernel). This can be incremented when the
event has something attached to it. But there exists no such mechanism for
dynamic events. This is dangerous as the dynamic events may now disappear
without the "attachment" knowing that it no longer exists.

To enforce the dynamic flag, change dyn_event_add() to pass the event that
is being created such that it can set the DYNAMIC flag of the event. This
helps make sure that no location that creates a dynamic event misses
setting this flag.

Link: https://lore.kernel.org/linux-trace-devel/20210813004448.51c7de69ce432d338f4d226b@kernel.org/
Link: https://lkml.kernel.org/r/20210817035026.936958254@goodmis.org

Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: ae70b04ab9c7 ("tracing: Have trace_event_update_all() only handle module that is loading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h      | 3 +++
 kernel/trace/trace_dynevent.h     | 4 +++-
 kernel/trace/trace_events_synth.c | 2 +-
 kernel/trace/trace_kprobe.c       | 4 ++--
 kernel/trace/trace_uprobe.c       | 4 ++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 0c8c3cf36f96e..c4d4c92257691 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -253,6 +253,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 	TRACE_EVENT_FL_TRACEPOINT_BIT,
+	TRACE_EVENT_FL_DYNAMIC_BIT,
 	TRACE_EVENT_FL_KPROBE_BIT,
 	TRACE_EVENT_FL_UPROBE_BIT,
 };
@@ -264,6 +265,7 @@ enum {
  *  NO_SET_FILTER - Set when filter has error and is to be ignored
  *  IGNORE_ENABLE - For trace internal events, do not enable with debugfs file
  *  TRACEPOINT    - Event is a tracepoint
+ *  DYNAMIC       - Event is a dynamic event (created at run time)
  *  KPROBE        - Event is a kprobe
  *  UPROBE        - Event is a uprobe
  */
@@ -273,6 +275,7 @@ enum {
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 	TRACE_EVENT_FL_TRACEPOINT	= (1 << TRACE_EVENT_FL_TRACEPOINT_BIT),
+	TRACE_EVENT_FL_DYNAMIC		= (1 << TRACE_EVENT_FL_DYNAMIC_BIT),
 	TRACE_EVENT_FL_KPROBE		= (1 << TRACE_EVENT_FL_KPROBE_BIT),
 	TRACE_EVENT_FL_UPROBE		= (1 << TRACE_EVENT_FL_UPROBE_BIT),
 };
diff --git a/kernel/trace/trace_dynevent.h b/kernel/trace/trace_dynevent.h
index d6857a254ede5..7cf9d03458c33 100644
--- a/kernel/trace/trace_dynevent.h
+++ b/kernel/trace/trace_dynevent.h
@@ -76,13 +76,15 @@ int dyn_event_init(struct dyn_event *ev, struct dyn_event_operations *ops)
 	return 0;
 }
 
-static inline int dyn_event_add(struct dyn_event *ev)
+static inline int dyn_event_add(struct dyn_event *ev,
+				struct trace_event_call *call)
 {
 	lockdep_assert_held(&event_mutex);
 
 	if (!ev || !ev->ops)
 		return -EINVAL;
 
+	call->flags |= TRACE_EVENT_FL_DYNAMIC;
 	list_add_tail(&ev->list, &dyn_event_list);
 	return 0;
 }
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index b126af59e61c3..be4b82d1cf648 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1370,7 +1370,7 @@ static int __create_synth_event(int argc, const char *name, const char **argv)
 	}
 	ret = register_synth_event(event);
 	if (!ret)
-		dyn_event_add(&event->devent);
+		dyn_event_add(&event->devent, &event->call);
 	else
 		free_synth_event(event);
  out:
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 044df6073211e..a7aedfbbb6b73 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -618,7 +618,7 @@ static int append_trace_kprobe(struct trace_kprobe *tk, struct trace_kprobe *to)
 	if (ret)
 		trace_probe_unlink(&tk->tp);
 	else
-		dyn_event_add(&tk->devent);
+		dyn_event_add(&tk->devent, trace_probe_event_call(&tk->tp));
 
 	return ret;
 }
@@ -665,7 +665,7 @@ static int register_trace_kprobe(struct trace_kprobe *tk)
 	if (ret < 0)
 		unregister_kprobe_event(tk);
 	else
-		dyn_event_add(&tk->devent);
+		dyn_event_add(&tk->devent, trace_probe_event_call(&tk->tp));
 
 end:
 	mutex_unlock(&event_mutex);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index fd40018813557..9a8ca7c547091 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -456,7 +456,7 @@ static int append_trace_uprobe(struct trace_uprobe *tu, struct trace_uprobe *to)
 	/* Append to existing event */
 	ret = trace_probe_append(&tu->tp, &to->tp);
 	if (!ret)
-		dyn_event_add(&tu->devent);
+		dyn_event_add(&tu->devent, trace_probe_event_call(&tu->tp));
 
 	return ret;
 }
@@ -523,7 +523,7 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 		goto end;
 	}
 
-	dyn_event_add(&tu->devent);
+	dyn_event_add(&tu->devent, trace_probe_event_call(&tu->tp));
 
 end:
 	mutex_unlock(&event_mutex);
-- 
2.53.0



