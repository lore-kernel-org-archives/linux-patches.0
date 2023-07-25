Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3560A14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB404C433C7;
	Tue, 25 Jul 2023 10:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282374;
	bh=9UP92zsORu1eL1h96OdQx+2RAGRtVWsn0V4x45unmR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpNJtOR2NohOxiYl9bARP4Wof97SD7kLFqcgTLrvorJSFaD3OlDVx3K+jopinOtQw
	 /HESjS3AauAwqlcY7JxairVJUtwEctejSN2EXmV0dreV51SSSEPo7hDpTJVjyPI3EV
	 +HZlc/R3ifATTNq25ni36frzrKhJL/lx4dUZXoPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 107/227] rcu: Mark additional concurrent load from ->cpu_no_qs.b.exp
Date: Tue, 25 Jul 2023 12:44:34 +0200
Message-ID: <20230725104519.201881689@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 9146eb25495ea8bfb5010192e61e3ed5805ce9ef ]

The per-CPU rcu_data structure's ->cpu_no_qs.b.exp field is updated
only on the instance corresponding to the current CPU, but can be read
more widely.  Unmarked accesses are OK from the corresponding CPU, but
only if interrupts are disabled, given that interrupt handlers can and
do modify this field.

Unfortunately, although the load from rcu_preempt_deferred_qs() is always
carried out from the corresponding CPU, interrupts are not necessarily
disabled.  This commit therefore upgrades this load to READ_ONCE.

Similarly, the diagnostic access from synchronize_rcu_expedited_wait()
might run with interrupts disabled and from some other CPU.  This commit
therefore marks this load with data_race().

Finally, the C-language access in rcu_preempt_ctxt_queue() is OK as
is because interrupts are disabled and this load is always from the
corresponding CPU.  This commit adds a comment giving the rationale for
this access being safe.

This data race was reported by KCSAN.  Not appropriate for backporting
due to failure being unlikely.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_exp.h    | 2 +-
 kernel/rcu/tree_plugin.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 3b7abb58157df..8239b39d945bd 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -643,7 +643,7 @@ static void synchronize_rcu_expedited_wait(void)
 					"O."[!!cpu_online(cpu)],
 					"o."[!!(rdp->grpmask & rnp->expmaskinit)],
 					"N."[!!(rdp->grpmask & rnp->expmaskinitnext)],
-					"D."[!!(rdp->cpu_no_qs.b.exp)]);
+					"D."[!!data_race(rdp->cpu_no_qs.b.exp)]);
 			}
 		}
 		pr_cont(" } %lu jiffies s: %lu root: %#lx/%c\n",
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7b0fe741a0886..41021080ad258 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -257,6 +257,8 @@ static void rcu_preempt_ctxt_queue(struct rcu_node *rnp, struct rcu_data *rdp)
 	 * GP should not be able to end until we report, so there should be
 	 * no need to check for a subsequent expedited GP.  (Though we are
 	 * still in a quiescent state in any case.)
+	 *
+	 * Interrupts are disabled, so ->cpu_no_qs.b.exp cannot change.
 	 */
 	if (blkd_state & RCU_EXP_BLKD && rdp->cpu_no_qs.b.exp)
 		rcu_report_exp_rdp(rdp);
@@ -941,7 +943,7 @@ notrace void rcu_preempt_deferred_qs(struct task_struct *t)
 {
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 
-	if (rdp->cpu_no_qs.b.exp)
+	if (READ_ONCE(rdp->cpu_no_qs.b.exp))
 		rcu_report_exp_rdp(rdp);
 }
 
-- 
2.39.2



