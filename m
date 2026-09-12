Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA51F356744;
	Sat, 12 Sep 2026 11:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211248; cv=none; b=X8CXY7DLIfvB/aqZxPSNdH4jKB1QETnhyz2wP4ArUFQLxgCRDiikpzJWu8wUo50maPsPmRxzM3KVvBBZlmcY3L+oVrRNpeQYyHcU7yjkkckBt7P1uHAMAFQZkm4/KzO+IlLcWFuPk9T3ieEuwZt7qE9vwOXTN3GUv70cFCV55yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211248; c=relaxed/simple;
	bh=qFeCF9TFunPpNCUARBNpcuJGtcoBjI+tTxBtWmxC8IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl+4vQJgoQJQOKMy0tzdKx5x0Nfl/Z+i1pFjnUS6mNzQk/4okGucAXXL37moMbViDwvtoJkhXMQuqgzHFzpLlNiFtAaMUik1AhfBy47LnHv3Fia1ecbRcSTwgnFl4OwsXdRewrVDBiueLkXn4qPWKsxDDeuKcpPetHGAJKBrpd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYuMaitP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYuMaitP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FF21F000FF;
	Sat, 12 Sep 2026 11:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211247;
	bh=rongLYh1biok+PnYIMVdj262efG5sclectaT0AimRtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYuMaitPHrNJqkU8bMcELUkLDO6zNQB/FZGZGBCb69K4uIHB5kmkkd+95bttsEmp+
	 YGM8U3d0qutpDoBSQQfBl3SQHH9GGcx5QU0pTFLuBmkddGX7MXZZlRlyQeX0mRuVg2
	 OmRemW1hB+7Pl8iKdHPh0qBuZO986X5juZgm65M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1190/1518] tracing: Have trace_event_update_all() only handle module that is loading
Date: Sat, 12 Sep 2026 08:55:59 +0200
Message-ID: <20260912065650.398210379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8c8a2aad3e49b..77ad2392954ab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5890,7 +5890,7 @@ trace_event_update_with_eval_map(struct module *mod,
 
 	map = start;
 
-	trace_event_update_all(map, len);
+	trace_event_update_all(map, len, mod);
 
 	if (len <= 0)
 		return;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8a2b35b7338f9..89e4d619e64b9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2136,13 +2136,13 @@ static inline const char *get_syscall_name(int syscall)
 
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
index 0f96eb95ad38f..b3ee028f93efe 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3402,7 +3402,7 @@ static void update_event_fields(struct trace_event_call *call,
 }
 
 /* Update all events for replacing eval and sanitizing */
-void trace_event_update_all(struct trace_eval_map **map, int len)
+void trace_event_update_all(struct trace_eval_map **map, int len, struct module *mod)
 {
 	struct trace_event_call *call, *p;
 	const char *last_system = NULL;
@@ -3414,6 +3414,10 @@ void trace_event_update_all(struct trace_eval_map **map, int len)
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



