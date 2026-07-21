Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B5436344;
	Tue, 21 Jul 2026 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657116; cv=none; b=P1XnBEi0bMT/wXpIEjNY747i5qsIy/FWS1p5+fT/X0R3kTswNefqYXLckKjkc1x7GbwJYNZj/guAsqoP50T0g2GHoh7Dy9O9IgzjhVY8wi/BliaVibh+30O4sLoWSJWVkynRIUrh1LZ94Yv1esMYXWD/ggpTLobecLjwy6ab9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657116; c=relaxed/simple;
	bh=q2/AnPrYBhkqCnW2pZJ0dkbubRsqBFwtPapiH5AjTY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UoYj3Ik0ChggIahv/PTD341kmjD1PQYa8B3xT/sX0ZAVoLY6lgYOzwOluVfUr99p78A3DihrKQP2RH1Z0bm7UwguCCnX/KVht4imLBJelLTYv5wix9S1NFBG25zPBsMthwoVSZNRHzvAumkYP677s5Rart63ZfAmd3lPdvHb0mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AR5HVhjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AR5HVhjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8511F000E9;
	Tue, 21 Jul 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657115;
	bh=n6fvIJAhUQhU5Uxg+XRprnnNLJt8p/JZxpM0KIswXNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AR5HVhjSdBoJhE8Od6X4+lbYoyPK7FgqIX3R6x+2Y+a6S3QrEcShdi6iX/OFpvrBh
	 92ytlFA33Nt80/RAeQBW19Vj3HF6QKtScBUY+XSi/Y9VsdAuQaZwXmpbulzN3ws/4+
	 1DGc2vhdgHjFIft3TXCXxmevUI7241oi0hGe2UTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0642/1611] perf sched: Fix register_pid() overflow, strcpy, and BUG_ON
Date: Tue, 21 Jul 2026 17:12:38 +0200
Message-ID: <20260721152529.830992287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5949d339f5ec98752d56dcd4e36f619a59d513a5 ]

register_pid() has several issues when processing untrusted perf.data:

1. Integer overflow: (pid + 1) * sizeof(struct task_desc *) can wrap
   to a small value on 32-bit systems when pid is large (e.g.
   0x40000000), causing realloc to return a tiny buffer followed by
   out-of-bounds writes in the initialization loop.

2. Heap buffer overflow: strcpy(task->comm, comm) copies the
   untrusted comm string into a fixed 20-byte COMM_LEN buffer with
   no length check.

3. BUG_ON on allocation failure: perf.data is untrusted input, so
   allocation failures should be handled gracefully rather than
   killing the process.

4. Realloc of sched->tasks assigned directly back, leaking the old
   pointer on failure; nr_tasks incremented before the realloc,
   leaving corrupted state on failure.

Cap pid at PID_MAX_LIMIT (4194304, matching the kernel's maximum
on 64-bit), replace strcpy with strlcpy, guard against NULL comm,
replace BUG_ON with NULL returns using safe realloc patterns, and
add NULL checks in callers that dereference the result.

Fixes: ec156764d424 ("perf sched: Import schedbench.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 40 ++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 2600747b243184..0b245e8240f6ec 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -52,6 +52,7 @@
 #define COMM_LEN		20
 #define SYM_LEN			129
 #define MAX_PID			1024000
+#define PID_MAX_LIMIT		4194304 /* kernel limit on 64-bit */
 #define MAX_PRIO		140
 
 static const char *cpu_list;
@@ -441,17 +442,28 @@ static void add_sched_event_sleep(struct perf_sched *sched, struct task_desc *ta
 static struct task_desc *register_pid(struct perf_sched *sched,
 				      unsigned long pid, const char *comm)
 {
-	struct task_desc *task;
+	struct task_desc *task, **tasks_p;
 	static int pid_max;
 
+	/* perf.data is untrusted — cap pid to prevent overflow in size calculations */
+	if (pid >= PID_MAX_LIMIT) {
+		pr_err("pid %lu exceeds limit %d, skipping\n", pid, PID_MAX_LIMIT);
+		return NULL;
+	}
+
 	if (sched->pid_to_task == NULL) {
 		if (sysctl__read_int("kernel/pid_max", &pid_max) < 0)
 			pid_max = MAX_PID;
-		BUG_ON((sched->pid_to_task = calloc(pid_max, sizeof(struct task_desc *))) == NULL);
+		sched->pid_to_task = calloc(pid_max, sizeof(struct task_desc *));
+		if (sched->pid_to_task == NULL)
+			return NULL;
 	}
 	if (pid >= (unsigned long)pid_max) {
-		BUG_ON((sched->pid_to_task = realloc(sched->pid_to_task, (pid + 1) *
-			sizeof(struct task_desc *))) == NULL);
+		void *p = realloc(sched->pid_to_task, (pid + 1) * sizeof(struct task_desc *));
+
+		if (p == NULL)
+			return NULL;
+		sched->pid_to_task = p;
 		while (pid >= (unsigned long)pid_max)
 			sched->pid_to_task[pid_max++] = NULL;
 	}
@@ -462,9 +474,11 @@ static struct task_desc *register_pid(struct perf_sched *sched,
 		return task;
 
 	task = zalloc(sizeof(*task));
+	if (task == NULL)
+		return NULL;
 	task->pid = pid;
-	task->nr = sched->nr_tasks;
-	strcpy(task->comm, comm);
+	if (comm)
+		strlcpy(task->comm, comm, sizeof(task->comm));
 	/*
 	 * every task starts in sleeping state - this gets ignored
 	 * if there's no wakeup pointing to this sleep state:
@@ -472,10 +486,12 @@ static struct task_desc *register_pid(struct perf_sched *sched,
 	add_sched_event_sleep(sched, task, 0);
 
 	sched->pid_to_task[pid] = task;
-	sched->nr_tasks++;
-	sched->tasks = realloc(sched->tasks, sched->nr_tasks * sizeof(struct task_desc *));
-	BUG_ON(!sched->tasks);
-	sched->tasks[task->nr] = task;
+	tasks_p = realloc(sched->tasks, (sched->nr_tasks + 1) * sizeof(struct task_desc *));
+	if (!tasks_p)
+		return NULL;
+	sched->tasks = tasks_p;
+	sched->tasks[sched->nr_tasks] = task;
+	task->nr = sched->nr_tasks++;
 
 	if (verbose > 0)
 		printf("registered task #%ld, PID %ld (%s)\n", sched->nr_tasks, pid, comm);
@@ -834,6 +850,8 @@ replay_wakeup_event(struct perf_sched *sched,
 
 	waker = register_pid(sched, sample->tid, "<unknown>");
 	wakee = register_pid(sched, pid, comm);
+	if (waker == NULL || wakee == NULL)
+		return -1;
 
 	add_sched_event_wakeup(sched, waker, sample->time, wakee);
 	return 0;
@@ -875,6 +893,8 @@ static int replay_switch_event(struct perf_sched *sched,
 
 	prev = register_pid(sched, prev_pid, prev_comm);
 	next = register_pid(sched, next_pid, next_comm);
+	if (prev == NULL || next == NULL)
+		return -1;
 
 	sched->cpu_last_switched[cpu] = timestamp;
 
-- 
2.53.0



