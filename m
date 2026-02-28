Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F2F375249;
	Sat, 28 Feb 2026 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301564; cv=none; b=WU2LfUPVaJq4xTd/XCdLNZrd+w8k4chi92fRDOkbn0iwaPbgR7jMToIUno28PcbRvqfQhFG+Mw7EpWfFCmFVO2xNWXoRsb5YYmPw0sSUufZx03yuGOgizb6MKMOr2qVCnTOln60HSShd5pxVkvRezmXfI0AARZe0oeHDSqzAV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301564; c=relaxed/simple;
	bh=cXUT2m/Buo3w8m1m3gfvVg09mDyDB+BPLUmn0QzseLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIa8cZ5Gd2EiHogCk4551wq/Gs0FldqKGVjmn8slUul1LyTD18m24YFWzzfIS62PSiqvT6x+RDc+7d69Bc+jFxC34NTLIZqmYKIjPK/JQecTziNx3JVF2MQPdW9qFe8yAFGKRzTj4kh2bPxH59E//+w0rJEDPXDv1/4asRujUlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8Ksfy6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8Ksfy6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8E7C2BC87;
	Sat, 28 Feb 2026 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301564;
	bh=cXUT2m/Buo3w8m1m3gfvVg09mDyDB+BPLUmn0QzseLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8Ksfy6kwr9472rD2SBT7YCkKVTCXk0ZXw1jccHmz1RXefS4TZWiOuZpYNG1mabSs
	 IFqlhdU579oDxsbcUb56X+/CeyGvcH3RRo8s8MvmkETlF03IUROXgF6qtBdmX85h6B
	 eCHRiXyVSAv+2RpAiHAEoOLjx+SG1ayaAZfepmvcU333TE9YfqZ3SzvgjkE6WHrFy9
	 pMKRWQRN21unRtu0Hun0PVsov+67rX2rKXaU6CJYDBhmUy2EErCrke1Jtw+bZ5aT+K
	 xoz9dSzqIgGn1KbNHG6a85tpwJO2aA3egZ2TwOCU8/QEQ7GLWYuUf2jjmtQqJA1zng
	 dxkq9E/usXw3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Pavlu <petr.pavlu@suse.com>,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 747/752] tracing: Wake up poll waiters for hist files when removing an event
Date: Sat, 28 Feb 2026 12:47:38 -0500
Message-ID: <20260228174750.1542406-747-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 9678e53179aa7e907360f5b5b275769008a69b80 ]

The event_hist_poll() function attempts to verify whether an event file is
being removed, but this check may not occur or could be unnecessarily
delayed. This happens because hist_poll_wakeup() is currently invoked only
from event_hist_trigger() when a hist command is triggered. If the event
file is being removed, no associated hist command will be triggered and a
waiter will be woken up only after an unrelated hist command is triggered.

Fix the issue by adding a call to hist_poll_wakeup() in
remove_event_file_dir() after setting the EVENT_FILE_FL_FREED flag. This
ensures that a task polling on a hist file is woken up and receives
EPOLLERR.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://patch.msgid.link/20260219162737.314231-3-petr.pavlu@suse.com
Fixes: 1bd13edbbed6 ("tracing/hist: Add poll(POLLIN) support on hist file")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace_events.h | 5 +++++
 kernel/trace/trace_events.c  | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 04307a19cde30..64ada9cc38864 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -682,6 +682,11 @@ static inline void hist_poll_wakeup(void)
 
 #define hist_poll_wait(file, wait)	\
 	poll_wait(file, &hist_poll_wq, wait)
+
+#else
+static inline void hist_poll_wakeup(void)
+{
+}
 #endif
 
 #define __TRACE_EVENT_FLAGS(name, value)				\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 5cf55a9c6fad4..e4ce7f856f630 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1296,6 +1296,9 @@ static void remove_event_file_dir(struct trace_event_file *file)
 	free_event_filter(file->filter);
 	file->flags |= EVENT_FILE_FL_FREED;
 	event_file_put(file);
+
+	/* Wake up hist poll waiters to notice the EVENT_FILE_FL_FREED flag. */
+	hist_poll_wakeup();
 }
 
 /*
-- 
2.51.0

