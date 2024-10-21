Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E394E194C62;
	Mon, 21 Oct 2024 10:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506561; cv=none; b=SkUVmZecO2l4NFlQarV4Pn48IY2H7O9MMyj2wmhGNKzQWEvlo1FHyvsYAaNtDBJyFyGvv/nTuem1JvNrs3s9i0UV1ZbznckPLlvpOVrIvxrtMFBonBV59/3UvHv3xdL+JaO3/M0cLC/mMOSDbf7sNwEtF861sZy+p47ZXgqF6d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506561; c=relaxed/simple;
	bh=tkYkVfEgUzPoXsrhVRuLds+PpmIlHv639m33uwzCegI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNNpxKWoKFnxx+p/mk+9zOR3Q9lPeKcyri3T+0Qq1+0II/0waFWjF/lygOtNG9xbZDmKc8VB4BA2+1OTHu/Esvwo9cJBbm+DV3HZ1VF+n4sTl6BY0EYJ2VeEglHSZwow5RiuQRU3mIQypNOJoHCdnO5O2kBVmKpdfnFIYVRqwvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEr97Xz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEr97Xz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A2DC4CEC3;
	Mon, 21 Oct 2024 10:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506560;
	bh=tkYkVfEgUzPoXsrhVRuLds+PpmIlHv639m33uwzCegI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEr97Xz8ElbjtPRzpOFKFcODLHmwwdqngvkbfKfCKKBfvtaTOlpYVh+eOm6y+8Mo5
	 HL8OcE4Pni8zKGtTpq7S+ZcyNBdE/ylm6fy+Saz1xfAgga3WJYSOnDZs0RnUhaSCfO
	 9SEMQo0R7aGlOgJE6922mJMrgi9bnRTAyQ6FFoxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.11 046/135] fgraph: Use CPU hotplug mechanism to initialize idle shadow stacks
Date: Mon, 21 Oct 2024 12:23:22 +0200
Message-ID: <20241021102301.135371057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 2c02f7375e658ae93d57a31a66f91b62754ef8f1 upstream.

The function graph infrastructure allocates a shadow stack for every task
when enabled. This includes the idle tasks. The first time the function
graph is invoked, the shadow stacks are created and never freed until the
task exits. This includes the idle tasks.

Only the idle tasks that were for online CPUs had their shadow stacks
created when function graph tracing started. If function graph tracing is
enabled and a CPU comes online, the idle task representing that CPU will
not have its shadow stack created, and all function graph tracing for that
idle task will be silently dropped.

Instead, use the CPU hotplug mechanism to allocate the idle shadow stacks.
This will include idle tasks for CPUs that come online during tracing.

This issue can be reproduced by:

 # cd /sys/kernel/tracing
 # echo 0 > /sys/devices/system/cpu/cpu1/online
 # echo 0 > set_ftrace_pid
 # echo function_graph > current_tracer
 # echo 1 > options/funcgraph-proc
 # echo 1 > /sys/devices/system/cpu/cpu1
 # grep '<idle>' per_cpu/cpu1/trace | head

Before, nothing would show up.

After:
 1)    <idle>-0    |   0.811 us    |                        __enqueue_entity();
 1)    <idle>-0    |   5.626 us    |                      } /* enqueue_entity */
 1)    <idle>-0    |               |                      dl_server_update_idle_time() {
 1)    <idle>-0    |               |                        dl_scaled_delta_exec() {
 1)    <idle>-0    |   0.450 us    |                          arch_scale_cpu_capacity();
 1)    <idle>-0    |   1.242 us    |                        }
 1)    <idle>-0    |   1.908 us    |                      }
 1)    <idle>-0    |               |                      dl_server_start() {
 1)    <idle>-0    |               |                        enqueue_dl_entity() {
 1)    <idle>-0    |               |                          task_contending() {

Note, if tracing stops and restarts, the old way would then initialize
the onlined CPUs.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/20241018214300.6df82178@rorschach
Fixes: 868baf07b1a25 ("ftrace: Fix memory leak with function graph and cpu hotplug")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1160,19 +1160,13 @@ void fgraph_update_pid_func(void)
 static int start_graph_tracing(void)
 {
 	unsigned long **ret_stack_list;
-	int ret, cpu;
+	int ret;
 
 	ret_stack_list = kmalloc(SHADOW_STACK_SIZE, GFP_KERNEL);
 
 	if (!ret_stack_list)
 		return -ENOMEM;
 
-	/* The cpu_boot init_task->ret_stack will never be freed */
-	for_each_online_cpu(cpu) {
-		if (!idle_task(cpu)->ret_stack)
-			ftrace_graph_init_idle_task(idle_task(cpu), cpu);
-	}
-
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
 	} while (ret == -EAGAIN);
@@ -1242,14 +1236,34 @@ static void ftrace_graph_disable_direct(
 	fgraph_direct_gops = &fgraph_stub;
 }
 
+/* The cpu_boot init_task->ret_stack will never be freed */
+static int fgraph_cpu_init(unsigned int cpu)
+{
+	if (!idle_task(cpu)->ret_stack)
+		ftrace_graph_init_idle_task(idle_task(cpu), cpu);
+	return 0;
+}
+
 int register_ftrace_graph(struct fgraph_ops *gops)
 {
+	static bool fgraph_initialized;
 	int command = 0;
 	int ret = 0;
 	int i = -1;
 
 	mutex_lock(&ftrace_lock);
 
+	if (!fgraph_initialized) {
+		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "fgraph_idle_init",
+					fgraph_cpu_init, NULL);
+		if (ret < 0) {
+			pr_warn("fgraph: Error to init cpu hotplug support\n");
+			return ret;
+		}
+		fgraph_initialized = true;
+		ret = 0;
+	}
+
 	if (!fgraph_array[0]) {
 		/* The array must always have real data on it */
 		for (i = 0; i < FGRAPH_ARRAY_SIZE; i++)


