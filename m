Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C19839C00E;
	Thu, 30 Jul 2026 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422902; cv=none; b=TIPZIgEbWUjmqJzzfBE/dCC8e4TE69u3NnSeZbeF3rZGooCsVGQKkLSYJWNtMXqSD+iKIkvXN8o8jsA9o7Fq6WAPKZTwJve5M9LgN0ETKfVkhadMz+NjWPq57sCzFVnY0BlPVF9G0ERIIX021Y0ZX/cIjZzodoLhlD0Y7//MSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422902; c=relaxed/simple;
	bh=W4n2Rwz63cNEP8DtVerRRxagFMtn98gJGWAUaVWgK2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrLAmg1a1QiaxZyd/POu2SjI8w7oay1ZVN/6PKMJqYryoABI6g+rkD7y3n/d7MPCXsf4J9aUBa8z1XFTZq1vDz1s+TQPXYoAub1RZf69Sa9zcTwTGixmikXgOPu1AnHgsd7rB3LELzuznoGtabwo2CYhhTwIKPBoFQiCnsvl9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/Hpz9xr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/Hpz9xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92411F000E9;
	Thu, 30 Jul 2026 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422901;
	bh=vw/WrrkTgzl4PBfuFYNMwIqPtM8dh8L8Tm8yrxrEiDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/Hpz9xrRhCt9cpzAoeeU3mW71A8etTxWJbrTiy/HmX13QBbunUokN4CkiyQ8aPqm
	 k1FQDIaWTHunu5+UmWBBRrUm2zoPcOgmtw6OV7mvpuA97jlpDq89HSh4VqgO1PCXxV
	 zzOm0LfBQ7ObQqVHVFPOn0I7YlFc7wW0VHF6Oim8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 594/744] tracing: Fix union collision of module and refcnt for dynamic events
Date: Thu, 30 Jul 2026 16:14:27 +0200
Message-ID: <20260730141456.905018584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1350,7 +1350,9 @@ __ftrace_set_clr_event_nolock(struct tra
 		call = file->event_call;
 
 		/* If a module is specified, skip events that are not that module */
-		if (module && (!call->module || strcmp(module_name(call->module), module)))
+		if (module &&
+		    ((call->flags & TRACE_EVENT_FL_DYNAMIC) ||
+		     !call->module || strcmp(module_name(call->module), module)))
 			continue;
 
 		name = trace_event_name(call);


