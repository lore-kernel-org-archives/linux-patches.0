Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D24C3DE;
	Mon,  8 Jan 2024 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiJY/zgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2A8C433D9;
	Mon,  8 Jan 2024 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726794;
	bh=DjjeD9YZur++4yIonkCQ2Kbr01mcyuHHwkXw17SO2hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiJY/zgK2vr9kmM4n3vgQUOvJHt9UD6lkNHunr+G/fEXGOVIBhGjPwr3+KEvJHG4j
	 SKm+lzhhuFmMZC2nHuZHXPQqNn6EP4/tpUKC7uSlSZJaPssQtTZjisSX6ZOVBwgEpE
	 905/3kdgtq21EcRJl4R+ASUyk0dQKVhvOL8DtS7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/124] rcu/tasks: Handle new PF_IDLE semantics
Date: Mon,  8 Jan 2024 16:08:26 +0100
Message-ID: <20240108150606.655265779@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 9715ed501b585d47444865071674c961c0cc0020 ]

The commit:

	cff9b2332ab7 ("kernel/sched: Modify initial boot task idle setup")

has changed the semantics of what is to be considered an idle task in
such a way that CPU boot code preceding the actual idle loop is excluded
from it.

This has however introduced new potential RCU-tasks stalls when either:

1) Grace period is started before init/0 had a chance to set PF_IDLE,
   keeping it stuck in the holdout list until idle ever schedules.

2) Grace period is started when some possible CPUs have never been
   online, keeping their idle tasks stuck in the holdout list until the
   CPU ever boots up.

3) Similar to 1) but with secondary CPUs: Grace period is started
   concurrently with secondary CPU booting, putting its idle task in
   the holdout list because PF_IDLE isn't yet observed on it. It stays
   then stuck in the holdout list until that CPU ever schedules. The
   effect is mitigated here by the hotplug AP thread that must run to
   bring the CPU up.

Fix this with handling the new semantics of PF_IDLE, keeping in mind
that it may or may not be set on an idle task. Take advantage of that to
strengthen the coverage of an RCU-tasks quiescent state within an idle
task, excluding the CPU boot code from it. Only the code running within
the idle loop is now a quiescent state, along with offline CPUs.

Fixes: cff9b2332ab7 ("kernel/sched: Modify initial boot task idle setup")
Suggested-by: Joel Fernandes <joel@joelfernandes.org>
Suggested-by: "Paul E. McKenney" <paulmck@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 8d65f7d576a34..b5dc1e5d78c83 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -892,10 +892,36 @@ static void rcu_tasks_pregp_step(struct list_head *hop)
 	synchronize_rcu();
 }
 
+/* Check for quiescent states since the pregp's synchronize_rcu() */
+static bool rcu_tasks_is_holdout(struct task_struct *t)
+{
+	int cpu;
+
+	/* Has the task been seen voluntarily sleeping? */
+	if (!READ_ONCE(t->on_rq))
+		return false;
+
+	/*
+	 * Idle tasks (or idle injection) within the idle loop are RCU-tasks
+	 * quiescent states. But CPU boot code performed by the idle task
+	 * isn't a quiescent state.
+	 */
+	if (is_idle_task(t))
+		return false;
+
+	cpu = task_cpu(t);
+
+	/* Idle tasks on offline CPUs are RCU-tasks quiescent states. */
+	if (t == idle_task(cpu) && !rcu_cpu_online(cpu))
+		return false;
+
+	return true;
+}
+
 /* Per-task initial processing. */
 static void rcu_tasks_pertask(struct task_struct *t, struct list_head *hop)
 {
-	if (t != current && READ_ONCE(t->on_rq) && !is_idle_task(t)) {
+	if (t != current && rcu_tasks_is_holdout(t)) {
 		get_task_struct(t);
 		t->rcu_tasks_nvcsw = READ_ONCE(t->nvcsw);
 		WRITE_ONCE(t->rcu_tasks_holdout, true);
@@ -944,7 +970,7 @@ static void check_holdout_task(struct task_struct *t,
 
 	if (!READ_ONCE(t->rcu_tasks_holdout) ||
 	    t->rcu_tasks_nvcsw != READ_ONCE(t->nvcsw) ||
-	    !READ_ONCE(t->on_rq) ||
+	    !rcu_tasks_is_holdout(t) ||
 	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
 	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
 		WRITE_ONCE(t->rcu_tasks_holdout, false);
-- 
2.43.0



