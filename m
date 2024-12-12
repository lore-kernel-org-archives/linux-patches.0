Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622E2210D8;
	Thu, 12 Dec 2024 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018672; cv=none; b=EyXo1okUrSMk0xOJ4DSnmuKwA53d7CNDe16m9vVTKDuxLKxl07p5JwU6nzHane6TzyGNhLHPImYSDu3sqJKOk2wtzwb9KLhC2OpNnfq3SXg1w7FnTPQcVd6Db2YTQGMI1yr2MmaY5y6fHEzGALsHUOAeQRxcUWiSOktaYULCJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018672; c=relaxed/simple;
	bh=u4Ww2h/PuFK1FqH9QSkXHG//5mJB2fetBCA/IXhP6b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3bnuh/TpuKhlkGWNXzv1p1mU6boUTqgUPs0GCg/vE2it4+zKL5Zttvxvf+zwXYCQB6uRmtxeGPUhmCL1v9lvYnJmKEtsoN6DPTCKrDZ1IXdN1EIgTyMyH4VqxLYHBXm5UwmkF78kBcOOVpupOFeWO1recIf2vt9ssa2YKI9qHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbEXUHfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbEXUHfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8805C4CECE;
	Thu, 12 Dec 2024 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018672;
	bh=u4Ww2h/PuFK1FqH9QSkXHG//5mJB2fetBCA/IXhP6b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbEXUHfQSBNGSUXG9Ihrcgw7hCkxA10jaddaECZJPLd0K8EEy2zQJ78Qgz0EhJ+uq
	 oTePVfe/jYj7DwAI/RNE4EMOUQYCh5KqZUiFfelxuhyXYFGAb41GAwMW/+x0Pd0m+R
	 UiBQDU3q0Ifi1jRcAkAr5H1SPqlmUpMvGb0iFmmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/356] sched: Remove vruntime from trace_sched_stat_runtime()
Date: Thu, 12 Dec 2024 16:00:46 +0100
Message-ID: <20241212144257.482395937@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 5fe6ec8f6ab549b6422e41551abb51802bd48bc7 ]

Tracing the runtime delta makes sense, observer can sum over time.
Tracing the absolute vruntime makes less sense, inconsistent:
absolute-vs-delta, but also vruntime delta can be computed from
runtime delta.

Removing the vruntime thing also makes the two tracepoint sites
identical, allowing to unify the code in a later patch.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 0664e2c311b9 ("sched/deadline: Fix warning in migrate_enable for boosted tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/sched.h | 15 ++++++---------
 kernel/sched/fair.c          |  5 ++---
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 010ba1b7cb0ea..bdb1e838954af 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -493,33 +493,30 @@ DEFINE_EVENT_SCHEDSTAT(sched_stat_template, sched_stat_blocked,
  */
 DECLARE_EVENT_CLASS(sched_stat_runtime,
 
-	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+	TP_PROTO(struct task_struct *tsk, u64 runtime),
 
-	TP_ARGS(tsk, __perf_count(runtime), vruntime),
+	TP_ARGS(tsk, __perf_count(runtime)),
 
 	TP_STRUCT__entry(
 		__array( char,	comm,	TASK_COMM_LEN	)
 		__field( pid_t,	pid			)
 		__field( u64,	runtime			)
-		__field( u64,	vruntime			)
 	),
 
 	TP_fast_assign(
 		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
 		__entry->pid		= tsk->pid;
 		__entry->runtime	= runtime;
-		__entry->vruntime	= vruntime;
 	),
 
-	TP_printk("comm=%s pid=%d runtime=%Lu [ns] vruntime=%Lu [ns]",
+	TP_printk("comm=%s pid=%d runtime=%Lu [ns]",
 			__entry->comm, __entry->pid,
-			(unsigned long long)__entry->runtime,
-			(unsigned long long)__entry->vruntime)
+			(unsigned long long)__entry->runtime)
 );
 
 DEFINE_EVENT(sched_stat_runtime, sched_stat_runtime,
-	     TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
-	     TP_ARGS(tsk, runtime, vruntime));
+	     TP_PROTO(struct task_struct *tsk, u64 runtime),
+	     TP_ARGS(tsk, runtime));
 
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3e9333466438c..062447861d8e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1185,8 +1185,7 @@ s64 update_curr_common(struct rq *rq)
 	if (unlikely(delta_exec <= 0))
 		return delta_exec;
 
-	trace_sched_stat_runtime(curr, delta_exec, 0);
-
+	trace_sched_stat_runtime(curr, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
 	cgroup_account_cputime(curr, delta_exec);
 
@@ -1215,7 +1214,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
-		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
+		trace_sched_stat_runtime(curtask, delta_exec);
 		cgroup_account_cputime(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
-- 
2.43.0



