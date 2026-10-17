Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710893B19B9;
	Sat, 17 Oct 2026 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258067; cv=none; b=PtgZvOkBFL0lA1DUP55k4zzxjpicpXrkYygSeQNPZ6rqCGqSJI4IEUAjf0bzKw+EQ5YvP/c9N0xICdm/n5tuyvKwN+cPDFIbzmVfhbKV0XKmGoJuhODwxZXp4XgH1GHVWCplng0CDYbuLupveD3zp79K1QrujDVgYNsxoBph6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258067; c=relaxed/simple;
	bh=N4e83ak6tXmw9rPUSNjUpgZ2HvIFq5ZYhhVbAyYDias=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdJpYLX48libsMRDO/AQlW8nixIlU35Ew0Qt+qYh0fdSJ1bWtFUT+uOB6qVs1DcdEcQ8S5KODADlzN3ktJidXwjw1bPNCGJuQF1PoN9uem/1t9hnsdc98dzDoIdYd5DE5w9rkbRSeVa5Jh8G6OZt38Eew3Geq2U02kpIJ2LjVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fn+fQub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fn+fQub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C493E1F000C4;
	Sat, 17 Oct 2026 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258066;
	bh=9Dhg8G39uzCnU8xb3v6SNE6wRVsl46M0VErwEodCYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fn+fQubmyxFxd3QFEVNQk8yS0fUEU8bCxVdaZm4rCjAlAqEN5eli0rfRPV+C6TLY
	 H9UkS3W08KzaHPyif7giu9yUie/FrlLP/DMSw3vr+VqpTu2KmOioW94xPBI12X9mrT
	 N0z14anq4P9CwQ9ZBnG+URtm9ktHG3C9JZ9RKdlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tomas Glozar <tglozar@redhat.com>,
	Juri Lelli <jlelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0762/1674] rv: Use strings in da monitors tracepoints
Date: Sat, 17 Oct 2026 17:50:34 +0200
Message-ID: <20261017160450.656721526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 7f904ff6e58d398c4336f3c19c42b338324451f7 ]

Using DA monitors tracepoints with KASAN enabled triggers the following
warning:

 BUG: KASAN: global-out-of-bounds in do_trace_event_raw_event_event_da_monitor+0xd6/0x1a0
 Read of size 32 at addr ffffffffaada8980 by task ...
 Call Trace:
  <TASK>
 [...]
  do_trace_event_raw_event_event_da_monitor+0xd6/0x1a0
  ? __pfx_do_trace_event_raw_event_event_da_monitor+0x10/0x10
  ? trace_event_sncid+0x83/0x200
  trace_event_sncid+0x163/0x200
 [...]
 The buggy address belongs to the variable:
  automaton_snep+0x4e0/0x5e0

This is caused by the tracepoints reading 32 bytes __array instead of
__string from the automata definition. Such strings are literals and
reading 32 bytes ends up in out of bound memory accesses (e.g. the next
automaton's data in this case).
The error is harmless as, while printing the string, we stop at the null
terminator, but it should still be fixed.

Use the __string facilities while defining the tracepoints to avoid
reading out of bound memory.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Link: https://lore.kernel.org/20250728135022.255578-4-gmonaco@redhat.com
Fixes: 792575348ff7 ("rv/include: Add deterministic automata monitor definition via C macros")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rv.h | 60 +++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/trace/events/rv.h b/include/trace/events/rv.h
index 56592da9301c0..9ac1e37bcc826 100644
--- a/include/trace/events/rv.h
+++ b/include/trace/events/rv.h
@@ -16,23 +16,23 @@ DECLARE_EVENT_CLASS(event_da_monitor,
 	TP_ARGS(state, event, next_state, final_state),
 
 	TP_STRUCT__entry(
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
+		__string(	state,	state	)
+		__string(	event,	event	)
+		__string(	next_state,	next_state	)
 		__field(	bool,	final_state			)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
+		__assign_str(state, state);
+		__assign_str(event, event);
+		__assign_str(next_state, next_state);
 		__entry->final_state		= final_state;
 	),
 
 	TP_printk("%s x %s -> %s %s",
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? "(final)" : "")
 );
 
@@ -43,18 +43,18 @@ DECLARE_EVENT_CLASS(error_da_monitor,
 	TP_ARGS(state, event),
 
 	TP_STRUCT__entry(
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
+		__string(	state,	state	)
+		__string(	event,	event	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
+		__assign_str(state, state);
+		__assign_str(event, event);
 	),
 
 	TP_printk("event %s not expected in the state %s",
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #ifdef CONFIG_RV_MON_WIP
@@ -77,25 +77,25 @@ DECLARE_EVENT_CLASS(event_da_monitor_id,
 
 	TP_STRUCT__entry(
 		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
+		__string(	state,	state	)
+		__string(	event,	event	)
+		__string(	next_state,	next_state	)
 		__field(	bool,	final_state			)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
+		__assign_str(state, state);
+		__assign_str(event, event);
+		__assign_str(next_state, next_state);
 		__entry->id			= id;
 		__entry->final_state		= final_state;
 	),
 
 	TP_printk("%d: %s x %s -> %s %s",
 		__entry->id,
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? "(final)" : "")
 );
 
@@ -107,20 +107,20 @@ DECLARE_EVENT_CLASS(error_da_monitor_id,
 
 	TP_STRUCT__entry(
 		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
+		__string(	state,	state	)
+		__string(	event,	event	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
+		__assign_str(state, state);
+		__assign_str(event, event);
 		__entry->id			= id;
 	),
 
 	TP_printk("%d: event %s not expected in the state %s",
 		__entry->id,
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #ifdef CONFIG_RV_MON_WWNR
-- 
2.53.0



