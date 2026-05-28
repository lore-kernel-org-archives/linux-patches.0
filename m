Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A70E3164B7;
	Thu, 28 May 2026 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999005; cv=none; b=u54EB9j56uxpDkDftVeF1xZ4J0PFNFTBYLOmpEHMQkBxJRC58E1hT3sF6A2WkkOLd1IuoylQJCuZMWwr+NzhWx8IA0ryw395gWHIAFJJ9/ENAoAlHYaYWwI/zyB3P6qIEn7ANvFsEQ7ITKEkcjhpYZ95TK4alZacP/N+zDe7jAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999005; c=relaxed/simple;
	bh=dEqUJ6zOyKgYVUbKVdT+QuE275aqiwAJ0rBqAUz8kL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMScp0IblqjIZDyK4iQ95Fj1cJBLUxuCS/xAMbU4dUq3dz72ahdGEzaXZyZKMap1GA2edN3dJYRjT9g8R/lp1iFQWiyUSU/fIkURcMvSoN3HPLYnepRIAV4wZmzSrc5g9/nDrfmjn4+9PX4XAhXiPqIPk9h0DPZkm6PYMKb47R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gt7+fbAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gt7+fbAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBE71F000E9;
	Thu, 28 May 2026 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999004;
	bh=J6CnqqE3K5Ct0FbC5s3SQiUHHBWHClCpTj/ZC1SWjnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gt7+fbApOWfpTZ7DMmDUdF9nmvjJPt6hl4us70hNZgDra1jwC+/0FndLeFVzz2qyz
	 +aTWp2ze8KacDn06F0Dl4fMtc2CBvt9Zfga38cS+uofks04t/kKqYj4OrKnTNmAJO8
	 HZiQJdEgdF/Z/z9S4FmoYFASOaRxgRADeN86wYzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Samir <samir@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Tejun Heo <tj@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Boqun Feng <boqun@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 374/461] srcu: Dont queue workqueue handlers to never-online CPUs
Date: Thu, 28 May 2026 21:48:23 +0200
Message-ID: <20260528194658.274143007@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 593889c401426004bd0ea0f6d4fcece728b03420 ]

While an srcu_struct structure is in the midst of switching from CPU-0
to all-CPUs state, it can attempt to invoke callbacks for CPUs that
have never been online.  Worse yet, it can attempt in invoke callbacks
for CPUs that never will be online, even including imaginary CPUs not in
cpu_possible_mask.  This can cause hangs on s390, which is not set up to
deal with workqueue handlers being scheduled on such CPUs.  This commit
therefore causes Tree SRCU to refrain from queueing workqueue handlers
on CPUs that have not yet (and might never) come online.

Because callbacks are not invoked on CPUs that have not been
online, it is an error to invoke call_srcu(), synchronize_srcu(), or
synchronize_srcu_expedited() on a CPU that is not yet fully online.
However, it turns out to be less code to redirect the callbacks
from too-early invocations of call_srcu() than to warn about such
invocations.  This commit therefore also redirects callbacks queued on
not-yet-fully-online CPUs to the boot CPU.

Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Fixes: 61bbcfb50514 ("srcu: Push srcu_node allocation to GP when non-preemptible")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Samir <samir@linux.ibm.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Boqun Feng <boqun@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 0d01cd8c4b4a7..7c2f7cc131f7a 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -897,11 +897,9 @@ static void srcu_schedule_cbs_snp(struct srcu_struct *ssp, struct srcu_node *snp
 {
 	int cpu;
 
-	for (cpu = snp->grplo; cpu <= snp->grphi; cpu++) {
-		if (!(mask & (1UL << (cpu - snp->grplo))))
-			continue;
-		srcu_schedule_cbs_sdp(per_cpu_ptr(ssp->sda, cpu), delay);
-	}
+	for (cpu = snp->grplo; cpu <= snp->grphi; cpu++)
+		if ((mask & (1UL << (cpu - snp->grplo))) && rcu_cpu_beenfullyonline(cpu))
+			srcu_schedule_cbs_sdp(per_cpu_ptr(ssp->sda, cpu), delay);
 }
 
 /*
@@ -1322,7 +1320,9 @@ static unsigned long srcu_gp_start_if_needed(struct srcu_struct *ssp,
 	 */
 	idx = __srcu_read_lock_nmisafe(ssp);
 	ss_state = smp_load_acquire(&ssp->srcu_sup->srcu_size_state);
-	if (ss_state < SRCU_SIZE_WAIT_CALL)
+	// If !rcu_cpu_beenfullyonline(), interrupts are still disabled,
+	// so no migration is possible in either direction from this CPU.
+	if (ss_state < SRCU_SIZE_WAIT_CALL || !rcu_cpu_beenfullyonline(raw_smp_processor_id()))
 		sdp = per_cpu_ptr(ssp->sda, get_boot_cpu_id());
 	else
 		sdp = raw_cpu_ptr(ssp->sda);
-- 
2.53.0



