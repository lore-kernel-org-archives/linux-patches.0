Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477B53AC17;
	Sat, 12 Sep 2026 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225561; cv=none; b=rlZMEfTWCqALazfeXhosx870ukDttNCeRlbv69QQUiuM8M5VR+sPK1HVbKavsDu3apqvvML/XKenYldZI/AASWwM3Scrq2CxvOQsZbCOIAWyvnNH6cLnXFC75/dKEpUPvJoFHzbzvimaYkcjv99vnVxjDl/flBmXyGbAhP7iKs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225561; c=relaxed/simple;
	bh=MJ2VT+EWMO/0LCd5l/BF4pKOTuFNAyyMZfRg6CVyhPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQVrBhRGdA9ZzSX6Hxzt+t+5xgd/AtQnx+NdDZIHGvkeHAmzsYpnYRDCBl00KncmvKRtsSPQJZ4siCE+TsGjPqzrpTjjYhZdpzFYvPXNO/YiiOnZ5KFrxxwPEVK5UBR6qtoL6XEGOmLSy7FFnbcCNy2gIuINTb2dCR55t5hj9dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MY2nw3Y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MY2nw3Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FD71F00898;
	Sat, 12 Sep 2026 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225554;
	bh=1Nb07AiF30iPT04PVMb0HKp0uveShYVMMxSoanvFiRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MY2nw3Y2PlyJrlZHNeAN9OcF00OhkET8NEZF4glYlu4oUsrt3WhI/s9E76SLdGwqD
	 kyGJaKxcpG6GzmOKRt5vT/hv014/mtM5BC4nob4S+uliXNjf/eksR2L6Be1H8benWZ
	 qDUj3yWBEth4gLRTdqTpfzpGDy6NroO88WRoUofI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1220/1424] tracing: Have trace_event_update_all() only handle module that is loading
Date: Sat, 12 Sep 2026 09:00:52 +0200
Message-ID: <20260912065634.607421370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16472cb70f74d..47f1e8f47d472 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6191,7 +6191,7 @@ trace_event_update_with_eval_map(struct module *mod,
 
 	map = start;
 
-	trace_event_update_all(map, len);
+	trace_event_update_all(map, len, mod);
 
 	if (len <= 0)
 		return;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a05c13a143184..05ac2b5c8e208 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1987,13 +1987,13 @@ static inline const char *get_syscall_name(int syscall)
 
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
index 04600cf6f8663..5e33b0c34f48b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3110,7 +3110,7 @@ static void update_event_fields(struct trace_event_call *call,
 }
 
 /* Update all events for replacing eval and sanitizing */
-void trace_event_update_all(struct trace_eval_map **map, int len)
+void trace_event_update_all(struct trace_eval_map **map, int len, struct module *mod)
 {
 	struct trace_event_call *call, *p;
 	const char *last_system = NULL;
@@ -3122,6 +3122,10 @@ void trace_event_update_all(struct trace_eval_map **map, int len)
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



