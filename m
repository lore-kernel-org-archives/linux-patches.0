Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B190367B76;
	Wed, 20 May 2026 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296747; cv=none; b=RhiynEtC/c15bZLNUpuzNUc1RM+074oP1WsFzVpIf5xHM9f9RHlhtW3vtTagd+3EHEiv+KbWf/tuM5ooi7MCRzTdmI+vYI3wj9Ya5XqtLl/cilc0qgTbkft0carfGzj/PP43l5CyphmWdSs7g8p4pQn1Ws8dAXxq4579UGi8sKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296747; c=relaxed/simple;
	bh=mbSXlRc68uxQnzG9cn6CMjEwRg9UdgTSH1pKz0iUWmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw9UGvqgyjtG0TkxvS9wQIUyzAMdCIQAKXFMY2eBYrEox+l9iSMMYHmzV745ygZmR3LwlaK2mphKUEUxaeYuqJ9xY2tfoLZd/afHmtYW9/ietVEvuPouMCudNGIX3MVgaZt7SopIKHsz8zhmUXDGU4sncRDMt6TMLTxZj8jOH9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6eCJoDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6eCJoDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815831F000E9;
	Wed, 20 May 2026 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296746;
	bh=JqaI8SsO3QV0gig/e/MefKjaJ+MIcwZGgucjJDcymYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6eCJoDjL1f/pWnD6Arx1Ilq2GVsDmZw2Qt5K7aeCtsQi7ZnLtmocPXDCeZvvUHH6
	 bofz72DZ8NVZ5KelabeTXguA/luabfavKn8Wgci6gNpCnv6mt8sAQG3tyBfisHit4v
	 ms5GY8K5yOj/4RCHKu+QUzjYNrmeRd1mdhrLUdVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0875/1146] tools/power turbostat: Fix --cpu-set 1 regression on HT systems
Date: Wed, 20 May 2026 18:18:45 +0200
Message-ID: <20260520162208.041731433@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit 08e11edd0e63b72651ed5eb9142430d1ca764923 ]

When the "--cpu-set" option limits turbostat to run on
a higher numbered HT sibling, it exits upon dividing by zero.

This is because the HT support handles higher numbered siblings
at the same time as lower numbered siblings.  But when that lower
number sibling is dis-allowed, the higher numbered sibling is
never processed.  The result is a time delta of 0, which results
in a divide by 0 for any of the "per-second" metrics.

Enhance the HT enumeration code to record all siblings (up to SMT4).
Consult this complete HT sibling list to determine when
to process an HT sibling, and when to skip it.

Fixes: a2b4d0f8bf07 ("tools/power turbostat: Favor cpu# over core#")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 70 +++++++++++++++++++++------
 1 file changed, 55 insertions(+), 15 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 7f61f07ceb314..e609272ed80b5 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2449,6 +2449,22 @@ int cpu_is_not_allowed(int cpu)
 
 #define PER_THREAD_PARAMS  struct thread_data *t, struct core_data *c, struct pkg_data *p
 
