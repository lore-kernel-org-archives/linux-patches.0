Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CD19F49A;
	Thu, 15 Aug 2024 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730559; cv=none; b=XTqzzEwDMyVn3MuKOB6MmgP2VFFaqg58eUVgNi6JiLx0ysfDbjrSx6vRdmKG/WiecTi2eIaTyZ7gALXL+Ih5e1VeiZpMu4Jvxfrnesf9WcOQLEaNnLjqMD1CGL/NkqmC6KjwNRJGQFgTvJutEPGovoGGiWcGuoWLJpr2JyUu8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730559; c=relaxed/simple;
	bh=pawTW0lh6hKdD5Nmak14KccYbG4OzJDDFOhqHNnstNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIc6W8ORwiUmvle7+R9Jiq5Cypl7ov/CxUxLQx8zv3tQofJeiY58pditYYmUWp8apwqw82ROGbohSgm2gOvreTFX8xkYxL1roiD2EG/17XuYx9zzN5TRxYbpfz7LoU7QNVEJO8HPJGaFY6vGkw7IK9P125RdpmZ353F9hgP2Fec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Orgl+V0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Orgl+V0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161AC32786;
	Thu, 15 Aug 2024 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730559;
	bh=pawTW0lh6hKdD5Nmak14KccYbG4OzJDDFOhqHNnstNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Orgl+V0vKYHWM/SMNAFdnH+XXrQUkMgGiZsmZi8/UNqVV8/sjvB7M7S43QRvYuk8c
	 pXA8OvIulcU1rUnBtq1as2rMwu1xYJuQ9xxTKeJKk+oVYTe97J6nI3S6W4xfEdot2y
	 0R52FN3iIgZX3UjXlKv1I+Y4MyI8EEymQcMnRhms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 447/484] sched/smt: Introduce sched_smt_present_inc/dec() helper
Date: Thu, 15 Aug 2024 15:25:05 +0200
Message-ID: <20240815131958.725647909@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 31b164e2e4af84d08d2498083676e7eeaa102493 upstream.

Introduce sched_smt_present_inc/dec() helper, so it can be called
in normal or error path simply. No functional changed.

Cc: stable@kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240703031610.587047-2-yangyingliang@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9101,6 +9101,22 @@ static int cpuset_cpu_inactive(unsigned
 	return 0;
 }
 
+static inline void sched_smt_present_inc(int cpu)
+{
+#ifdef CONFIG_SCHED_SMT
+	if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
+		static_branch_inc_cpuslocked(&sched_smt_present);
+#endif
+}
+
+static inline void sched_smt_present_dec(int cpu)
+{
+#ifdef CONFIG_SCHED_SMT
+	if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
+		static_branch_dec_cpuslocked(&sched_smt_present);
+#endif
+}
+
 int sched_cpu_activate(unsigned int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -9112,13 +9128,10 @@ int sched_cpu_activate(unsigned int cpu)
 	 */
 	balance_push_set(cpu, false);
 
-#ifdef CONFIG_SCHED_SMT
 	/*
 	 * When going up, increment the number of cores with SMT present.
 	 */
-	if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
-		static_branch_inc_cpuslocked(&sched_smt_present);
-#endif
+	sched_smt_present_inc(cpu);
 	set_cpu_active(cpu, true);
 
 	if (sched_smp_initialized) {
@@ -9187,13 +9200,12 @@ int sched_cpu_deactivate(unsigned int cp
 	}
 	rq_unlock_irqrestore(rq, &rf);
 
-#ifdef CONFIG_SCHED_SMT
 	/*
 	 * When going down, decrement the number of cores with SMT present.
 	 */
-	if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
-		static_branch_dec_cpuslocked(&sched_smt_present);
+	sched_smt_present_dec(cpu);
 
+#ifdef CONFIG_SCHED_SMT
 	sched_core_cpu_deactivate(cpu);
 #endif
 


