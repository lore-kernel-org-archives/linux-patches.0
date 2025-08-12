Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521F92FDC55;
	Tue, 12 Aug 2025 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024170; cv=none; b=Ut8ZmHeRviHIjdair1QYyHcRpDubUmIuVt6ppbOFNbmINvoOzjtaogtZcEWDj3OiWYKF2AHX8yT2Uwd0w38d+NhC8Rx8XRDaKVNsxMvVIyBtIjCtVBCV72uPAXiV80ujE5Iy/FmsScrpkN6jfpR3sh1P/SiYIqrS6TJZLf2PtyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024170; c=relaxed/simple;
	bh=WG/tC0tUdn4YzEkJwBhMcHxtUcaui8/RT6UiQ7IYZ6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIgijIuDOZpQvIOJV36ob5sGxIPRMqJTjyZqljO2afPVW6SCZoWc5FJjVewCit1jgwntzOoKKtCZ6K+v/QyDwi4sSQo4GwZZK5VRIrKoPO2Sat1BQvCN744Q7OjBBSZ69ai4quOoNlvOZFpAQahL6EI2+g82Acbu54zcL4ZjENo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adchXmsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adchXmsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EC1C4CEF0;
	Tue, 12 Aug 2025 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024169;
	bh=WG/tC0tUdn4YzEkJwBhMcHxtUcaui8/RT6UiQ7IYZ6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adchXmsYdMFYINUV6t0BUr/KLKicPhw6MrEdLb+F+qKcvG6AqNixzgwSff++5wVgn
	 yqOkcG7q9FjiZSSZHeFq9sjqYAkj8osX/0twhHRu2kRDPDNKMF/6/pOiGhk+iCK1tZ
	 7HoDWmPRkSzGJGlopX7iFFWgg/J+3jMnGLzDiP78=
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
Subject: [PATCH 6.16 294/627] rv: Use strings in da monitors tracepoints
Date: Tue, 12 Aug 2025 19:29:49 +0200
Message-ID: <20250812173430.493889971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/trace/rv/rv_trace.h | 76 +++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/rv/rv_trace.h b/kernel/trace/rv/rv_trace.h
index 18fa0e358a30..01fa84824bcb 100644
--- a/kernel/trace/rv/rv_trace.h
+++ b/kernel/trace/rv/rv_trace.h
@@ -16,23 +16,23 @@ DECLARE_EVENT_CLASS(event_da_monitor,
 	TP_ARGS(state, event, next_state, final_state),
 
 	TP_STRUCT__entry(
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
-		__field(	bool,	final_state			)
+		__string(	state,		state		)
+		__string(	event,		event		)
+		__string(	next_state,	next_state	)
+		__field(	bool,		final_state	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
-		__entry->final_state		= final_state;
+		__assign_str(state);
+		__assign_str(event);
+		__assign_str(next_state);
+		__entry->final_state = final_state;
 	),
 
 	TP_printk("%s x %s -> %s%s",
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? " (final)" : "")
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
+		__assign_str(state);
+		__assign_str(event);
 	),
 
 	TP_printk("event %s not expected in the state %s",
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #include <monitors/wip/wip_trace.h>
@@ -75,26 +75,26 @@ DECLARE_EVENT_CLASS(event_da_monitor_id,
 	TP_ARGS(id, state, event, next_state, final_state),
 
 	TP_STRUCT__entry(
-		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
-		__array(	char,	next_state,	MAX_DA_NAME_LEN	)
-		__field(	bool,	final_state			)
+		__field(	int,		id		)
+		__string(	state,		state		)
+		__string(	event,		event		)
+		__string(	next_state,	next_state	)
+		__field(	bool,		final_state	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		memcpy(__entry->next_state,	next_state,	MAX_DA_NAME_LEN);
-		__entry->id			= id;
-		__entry->final_state		= final_state;
+		__assign_str(state);
+		__assign_str(event);
+		__assign_str(next_state);
+		__entry->id		= id;
+		__entry->final_state	= final_state;
 	),
 
 	TP_printk("%d: %s x %s -> %s%s",
 		__entry->id,
-		__entry->state,
-		__entry->event,
-		__entry->next_state,
+		__get_str(state),
+		__get_str(event),
+		__get_str(next_state),
 		__entry->final_state ? " (final)" : "")
 );
 
@@ -105,21 +105,21 @@ DECLARE_EVENT_CLASS(error_da_monitor_id,
 	TP_ARGS(id, state, event),
 
 	TP_STRUCT__entry(
-		__field(	int,	id				)
-		__array(	char,	state,		MAX_DA_NAME_LEN	)
-		__array(	char,	event,		MAX_DA_NAME_LEN	)
+		__field(	int,	id	)
+		__string(	state,	state	)
+		__string(	event,	event	)
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->state,		state,		MAX_DA_NAME_LEN);
-		memcpy(__entry->event,		event,		MAX_DA_NAME_LEN);
-		__entry->id			= id;
+		__assign_str(state);
+		__assign_str(event);
+		__entry->id	= id;
 	),
 
 	TP_printk("%d: event %s not expected in the state %s",
 		__entry->id,
-		__entry->event,
-		__entry->state)
+		__get_str(event),
+		__get_str(state))
 );
 
 #include <monitors/wwnr/wwnr_trace.h>
-- 
2.39.5



