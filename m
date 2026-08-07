Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818C33C1AD;
	Fri,  7 Aug 2026 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115364; cv=none; b=nEjsqijRkrQlRW4zX2n0p4FQO+aFoRImYDDyJuQoReSRDWlUBZy1H8BZb46qeX5W3dATinOzB/uz/gnXg3em0d5ZvFNvpBmhF9ex0upwZC6WnE044hxUX+76tbTgFs2HXBxuSLNQcl2MEDir+2D1RVh0wWbys49DHFd5dIWYW/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115364; c=relaxed/simple;
	bh=OwR6AVds6RG9LZFzQSmGxECKCTCBl2d61XMoA/sT8gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEES2MUWs2JL9DIpi/N05ZeEjSBAQp/4haVDu3bfFBydNCTsPZDDsXQBfgmSHefClHvi7mNB2N8heUKaABKVbJ7Vc2KiaNXVaGfUx7im4qSaQuAc5/3KBYdu4VJgeIroJ9DipuEJ0ea9aziDhE3rrWoCjcRahRImwuCaSxJ1R9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/kW6FoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/kW6FoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAB51F000E9;
	Fri,  7 Aug 2026 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115363;
	bh=EkMbsOsHRPzh3cJ0yiP69NlHYkQY9zk0wXR8boS9u38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/kW6FoTn66QYEBEJT8Cv+Q8ybjf4K8qCvyZwV9PoP3zINdW8P/3gm7bRKzu6pXPy
	 T24LbhC9FxoWcNyK9fnPbQHZ7UpmJ8RDLmc30Ios1GA1nwapNfTSUcdgGzChwzBvko
	 OhaSsiHZMNN/ElhYnpWBnAMkej5J0gvbHOJETR+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 251/396] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Fri,  7 Aug 2026 16:36:51 +0200
Message-ID: <20260807143429.663735263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -3771,8 +3771,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 
 	update_cache_events(mod);


