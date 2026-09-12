Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA237204A;
	Sat, 12 Sep 2026 07:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197126; cv=none; b=HZP+49tnAboc22R3CPGckCEEuizIYixsM1OfstvVGCGsS46NiDN8Fh0u0KO3JmAIBjU6QRKgAZzLqkPPH0A7MV2lFwI9i5zZBrwfQJugw0NhvqDpF+/uXoEzqtdWdAFt9684m5dqyPht0UKC12pDLn2HDpy2ZQBmDGP8aPsCJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197126; c=relaxed/simple;
	bh=h1HqXgi630z/AG81SgFPJ/ToA7HPmOxBFu0nMNnHsdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OczMozQIcfinxvv3G0Da37zXA3fAZGSrBmDDtbXS5krsHTm9Qx7q8VJSqrSN27iplJLTl1UO/kzbHh+Va4fyTzOevU6XI7R/6r5Aoi+5Q+IwJoTN3d4R2CYuEw4qGe8vW9VHe4J8OVTwyv3+dINQ6eSZ0j6JaMjEJt267LkWkeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTnezChE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTnezChE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE201F000FF;
	Sat, 12 Sep 2026 07:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197125;
	bh=+a1B5M5JfrRlf0djVR/IuK0uXTc/E69fSlMLduXND2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTnezChEky7evSaAbpa7EAYzMwaAb1n011JUgdkGT7Efv5Y/aqAmyCRykCPNi8Ne5
	 o8/vcvk4wshFAE8hSbMGNy4vP0gTx+rb3qOGjmCpp+8Y/S5gNoI9Za4ygzKtBUq1yt
	 t0QxXsSeXswxHo6tFywAbXw4Z9cKTLgY0RHZMgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0107/1815] perf/x86/intel/uncore: Introduce PMU flags and broken state
Date: Sat, 12 Sep 2026 08:30:57 +0200
Message-ID: <20260912065651.518615797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 30c0a1095652275768a5de67188ff888d1f5d190 ]

Replace the boolean 'registered' field in intel_uncore_pmu with an
unsigned long 'flags' field, and add a PMU_BROKEN flag to track box
setup failures. The broken flag is sticky, meaning it is cleared only
by a module reload or system reboot.

Broken PMUs are skipped in the CPU hotplug and box allocation paths.

When any box fails to initialize, the PMU is marked broken.  Broken
PMUs reject new event assignments and skip future box setup attempts.
If the PMU was already registered, it remains so to avoid disrupting
in-flight events on other boxes.

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-7-zide.chen@intel.com
Stable-dep-of: 174f0582e38a ("perf/x86/intel/uncore: Fix uncore_box ref/unref ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c     | 44 ++++++++++++++++++++++--------
 arch/x86/events/intel/uncore.h     | 13 ++++++++-
 arch/x86/events/intel/uncore_snb.c |  2 +-
 3 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 06ef89f6ccc28..feb8c3b0076b2 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -757,7 +757,7 @@ static int uncore_pmu_event_init(struct perf_event *event)
 
 	pmu = uncore_event_to_pmu(event);
 	/* no device found for this pmu */
-	if (!pmu->registered)
+	if (!uncore_pmu_available(pmu))
 		return -ENOENT;
 
 	/* Sampling not supported yet */
@@ -953,16 +953,18 @@ static int uncore_pmu_register(struct intel_uncore_pmu *pmu)
 
 	ret = perf_pmu_register(&pmu->pmu, pmu->name, -1);
 	if (!ret)
-		pmu->registered = true;
+		uncore_pmu_set_registered(pmu);
 	return ret;
 }
 
 static void uncore_pmu_unregister(struct intel_uncore_pmu *pmu)
 {
-	if (!pmu->registered)
+	if (!uncore_pmu_registered(pmu))
 		return;
 	perf_pmu_unregister(&pmu->pmu);
-	pmu->registered = false;
+
+	/* Keep PMU_BROKEN_BIT sticky. */
+	uncore_pmu_clear_registered(pmu);
 }
 
 static void uncore_free_boxes(struct intel_uncore_pmu *pmu)
