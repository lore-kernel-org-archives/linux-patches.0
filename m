Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333EE2DD608;
	Wed, 28 Jan 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614670; cv=none; b=tVprDhr3kDIRE6csC00JHHnIFEpdZvoJM4mdz814/6M92s0X0yzZDQHhA23ZZ0upD91MDTQGPhGK4Howq0qyDt0/TrzTpuyv6xsqQZFA4uSKVbT+rWgnmlknbY4WGLfbUrT/HNb9QWJddV5oAo4M1ffS0H6qC31Zq+8LCybDjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614670; c=relaxed/simple;
	bh=f38qKv75AVmty4cIkU14O9P/J+OKYKpun8M4j3fexPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkqdmt1XGJCRdsnOTAM6rvOanfDrewxpWiU5uBvsbZLoBM5Hp8x+e0Th8/JC7kIa4+wLyQlzbJcS+Uo5cCuOEheBM7cwjjOIIo6nnI34nHO1tgRBfW98GWz/IxUdOjAo44LNAUNbTxwKYLxYPGTjA9G2eHcI+DdgtPypS15KmaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDrGMxuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDrGMxuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792D2C2BC9E;
	Wed, 28 Jan 2026 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614670;
	bh=f38qKv75AVmty4cIkU14O9P/J+OKYKpun8M4j3fexPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDrGMxuOLLbZpDo0dzRDSS2r4CiEIA7taP7Sk9K8p/SWTK4h6wbvJXnNV5AO3PJQJ
	 /Q57ws8JWPKnumS/Ffp0le6nlKD1mO/w1+QxtM0CwYiGzXkE22o3O4MjU33ZkOq5j2
	 8snTS2vMkar4IKzT+HsRqBF1UdcS7C6i61baGyL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 205/254] tracing: Fix crash on synthetic stacktrace field usage
Date: Wed, 28 Jan 2026 16:23:01 +0100
Message-ID: <20260128145352.172334652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 90f9f5d64cae4e72defd96a2a22760173cb3c9ec upstream.

When creating a synthetic event based on an existing synthetic event that
had a stacktrace field and the new synthetic event used that field a
kernel crash occurred:

 ~# cd /sys/kernel/tracing
 ~# echo 's:stack unsigned long stack[];' > dynamic_events
 ~# echo 'hist:keys=prev_pid:s0=common_stacktrace if prev_state & 3' >> events/sched/sched_switch/trigger
 ~# echo 'hist:keys=next_pid:s1=$s0:onmatch(sched.sched_switch).trace(stack,$s1)' >> events/sched/sched_switch/trigger

The above creates a synthetic event that takes a stacktrace when a task
schedules out in a non-running state and passes that stacktrace to the
sched_switch event when that task schedules back in. It triggers the
"stack" synthetic event that has a stacktrace as its field (called "stack").

 ~# echo 's:syscall_stack s64 id; unsigned long stack[];' >> dynamic_events
 ~# echo 'hist:keys=common_pid:s2=stack' >> events/synthetic/stack/trigger
 ~# echo 'hist:keys=common_pid:s3=$s2,i0=id:onmatch(synthetic.stack).trace(syscall_stack,$i0,$s3)' >> events/raw_syscalls/sys_exit/trigger

The above makes another synthetic event called "syscall_stack" that
attaches the first synthetic event (stack) to the sys_exit trace event and
records the stacktrace from the stack event with the id of the system call
that is exiting.

When enabling this event (or using it in a historgram):

 ~# echo 1 > events/synthetic/syscall_stack/enable

