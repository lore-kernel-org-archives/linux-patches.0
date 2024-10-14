Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCF21B85E3;
	Mon, 14 Oct 2024 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919737; cv=none; b=e7SNyhKz8vj7s37O1FaFOK7Kw7L7HDwNa+uh0CLeEy0z+n7UPnJfyoj7DhJxteqq/dSuU7Ym4mUG/zMBWh4h30a8dK+U0do+KEq5rIDOEu3BQBgZNvdk9co50wqiZTrsjySkbuCGNZIITlsHkR1FEgoHmH/Z5iglJUdlucOz8SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919737; c=relaxed/simple;
	bh=f5dLOV/d6sBchKZ05l5B0SAbVzqGu5ttgJvQXzmjun0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWh/iUFQiSIaH2+/3ST0+3k1xs+mO+EZsyA3DLX8WtqKhSonGoVSDoVUUiqL+2vIzUQHsiPniXtzmxYaz1jM9ZwULKlRrP7DovlSMz2KYe7FFn0VLxEBoEkJkU++0mgAY/zkAhgTQV0uUOHaXjnHWyvBvbdNtB/GsZ8jqD9hBfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIMbdCgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIMbdCgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876EDC4CEC7;
	Mon, 14 Oct 2024 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919737;
	bh=f5dLOV/d6sBchKZ05l5B0SAbVzqGu5ttgJvQXzmjun0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIMbdCgrCDiCinXNwtPJGRfvBpeIqiUig6iUG2TzUXwOwWr7F+IPghRTbKVRW53DQ
	 rTmcnKOSVg2niCpNNVEi3jvBHV+ZvFRAI9Y0fsYzMFPTk09FrA1hyaXECTH+zYFVD0
	 W+NZEua/joq5kOyUpGbQqsUbJQIi9Tsm5+V9XNuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sachin Sant <sachinp@linux.ibm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 666/798] tracing: Remove precision vsnprintf() check from print event
Date: Mon, 14 Oct 2024 16:20:20 +0200
Message-ID: <20241014141244.229980724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 5efd3e2aef91d2d812290dcb25b2058e6f3f532c ]

This reverts 60be76eeabb3d ("tracing: Add size check when printing
trace_marker output"). The only reason the precision check was added
was because of a bug that miscalculated the write size of the string into
the ring buffer and it truncated it removing the terminating nul byte. On
reading the trace it crashed the kernel. But this was due to the bug in
the code that happened during development and should never happen in
practice. If anything, the precision can hide bugs where the string in the
ring buffer isn't nul terminated and it will not be checked.

Link: https://lore.kernel.org/all/C7E7AF1A-D30F-4D18-B8E5-AF1EF58004F5@linux.ibm.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240227125706.04279ac2@gandalf.local.home
Link: https://lore.kernel.org/all/20240302111244.3a1674be@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20240304174341.2a561d9f@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 60be76eeabb3d ("tracing: Add size check when printing trace_marker output")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_output.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index bf1965b180992..5cd4fb6563068 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1445,12 +1445,11 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
-	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
 	seq_print_ip_sym(s, field->ip, flags);
-	trace_seq_printf(s, ": %.*s", max, field->buf);
+	trace_seq_printf(s, ": %s", field->buf);
 
 	return trace_handle_return(s);
 }
@@ -1459,11 +1458,10 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
 					 struct trace_event *event)
 {
 	struct print_entry *field;
-	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
-	trace_seq_printf(&iter->seq, "# %lx %.*s", field->ip, max, field->buf);
+	trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf);
 
 	return trace_handle_return(&iter->seq);
 }
-- 
2.43.0



