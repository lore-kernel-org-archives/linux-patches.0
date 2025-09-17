Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89113393DE9;
	Wed, 17 Sep 2025 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113708; cv=none; b=gC2jpSBE/+OAPecrmHewJrHSKULg+1SFdjYa/njf0n6htmj2hkCAlmbvRQox6vu2WUdx9LjDwagVfeWCWSpbRyQTVl/7CUbYncGJbligRcNzfkfpbH8F+fVj12tPa9FRhQ0wU/ifiZD2aa5RCuqB2jlkEljgzOvDWILCRoNwtIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113708; c=relaxed/simple;
	bh=flEuoQIdBNpVD+E0ZnvxsIOkJj6WDp6YjYNmz4VHjA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqlLW4vfley25HhSZvYtG9DZvIoQADmw6v37J6IIWo+RPcADEgRWCfnnd8gPjpiUD5VtKfmiRdsFVlcVxPbWNRPAZXWV7gbCe1Q9acHI53QSSaDjXog2NXRgmLwgOMFAt8XsOI+qKnERDM6ldZC55yebgrgl+C/MKgBgz1luxl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbOnQZri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbOnQZri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5065C4CEF0;
	Wed, 17 Sep 2025 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113708;
	bh=flEuoQIdBNpVD+E0ZnvxsIOkJj6WDp6YjYNmz4VHjA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbOnQZripy+fgp6+mnbqVcSWnGh0Cc+AOfBZUfefvcrW1PYH9wiQSsrSSDsPqbgt2
	 ew8OmUtz+lLC1qgmkHv+utaGJc/68NurcB1NInwKnmwnIR2uBi4kwi+vutXsYWFydN
	 as+zS5UAKl+CA0qKvtU6mXnBYeqHwnWY0Ce4WjH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Siewior <bigeasy@linutronix.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Tahera Fahimi <taherafahimi@linux.microsoft.com>
Subject: [PATCH 6.6 029/101] rcu-tasks: Maintain real-time response in rcu_tasks_postscan()
Date: Wed, 17 Sep 2025 14:34:12 +0200
Message-ID: <20250917123337.557303681@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paul E. McKenney <paulmck@kernel.org>

commit 0bb11a372fc8d7006b4d0f42a2882939747bdbff upstream.

The current code will scan the entirety of each per-CPU list of exiting
tasks in ->rtp_exit_list with interrupts disabled.  This is normally just
fine, because each CPU typically won't have very many tasks in this state.
However, if a large number of tasks block late in do_exit(), these lists
could be arbitrarily long.  Low probability, perhaps, but it really
could happen.

This commit therefore occasionally re-enables interrupts while traversing
these lists, inserting a dummy element to hold the current place in the
list.  In kernels built with CONFIG_PREEMPT_RT=y, this re-enabling happens
after each list element is processed, otherwise every one-to-two jiffies.

[ paulmck: Apply Frederic Weisbecker feedback. ]

Link: https://lore.kernel.org/all/ZdeI_-RfdLR8jlsm@localhost.localdomain/

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: Tahera Fahimi <taherafahimi@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -995,13 +995,33 @@ static void rcu_tasks_postscan(struct li
 	 */
 
 	for_each_possible_cpu(cpu) {
+		unsigned long j = jiffies + 1;
 		struct rcu_tasks_percpu *rtpcp = per_cpu_ptr(rcu_tasks.rtpcpu, cpu);
 		struct task_struct *t;
+		struct task_struct *t1;
+		struct list_head tmp;
 
 		raw_spin_lock_irq_rcu_node(rtpcp);
-		list_for_each_entry(t, &rtpcp->rtp_exit_list, rcu_tasks_exit_list)
+		list_for_each_entry_safe(t, t1, &rtpcp->rtp_exit_list, rcu_tasks_exit_list) {
 			if (list_empty(&t->rcu_tasks_holdout_list))
 				rcu_tasks_pertask(t, hop);
+
+			// RT kernels need frequent pauses, otherwise
+			// pause at least once per pair of jiffies.
+			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && time_before(jiffies, j))
+				continue;
+
+			// Keep our place in the list while pausing.
+			// Nothing else traverses this list, so adding a
+			// bare list_head is OK.
+			list_add(&tmp, &t->rcu_tasks_exit_list);
+			raw_spin_unlock_irq_rcu_node(rtpcp);
+			cond_resched(); // For CONFIG_PREEMPT=n kernels
+			raw_spin_lock_irq_rcu_node(rtpcp);
+			t1 = list_entry(tmp.next, struct task_struct, rcu_tasks_exit_list);
+			list_del(&tmp);
+			j = jiffies + 1;
+		}
 		raw_spin_unlock_irq_rcu_node(rtpcp);
 	}
 


