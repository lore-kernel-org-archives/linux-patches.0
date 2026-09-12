Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6BB39448F;
	Sat, 12 Sep 2026 07:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197131; cv=none; b=X2GtrcLjgHIg8Ag8YPxfMD7IjgJ7Ql/3aZlzZ3QxLs77+uYxSEenfgxVTP+y/fQ9ii1OGmniaioo6XH3qet9y21bR0faeDOTq525mdyjheIuLkOwCrV6j9jIB4dwhxfm5dCuGhJMgWrI5kw8rWXo15Y9PU35F4zh65Nt00MaEFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197131; c=relaxed/simple;
	bh=2fpKPkL3iP3I1ABTNQVaBumtZyZZMgYVfkQ3OGpdbWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy8puZ6UDKv7UCRo74ReG6r86W2yvPhCteULULaVf7Jc0ODE1yNuf6Oq/TuNhF47ovS04N+VCp0vjD83tFhFnOd64GeZpgsG/sYd5UKtJ/il2jeVGGeU2JSptLbOEKmRk5Ft4Sw4B4CYZjdQ+XyeWbFJ3d4wTXbhj5PHv5Z0Kig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvzueA7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvzueA7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135101F000FF;
	Sat, 12 Sep 2026 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197130;
	bh=SYnqS42avlp5p9f+VnuO+WNv9cwVfjIuGyP9bfPUZ1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvzueA7zuStxIO6lEofXg8zJwz7jKftNVxgwy3UFzL8mskbnbCyf6pv1NX/9BPRfe
	 TH9rJjNIEjCOUHIAPvxy2WIVt4l+CoMOdDqV9Oo0nSeS2pPu8h/kYe6VD0oowcF1T9
	 /7VDZCpzEnIWfs69HJbTGUgBgaGJVZq8hWjtSrJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0108/1815] perf/x86/intel/uncore: Fix uncore_box ref/unref ordering
Date: Sat, 12 Sep 2026 08:30:58 +0200
Message-ID: <20260912065651.541798965@linuxfoundation.org>
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

[ Upstream commit 174f0582e38abe03b88e15f04bfe58490f88cb19 ]

In uncore_event_cpu_online(), uncore_box_ref() was called before
uncore_change_context().  uncore_box_ref() gates on box->cpu >= 0,
but box->cpu is still -1 at that point because uncore_change_context()
has not run yet.  As a result, the box is never initialized on the
first CPU to come online in a die, leaving it permanently
uninitialized in the single-CPU-per-die case.

Thus, box->refcnt is one count below the true value, and in the CPU
offline path, the box will be torn down on the second-to-last CPU.

In uncore_event_cpu_offline(), uncore_box_unref() was called after
uncore_change_context(), so box->cpu is already -1 when the collector
CPU goes offline, which prevents it from tearing down the box.

Fix by swapping the call order in both paths so that
uncore_box_{ref,unref}() runs at the point where box->cpu reflects
the correct context.

Move allocate_boxes() out of uncore_box_ref() to enable this
reordering.

Fixes: c74443d92f68 ("perf/x86/uncore: Support per PMU cpumask")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-8-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 50 ++++++++++++++++------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index feb8c3b0076b2..b9ac2f7d31caa 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1580,9 +1580,15 @@ static int uncore_event_cpu_offline(unsigned int cpu)
 {
 	int die, target;
 
+	/* Clear the references */
+	die = topology_logical_die_id(cpu);
+	uncore_box_unref(uncore_msr_uncores, die);
+	uncore_box_unref(uncore_mmio_uncores, die);
+
 	/* Check if exiting cpu is used for collecting uncore events */
 	if (!cpumask_test_and_clear_cpu(cpu, &uncore_cpu_mask))
-		goto unref;
+		return 0;
+
 	/* Find a new cpu to collect uncore events */
 	target = cpumask_any_but(topology_die_cpumask(cpu), cpu);
 
@@ -1595,16 +1601,10 @@ static int uncore_event_cpu_offline(unsigned int cpu)
 	uncore_change_context(uncore_msr_uncores, cpu, target);
 	uncore_change_context(uncore_mmio_uncores, cpu, target);
 	uncore_change_context(uncore_pci_uncores, cpu, target);
-
-unref:
-	/* Clear the references */
-	die = topology_logical_die_id(cpu);
-	uncore_box_unref(uncore_msr_uncores, die);
-	uncore_box_unref(uncore_mmio_uncores, die);
 	return 0;
 }
 
-static int allocate_boxes(struct intel_uncore_type **types,
+static void allocate_boxes(struct intel_uncore_type **types,
 			 unsigned int die, unsigned int cpu)
 {
 	struct intel_uncore_box *box, *tmp;
@@ -1621,8 +1621,10 @@ static int allocate_boxes(struct intel_uncore_type **types,
 			if (pmu->boxes[die] || uncore_pmu_broken(pmu))
 				continue;
 			box = uncore_alloc_box(type, cpu_to_node(cpu));
-			if (!box)
+			if (!box) {
+				uncore_pmu_set_broken(pmu);
 				goto cleanup;
+			}
 			box->pmu = pmu;
 			box->dieid = die;
 			list_add(&box->active_list, &allocated);
@@ -1633,14 +1635,13 @@ static int allocate_boxes(struct intel_uncore_type **types,
 		list_del_init(&box->active_list);
 		box->pmu->boxes[die] = box;
 	}
-	return 0;
+	return;
 
 cleanup:
 	list_for_each_entry_safe(box, tmp, &allocated, active_list) {
 		list_del_init(&box->active_list);
 		kfree(box);
 	}
-	return -ENOMEM;
 }
 
 static int uncore_box_ref(struct intel_uncore_type **types,
@@ -1649,11 +1650,7 @@ static int uncore_box_ref(struct intel_uncore_type **types,
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, ret;
-
-	ret = allocate_boxes(types, die, cpu);
-	if (ret)
-		return ret;
+	int i;
 
 	for (; *types; types++) {
 		type = *types;
@@ -1669,27 +1666,26 @@ static int uncore_box_ref(struct intel_uncore_type **types,
 
 static int uncore_event_cpu_online(unsigned int cpu)
 {
-	int die, target, msr_ret, mmio_ret;
+	int die, target;
 
 	die = topology_logical_die_id(cpu);
-	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
-	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
+	allocate_boxes(uncore_msr_uncores, die, cpu);
+	allocate_boxes(uncore_mmio_uncores, die, cpu);
 
 	/*
 	 * Check if there is an online cpu in the package
 	 * which collects uncore events already.
 	 */
 	target = cpumask_any_and(&uncore_cpu_mask, topology_die_cpumask(cpu));
-	if (target < nr_cpu_ids)
-		return 0;
-
-	cpumask_set_cpu(cpu, &uncore_cpu_mask);
-
-	if (!msr_ret)
+	if (target >= nr_cpu_ids) {
+		cpumask_set_cpu(cpu, &uncore_cpu_mask);
 		uncore_change_context(uncore_msr_uncores, -1, cpu);
-	if (!mmio_ret)
 		uncore_change_context(uncore_mmio_uncores, -1, cpu);
-	uncore_change_context(uncore_pci_uncores, -1, cpu);
+		uncore_change_context(uncore_pci_uncores, -1, cpu);
+	}
+
+	uncore_box_ref(uncore_msr_uncores, die, cpu);
+	uncore_box_ref(uncore_mmio_uncores, die, cpu);
 	return 0;
 }
 
-- 
2.53.0



