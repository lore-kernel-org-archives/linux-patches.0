Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733D131327A;
	Fri,  7 Aug 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116176; cv=none; b=YX5w4ZynG9BDgn3h3DIwH8sv3xuc0sZ0PKtjwvujcgxgGwCb5N6n0uhvys1tb28mLGL1vocUmGrIRgi48eowChOUYdm1nC0ILU6ZW/ZTQFGTSO+rK2AmTQfBuTCajZizt7i14ytrrEgp6NMV1srAScqCntQzhLMA/yps3rKQ38Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116176; c=relaxed/simple;
	bh=f48En3T1UnX8De6akLT1xdo+ZtEsFUjZlTdPBN73xuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/OjrXh2uESVydiRG98NJp+L4w3O0Vp0mth+gYf815cJExU/15K1AWsLjqnrO+1T5gJ5XM433CYe9OFzwO5we4sFgCCjUMp7sWvfzT3cnxW7/5t9F4VqIOWXkGW+dwQfQOOZ/Nrs23kk7SxQuDIO+0NCn2syaUhHy/oLCxzVtLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S6be5P+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S6be5P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFE61F000E9;
	Fri,  7 Aug 2026 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116175;
	bh=2CJC/HCr3wfhHoBKlvzI8o6dB3pO6yFCMo7X4xEIaVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1S6be5P+hOn6swFGmfqruqhrRuCYMq/9lCFwBZ0sZDg9JeaccQX83O4fH4WLe9IDi
	 MQPxF95vSEivSjW/ZM8rR8mNMfxBXLSDgg5Ab8CNbOEoDkNNMT9AptkSvnM2hw5ffL
	 YlDgCBXm31Lw/MUZnMiVoPp8kTI6hqPz5orm+sng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 139/261] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Fri,  7 Aug 2026 16:38:16 +0200
Message-ID: <20260807143418.364606098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ac8719969e6c3c54e939834df812bc41f25453cf upstream.

trace_module_add_events() ignores the return value of __register_event()
and unconditionally calls __add_event_to_tracers() for each event.

If __register_event() fails (for example, if event_init() fails), the
trace_event_call is not added to ftrace_events list, but
__add_event_to_tracers() still creates a trace_event_file pointing to it.
If module loading subsequently fails and module memory is freed, tracing
state retains a stale trace_event_call pointer in trace_event_file,
leading to a use-after-free when tracefs or tracing subsystem operations
are later executed.

Fix this by checking the return value of __register_event() and only
calling __add_event_to_tracers() if event registration succeeded.

Fixes: ae63b31e4d0e ("tracing: Separate out trace events from global variables")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/178528487878.124250.14170824576025743236.stgit@devnote2
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3373,8 +3373,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 }
 


