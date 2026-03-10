Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95C3381AF8;
	Tue, 10 Mar 2026 11:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141267; cv=none; b=oWVgQQ6VvuLfGuai2rW/7H6fTByZBNE4ytujWeO5POYTduW0Wkbi7aPP9wdtwgaCNkg7hy2L9aEvXAcaMrRKvVNwoL0Do7GcTdqDUWm27sYblZF8d7y1TJ5eUFX/li9GUIbj3gOZNb+XloUkLZUWYqmmFTfxjSEXOtf2eRj5C7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141267; c=relaxed/simple;
	bh=A2aAu4mkBaoS6M/2fldEvkHbIj7lXOnV/AQZYRxGZEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM+pfFVnRaZXKAEbQCnLmtS5O9m+7mgOhvT4PmfgZ8NTloIFKBgCde9s79xJhjbu96P9BERfdJM7/nNt3979cluZ1e8hagvqVtLV1HUp/l2FFvLisZ9gjYs80rxf1dq93ecJ94gZTsYAHhRnuY7i7xaaUo9hitzYyJFd8l3XoW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqBnzMe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqBnzMe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C9C2BCAF;
	Tue, 10 Mar 2026 11:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141267;
	bh=A2aAu4mkBaoS6M/2fldEvkHbIj7lXOnV/AQZYRxGZEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqBnzMe8W1E6k4ezdQJuLe9qqAfebcI6+maoXYjJmrO9vPHd+2255XXN0RLHEkrMg
	 my+Ij6DBd38KiOPFFM/EKlA0s9flvRiMlNhipZv9Locj+ib3wfrS4vcHl+F/XeIWNN
	 Gk+GKmiZWj0c8gCC7F1U144l5QbdOSgV2bBJ1S+sAhzh1qmO8jTTOGLGvwwNmWP4Rz
	 qfkG5+rhW5meiynO5HaGX111kpneicAPrE+pmymvNb/wRhMa59A/aI1TKCDK25jxW8
	 ldD9uE0nSdeD7L046LKbjdCM1RfOotncAs8WGxa7pBab0VN7Ibnl9tcrdnLi64bhVW
	 MUH5C0OkSAQhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Ingo Molnar <mingo@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 269/311] x86/topo: Fix SNC topology mess
Date: Tue, 10 Mar 2026 07:05:16 -0400
Message-ID: <f4392565aeb782be61b036251abd5a0c75c35d64.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 528d89a4707e5bfd86e30823c45dbb66877df900 ]

Per 4d6dd05d07d0 ("sched/topology: Fix sched domain build error for GNR, CWF in
SNC-3 mode"), the original crazy SNC-3 SLIT table was:

node distances:
node     0    1    2    3    4    5
    0:   10   15   17   21   28   26
    1:   15   10   15   23   26   23
    2:   17   15   10   26   23   21
    3:   21   28   26   10   15   17
    4:   23   26   23   15   10   15
    5:   26   23   21   17   15   10

And per:

  https://lore.kernel.org/lkml/20250825075642.GQ3245006@noisy.programming.kicks-ass.net/

The suggestion was to average the off-trace clusters to restore sanity.

However, 4d6dd05d07d0 implements this under various assumptions:

 - anything GNR/CWF with numa_in_package;
 - there will never be more than 2 packages;
 - the off-trace cluster will have distance >20

And then HPE shows up with a machine that matches the
Vendor-Family-Model checks but looks like this:

Here's an 8 socket (2 chassis) HPE system with SNC enabled:

node   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
  0:  10  12  16  16  16  16  18  18  40  40  40  40  40  40  40  40
  1:  12  10  16  16  16  16  18  18  40  40  40  40  40  40  40  40
  2:  16  16  10  12  18  18  16  16  40  40  40  40  40  40  40  40
  3:  16  16  12  10  18  18  16  16  40  40  40  40  40  40  40  40
  4:  16  16  18  18  10  12  16  16  40  40  40  40  40  40  40  40
  5:  16  16  18  18  12  10  16  16  40  40  40  40  40  40  40  40
  6:  18  18  16  16  16  16  10  12  40  40  40  40  40  40  40  40
  7:  18  18  16  16  16  16  12  10  40  40  40  40  40  40  40  40
  8:  40  40  40  40  40  40  40  40  10  12  16  16  16  16  18  18
  9:  40  40  40  40  40  40  40  40  12  10  16  16  16  16  18  18
 10:  40  40  40  40  40  40  40  40  16  16  10  12  18  18  16  16
 11:  40  40  40  40  40  40  40  40  16  16  12  10  18  18  16  16
 12:  40  40  40  40  40  40  40  40  16  16  18  18  10  12  16  16
 13:  40  40  40  40  40  40  40  40  16  16  18  18  12  10  16  16
 14:  40  40  40  40  40  40  40  40  18  18  16  16  16  16  10  12
 15:  40  40  40  40  40  40  40  40  18  18  16  16  16  16  12  10

 10 = Same chassis and socket
 12 = Same chassis and socket (SNC)
 16 = Same chassis and adjacent socket
 18 = Same chassis and non-adjacent socket
 40 = Different chassis

Turns out, the 'max 2 packages' thing is only relevant to the SNC-3 parts, the
smaller parts do 8 sockets (like usual). The above SLIT table is sane, but
violates the previous assumptions and trips a WARN.

Now that the topology code has a sensible measure of nodes-per-package, we can
use that to divinate the SNC mode at hand, and only fix up SNC-3 topologies.

There is a 'healthy' amount of paranoia code validating the assumptions on the
SLIT table, a simple pr_err(FW_BUG) print on failure and a fallback to using
the regular table. Lets see how long this lasts :-)

