Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9521AD3FA;
	Mon, 23 Jun 2025 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715768; cv=none; b=OZLr0TFymHWpj8Pj2yYzwioVR/cJezi+3SMzmmtAv578Fr+F7GhGJ/ZhI3cJvsa7d1q45L1p09Bk8VJDkpCw7clQDQ09wtRV/iNpXYrqk7uf5S4s2Ao3f8tNdpSprbFTF2w+ogO35OM4wms64X2l70vg3TV6XOgR2hBwdlkySDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715768; c=relaxed/simple;
	bh=cR/0oE3KQ+K1/Wu2qlY2tfx/bjXJOQkUTQKfTjI4+zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSepZUaS7+3KIPkFG8EDHbnR91moUSUoABuWRwoKZAW+JqM40UfDC6s34ec6itoqJmnjiut8sPEGSPogzfuiteP1siKA/FMHNR5I05xVdmfBa8QBsCBkuq8GTDD7UF5ahB/etyQwz5DJKemwTOTv26hXxmtRlV16z1C+augsrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvd7kWez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvd7kWez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB0FC4CEEA;
	Mon, 23 Jun 2025 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715768;
	bh=cR/0oE3KQ+K1/Wu2qlY2tfx/bjXJOQkUTQKfTjI4+zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nvd7kWezgk1CdB1lRcknQCOH2pTtdydAJDns0oDUOQ8pJpkCRq47Um6fwWu6cxdWw
	 CzFPIjaGJDZohsnPFIafMfhXbnPIxS7FN9gwbMv6qB6uQYNUyAhIw7eoI6xO+yuhj7
	 nbDicw7xCxcRSZh1le2oSYPJ1KJyX/ohMGaAvWmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Changbin Du <changbin.du@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.15 479/592] fgraph: Do not enable function_graph tracer when setting funcgraph-args
Date: Mon, 23 Jun 2025 15:07:17 +0200
Message-ID: <20250623130711.826000335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 327e28664307d49ce3fa71ba30dcc0007c270974 upstream.

