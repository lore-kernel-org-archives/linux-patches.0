Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874BD183CD9;
	Mon, 12 Aug 2024 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479070; cv=none; b=NSkD2CYksWYMGXG0NLgvRVYGWdfq3yL9WSVR5zzMbDOzuetwXjX9zQqusDlVlAujv7tM4KHBkwMSq4sxU/IimYKxe2ZAvCNy+7cUMaKnCwxwXH4aQzbrUqBWZdxUykg6mbPFkuSsznaW7CZf6mSfPlPA2asZyYbuZv+CqnPbgL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479070; c=relaxed/simple;
	bh=eALYMivd+RmZ73Ux+EqL7ianBCtZeCB6vVwTFUg5u/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIGrJ6KVxuBlg5hTwqlp9mt73zdjFHCHyK03WU4I7geXkEmuEj71NGeUy+PLHTAVl6oO94mzk+zXdAEhBorA6g6+vuQ7UpHRADn+6ZsVxo4rCaE5Q0KGVr2oTxBtf2RJWYGHmBB6snUbqM2w7ylgjznjF0L0nhZn73PeQcXdEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPUXo/VJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPUXo/VJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030D0C32782;
	Mon, 12 Aug 2024 16:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479070;
	bh=eALYMivd+RmZ73Ux+EqL7ianBCtZeCB6vVwTFUg5u/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPUXo/VJusZ/gAvJatAhqBl8EbD/52WfRDyGdJAD5nAV/VuFP4HivT7OFsOtPppW3
	 U+W9e9npOSDzH/bXGcl/i8JjC6i5qiey+bfkqaXxKUJ/U82XUpj1pq0hSt8gXK7kSz
	 P138H1eZrV/Dk1YBFNn6nXgdkmy2JBoMYWJ9Esf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 122/150] sched/smt: Introduce sched_smt_present_inc/dec() helper
Date: Mon, 12 Aug 2024 18:03:23 +0200
Message-ID: <20240812160129.871875732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9398,6 +9398,22 @@ static int cpuset_cpu_inactive(unsigned
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
@@ -9409,13 +9425,10 @@ int sched_cpu_activate(unsigned int cpu)
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
@@ -9485,13 +9498,12 @@ int sched_cpu_deactivate(unsigned int cp
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
 