Fixes: 4d6dd05d07d0 ("sched/topology: Fix sched domain build error for GNR, CWF in SNC-3 mode")
Reported-by: Kyle Meyer <kyle.meyer@hpe.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Kyle Meyer <kyle.meyer@hpe.com>
Link: https://patch.msgid.link/20260303110100.238361290@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 190 ++++++++++++++++++++++++++++----------
 1 file changed, 143 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index db3e481cdbb2e..294a8ea602986 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -506,33 +506,149 @@ static void __init build_sched_topology(void)
 }
 
 #ifdef CONFIG_NUMA
-static int sched_avg_remote_distance;
-static int avg_remote_numa_distance(void)
+/*
+ * Test if the on-trace cluster at (N,N) is symmetric.
+ * Uses upper triangle iteration to avoid obvious duplicates.
+ */
+static bool slit_cluster_symmetric(int N)
 {
-	int i, j;
-	int distance, nr_remote, total_distance;
-
-	if (sched_avg_remote_distance > 0)
-		return sched_avg_remote_distance;
-
-	nr_remote = 0;
-	total_distance = 0;
-	for_each_node_state(i, N_CPU) {
-		for_each_node_state(j, N_CPU) {
-			distance = node_distance(i, j);
-
-			if (distance >= REMOTE_DISTANCE) {
-				nr_remote++;
-				total_distance += distance;
-			}
+	int u = topology_num_nodes_per_package();
+
+	for (int k = 0; k < u; k++) {
+		for (int l = k; l < u; l++) {
+			if (node_distance(N + k, N + l) !=
+			    node_distance(N + l, N + k))
+				return false;
 		}
 	}
-	if (nr_remote)
-		sched_avg_remote_distance = total_distance / nr_remote;
-	else
-		sched_avg_remote_distance = REMOTE_DISTANCE;
 
-	return sched_avg_remote_distance;
+	return true;
+}
+
+/*
+ * Return the package-id of the cluster, or ~0 if indeterminate.
+ * Each node in the on-trace cluster should have the same package-id.
+ */
+static u32 slit_cluster_package(int N)
+{
+	int u = topology_num_nodes_per_package();
+	u32 pkg_id = ~0;
+
+	for (int n = 0; n < u; n++) {
+		const struct cpumask *cpus = cpumask_of_node(N + n);
+		int cpu;
+
+		for_each_cpu(cpu, cpus) {
+			u32 id = topology_logical_package_id(cpu);
+
+			if (pkg_id == ~0)
+				pkg_id = id;
+			if (pkg_id != id)
+				return ~0;
+		}
+	}
+
+	return pkg_id;
+}
+
+/*
+ * Validate the SLIT table is of the form expected for SNC, specifically:
+ *
+ *  - each on-trace cluster should be symmetric,
+ *  - each on-trace cluster should have a unique package-id.
+ *
+ * If you NUMA_EMU on top of SNC, you get to keep the pieces.
+ */
+static bool slit_validate(void)
+{
+	int u = topology_num_nodes_per_package();
+	u32 pkg_id, prev_pkg_id = ~0;
+
+	for (int pkg = 0; pkg < topology_max_packages(); pkg++) {
+		int n = pkg * u;
+
+		/*
+		 * Ensure the on-trace cluster is symmetric and each cluster
+		 * has a different package id.
+		 */
+		if (!slit_cluster_symmetric(n))
+			return false;
+		pkg_id = slit_cluster_package(n);
+		if (pkg_id == ~0)
+			return false;
+		if (pkg && pkg_id == prev_pkg_id)
+			return false;
+
+		prev_pkg_id = pkg_id;
+	}
+
+	return true;
+}
+
+/*
+ * Compute a sanitized SLIT table for SNC; notably SNC-3 can end up with
+ * asymmetric off-trace clusters, reflecting physical assymmetries. However
+ * this leads to 'unfortunate' sched_domain configurations.
+ *
+ * For example dual socket GNR with SNC-3:
+ *
+ * node distances:
+ * node     0    1    2    3    4    5
+ *     0:   10   15   17   21   28   26
+ *     1:   15   10   15   23   26   23
+ *     2:   17   15   10   26   23   21
+ *     3:   21   28   26   10   15   17
+ *     4:   23   26   23   15   10   15
+ *     5:   26   23   21   17   15   10
+ *
+ * Fix things up by averaging out the off-trace clusters; resulting in:
+ *
+ * node     0    1    2    3    4    5
+ *     0:   10   15   17   24   24   24
+ *     1:   15   10   15   24   24   24
+ *     2:   17   15   10   24   24   24
+ *     3:   24   24   24   10   15   17
+ *     4:   24   24   24   15   10   15
+ *     5:   24   24   24   17   15   10
+ */
+static int slit_cluster_distance(int i, int j)
+{
+	static int slit_valid = -1;
+	int u = topology_num_nodes_per_package();
+	long d = 0;
+	int x, y;
+
+	if (slit_valid < 0) {
+		slit_valid = slit_validate();
+		if (!slit_valid)
+			pr_err(FW_BUG "SLIT table doesn't have the expected form for SNC -- fixup disabled!\n");
+		else
+			pr_info("Fixing up SNC SLIT table.\n");
+	}
+
+	/*
+	 * Is this a unit cluster on the trace?
+	 */
+	if ((i / u) == (j / u) || !slit_valid)
+		return node_distance(i, j);
+
+	/*
+	 * Off-trace cluster.
+	 *
+	 * Notably average out the symmetric pair of off-trace clusters to
+	 * ensure the resulting SLIT table is symmetric.
+	 */
+	x = i - (i % u);
+	y = j - (j % u);
+
+	for (i = x; i < x + u; i++) {
+		for (j = y; j < y + u; j++) {
+			d += node_distance(i, j);
+			d += node_distance(j, i);
+		}
+	}
+
+	return d / (2*u*u);
 }
 
 int arch_sched_node_distance(int from, int to)
@@ -542,34 +658,14 @@ int arch_sched_node_distance(int from, int to)
 	switch (boot_cpu_data.x86_vfm) {
 	case INTEL_GRANITERAPIDS_X:
 	case INTEL_ATOM_DARKMONT_X:
-
-		if (topology_max_packages() == 1 || topology_num_nodes_per_package() == 1 ||
-		    d < REMOTE_DISTANCE)
+		if (topology_max_packages() == 1 ||
+		    topology_num_nodes_per_package() < 3)
 			return d;
 
 		/*
-		 * With SNC enabled, there could be too many levels of remote
-		 * NUMA node distances, creating NUMA domain levels
-		 * including local nodes and partial remote nodes.
-		 *
-		 * Trim finer distance tuning for NUMA nodes in remote package
-		 * for the purpose of building sched domains. Group NUMA nodes
-		 * in the remote package in the same sched group.
-		 * Simplify NUMA domains and avoid extra NUMA levels including
-		 * different remote NUMA nodes and local nodes.
-		 *
-		 * GNR and CWF don't expect systems with more than 2 packages
-		 * and more than 2 hops between packages. Single average remote
-		 * distance won't be appropriate if there are more than 2
-		 * packages as average distance to different remote packages
-		 * could be different.
+		 * Handle SNC-3 asymmetries.
 		 */
-		WARN_ONCE(topology_max_packages() > 2,
-			  "sched: Expect only up to 2 packages for GNR or CWF, "
-			  "but saw %d packages when building sched domains.",
-			  topology_max_packages());
-
-		d = avg_remote_numa_distance();
+		return slit_cluster_distance(from, to);
 	}
 	return d;
 }
-- 
2.51.0

