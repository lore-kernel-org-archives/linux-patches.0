Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F91186E36;
	Mon, 12 Aug 2024 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480578; cv=none; b=Gur3FFH128Tp/NQ/mORK0f50qufgBLGx5gpHAH5NMvh8AQ9BJXxdj5s4sipVWJYtyQmDmo8syUq3uBlojSQZf2WZCvMpnywu/X2FYoSZjlgWCYpEO3bPCbQSzzzbFVfvtSCJipfljluXLZRb77dS/pAYLQLNmetyqFJX+dddbbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480578; c=relaxed/simple;
	bh=teMc66VdP/vOekXqs0z68h54vDaTxfjt2lq7HMF0pkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmdgYhxppxio278Sb7MvuDtyXySVQafuXLVQGOJFJkc3pNJcOpDUHiNSBQnDKHHjxQOmXOr52JRDyEGcH5zp/8Hh5BIvLXGCIOYAWOb+CMP1Yr7BybXiRjzNwv7fS97SljuCgZeJapg/VlW28yq9FJ8ZoSPStCwNJtNANV+q+Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOoBSXxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOoBSXxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30532C32782;
	Mon, 12 Aug 2024 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480577;
	bh=teMc66VdP/vOekXqs0z68h54vDaTxfjt2lq7HMF0pkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOoBSXxHZrK1zgWRORDUSKf3aQOvw34IFtBfl9uon1nrr93yHtg+tyo6PnpLSXDIr
	 Wdd9GbhGyTpymTjJhCaQEhvnevZoCc5rbFCEhcaF1bOEmU0N4JVNQwXPYyJ0ogxbMb
	 Y2Sl4D6+Qmdk4EmnIvdSuDy3Oi45ZKsoq4ObxZME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 238/263] sched/smt: Introduce sched_smt_present_inc/dec() helper
Date: Mon, 12 Aug 2024 18:03:59 +0200
Message-ID: <20240812160155.646129753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9654,6 +9654,22 @@ static int cpuset_cpu_inactive(unsigned
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
@@ -9665,13 +9681,10 @@ int sched_cpu_activate(unsigned int cpu)
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
@@ -9740,13 +9753,12 @@ int sched_cpu_deactivate(unsigned int cp
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
 


