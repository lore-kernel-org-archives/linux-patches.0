Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613DBBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20BCC433D2;
	Tue,  7 Mar 2023 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209316;
	bh=06aAdmUsOD91mW3GI3vxntpTk6RpxZOxbnjk85Zb+3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J88l/37++jmrLrgn4cDCUhTm8wZBVjArktQxrSpMOtLA55atGKoRHtgn5d/6ZYIWy
	 3YN2nSK9tgn+1bf+vq9iP8giM6mi2OAtp5wGfl3NE7CvAIKa97EahUxMiCg99Lq1zG
	 tFXk6OOaLi7HkLb/tSQ2u06ejx1P7AMzAR5O0cJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0179/1001] rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls
Date: Tue,  7 Mar 2023 17:49:11 +0100
Message-Id: <20230307170029.685993494@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 44757092958bdd749775022f915b7ac974384c2a ]

Ever since the following commit:

	5a41344a3d83 ("srcu: Simplify __srcu_read_unlock() via this_cpu_dec()")

SRCU doesn't rely anymore on preemption to be disabled in order to
modify the per-CPU counter. And even then it used to be done from the API
itself.

Therefore and after checking further, it appears to be safe to remove
the preemption disablement around __srcu_read_[un]lock() in
exit_tasks_rcu_start() and exit_tasks_rcu_finish()

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Suggested-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 28319d6dc5e2 ("rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 488ba8adf132c..20617a2d04ed9 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1008,9 +1008,7 @@ EXPORT_SYMBOL_GPL(show_rcu_tasks_classic_gp_kthread);
  */
 void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 {
-	preempt_disable();
 	current->rcu_tasks_idx = __srcu_read_lock(&tasks_rcu_exit_srcu);
-	preempt_enable();
 }
 
 /*
@@ -1022,9 +1020,7 @@ void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
 {
 	struct task_struct *t = current;
 
-	preempt_disable();
 	__srcu_read_unlock(&tasks_rcu_exit_srcu, t->rcu_tasks_idx);
-	preempt_enable();
 	exit_tasks_rcu_finish_trace(t);
 }
 
-- 
2.39.2