Produces a kernel crash!

 BUG: unable to handle page fault for address: 0000000000400010
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: Oops: 0000 [#1] SMP PTI
 CPU: 6 UID: 0 PID: 1257 Comm: bash Not tainted 6.16.3+deb14-amd64 #1 PREEMPT(lazy)  Debian 6.16.3-1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
 RIP: 0010:trace_event_raw_event_synth+0x90/0x380
 Code: c5 00 00 00 00 85 d2 0f 84 e1 00 00 00 31 db eb 34 0f 1f 00 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 2e 0f 1f 84 00 00 00 00 00 <49> 8b 04 24 48 83 c3 01 8d 0c c5 08 00 00 00 01 cd 41 3b 5d 40 0f
 RSP: 0018:ffffd2670388f958 EFLAGS: 00010202
 RAX: ffff8ba1065cc100 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: fffff266ffda7b90 RDI: ffffd2670388f9b0
 RBP: 0000000000000010 R08: ffff8ba104e76000 R09: ffffd2670388fa50
 R10: ffff8ba102dd42e0 R11: ffffffff9a908970 R12: 0000000000400010
 R13: ffff8ba10a246400 R14: ffff8ba10a710220 R15: fffff266ffda7b90
 FS:  00007fa3bc63f740(0000) GS:ffff8ba2e0f48000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000400010 CR3: 0000000107f9e003 CR4: 0000000000172ef0
 Call Trace:
  <TASK>
  ? __tracing_map_insert+0x208/0x3a0
  action_trace+0x67/0x70
  event_hist_trigger+0x633/0x6d0
  event_triggers_call+0x82/0x130
  trace_event_buffer_commit+0x19d/0x250
  trace_event_raw_event_sys_exit+0x62/0xb0
  syscall_exit_work+0x9d/0x140
  do_syscall_64+0x20a/0x2f0
  ? trace_event_raw_event_sched_switch+0x12b/0x170
  ? save_fpregs_to_fpstate+0x3e/0x90
  ? _raw_spin_unlock+0xe/0x30
  ? finish_task_switch.isra.0+0x97/0x2c0
  ? __rseq_handle_notify_resume+0xad/0x4c0
  ? __schedule+0x4b8/0xd00
  ? restore_fpregs_from_fpstate+0x3c/0x90
  ? switch_fpu_return+0x5b/0xe0
  ? do_syscall_64+0x1ef/0x2f0
  ? do_fault+0x2e9/0x540
  ? __handle_mm_fault+0x7d1/0xf70
  ? count_memcg_events+0x167/0x1d0
  ? handle_mm_fault+0x1d7/0x2e0
  ? do_user_addr_fault+0x2c3/0x7f0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The reason is that the stacktrace field is not labeled as such, and is
treated as a normal field and not as a dynamic event that it is.

In trace_event_raw_event_synth() the event is field is still treated as a
dynamic array, but the retrieval of the data is considered a normal field,
and the reference is just the meta data:

// Meta data is retrieved instead of a dynamic array
  str_val = (char *)(long)var_ref_vals[val_idx];

// Then when it tries to process it:
  len = *((unsigned long *)str_val) + 1;

It triggers a kernel page fault.

To fix this, first when defining the fields of the first synthetic event,
set the filter type to FILTER_STACKTRACE. This is used later by the second
synthetic event to know that this field is a stacktrace. When creating
the field of the new synthetic event, have it use this FILTER_STACKTRACE
to know to create a stacktrace field to copy the stacktrace into.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20260122194824.6905a38e@gandalf.local.home
Fixes: 00cf3d672a9d ("tracing: Allow synthetic events to pass around stacktraces")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c  |    9 +++++++++
 kernel/trace/trace_events_synth.c |    8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2047,6 +2047,15 @@ static struct hist_field *create_hist_fi
 			hist_field->fn_num = HIST_FIELD_FN_RELDYNSTRING;
 		else
 			hist_field->fn_num = HIST_FIELD_FN_PSTRING;
+	} else if (field->filter_type == FILTER_STACKTRACE) {
+		flags |= HIST_FIELD_FL_STACKTRACE;
+
+		hist_field->size = MAX_FILTER_STR_VAL;
+		hist_field->type = kstrdup_const(field->type, GFP_KERNEL);
+		if (!hist_field->type)
+			goto free;
+
+		hist_field->fn_num = HIST_FIELD_FN_STACK;
 	} else {
 		hist_field->size = field->size;
 		hist_field->is_signed = field->is_signed;
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -137,7 +137,9 @@ static int synth_event_define_fields(str
 	struct synth_event *event = call->data;
 	unsigned int i, size, n_u64;
 	char *name, *type;
+	int filter_type;
 	bool is_signed;
+	bool is_stack;
 	int ret = 0;
 
 	for (i = 0, n_u64 = 0; i < event->n_fields; i++) {
@@ -145,8 +147,12 @@ static int synth_event_define_fields(str
 		is_signed = event->fields[i]->is_signed;
 		type = event->fields[i]->type;
 		name = event->fields[i]->name;
+		is_stack = event->fields[i]->is_stack;
+
+		filter_type = is_stack ? FILTER_STACKTRACE : FILTER_OTHER;
+
 		ret = trace_define_field(call, type, name, offset, size,
-					 is_signed, FILTER_OTHER);
+					 is_signed, filter_type);
 		if (ret)
 			break;
 