When setting the funcgraph-args option when function graph tracer is net
enabled, it incorrectly enables it. Worse, it unregisters itself when it
was never registered. Then when it gets enabled again, it will register
itself a second time causing a WARNing.

 ~# echo 1 > /sys/kernel/tracing/options/funcgraph-args
 ~# head -20 /sys/kernel/tracing/trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 813/26317372   #P:8
 #
 #                                _-----=> irqs-off/BH-disabled
 #                               / _----=> need-resched
 #                              | / _---=> hardirq/softirq
 #                              || / _--=> preempt-depth
 #                              ||| / _-=> migrate-disable
 #                              |||| /     delay
 #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
 #              | |         |   |||||     |         |
           <idle>-0       [007] d..4.   358.966010:  7)   1.692 us    |          fetch_next_timer_interrupt(basej=4294981640, basem=357956000000, base_local=0xffff88823c3ae040, base_global=0xffff88823c3af300, tevt=0xffff888100e47cb8);
           <idle>-0       [007] d..4.   358.966012:  7)               |          tmigr_cpu_deactivate(nextexp=357988000000) {
           <idle>-0       [007] d..4.   358.966013:  7)               |            _raw_spin_lock(lock=0xffff88823c3b2320) {
           <idle>-0       [007] d..4.   358.966014:  7)   0.981 us    |              preempt_count_add(val=1);
           <idle>-0       [007] d..5.   358.966017:  7)   1.058 us    |              do_raw_spin_lock(lock=0xffff88823c3b2320);
           <idle>-0       [007] d..4.   358.966019:  7)   5.824 us    |            }
           <idle>-0       [007] d..5.   358.966021:  7)               |            tmigr_inactive_up(group=0xffff888100cb9000, child=0x0, data=0xffff888100e47bc0) {
           <idle>-0       [007] d..5.   358.966022:  7)               |              tmigr_update_events(group=0xffff888100cb9000, child=0x0, data=0xffff888100e47bc0) {

Notice the "tracer: nop" at the top there. The current tracer is the "nop"
tracer, but the content is obviously the function graph tracer.

Enabling function graph tracing will cause it to register again and
trigger a warning in the accounting:

 ~# echo function_graph > /sys/kernel/tracing/current_tracer
 -bash: echo: write error: Device or resource busy

With the dmesg of:

 ------------[ cut here ]------------
 WARNING: CPU: 7 PID: 1095 at kernel/trace/ftrace.c:3509 ftrace_startup_subops+0xc1e/0x1000
 Modules linked in: kvm_intel kvm irqbypass
 CPU: 7 UID: 0 PID: 1095 Comm: bash Not tainted 6.16.0-rc2-test-00006-gea03de4105d3 #24 PREEMPT
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
 RIP: 0010:ftrace_startup_subops+0xc1e/0x1000
 Code: 48 b8 22 01 00 00 00 00 ad de 49 89 84 24 88 01 00 00 8b 44 24 08 89 04 24 e9 c3 f7 ff ff c7 04 24 ed ff ff ff e9 b7 f7 ff ff <0f> 0b c7 04 24 f0 ff ff ff e9 a9 f7 ff ff c7 04 24 f4 ff ff ff e9
 RSP: 0018:ffff888133cff948 EFLAGS: 00010202
 RAX: 0000000000000001 RBX: 1ffff1102679ff31 RCX: 0000000000000000
 RDX: 1ffffffff0b27a60 RSI: ffffffff8593d2f0 RDI: ffffffff85941140
 RBP: 00000000000c2041 R08: ffffffffffffffff R09: ffffed1020240221
 R10: ffff88810120110f R11: ffffed1020240214 R12: ffffffff8593d2f0
 R13: ffffffff8593d300 R14: ffffffff85941140 R15: ffffffff85631100
 FS:  00007f7ec6f28740(0000) GS:ffff8882b5251000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f7ec6f181c0 CR3: 000000012f1d0005 CR4: 0000000000172ef0
 Call Trace:
  <TASK>
  ? __pfx_ftrace_startup_subops+0x10/0x10
  ? find_held_lock+0x2b/0x80
  ? ftrace_stub_direct_tramp+0x10/0x10
  ? ftrace_stub_direct_tramp+0x10/0x10
  ? trace_preempt_on+0xd0/0x110
  ? __pfx_trace_graph_entry_args+0x10/0x10
  register_ftrace_graph+0x4d2/0x1020
  ? tracing_reset_online_cpus+0x14b/0x1e0
  ? __pfx_register_ftrace_graph+0x10/0x10
  ? ring_buffer_record_enable+0x16/0x20
  ? tracing_reset_online_cpus+0x153/0x1e0
  ? __pfx_tracing_reset_online_cpus+0x10/0x10
  ? __pfx_trace_graph_return+0x10/0x10
  graph_trace_init+0xfd/0x160
  tracing_set_tracer+0x500/0xa80
  ? __pfx_tracing_set_tracer+0x10/0x10
  ? lock_release+0x181/0x2d0
  ? _copy_from_user+0x26/0xa0
  tracing_set_trace_write+0x132/0x1e0
  ? __pfx_tracing_set_trace_write+0x10/0x10
  ? ftrace_graph_func+0xcc/0x140
  ? ftrace_stub_direct_tramp+0x10/0x10
  ? ftrace_stub_direct_tramp+0x10/0x10
  ? ftrace_stub_direct_tramp+0x10/0x10
  vfs_write+0x1d0/0xe90
  ? __pfx_vfs_write+0x10/0x10

Have the setting of the funcgraph-args check if function_graph tracer is
the current tracer of the instance, and if not, do nothing, as there's
nothing to do (the option is checked when function_graph tracing starts).

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/20250618073801.057ea636@gandalf.local.home
Fixes: c7a60a733c373 ("ftrace: Have funcgraph-args take affect during tracing")
Closes: https://lore.kernel.org/all/4ab1a7bdd0174ab09c7b0d68cdbff9a4@huawei.com/
Reported-by: Changbin Du <changbin.du@huawei.com>
Tested-by: Changbin Du <changbin.du@huawei.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_functions_graph.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -475,10 +475,16 @@ static int graph_trace_init(struct trace
 	return 0;
 }
 
+static struct tracer graph_trace;
+
 static int ftrace_graph_trace_args(struct trace_array *tr, int set)
 {
 	trace_func_graph_ent_t entry;
 
+	/* Do nothing if the current tracer is not this tracer */
+	if (tr->current_trace != &graph_trace)
+		return 0;
+
 	if (set)
 		entry = trace_graph_entry_args;
 	else


