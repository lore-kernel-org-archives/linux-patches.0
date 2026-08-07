Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7581E4334AE;
	Fri,  7 Aug 2026 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114240; cv=none; b=CEqhFjvNWPVvq/qHO40LouvdqUBsWEa/0vVRE9zq6rJlN+LbIwPXHE84WtWd3tqRh9b8i1sBUWPpWuEU1Zezb4QX/jqBEZAbPs7kNblav4EhmzhWmAKfOw7ceaobi7RN5y58BtVeK3/dQ5QOY0ItpHmeN2zmi+Tv14C0FmIIbdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114240; c=relaxed/simple;
	bh=H1dVsCizahAfaARb8R+ZKzeSzTQS/ajTkt+r06CU+z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhqFC4lVPTA/AgEH/XzWzyOAHAL1uA8qAnO75e8H3pAKnX9IHnETIhsCHbjvBk8fHphghOeI8kabvGGR/eDHZ4CObAY5cv562o3ejgYI8Qo5S0Pw8zzX4V0wkUzSWEpmimDWdHbHfvFgMVKLdlY8jAXblr8+KNNfkDdYh4CU4y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMT/Ah5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMT/Ah5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CFE1F000E9;
	Fri,  7 Aug 2026 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114235;
	bh=PsQ+gSyFt/egWCtr8sBRNw+AjNi5mQP83yQtx2FYxmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMT/Ah5QCpXbFiEvcpw6xtj7FMvCQPNANdg+KZcKKnpTLJpx8cNHKqI+a4SPtsCvB
	 jw0YgHRWRQvGEP85BkZOxjzeiWMDwkd9w1Rt6RPPBFEKz67SmN6h5WTyKxXBrncJoZ
	 +A6TZY3Gg4jy6dxk9L4ZKGBL+pkFCQVQGgW8h9WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 192/337] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Fri,  7 Aug 2026 16:36:35 +0200
Message-ID: <20260807143422.720693508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3405,8 +3405,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 }
 


