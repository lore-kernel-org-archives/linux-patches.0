Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B293AEB29;
	Sat, 17 Oct 2026 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255559; cv=none; b=tRicQL8hp8eojcQSn3KqezHybvYzByZ/7NUpLxtOsgTPR3xGO6UGWbg29cGLJVoxo4Wf5aWXsjd8WgrP6RIY9Xtiy5OZ7Xq7ZBB8HJHCkehvoa3e7Qsr0k53005hD7QE6ZPLtv54BusS8rh7paIhbXFNLj02n5buZEyL/9lZbq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255559; c=relaxed/simple;
	bh=nMp1Ajigw+fP5WiQ+o85SIi6l/YaR3jZJ66JtPudCU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osgyEBNgqqxPDDHtLVR5mujx8XUxaPD9h4+1ZXfEvvz5uL/zGQ/nbVrs1Un57gYgdqh+uBwaWAZxutPypYTvgZHOcZeoB+tvtsLb2Mn2pRB97GhMT9xZKVdpwhzfM4moZYn4rKNi8+ECipyZTqUl6A05FgvrBA3nbHDfR6Lj+bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa+EBAvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa+EBAvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D71F000C6;
	Sat, 17 Oct 2026 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255558;
	bh=Dkej6Y2XIulXsm3FaY/O4RQAKLDeRAfvCsqKa3UbXgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sa+EBAvwtA85V5wqDRX/uTNe3SzwqzKkU/1ucK0/Ow1endV9gDkdCmlD6GQhUXw79
	 rW7stjYyxDEUg0A56KUEeBHjnuf0ZkFtI8vsF/lVSBhDikixV81crZDLoWYTmVO1Bb
	 M9htQCix7f7QAMR+TT3/QXn1IOXh1IZK8Tn3BEwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 816/869] perf/x86/intel/uncore: Fix uncore_box ref/unref ordering
Date: Sat, 17 Oct 2026 18:00:57 +0200
Message-ID: <20261017160057.811105650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/events/intel/uncore.c | 46 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 2736815e651c7..2cc80848e3188 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1535,9 +1535,15 @@ static int uncore_event_cpu_offline(unsigned int cpu)
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
 
@@ -1550,16 +1556,10 @@ static int uncore_event_cpu_offline(unsigned int cpu)
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
@@ -1588,14 +1588,13 @@ static int allocate_boxes(struct intel_uncore_type **types,
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
@@ -1604,11 +1603,7 @@ static int uncore_box_ref(struct intel_uncore_type **types,
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
 	struct intel_uncore_box *box;
-	int i, ret;
-
-	ret = allocate_boxes(types, id, cpu);
-	if (ret)
-		return ret;
+	int i;
 
 	for (; *types; types++) {
 		type = *types;
@@ -1624,27 +1619,26 @@ static int uncore_box_ref(struct intel_uncore_type **types,
 
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



