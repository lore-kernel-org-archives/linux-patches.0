Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A03321D9;
	Mon, 29 Dec 2025 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025848; cv=none; b=J0xM03p3e1nWjbg2FUmD3mg4dS3xWMoNArYxMlGacr4op1zPKk9+SgkT/N6JP8k+ri/JUzLYhRs9+J3FNfFVmx+Cteu/++A18RoHKxwthRj6RIxpBozxufsmkTtJC4yKZOsMPaRlmE6e7iG36fhHYQ9aGxoMmZbg2KYNBna4YOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025848; c=relaxed/simple;
	bh=tmFV+gkYBO4tXtYEug6Q4AnWdJQW2+1Tp/WSRHrLWWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMnRVAcR5MmuQ0oC4tmNL7/yYpwIBxfEUgPFHqlxkiiR95wyIK92ZJkoHx7Zby6zLdI2f1xF6Fl1kPDigr9RS8a89hraaMZz/vcy7eWtIqratmcMD2DKwyFNhaQTHA0lXoIfYqdPOEdpd8YkNZEWIx0ZZNocSp7ZWkLCV4XA1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mnrg4KSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mnrg4KSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E34C4CEF7;
	Mon, 29 Dec 2025 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025848;
	bh=tmFV+gkYBO4tXtYEug6Q4AnWdJQW2+1Tp/WSRHrLWWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mnrg4KSEo/GL9ZP0+JnUg1ay4ewm9VNDeheK6ywNOFGbC4a4vt7TmT4DLZZbxFvep
	 Z/pY0EdABC4VKR+oZHh5GUL1fEFPy3rVWY1R284ylYPRxhX6gEe2gbk1kDD3U3BqG5
	 vYYYNli/tqd93DlwKmQoIC3/uoqTY40Yi2YePNo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 359/430] tracing: Do not register unsupported perf events
Date: Mon, 29 Dec 2025 17:12:41 +0100
Message-ID: <20251229160737.539989800@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit ef7f38df890f5dcd2ae62f8dbde191d72f3bebae upstream.

Synthetic events currently do not have a function to register perf events.
This leads to calling the tracepoint register functions with a NULL
function pointer which triggers:

 ------------[ cut here ]------------
 WARNING: kernel/tracepoint.c:175 at tracepoint_add_func+0x357/0x370, CPU#2: perf/2272
 Modules linked in: kvm_intel kvm irqbypass
 CPU: 2 UID: 0 PID: 2272 Comm: perf Not tainted 6.18.0-ftest-11964-ge022764176fc-dirty #323 PREEMPTLAZY
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
 RIP: 0010:tracepoint_add_func+0x357/0x370
 Code: 28 9c e8 4c 0b f5 ff eb 0f 4c 89 f7 48 c7 c6 80 4d 28 9c e8 ab 89 f4 ff 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc <0f> 0b 49 c7 c6 ea ff ff ff e9 ee fe ff ff 0f 0b e9 f9 fe ff ff 0f
 RSP: 0018:ffffabc0c44d3c40 EFLAGS: 00010246
 RAX: 0000000000000001 RBX: ffff9380aa9e4060 RCX: 0000000000000000
 RDX: 000000000000000a RSI: ffffffff9e1d4a98 RDI: ffff937fcf5fd6c8
 RBP: 0000000000000001 R08: 0000000000000007 R09: ffff937fcf5fc780
 R10: 0000000000000003 R11: ffffffff9c193910 R12: 000000000000000a
 R13: ffffffff9e1e5888 R14: 0000000000000000 R15: ffffabc0c44d3c78
 FS:  00007f6202f5f340(0000) GS:ffff93819f00f000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055d3162281a8 CR3: 0000000106a56003 CR4: 0000000000172ef0
 Call Trace:
  <TASK>
  tracepoint_probe_register+0x5d/0x90
  synth_event_reg+0x3c/0x60
  perf_trace_event_init+0x204/0x340
  perf_trace_init+0x85/0xd0
  perf_tp_event_init+0x2e/0x50
  perf_try_init_event+0x6f/0x230
  ? perf_event_alloc+0x4bb/0xdc0
  perf_event_alloc+0x65a/0xdc0
  __se_sys_perf_event_open+0x290/0x9f0
  do_syscall_64+0x93/0x7b0
  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ? trace_hardirqs_off+0x53/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Instead, have the code return -ENODEV, which doesn't warn and has perf
error out with:

 # perf record -e synthetic:futex_wait
Error:
The sys_perf_event_open() syscall returned with 19 (No such device) for event (synthetic:futex_wait).
"dmesg | grep -i perf" may provide additional information.

Ideally perf should support synthetic events, but for now just fix the
warning. The support can come later.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://patch.msgid.link/20251216182440.147e4453@gandalf.local.home
Fixes: 4b147936fa509 ("tracing: Add support for 'synthetic' events")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -700,6 +700,8 @@ int trace_event_reg(struct trace_event_c
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
+		if (!call->class->perf_probe)
+			return -ENODEV;
 		return tracepoint_probe_register(call->tp,
 						 call->class->perf_probe,
 						 call);