@@ -1153,7 +1155,12 @@ static int uncore_box_setup(struct intel_uncore_pmu *pmu,
 {
 	int ret;
 
-	uncore_box_init(box);
+	if (uncore_pmu_broken(pmu))
+		return -ENODEV;
+
+	ret = uncore_box_init(box);
+	if (ret)
+		goto err;
 
 	/* First active box registers the pmu. */
 	if (atomic_inc_return(&pmu->activeboxes) > 1)
@@ -1167,6 +1174,16 @@ static int uncore_box_setup(struct intel_uncore_pmu *pmu,
 
 	return 0;
 err:
+	/*
+	 * If any box fails, mark the per-package PMU as broken regardless of
+	 * whether it was registered or not.
+	 *
+	 * Don't decrement refcnt to avoid other in-die CPUs from trying to set
+	 * up the PMU box again.
+	 *
+	 * Don't kfree box; MSR and MMIO boxes are freed at module exit only.
+	 */
+	uncore_pmu_set_broken(pmu);
 	uncore_box_exit(box);
 	return ret;
 }
@@ -1190,8 +1207,10 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 		return -EINVAL;
 
 	box = uncore_alloc_box(type, NUMA_NO_NODE);
-	if (!box)
+	if (!box) {
+		uncore_pmu_set_broken(pmu);
 		return -ENOMEM;
+	}
 
 	atomic_inc(&box->refcnt);
 	box->dieid = die;
@@ -1507,7 +1526,8 @@ static void uncore_change_type_ctx(struct intel_uncore_type *type, int old_cpu,
 
 		if (old_cpu < 0) {
 			WARN_ON_ONCE(box->cpu != -1);
-			if (uncore_die_has_box(type, die, pmu->pmu_idx)) {
+			if (uncore_die_has_box(type, die, pmu->pmu_idx) &&
+			    !uncore_pmu_broken(pmu)) {
 				box->cpu = new_cpu;
 				cpumask_set_cpu(new_cpu, &pmu->cpu_mask);
 			}
@@ -1515,12 +1535,14 @@ static void uncore_change_type_ctx(struct intel_uncore_type *type, int old_cpu,
 		}
 
 		WARN_ON_ONCE(box->cpu != -1 && box->cpu != old_cpu);
-		box->cpu = -1;
 		cpumask_clear_cpu(old_cpu, &pmu->cpu_mask);
-		if (new_cpu < 0)
+		if (new_cpu < 0) {
+			box->cpu = -1;
 			continue;
+		}
 
-		if (!uncore_die_has_box(type, die, pmu->pmu_idx))
+		/* An inactive box doesn't need migration. */
+		if (box->cpu == -1)
 			continue;
 		uncore_pmu_cancel_hrtimer(box);
 		perf_pmu_migrate_context(&pmu->pmu, old_cpu, new_cpu);
@@ -1596,7 +1618,7 @@ static int allocate_boxes(struct intel_uncore_type **types,
 		type = *types;
 		pmu = type->pmus;
 		for (i = 0; i < type->num_boxes; i++, pmu++) {
-			if (pmu->boxes[die])
+			if (pmu->boxes[die] || uncore_pmu_broken(pmu))
 				continue;
 			box = uncore_alloc_box(type, cpu_to_node(cpu));
 			if (!box)
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index d732b87be0a95..0adb477d97086 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -146,13 +146,24 @@ struct intel_uncore_pmu {
 	struct pmu			pmu;
 	char				name[UNCORE_PMU_NAME_LEN];
 	int				pmu_idx;
-	bool				registered;
+	unsigned long			flags;
 	atomic_t			activeboxes;
 	cpumask_t			cpu_mask;
 	struct intel_uncore_type	*type;
 	struct intel_uncore_box		**boxes;
 };
 
+#define PMU_REGISTERED_BIT	0
+#define PMU_BROKEN_BIT		1
+
+#define uncore_pmu_registered(pmu)	test_bit(PMU_REGISTERED_BIT, &(pmu)->flags)
+#define uncore_pmu_broken(pmu)		test_bit(PMU_BROKEN_BIT, &(pmu)->flags)
+#define uncore_pmu_available(pmu)	(uncore_pmu_registered(pmu) &&  \
+					 !uncore_pmu_broken(pmu))
+#define uncore_pmu_set_registered(pmu)	set_bit(PMU_REGISTERED_BIT, &(pmu)->flags)
+#define uncore_pmu_set_broken(pmu)	set_bit(PMU_BROKEN_BIT, &(pmu)->flags)
+#define uncore_pmu_clear_registered(pmu) clear_bit(PMU_REGISTERED_BIT, &(pmu)->flags)
+
 struct intel_uncore_extra_reg {
 	raw_spinlock_t lock;
 	u64 config, config1, config2;
diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index c5347920541c7..055131c508ffa 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -940,7 +940,7 @@ static int snb_uncore_imc_event_init(struct perf_event *event)
 
 	pmu = uncore_event_to_pmu(event);
 	/* no device found for this pmu */
-	if (!pmu->registered)
+	if (!uncore_pmu_available(pmu))
 		return -ENOENT;
 
 	/* Sampling not supported yet */
-- 
2.53.0



