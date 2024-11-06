Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA871DF737;
	Wed,  6 Nov 2024 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895471; cv=none; b=EqIIWn/BtzVryYe51rjjqIYuIFbxV0jIuzn6o/kKcTL8ju0v37cSmmtYIlx4PE7aDnxrC6ZGyeHXFLYtUtn+/MMBJuqkyeWsftJR4eIJTlZikiDYIaeZVDJ8b6MdkD7tiG1FmFj8LU8irrhiNstHZi6W8ddVDjAwDbGWWcGUCy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895471; c=relaxed/simple;
	bh=Gc3/V6iPiqF3X3+YdcHTIAtw0k0KamupT9NJPbwPleI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5a/clCfQagr5fB+xEIZK8K9ryXwRF6tyCIHLxzAxLznX3iJ9Uan1bXzEjSiCfaFehqHEQmR1oH6jjg1zYiGBSksxywi3el99bnj/MbxSE2dORxuDn9DdnMX2z/oyutMQtkrJvNimW6XNl7Z4JRZdwxANXYcT3W8FaliBgc2Xjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1El5v6xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1El5v6xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DF3C4CECD;
	Wed,  6 Nov 2024 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895471;
	bh=Gc3/V6iPiqF3X3+YdcHTIAtw0k0KamupT9NJPbwPleI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1El5v6xA7H7BRvyzQyaMgUwAsaEbfqeH3obWTXj075HY4t8up+UxyaKetFRJ0dXtd
	 cIV88cNfT7XFCuywJNagMdRXYRHNZFeV/iZNcepgkoNTed/sJ2NjPBvwiSZF1QHY94
	 GFVQtwKenfrIG6PwTMNJd807mXykaI2x5Eb7ZKjM=
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
Subject: [PATCH 4.19 229/350] tracing: Remove precision vsnprintf() check from print event
Date: Wed,  6 Nov 2024 13:02:37 +0100
Message-ID: <20241106120326.638138896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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
index 43fb832d26d23..62015d62dd6f5 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1320,12 +1320,11 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
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
@@ -1334,11 +1333,10 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
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



