Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878F187325;
	Tue, 10 Sep 2024 09:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961426; cv=none; b=SpdvhhHxKTfXVpMfnkbTX8NgQOavTVF5Fj1dACStPf0sHBMjcqXkv1BwJWNUorjiRuhab30iKduZARZjHrbR2YRqJ92JsnKdbDTO25p2/qSWevS+RfQBvooZG4jaCdhkoBbvNZaq8mZDccd07ZWhvhUULZRyomaKrwX6FyxHMJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961426; c=relaxed/simple;
	bh=BrBh0h85vBs/9iShEHVmC6TF8JucMf2Ehy+f21UGSAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqgQaaZ08y11iuqWB4V1kcrHm5SF77FL45YMq8H8nWx3ABoq0UIcNNdjM5GAXPQOxE7v0ymsBdAyIHoi81WJSgFuC8Atkob6JlqDzoktZBYdmCICK2M4Mksj+8KaVvobo0OOo2ffdIW9sQVulD+CvTCvIcg4eEnBVAZ2CiBOWHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDUVz4P4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDUVz4P4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31B6C4CEC6;
	Tue, 10 Sep 2024 09:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961426;
	bh=BrBh0h85vBs/9iShEHVmC6TF8JucMf2Ehy+f21UGSAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDUVz4P4aE3CnUINhGviScqhzeHq+pPbsPRRdgY0J2uoq61IOoKT2/X6ujj7tpy0T
	 XIdYnarw2jPyhcWygaU8wulo32hOKZeoFdG+1YYWq7n9WesySonaieYWYLorR1veFz
	 PVj29a+o7MQPX7u5SsRMF1JNIFeVZWeE7eavR6U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tomas Glozar <tglozar@redhat.com>,
	John Kacur <jkacur@redhat.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 065/375] tracing/timerlat: Add interface_lock around clearing of kthread in stop_kthread()
Date: Tue, 10 Sep 2024 11:27:42 +0200
Message-ID: <20240910092624.406245992@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 5bfbcd1ee57b607fd29e4645c7f350dd385dd9ad upstream.

The timerlat interface will get and put the task that is part of the
"kthread" field of the osn_var to keep it around until all references are
released. But here's a race in the "stop_kthread()" code that will call
put_task_struct() on the kthread if it is not a kernel thread. This can
race with the releasing of the references to that task struct and the
put_task_struct() can be called twice when it should have been called just
once.

Take the interface_lock() in stop_kthread() to synchronize this change.
But to do so, the function stop_per_cpu_kthreads() needs to change the
loop from for_each_online_cpu() to for_each_possible_cpu() and remove the
cpu_read_lock(), as the interface_lock can not be taken while the cpu
locks are held. The only side effect of this change is that it may do some
extra work, as the per_cpu variables of the offline CPUs would not be set
anyway, and would simply be skipped in the loop.

Remove unneeded "return;" in stop_kthread().

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tomas Glozar <tglozar@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20240905113359.2b934242@gandalf.local.home
Fixes: e88ed227f639e ("tracing/timerlat: Add user-space interface")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1953,8 +1953,12 @@ static void stop_kthread(unsigned int cp
 {
 	struct task_struct *kthread;
 
+	mutex_lock(&interface_lock);
 	kthread = per_cpu(per_cpu_osnoise_var, cpu).kthread;
 	if (kthread) {
+		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
+		mutex_unlock(&interface_lock);
+
 		if (cpumask_test_and_clear_cpu(cpu, &kthread_cpumask) &&
 		    !WARN_ON(!test_bit(OSN_WORKLOAD, &osnoise_options))) {
 			kthread_stop(kthread);
@@ -1967,8 +1971,8 @@ static void stop_kthread(unsigned int cp
 			kill_pid(kthread->thread_pid, SIGKILL, 1);
 			put_task_struct(kthread);
 		}
-		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
 	} else {
+		mutex_unlock(&interface_lock);
 		/* if no workload, just return */
 		if (!test_bit(OSN_WORKLOAD, &osnoise_options)) {
 			/*
@@ -1976,7 +1980,6 @@ static void stop_kthread(unsigned int cp
 			 */
 			per_cpu(per_cpu_osnoise_var, cpu).sampling = false;
 			barrier();
-			return;
 		}
 	}
 }
@@ -1991,12 +1994,8 @@ static void stop_per_cpu_kthreads(void)
 {
 	int cpu;
 
-	cpus_read_lock();
-
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu)
 		stop_kthread(cpu);
-
-	cpus_read_unlock();
 }
 
 /*


