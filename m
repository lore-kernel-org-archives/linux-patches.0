Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3890D420472;
	Mon, 17 Aug 2026 14:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977430; cv=none; b=lsv3GdPAJWzITrVmEfdW7XEsHLOGDuDXdLBvYnSWRLonCqIkkFJtrYpjuYgkykPwHrQOLCXdoLWxZe+shFcVGeGlfx5k/5A1nR6iSKbnrwHAhU3DKq56kGsWredOyfbeRi3LkvpuobnOHMqi597Vn1LVr3FCnpKJ2Ch0Dk0UbrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977430; c=relaxed/simple;
	bh=rPoNT99HhxP6rRsL9vRbU5Z2hmcApk3DlIANFxPIhrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFus2BxerioGpxO6vhgzgQ+bL4dcC0LROz445WqV+7vNOJPjqZdWJLRY/3FGR8GNpbvARKzRsacZcBtFHhXcAVD4w3+of2dLQKHuKgqWIlliyjwHfxXxLsGkKtYCrYNE4CNcXKd6Sr0InKZWx01rzmpaunpvCxt4j3ZghKIjUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAZlLDwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAZlLDwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E62F1F000E9;
	Mon, 17 Aug 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977429;
	bh=LHUrXrCfpAeNOHHFbtJNZFWrcUXzmiiWbsAF3NTus5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAZlLDwl0nvfkovabU0L94lszzS0VavE29fMtfpKmCWQAVjyE04Z6I78/pxEGmFTP
	 1YD7DEr45qfsm7SMAV0ojiADgnvoCTWAsGk8JwCs0ijTaMEmgmQmNapgXVQm4OHmID
	 T5SMIU80reOEtx/KDGQVaMm733hi+3e6Zlkf95Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 327/456] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Mon, 17 Aug 2026 15:31:57 +0200
Message-ID: <20260817132552.445255219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3089,8 +3089,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 }
 


