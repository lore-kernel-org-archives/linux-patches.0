Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB29217723;
	Thu, 30 Jul 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424724; cv=none; b=hhkWwMdqNL6TlmFZKlLswt5ddv1S0jLTWU2vG8izkZNfdyrvvXwsCCqyxpYWx5SYwhT8g5UU+cId7UY8Tg5uxHppHOJcVLH7wYTSmyKj9DKNCiLyMY1p0Fp80uFo/1WR7WfBCPp3rHIn+1bFS422Lzjc2hCZVz1SrYSjg/bBcDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424724; c=relaxed/simple;
	bh=3Eu3F1dcaGYerjut/EJCT7T2iOf8gtzY1ZUNBqMsRcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VS4FQT/c0B9hHAScBR+/peKX3gbacxlfIDCgV5dhIzYGG7415/B2OSKcYjzPvpXM0LNWz16F1r9qFVDXhpOE75d6v0YPtkChucUpLOWQZXBg7O3iCoCxhpA0f2uJb+olhtde0/5u8+mu+MP0e+OwY9Z0mzIF3iR0Ykzi2UfshRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ks497fwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ks497fwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0AE1F000E9;
	Thu, 30 Jul 2026 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424723;
	bh=JYJPWVBAq6GgT9K6vOONuYWbcgdl+gbMrTctVi24sio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks497fwjoxWCNecWyf4m/y/JihnMxIQxLIEhEwsRwMWD7fL/fM0D/IEonXAW/5LBD
	 mUqZPsQzTeLoHxbQJjy8fu1MkAXrX2twmI00MRfawF8FByfoIjTdNNVEBclV1yw4NZ
	 X0G/Uuj1TPm/cuvJ2bVG9KSIzUl45l31AD3y9Cp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 493/675] tracing: Fix union collision of module and refcnt for dynamic events
Date: Thu, 30 Jul 2026 16:13:43 +0200
Message-ID: <20260730141455.600521322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit b4eb07bde606c2096b24252be589e735eff6d413 upstream.

In 'struct trace_event_call', the 'module' pointer and the 'refcnt'
atomic variable share the same memory space in a union. For dynamic
events, the union member is 'refcnt', which acts as an active
reference counter.

When a dynamic event (such as kprobe, uprobe, fprobe, eprobe, or
wprobe) has a non-zero reference count (e.g. due to active event
triggers or perf attachments), its 'call->module' evaluates to a
small non-zero integer instead of NULL.

When filtering or setting events for a specific module (e.g., writing
':mod:<module>' to 'set_event'), the code in
'__ftrace_set_clr_event_nolock()' and 'update_event_fields()' reads
'call->module' directly without checking whether the event is dynamic.
This causes the kernel to treat the small integer (refcnt) as a
'struct module' pointer, leading to a NULL/invalid pointer dereference
(Oops) when dereferencing the module name.

Fix this by ensuring that the 'TRACE_EVENT_FL_DYNAMIC' flag is checked
before treating 'call->module' as a valid pointer in these code paths.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/178425670947.84440.11344393611899824907.stgit@devnote2
Fixes: 4c86bc531e60 ("tracing: Add :mod: command to enabled module events")
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1333,7 +1333,9 @@ __ftrace_set_clr_event_nolock(struct tra
 		call = file->event_call;
 
 		/* If a module is specified, skip events that are not that module */
-		if (module && (!call->module || strcmp(module_name(call->module), module)))
+		if (module &&
+		    ((call->flags & TRACE_EVENT_FL_DYNAMIC) ||
+		     !call->module || strcmp(module_name(call->module), module)))
 			continue;
 
 		name = trace_event_name(call);


