Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF063ABD99;
	Mon, 17 Aug 2026 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980009; cv=none; b=hXkKQ8lDyL0WJTRRtACbsSHOMmHfIZuQ7xnxiSJEr0pcaOpcZdTU8Z6B06+2Ohz9IQQnZM1TrnPACU4a1hlTNgUeo18eHWQcE06Uky4/1SheVonU0a44p+m1aR2M1AhMgaDlhQDxxi+qBwv8jQ2EB5rjYB/XHLz2J2T0Gy9xf6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980009; c=relaxed/simple;
	bh=1hP3gs+OYq7q+moXXAq1YCFH0+QJzIbazZG3K/HV8ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5vCn5KVVuYc5ntYQlUifvadUTD+zTajfuD+qwmAM7hbByfd6rtrk0AW56Jjcu8+0RwNJ6NgtC5zSCPXLZXMBMjpoIpgtAAB1DPs3pxqyny5Cp+Bri7EIo7Wpo18TeKClXZlVXBTRpInI0oHWqaHN+TBA1C1upkOK4luHvva5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0F73IPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0F73IPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAAD1F000E9;
	Mon, 17 Aug 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980008;
	bh=0AwLQh9VdgvbUZ4KNdPdbjrD+gMVZBm6GfWFzyTRn0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0F73IPWgzVZQXojGv64DXn11vonVZRXJnNWD/cZPUWwdsZI0huVT7sWIOXLyppwD
	 xWLqAdW8lsw6YgFqipHwOxBk2q0LJ1Uw8RDcRSqXtNtl+4KlBJ74D8I3ag44X+kdqA
	 geYFm4eR0l6iEcno+o8fTMNIXKEOLr3HchgJv/SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 424/609] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Mon, 17 Aug 2026 15:32:00 +0200
Message-ID: <20260817132558.296419389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3122,8 +3122,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 }
 


