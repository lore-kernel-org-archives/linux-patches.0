Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBFC1AA797;
	Mon, 14 Oct 2024 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916597; cv=none; b=eVXNH7BeF5PP0XEuYn7Ma0ZjHxap2KfpgmvLhx/KjS7xDQvLjHJmbLjG0FpNWcUif9HhQ3SRWK+vNVECVOF67V91hQjJX+AQFyl6HrAhedyF51uBGkrJuYXnzh4T/mrYGkASQabM7PmtaJzoDyD7/DxPfaGgRfD2Gw5GMkvjdA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916597; c=relaxed/simple;
	bh=HwJKvhwJ13TyIUPWfrRVmuD2MJ4oLE1eM3+5WDrLU80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3cR2NYI+7av0JG9fBoa/AO2ON1FWZyXI9EEEyU0HQ9fc35S4ZUoC31jaM/ITK0aQssvb6JzqCdUsyOvC/FzLU2e7n/+8zYN69XlZN6z8TV9nHIaAqpfc9EVWU/bfpo9DZDHu0dU/XRy+6TIZcO3NFGVdwGO0uR7W3YN30lwCgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RZzGZsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RZzGZsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD74BC4CEC7;
	Mon, 14 Oct 2024 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916597;
	bh=HwJKvhwJ13TyIUPWfrRVmuD2MJ4oLE1eM3+5WDrLU80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RZzGZsgdhqu1UMDmc9J1Nvr8LUNSLCQe2zguVa6C0ROFRm32e74R0S1WamXBBh9e
	 UqWSBVOjpQAMsP1V0/uUzPIm6HtCg6xZ/1pIfx0JdpfROk8yxFwdL/0uvgLuEEr/qN
	 k0zfkuxUusPORpp1Y3/V+jCiwatkhLFX/sxnTNaA=
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
Subject: [PATCH 6.6 013/213] tracing: Remove precision vsnprintf() check from print event
Date: Mon, 14 Oct 2024 16:18:39 +0200
Message-ID: <20241014141043.500650507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3b7d3e9eb6ea4..db575094c4982 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1587,12 +1587,11 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
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
@@ -1601,11 +1600,10 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
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



