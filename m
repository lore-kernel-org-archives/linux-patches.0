Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E33F8F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6755C433C8;
	Thu, 31 Aug 2023 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480271;
	bh=Rav6HRLpJltk2TvHFABQTJq/ySQJslaEUtV39jjV+uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fFjlsPa6llKf+XUnFCJLA28WgQ3ru+FtvIVlDQHIBGiJa+hOkc6g77QrELdf+JQ8
	 wNbEsI2QBv1pfUK66rynhI46abcnZUewIVD4wXmUQMG/mVR5uh1D15wfaIS+7VT2pw
	 wOlrW/XEoW+Lp3UPD55jvpotUd4eN836CkjPx9tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Upadhyay <neeraju@codeaurora.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.15 7/9] rcu-tasks: Fix IPI failure handling in trc_wait_for_one_reader
Date: Thu, 31 Aug 2023 13:10:15 +0200
Message-ID: <20230831110830.367157989@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
References: <20230831110830.039135096@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Upadhyay <neeraju@codeaurora.org>

commit 46aa886c483f57ef13cd5ea0a85e70b93eb1d381 upstream.

The trc_wait_for_one_reader() function is called at multiple stages
of trace rcu-tasks GP function, rcu_tasks_wait_gp():

- First, it is called as part of per task function -
  rcu_tasks_trace_pertask(), for all non-idle tasks. As part of per task
  processing, this function add the task in the holdout list and if the
  task is currently running on a CPU, it sends IPI to the task's CPU.
  The IPI handler takes action depending on whether task is in trace
  rcu-tasks read side critical section or not:

  - a. If the task is in trace rcu-tasks read side critical section
       (t->trc_reader_nesting != 0), the IPI handler sets the task's
       ->trc_reader_special.b.need_qs, so that this task notifies exit
       from its outermost read side critical section (by decrementing
       trc_n_readers_need_end) to the GP handling function.
       trc_wait_for_one_reader() also increments trc_n_readers_need_end,
       so that the trace rcu-tasks GP handler function waits for this
       task's read side exit notification. The IPI handler also sets
       t->trc_reader_checked to true, and no further IPIs are sent for
       this task, for this trace rcu-tasks grace period and this
       task can be removed from holdout list.

  - b. If the task is in the process of exiting its trace rcu-tasks
       read side critical section, (t->trc_reader_nesting < 0), defer
       this task's processing to future calls to trc_wait_for_one_reader().

  - c. If task is not in rcu-task read side critical section,
       t->trc_reader_nesting == 0, ->trc_reader_checked is set for this
       task, so that this task is removed from holdout list.

- Second, trc_wait_for_one_reader() is called as part of post scan, in
  function rcu_tasks_trace_postscan(), for all idle tasks.

- Third, in function check_all_holdout_tasks_trace(), this function is
  called for each task in the holdout list, but only if there isn't
  a pending IPI for the task (->trc_ipi_to_cpu == -1). This function
  removed the task from holdout list, if IPI handler has completed the
  required work, to ensure that the current trace rcu-tasks grace period
  either waits for this task, or this task is not in a trace rcu-tasks
  read side critical section.

Now, considering the scenario where smp_call_function_single() fails in
first case, inside rcu_tasks_trace_pertask(). In this case,
->trc_ipi_to_cpu is set to the current CPU for that task. This will
result in trc_wait_for_one_reader() getting skipped in third case,
inside check_all_holdout_tasks_trace(), for this task. This further
results in ->trc_reader_checked never getting set for this task,
and the task not getting removed from holdout list. This can cause
the current trace rcu-tasks grace period to stall.

Fix the above problem, by resetting ->trc_ipi_to_cpu to -1, on
smp_call_function_single() failure, so that future IPI calls can
be send for this task.

Note that all three of the trc_wait_for_one_reader() function's
callers (rcu_tasks_trace_pertask(), rcu_tasks_trace_postscan(),
check_all_holdout_tasks_trace()) hold cpu_read_lock().  This means
that smp_call_function_single() cannot race with CPU hotplug, and thus
should never fail.  Therefore, also add a warning in order to report
any such failure in case smp_call_function_single() grows some other
reason for failure.

Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1041,9 +1041,11 @@ static void trc_wait_for_one_reader(stru
 		if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
 			// Just in case there is some other reason for
 			// failure than the target CPU being offline.
+			WARN_ONCE(1, "%s():  smp_call_function_single() failed for CPU: %d\n",
+				  __func__, cpu);
 			rcu_tasks_trace.n_ipis_fails++;
 			per_cpu(trc_ipi_to_cpu, cpu) = false;
-			t->trc_ipi_to_cpu = cpu;
+			t->trc_ipi_to_cpu = -1;
 		}
 	}
 }


