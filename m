Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF221779B1;
	Tue,  8 Oct 2024 12:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391008; cv=none; b=ieFnefdGk3USarlGNSbbCqK3g4ZYbjPr4eD6qD1O/SKeMyZgtKpiFGZdfPf7ujgK28uO9NgR6aVTLT1/5FSTYD6pzGMdkWVu7WksJ2D7gEk0BdrDKPz8G+b0hhBRWrdxp25y3mU0m55LMpU5EQ9HwyZhfeOOFjwnTGptJgWf+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391008; c=relaxed/simple;
	bh=P4rlnpOw4w8IsyAKUaDtN/DT8vppY4gqVwvuBMeioXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYKTepN6XwIAckaqd1m+ULMaVUscEANKie4/TUyFvb72UdMc/2QySCMojRwnS1pkiXqQEBmapDBpr22DBElAfRG6sS83CABBwYbFVfA3h4sIurUPpL2ymhv7F0ZkIPvQcU/SbiLuH0bb3OZeLm2CIyAyxgCrqLvS9408+4Y3EUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0krgO1Jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0krgO1Jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFABC4CEC7;
	Tue,  8 Oct 2024 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391008;
	bh=P4rlnpOw4w8IsyAKUaDtN/DT8vppY4gqVwvuBMeioXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0krgO1JyFUuk6BmDkclQxEFhV1fzZjI0w6aIQVnkYhFHXRXCp4aBY6lQuWsMZVaKF
	 Egsh3X6iLvmthFMO9z3CIb5S77EIEHjfEC5HuzNcySoRL/2sYYb4cvZQL0ibT3paqU
	 edGnEFHnxCw719jFvKbJ5+6AybMgCByN7NtCpo8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wei Li <liwei391@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 431/482] tracing/timerlat: Fix duplicated kthread creation due to CPU online/offline
Date: Tue,  8 Oct 2024 14:08:14 +0200
Message-ID: <20241008115705.484343411@linuxfoundation.org>
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

commit 0bb0a5c12ecf36ad561542bbb95f96355e036a02 upstream.

osnoise_hotplug_workfn() is the asynchronous online callback for
"trace/osnoise:online". It may be congested when a CPU goes online and
offline repeatedly and is invoked for multiple times after a certain
online.

This will lead to kthread leak and timer corruption. Add a check
in start_kthread() to prevent this situation.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20240924094515.3561410-2-liwei391@huawei.com
Fixes: c8895e271f79 ("trace/osnoise: Support hotplug operations")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2006,6 +2006,10 @@ static int start_kthread(unsigned int cp
 	void *main = osnoise_main;
 	char comm[24];
 
+	/* Do not start a new thread if it is already running */
+	if (per_cpu(per_cpu_osnoise_var, cpu).kthread)
+		return 0;
+
 	if (timerlat_enabled()) {
 		snprintf(comm, 24, "timerlat/%d", cpu);
 		main = timerlat_main;
@@ -2060,11 +2064,10 @@ static int start_per_cpu_kthreads(void)
 		if (cpumask_test_and_clear_cpu(cpu, &kthread_cpumask)) {
 			struct task_struct *kthread;
 
-			kthread = per_cpu(per_cpu_osnoise_var, cpu).kthread;
+			kthread = xchg_relaxed(&(per_cpu(per_cpu_osnoise_var, cpu).kthread), NULL);
 			if (!WARN_ON(!kthread))
 				kthread_stop(kthread);
 		}
-		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
 	}
 
 	for_each_cpu(cpu, current_mask) {