+int has_allowed_lower_ht_sibling(int cpu)
+{
+	int i;
+
+	for (i = 0; i <= cpus[cpu].ht_id; ++i) {
+		int sibling_cpu_id = cpus[cpu].ht_sibling_cpu_id[i];
+
+		if (sibling_cpu_id == cpu)
+			return 0;
+
+		if (!cpu_is_not_allowed(sibling_cpu_id))
+			return 1;
+	}
+	return 0;
+}
+
 int for_all_cpus(int (func) (struct thread_data *, struct core_data *, struct pkg_data *),
 		 struct thread_data *thread_base, struct core_data *core_base, struct pkg_data *pkg_base)
 {
@@ -2466,7 +2482,7 @@ int for_all_cpus(int (func) (struct thread_data *, struct core_data *, struct pk
 		if (cpu_is_not_allowed(cpu))
 			continue;
 
-		if (cpus[cpu].ht_id > 0)	/* skip HT sibling */
+		if (has_allowed_lower_ht_sibling(cpu))	/* skip HT sibling */
 			continue;
 
 		t = &thread_base[cpu];
@@ -2475,12 +2491,18 @@ int for_all_cpus(int (func) (struct thread_data *, struct core_data *, struct pk
 
 		retval |= func(t, c, p);
 
-		/* Handle HT sibling now */
+		/* Handle other HT siblings now */
 		int i;
 
-		for (i = MAX_HT_ID; i > 0; --i) {	/* ht_id 0 is self */
+		for (i = 0; i <= MAX_HT_ID; ++i) {
 			int sibling_cpu_id = cpus[cpu].ht_sibling_cpu_id[i];
 
+			if (sibling_cpu_id < 0)
+				break;
+
+			if (sibling_cpu_id == cpu)
+				continue;
+
 			if (cpu_is_not_allowed(sibling_cpu_id))
 				continue;
 
@@ -6178,11 +6200,11 @@ int set_thread_siblings(struct cpu_topology *thiscpu)
 	int cpu = thiscpu->cpu_id;
 	int offset = topo.max_cpu_num + 1;
 	size_t size;
-	int thread_id = 0;
+	int ht_id = 0;
 
 	thiscpu->put_ids = CPU_ALLOC((topo.max_cpu_num + 1));
 	if (thiscpu->ht_id < 0)
-		thiscpu->ht_id = thread_id++;
+		thiscpu->ht_id = 0;	/* first CPU in core */
 	if (!thiscpu->put_ids)
 		return -1;
 
@@ -6206,13 +6228,9 @@ int set_thread_siblings(struct cpu_topology *thiscpu)
 				sib_core = get_core_id(so);
 				if (sib_core == thiscpu->core_id) {
 					CPU_SET_S(so, size, thiscpu->put_ids);
-					if ((so != cpu) && (cpus[so].ht_id < 0)) {
-						cpus[so].ht_id = thread_id;
-						cpus[cpu].ht_sibling_cpu_id[thread_id] = so;
-						if (debug)
-							fprintf(stderr, "%s: cpu%d.ht_sibling_cpu_id[%d] = %d\n", __func__, cpu, thread_id, so);
-						thread_id += 1;
-					}
+					cpus[so].ht_id = ht_id;
+					cpus[cpu].ht_sibling_cpu_id[ht_id] = so;
+					ht_id += 1;
 				}
 			}
 		}
@@ -6245,7 +6263,7 @@ int for_all_cpus_2(int (func) (struct thread_data *, struct core_data *,
 		if (cpu_is_not_allowed(cpu))
 			continue;
 
-		if (cpus[cpu].ht_id > 0)	/* skip HT sibling */
+		if (has_allowed_lower_ht_sibling(cpu))	/* skip HT sibling */
 			continue;
 
 		t = &thread_base[cpu];
@@ -6260,9 +6278,15 @@ int for_all_cpus_2(int (func) (struct thread_data *, struct core_data *,
 		/* Handle HT sibling now */
 		int i;
 
-		for (i = MAX_HT_ID; i > 0; --i) {	/* ht_id 0 is self */
+		for (i = 0; i <= MAX_HT_ID; ++i) {
 			int sibling_cpu_id = cpus[cpu].ht_sibling_cpu_id[i];
 
+			if (sibling_cpu_id < 0)
+				break;
+
+			if (sibling_cpu_id == cpu)
+				continue;
+
 			if (cpu_is_not_allowed(sibling_cpu_id))
 				continue;
 
@@ -9517,6 +9541,8 @@ void topology_probe(bool startup)
 	cpu_present_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
 	CPU_ZERO_S(cpu_present_setsize, cpu_present_set);
 	for_all_proc_cpus(mark_cpu_present);
+	if (debug)
+		print_cpu_set("present set", cpu_present_set);
 
 	/*
 	 * Allocate and initialize cpu_possible_set
@@ -9527,6 +9553,8 @@ void topology_probe(bool startup)
 	cpu_possible_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
 	CPU_ZERO_S(cpu_possible_setsize, cpu_possible_set);
 	initialize_cpu_set_from_sysfs(cpu_possible_set, "/sys/devices/system/cpu", "possible");
+	if (debug)
+		print_cpu_set("possible set", cpu_possible_set);
 
 	/*
 	 * Allocate and initialize cpu_effective_set
@@ -9537,6 +9565,8 @@ void topology_probe(bool startup)
 	cpu_effective_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
 	CPU_ZERO_S(cpu_effective_setsize, cpu_effective_set);
 	update_effective_set(startup);
+	if (debug)
+		print_cpu_set("effective set", cpu_effective_set);
 
 	/*
 	 * Allocate and initialize cpu_allowed_set
@@ -9580,6 +9610,8 @@ void topology_probe(bool startup)
 
 		CPU_SET_S(i, cpu_allowed_setsize, cpu_allowed_set);
 	}
+	if (debug)
+		print_cpu_set("allowed set", cpu_allowed_set);
 
 	if (!CPU_COUNT_S(cpu_allowed_setsize, cpu_allowed_set))
 		err(-ENODEV, "No valid cpus found");
@@ -9683,12 +9715,18 @@ void topology_probe(bool startup)
 		return;
 
 	for (i = 0; i <= topo.max_cpu_num; ++i) {
+		int ht_id;
+
 		if (cpu_is_not_present(i))
 			continue;
 		fprintf(outf,
-			"cpu %d pkg %d die %d l3 %d node %d lnode %d core %d thread %d\n",
+			"cpu %d pkg %d die %d l3 %d node %d lnode %d core %d ht_id %d",
 			i, cpus[i].package_id, cpus[i].die_id, cpus[i].l3_id,
 			cpus[i].physical_node_id, cpus[i].logical_node_id, cpus[i].core_id, cpus[i].ht_id);
+		fprintf(outf, " siblings");
+		for (ht_id = 0; ht_id <= MAX_HT_ID; ++ht_id)
+			fprintf(outf, " %d", cpus[i].ht_sibling_cpu_id[ht_id]);
+		fprintf(outf, "\n");
 	}
 
 }
@@ -9829,6 +9867,8 @@ void topology_update(void)
 	topo.allowed_cores = 0;
 	topo.allowed_packages = 0;
 	for_all_cpus(update_topo, ODD_COUNTERS);
+	if (debug)
+		fprintf(stderr, "allowed_cpus %d allowed_cores %d allowed_packages %d\n", topo.allowed_cpus, topo.allowed_cores, topo.allowed_packages);
 }
 
 void setup_all_buffers(bool startup)
-- 
2.53.0



