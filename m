Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1864756BB;
	Fri,  7 Aug 2026 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117544; cv=none; b=Q+OARuhuq5+zo2aDF57sa6VWJPUuGhpkxuzwENwwsGg7AVr2igtd4Q0yzibNZndzlDg5P7HwvLslBF2lKg4URJSpRwtd2hJQHFyyBMKDzLUaWb4w+6i1g276MysQgFPpJD/N7F9T5c/E/Xhhr/G/QL17Uv3e63ymB7zomXRWW6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117544; c=relaxed/simple;
	bh=diLXBS7rph1kNVuOZyaAHED7/Ed81d990OhtN1VpZaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3yFm1mpVRPQwISibk88B2W3zs3usDR7uQBnvgn44T830FSfEXprMkPIVDxv+EswSm513Os9m24XIfQPDPfKFp3Po+6rtxdqrjc4YeLYtQ2QH2c+fzTx7pNLDmzHq9iKcvdLZGbCbg5S83wUB1jqF/qJziS2lw+MZ3A49Rn9C+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1cJjczn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1cJjczn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367161F000E9;
	Fri,  7 Aug 2026 15:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117543;
	bh=w0JZO0+rpt/MVIpiRzYZxypdwiuqny6hOEoZVjlLbC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1cJjcznbiCtVtnVP77hPqLyL1Eb+NOG1eN2IX8bfB1xRDy8hvzsOKv74s3veW5aN
	 whPIHaIHg39so/FshHvG0Hi4nGMepg26L4xc8SnCcqgYiDE92VpD9zNbje/MvOTA5c
	 8ZmRpjNtebBjlbBmBC8pexE1vCFHB92NXXe9+aa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 312/438] tracing: Check return value of __register_event() in trace_module_add_events()
Date: Fri,  7 Aug 2026 16:38:28 +0200
Message-ID: <20260807143434.621422488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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
@@ -3933,8 +3933,8 @@ static void trace_module_add_events(stru
 	end = mod->trace_events + mod->num_trace_events;
 
 	for_each_event(call, start, end) {
-		__register_event(*call, mod);
-		__add_event_to_tracers(*call);
+		if (!__register_event(*call, mod))
+			__add_event_to_tracers(*call);
 	}
 
 	update_cache_events(mod);


