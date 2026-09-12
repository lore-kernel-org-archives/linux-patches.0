Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6136F32B13F;
	Sat, 12 Sep 2026 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230240; cv=none; b=BvejjA88nwF5tRdVgHVlVOVqEOyqE1BtrDk/Q4m9djSNSPGgRpx3eRenn5Xv7HFKZ0oE9LTG0Em/541F5V7NqwRpDZZ6CMurYnxK743LFCumb323HKRmoHkGkHhm12mq76lG6m1J2MRVTY0+O5fvgtaJ63dgVJ/5fIThwK34cec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230240; c=relaxed/simple;
	bh=C503s68fyArAGaWwBLJc3Xn+CBOKP4vqZXSmRNT7mcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qaj0k8hHuJ7HeVEK5O+77kAYFhHtTqdoCUvNh/rXtL/XtWyRyfjPpkKq4LQwHCQw6UBwupAZphLxLa4Iih3G9yAu2g+eF7zBtiU/Q5lHCWSh8oEPk4GydoFNWp9okg0fpbhsirqc6CBTE35zUbOKmyGpaM5nPqFAAyC9DmmZZ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMFXsNoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMFXsNoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFD61F000FF;
	Sat, 12 Sep 2026 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230239;
	bh=1zRVDOz17Ot3eJJ7Zi6HAYlDaA3u2Lg8kt8DW952HUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMFXsNoS+25FkfMc7bjDnRjfr3ENnxFUfkE3v2VsNbKOPXecVJ7NMzKM8l5Qmtfpn
	 FjiaLCncIxxaaEb3qrjgYrgkNDgyH0onE2lCroKDebX3KZY/p0P5THDjFGAncnCEyC
	 vnwkiay0t/PXbrZL0RNg2obSp1vgXGdgUEstCQNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0754/1191] tracing/osnoise: Add OSNOISE_WORKLOAD option
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065605.215255683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 30838fcd81078d078b10209bc18a6357ba4dd5fa ]

The osnoise tracer is not only a tracer, and a set of tracepoints,
but also a workload dispatcher.

In preparation for having other workloads, e.g., in user-space,
add an option to avoid dispatching the workload.

By not dispatching the workload, the osnoise: tracepoints become
generic events to measure the execution time of *any* task on Linux.

For example:

  # cd /sys/kernel/tracing/
  # cat osnoise/options
  DEFAULTS OSNOISE_WORKLOAD
  # echo NO_OSNOISE_WORKLOAD > osnoise/options
  # cat osnoise/options
  NO_DEFAULTS NO_OSNOISE_WORKLOAD
  # echo osnoise > set_event
  # echo osnoise > current_tracer
  # tail -8 trace
      make-94722   [002] d..3.  1371.794507: thread_noise:     make:94722 start 1371.794302286 duration 200897 ns
        sh-121042  [020] d..3.  1371.794534: thread_noise:       sh:121042 start 1371.781610976 duration 8943683 ns
      make-121097  [005] d..3.  1371.794542: thread_noise:     make:121097 start 1371.794481522 duration 60444 ns
     <...>-40      [005] d..3.  1371.794550: thread_noise: migration/5:40 start 1371.794542256 duration 7154 ns
    <idle>-0       [018] dNh2.  1371.794554: irq_noise: reschedule:253 start 1371.794553547 duration 40 ns
    <idle>-0       [018] dNh2.  1371.794561: irq_noise: local_timer:236 start 1371.794556222 duration 4890 ns
    <idle>-0       [018] .Ns2.  1371.794563: softirq_noise:    SCHED:7 start 1371.794561803 duration 992 ns
    <idle>-0       [018] d..3.  1371.794566: thread_noise: swapper/18:0 start 1371.781368110 duration 13191798 ns

In preparation for the rtla exec_time tracer/tool and
rtla osnoise --user option.

Link: https://lkml.kernel.org/r/f5cfbd37aefd419eefe9243b4d2fc38ed5753fe4.1668692096.git.bristot@kernel.org

Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 6e82b61fc0d2f..3319f940d78e6 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -53,12 +53,13 @@
  */
 enum osnoise_options_index {
 	OSN_DEFAULTS = 0,
+	OSN_WORKLOAD,
 	OSN_MAX
 };
 
-static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS" };
+static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS", "OSNOISE_WORKLOAD" };
 
-#define OSN_DEFAULT_OPTIONS	0
+#define OSN_DEFAULT_OPTIONS	0x2
 unsigned long osnoise_options	= OSN_DEFAULT_OPTIONS;
 
 /*
@@ -1187,11 +1188,12 @@ trace_sched_switch_callback(void *data, bool preempt,
 			    unsigned int prev_state)
 {
 	struct osnoise_variables *osn_var = this_cpu_osn_var();
+	int workload = test_bit(OSN_WORKLOAD, &osnoise_options);
 
-	if (p->pid != osn_var->pid)
+	if ((p->pid != osn_var->pid) || !workload)
 		thread_exit(osn_var, p);
 
-	if (n->pid != osn_var->pid)
+	if ((n->pid != osn_var->pid) || !workload)
 		thread_entry(osn_var, n);
 }
 
@@ -1728,9 +1730,16 @@ static void stop_kthread(unsigned int cpu)
 	struct task_struct *kthread;
 
 	kthread = per_cpu(per_cpu_osnoise_var, cpu).kthread;
-	if (kthread)
+	if (kthread) {
 		kthread_stop(kthread);
-	per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
+		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
+	} else {
+		if (!test_bit(OSN_WORKLOAD, &osnoise_options)) {
+			per_cpu(per_cpu_osnoise_var, cpu).sampling = false;
+			barrier();
+			return;
+		}
+	}
 }
 
 /*
@@ -1764,6 +1773,13 @@ static int start_kthread(unsigned int cpu)
 		snprintf(comm, 24, "timerlat/%d", cpu);
 		main = timerlat_main;
 	} else {
+		/* if no workload, just return */
+		if (!test_bit(OSN_WORKLOAD, &osnoise_options)) {
+			per_cpu(per_cpu_osnoise_var, cpu).sampling = true;
+			barrier();
+			return 0;
+		}
+
 		snprintf(comm, 24, "osnoise/%d", cpu);
 	}
 
-- 
2.53.0



