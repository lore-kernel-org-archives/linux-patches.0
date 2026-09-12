Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983C647DD63;
	Sat, 12 Sep 2026 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218366; cv=none; b=kfeSzVJwadJcha7e74g4qRlK4YwOOQ/aP77Xjdc5AryJjw/h6gaNcakhBBqTzhaTeBeI5qSn5hjPDOdFODEGoyeRjZRF2YtajXGf/oU32wT+gAZc/sInTatF44gtO1oEITBu18mRIfJiDKplmtPdv8Br0xWrwz7JEdV21tU8PKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218366; c=relaxed/simple;
	bh=9FOC6Oo1tEsWfs/uxQxS4MpS6GXZXPvRv4oCHDdI1RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL0ibeCozi6BQZanQgqJzDue3QXGYOag5KQZB81Cg9ESbMBkZjA2olfJpLLP6ci83exsfWvY31eXvogWjc+9PRQvhL+jroE159uCYGxxhddWnioVCXlQw91gIcSXS5Shb10WmP+azjWpNVgZ47AKqNmwrQ1ljw0Iw1r0rsSmcOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUnDLUiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUnDLUiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9445A1F000FF;
	Sat, 12 Sep 2026 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218365;
	bh=q5xzx1/CGFyl+VPI4jXezskrIIJD2zr5M3GPsRaQdDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUnDLUiU9v+VHvq458qXxtkgW06Dp4OkcihQtX5WkswlOZ8wOKdKn2UWYrIm5DIUf
	 JZO2+IqWc7svMHCzP767c1Mc5m8OQ47oESJkxjMny9co+al7YyVyeODfz9UB4ccB4a
	 dhndnrJXx66kfgeUdeBiNLcgUfrwqOfummOHV1os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1130/1376] tracing: Have trace_event_update_all() only handle module that is loading
Date: Sat, 12 Sep 2026 08:59:16 +0200
Message-ID: <20260912065632.748585403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit ae70b04ab9c7f6162a8c0fdd18a62a945c133142 ]

The function trace_event_update_all() does a scan of events looking to
replace enums with their values in the strings that get exported to the
event format files. It's run at boot up on all events and again when a
module loads.

The issue is that when a module loads, it still runs on *all* events.
There's no reason to process every event when a module loads as the
previous events have already been processed. Only execute on the events
that are loaded with the module.

Link: https://patch.msgid.link/20260813204226.29563591@gandalf.local.home
Fixes: 3673b8e4ce723 ("tracing: Allow for modules to convert their enums to values")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c        | 2 +-
 kernel/trace/trace.h        | 4 ++--
 kernel/trace/trace_events.c | 6 +++++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c8c29a544227c..522b9e11d0ba4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5840,7 +5840,7 @@ trace_event_update_with_eval_map(struct module *mod,
 
 	map = start;
 
-	trace_event_update_all(map, len);
+	trace_event_update_all(map, len, mod);
 
 	if (len <= 0)
 		return;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f96942f872a96..176e493f79db8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2071,13 +2071,13 @@ static inline const char *get_syscall_name(int syscall)
 
 #ifdef CONFIG_EVENT_TRACING
 void trace_event_init(void);
-void trace_event_update_all(struct trace_eval_map **map, int len);
+void trace_event_update_all(struct trace_eval_map **map, int len, struct module *mod);
 /* Used from boot time tracer */
 extern int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 extern int trigger_process_regex(struct trace_event_file *file, char *buff);
 #else
 static inline void __init trace_event_init(void) { }
-static inline void trace_event_update_all(struct trace_eval_map **map, int len) { }
+static inline void trace_event_update_all(struct trace_eval_map **map, int len, struct module *mod) { }
 #endif
 
 #ifdef CONFIG_TRACER_SNAPSHOT
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e15ce300370d3..0da762d9696de 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3144,7 +3144,7 @@ static void update_event_fields(struct trace_event_call *call,
 }
 
 /* Update all events for replacing eval and sanitizing */
-void trace_event_update_all(struct trace_eval_map **map, int len)
+void trace_event_update_all(struct trace_eval_map **map, int len, struct module *mod)
 {
 	struct trace_event_call *call, *p;
 	const char *last_system = NULL;
@@ -3156,6 +3156,10 @@ void trace_event_update_all(struct trace_eval_map **map, int len)
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
+
+		if (mod && call->module != mod)
+			continue;
+
 		/* events are usually grouped together with systems */
 		if (!last_system || call->class->system != last_system) {
 			first = true;
-- 
2.53.0



