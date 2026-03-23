Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C2440DFC4;
	Mon, 23 Mar 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275010; cv=none; b=V89PtfopvGyAlaHdK1sywDAKrRCTj92CWAesK+qgY63FsJCI+d9XF0sECF1qBpCeGKk0xzl9xP06v4E5ZKXCKfSe2rQ6Sy6gG5OdGB5uFw0hVmR5S5oWii82R2uIV0QPLyfEeggezeIaWJdwh0uMXRunZUHZ9aEsaGAFJmcE9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275010; c=relaxed/simple;
	bh=6UuYLhATvAEmBtMTbHL/UtgVaQn63cyol2RconnS9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stGbClNaam1M29ooUZcQDlAsCl5vcS3B6+jtWWO/dgDlCX4/g3mUsQUZhE7ZdxFZTRywYT/uPV5dqZ6VPl4Kh841UjxmAQIvQAJWjVehFJnrVpqylBBmR3qHbUw5pfaLagxhydDki+8iNN4I6O3L2zjXH0u4HZvOpDIGdemrxNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqpsHJ1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqpsHJ1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D473C4CEF7;
	Mon, 23 Mar 2026 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275009;
	bh=6UuYLhATvAEmBtMTbHL/UtgVaQn63cyol2RconnS9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqpsHJ1G+ZvmshV3zIGirFx8lKLwQ9i1hqRdBGZFgPT9qcRFigA3bb7Q0wfNyWufW
	 wcCMUWUbuqEBtrCdFQJPqCemJQnMAo55FsfOlupVnvkxz2OTrEjBP4nKs7jN3EuH6J
	 HQuE1VzaglHxXC3nh+UrFVWryWrwGe8HHtg0uCKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 192/212] tracing: Fix failure to read user space from system call trace events
Date: Mon, 23 Mar 2026 14:46:53 +0100
Message-ID: <20260323134509.797238362@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

commit edca33a56297d5741ccf867669debec116681987 upstream.

The system call trace events call trace_user_fault_read() to read the user
space part of some system calls. This is done by grabbing a per-cpu
buffer, disabling migration, enabling preemption, calling
copy_from_user(), disabling preemption, enabling migration and checking if
the task was preempted while preemption was enabled. If it was, the buffer
is considered corrupted and it tries again.

There's a safety mechanism that will fail out of this loop if it fails 100
times (with a warning). That warning message was triggered in some
pi_futex stress tests. Enabling the sched_switch trace event and
traceoff_on_warning, showed the problem:

 pi_mutex_hammer-1375    [006] d..21   138.981648: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981651: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981656: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981659: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981664: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981667: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981671: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981675: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981679: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981682: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981687: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981690: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981695: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981698: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981703: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981706: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981711: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981714: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981719: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981722: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981727: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981730: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95
 pi_mutex_hammer-1375    [006] d..21   138.981735: sched_switch: prev_comm=pi_mutex_hammer prev_pid=1375 prev_prio=95 prev_state=R+ ==> next_comm=migration/6 next_pid=47 next_prio=0
     migration/6-47      [006] d..2.   138.981738: sched_switch: prev_comm=migration/6 prev_pid=47 prev_prio=0 prev_state=S ==> next_comm=pi_mutex_hammer next_pid=1375 next_prio=95

What happened was the task 1375 was flagged to be migrated. When
preemption was enabled, the migration thread woke up to migrate that task,
but failed because migration for that task was disabled. This caused the
loop to fail to exit because the task scheduled out while trying to read
user space.

Every time the task enabled preemption the migration thread would schedule
in, try to migrate the task, fail and let the task continue. But because
the loop would only enable preemption with migration disabled, it would
always fail because each time it enabled preemption to read user space,
the migration thread would try to migrate it.

To solve this, when the loop fails to read user space without being
scheduled out, enabled and disable preemption with migration enabled. This
will allow the migration task to successfully migrate the task and the
next loop should succeed to read user space without being scheduled out.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260316130734.1858a998@gandalf.local.home
Fixes: 64cf7d058a005 ("tracing: Have trace_marker use per-cpu data to read user space")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7346,6 +7346,23 @@ static char *trace_user_fault_read(struc
 
 	do {
 		/*
+		 * It is possible that something is trying to migrate this
+		 * task. What happens then, is when preemption is enabled,
+		 * the migration thread will preempt this task, try to
+		 * migrate it, fail, then let it run again. That will
+		 * cause this to loop again and never succeed.
+		 * On failures, enabled and disable preemption with
+		 * migration enabled, to allow the migration thread to
+		 * migrate this task.
+		 */
+		if (trys) {
+			preempt_enable_notrace();
+			preempt_disable_notrace();
+			cpu = smp_processor_id();
+			buffer = per_cpu_ptr(tinfo->tbuf, cpu)->buf;
+		}
+
+		/*
 		 * If for some reason, copy_from_user() always causes a context
 		 * switch, this would then cause an infinite loop.
 		 * If this task is preempted by another user space task, it


