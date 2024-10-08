Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297391DEFED;
	Tue,  8 Oct 2024 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392897; cv=none; b=k9FZWzDtb6Qm/WoQo31AG1F1lEFZgEFroNlW4aNUl+rKlWjnoa5/5UvBKtGgEYsxDyaCdTBWiU6ZTdEgDgtzC05dZpHM8IJ2EDquS1Vf63v1iuCV5W2NoGpP2pdsNgLHpFT5ItnPCUjIhDWl4HdKZv91CetkQNTpRluPZibTYEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392897; c=relaxed/simple;
	bh=ERmHoXo1YJwxut4E/9rbUu3HRXxWD3A/JPo+/UFpmeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EewGGU/NemVWhRb11KHUKodKFRRwRlRZ9OXkzmMqmpVtPOIJf7v25DA/9/jXs7i56mYNnVKpWv68BsG+TY90BUM18yblP76LOc+Da0gLHb7colENXsd70AQ/0aZ3xiX24uTorXXd+bTUoah8U0aES7c6etlvi392YQwDzsn1Bqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiHAlI6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiHAlI6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89065C4CECD;
	Tue,  8 Oct 2024 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392897;
	bh=ERmHoXo1YJwxut4E/9rbUu3HRXxWD3A/JPo+/UFpmeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiHAlI6Q1GJ+4giWCbDxsdQAAgEirnqXH7vw3Lck2++1dSFh5k3BfmfO2ZbF+GpAX
	 1iBiFdbp4eV4QxxBhHR5mctlj0REa1wwBIvrR+BY/6/mcCSoPGPklkv/F2/g0V+mZx
	 ixTf7QxjDJBSIMQu9kePnTrNQr4pRy+oBUTEYYt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.11 510/558] tracing/timerlat: Drop interface_lock in stop_kthread()
Date: Tue,  8 Oct 2024 14:09:00 +0200
Message-ID: <20241008115722.298176997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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


