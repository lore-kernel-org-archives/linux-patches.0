Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588FF18734F;
	Mon, 12 Aug 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479682; cv=none; b=S5GoBkbk1uOm1Xc0z0Ev9pOIwli18lEmGXCqZ1wlzNIosGhvHW0v+/ch/mOv5Rmwdl75chb/QGHUVJlLl+tKx6nhNV6YWbEOMIszczfs2kJU+PXTtCTM7P+wsWg0X6vdNqgOs/jQJnl6WJ2ZfnMI66cOCTg5OVagvDMvGS0rUVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479682; c=relaxed/simple;
	bh=aBWXgHqoMDILUReSXU27UiSJuHGGPBuTlfmRnO0RBus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSMxvCbCReSBViT3XSiHmaL51/xrjP68fOrfZ3lb/bPN/RmZp/meHua16R1Xzp9Qt9uIeOL+VHF20f/ZdrgS6bWv8O92O/EbluH3x4YR4BI4qihvadRNnFBpnMh1vjahkYPW17TPhAhmluzG6h2z777mtEpSfXjSRKEiPgkrT8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbEXbZfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbEXbZfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC73C4AF09;
	Mon, 12 Aug 2024 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479682;
	bh=aBWXgHqoMDILUReSXU27UiSJuHGGPBuTlfmRnO0RBus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbEXbZfiu8Ik7OoG71iUyQ5oXgwV8+Qv3kgCWiisb6I2Iitep6FBuN5qVlH4yZrPV
	 A/hupT+813Whp2zZJAtZEmv3FYbrcGmM5+Nk28JKybBhcIbQNP/k9INNHVyhKqrWLi
	 JZIyvsJCWLO0Ts+qjwdi0z22bv05BcYfINrnfi+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 159/189] sched/core: Introduce sched_set_rq_on/offline() helper
Date: Mon, 12 Aug 2024 18:03:35 +0200
Message-ID: <20240812160138.261905228@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 2f027354122f58ee846468a6f6b48672fff92e9b upstream.

Introduce sched_set_rq_on/offline() helper, so it can be called
in normal or error path simply. No functional changed.

Cc: stable@kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240703031610.587047-4-yangyingliang@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9596,6 +9596,30 @@ void set_rq_offline(struct rq *rq)
 	}
 }
 
+static inline void sched_set_rq_online(struct rq *rq, int cpu)
+{
+	struct rq_flags rf;
+
+	rq_lock_irqsave(rq, &rf);
+	if (rq->rd) {
+		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+		set_rq_online(rq);
+	}
+	rq_unlock_irqrestore(rq, &rf);
+}
+
+static inline void sched_set_rq_offline(struct rq *rq, int cpu)
+{
+	struct rq_flags rf;
+
+	rq_lock_irqsave(rq, &rf);
+	if (rq->rd) {
+		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
+		set_rq_offline(rq);
+	}
+	rq_unlock_irqrestore(rq, &rf);
+}
+
 /*
  * used to mark begin/end of suspend/resume:
  */
@@ -9665,7 +9689,6 @@ static inline void sched_smt_present_dec
 int sched_cpu_activate(unsigned int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	struct rq_flags rf;
 
 	/*
 	 * Clear the balance_push callback and prepare to schedule
@@ -9694,12 +9717,7 @@ int sched_cpu_activate(unsigned int cpu)
 	 * 2) At runtime, if cpuset_cpu_active() fails to rebuild the
 	 *    domains.
 	 */
-	rq_lock_irqsave(rq, &rf);
-	if (rq->rd) {
-		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
-		set_rq_online(rq);
-	}
-	rq_unlock_irqrestore(rq, &rf);
+	sched_set_rq_online(rq, cpu);
 
 	return 0;
 }
@@ -9707,7 +9725,6 @@ int sched_cpu_activate(unsigned int cpu)
 int sched_cpu_deactivate(unsigned int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	struct rq_flags rf;
 	int ret;
 
 	/*
@@ -9738,12 +9755,7 @@ int sched_cpu_deactivate(unsigned int cp
 	 */
 	synchronize_rcu();
 
-	rq_lock_irqsave(rq, &rf);
-	if (rq->rd) {
-		BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
-		set_rq_offline(rq);
-	}
-	rq_unlock_irqrestore(rq, &rf);
+	sched_set_rq_offline(rq, cpu);
 
 	/*
 	 * When going down, decrement the number of cores with SMT present.


