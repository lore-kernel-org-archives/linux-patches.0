Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393801779B1;
	Tue,  8 Oct 2024 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390959; cv=none; b=bPnnWA9AlrN0dom+kbcSmVWXGYOD58lvTFvW45Mogl3vh+RbnNPfcr+o4butXN00RK1bi6CeIPnQpGPnh2g5DVu0i5Eo+vorRjtXwADsheq6QVAwzWitZh72LGajdh6RypRImYsoYoSingJtAChDfOaF56YvTM66ZdPg7/zfKXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390959; c=relaxed/simple;
	bh=NDp6vGjhR33+LtKiKNVbQiVQ129MDfb8wFRR3YZHvXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay5QaQM+kYzspKd4RLadBxbZq5yTESCzJ5KEn0jLd1z28jBz6N6QieQFMt56yc6nYeT5xYetxW+EAHHiGBIAkmmgskvFep0BkI+Ot3QQ9VJhzUlxdZ0Gei3vzShklRDxE6bBxtwiJ7fKzpgfYJejjqmh/v5czIPlnXiHkayqTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK7JSc7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK7JSc7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B5CC4CEC7;
	Tue,  8 Oct 2024 12:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390959;
	bh=NDp6vGjhR33+LtKiKNVbQiVQ129MDfb8wFRR3YZHvXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK7JSc7TJIeFdKwaPESBJBeyIbWgr4zwhnWhT4nCfWgQDuMI6OzsMvFcIjPsiW8CS
	 5vI7Q+tTX3htmSHutsBnzwFilbnpLnWxlW0h8oUOwCFKuXoANSK8WG2ZxBa90aA9ij
	 v4vKu9R8Ek2NK1Ghuk/WAsBs7A/msFuUYQQfYpr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 429/482] tracing/timerlat: Drop interface_lock in stop_kthread()
Date: Tue,  8 Oct 2024 14:08:12 +0200
Message-ID: <20241008115705.406844332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Li <liwei391@huawei.com>

commit b484a02c9cedf8703eff8f0756f94618004bd165 upstream.

stop_kthread() is the offline callback for "trace/osnoise:online", since
commit 5bfbcd1ee57b ("tracing/timerlat: Add interface_lock around clearing
of kthread in stop_kthread()"), the following ABBA deadlock scenario is
introduced:

T1                            | T2 [BP]               | T3 [AP]
osnoise_hotplug_workfn()      | work_for_cpu_fn()     | cpuhp_thread_fun()
                              |   _cpu_down()         |   osnoise_cpu_die()
  mutex_lock(&interface_lock) |                       |     stop_kthread()
                              |     cpus_write_lock() |       mutex_lock(&interface_lock)
  cpus_read_lock()            |     cpuhp_kick_ap()   |

As the interface_lock here in just for protecting the "kthread" field of
the osn_var, use xchg() instead to fix this issue. Also use
for_each_online_cpu() back in stop_per_cpu_kthreads() as it can take
cpu_read_lock() again.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240924094515.3561410-3-liwei391@huawei.com
Fixes: 5bfbcd1ee57b ("tracing/timerlat: Add interface_lock around clearing of kthread in stop_kthread()")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1953,12 +1953,8 @@ static void stop_kthread(unsigned int cp
 {
 	struct task_struct *kthread;
 
-	mutex_lock(&interface_lock);
-	kthread = per_cpu(per_cpu_osnoise_var, cpu).kthread;
+	kthread = xchg_relaxed(&(per_cpu(per_cpu_osnoise_var, cpu).kthread), NULL);
 	if (kthread) {
-		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
-		mutex_unlock(&interface_lock);
-
 		if (cpumask_test_and_clear_cpu(cpu, &kthread_cpumask) &&
 		    !WARN_ON(!test_bit(OSN_WORKLOAD, &osnoise_options))) {
 			kthread_stop(kthread);
@@ -1972,7 +1968,6 @@ static void stop_kthread(unsigned int cp
 			put_task_struct(kthread);
 		}
 	} else {
-		mutex_unlock(&interface_lock);
 		/* if no workload, just return */
 		if (!test_bit(OSN_WORKLOAD, &osnoise_options)) {
 			/*
@@ -1994,8 +1989,12 @@ static void stop_per_cpu_kthreads(void)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	cpus_read_lock();
+
+	for_each_online_cpu(cpu)
 		stop_kthread(cpu);
+
+	cpus_read_unlock();
 }
 
 /*


