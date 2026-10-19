Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A323514753;
	Mon, 19 Oct 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418107; cv=none; b=VlkHXPiTfjXRUQ+fJowRWL6kCpCE9p161z+rBir31pvSVfJRqJlNouDlPPHfBQZitCOCCtFpZLoZuTFY/GO5pZI7TPdSQMvdJPWxV9wYBPMx9b7jmZ2LJZK4RWmegKjE2ZGbd6VU60O1asLkSQxeVgM4HxutTtXlx2Q0aUPbk1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418107; c=relaxed/simple;
	bh=jXlyxxQFxfUqX6pnvaWYF38tE6OgTm28TgmzDMre1GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kc7mLGGevxOaEQFg8NmCm6uhg2WHwO1+HZL3PQAmhLMmfU1Kpd0RDVxpRaAREsXKGRbd9TxmCbojihWPQyxdzyEPDGNCGbxPg4B+9tIPndnejS/K7PP9rFezC1FBxzeVX02a2ExLqwwe/OqjcHMMsgLlO+OKiD6S/4ZFZpfUAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGFRHV8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGFRHV8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25251F000CA;
	Mon, 19 Oct 2026 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418105;
	bh=JqlXyvFuSdHOxo0/HGsAnTDVAoVmT6DZMuonjjOohJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGFRHV8dNIxkoJ9H/PyGPhaAEiO6sW0aKH+iVRcfYGCOPUkIXbr9haONkuLTfY4jb
	 QHFBIn1yZx94Ik25qhtmFg2wX6VdRhKvGrDa8ENVn34VFgLeBMnU/dUA3XGV+yYcd/
	 ZpNCOnBLCLvf2sMNxV2pT+XSEDLea6NqKmd0cJV1uBUqGqX8xWCkm+1TTG3p8rM5YI
	 rynt9Pet5wfWu8XDNo6zh2s+imKmRWJOgrWCOQD3Yc6OHLNMQGYZYnU7gko35oHRFG
	 3zBi9C+/rUmzSG44X1MtLPyp0w6gaDxIinxxYfsgO8t2wbpM2qotzbgI2YO0evzY4X
	 vJDz66DkNkCmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Feng Tang <feng.tang@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	shuah@kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] selftests: net: reuseport_bpf_numa: consider cpuless numa node
Date: Mon, 19 Oct 2026 09:45:06 -0400
Message-ID: <20261019135441.1420968-15-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Feng Tang <feng.tang@linux.alibaba.com>

[ Upstream commit 88b8d85e889e2fe1cce3e66e50c3029dda94842a ]

reuseport_bpf_numa case failed when testing on a platform with CXL
memory:

    #./reuseport_bpf_numa
    ---- IPv4 UDP ----
    send node 0, receive socket 0
    ./reuseport_bpf_numa: failed to pin to node: Invalid argument

The root cause is that the platform has 2 numa nodes: node 0 has
both cpu and memory, while node 1 is a CXL node which only has
memory, and caused numa_run_on_node() to fail.

Add sanity check to skip cpuless numa node for the numa binding test.

Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260807002436.43991-1-feng.tang@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[selftests: net]` `[consider]` skip CPU-less NUMA nodes in
  `reuseport_bpf_numa` so the test does not abort when
  `numa_run_on_node()` cannot pin to a memory-only node.

**Step 1.2: Tags**
- Record: `Reviewed-by: Simon Horman <horms@kernel.org>`; `Link: https:/
  /patch.msgid.link/20260807002436.43991-1-feng.tang@linux.alibaba.com`;
  `Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>`; `Signed-off-
  by: Paolo Abeni <pabeni@redhat.com>`.
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Cc: stable`
  (absence is expected). Ignore any pipeline `Signed-off-by: Sasha
  Levin` / `[Upstream commit ...]` markers.

**Step 1.3: Body**
- Record: On a 2-node CXL box, node 0 has CPU+memory and node 1 is
  memory-only. The test prints `send node 0, receive socket 0` then dies
  with `failed to pin to node: Invalid argument` from
  `numa_run_on_node()`. Root cause is treating every bit in
  `numa_nodes_ptr` as a pin-able CPU node. Fix: skip CPU-less nodes.

**Step 1.4: Hidden bug fix?**
- Record: Yes. “Consider” is test-robustness language, but the program
  currently `error(1, ...)` and fails. This is a real false failure, not
  style cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: One file, `tools/testing/selftests/net/reuseport_bpf_numa.c`.
  About +24 lines. New helper `is_cpuless_node()`; `test()` gains two
  `continue`s. Surgical, single-file, userspace selftest only.

**Step 2.2: Flow**
- Record: Before: both forward and reverse loops skip only nodes unset
  in `numa_nodes_ptr`, then call `send_from_node()` which does
  `numa_run_on_node()` and aborts on failure. After: also skip nodes
  whose libnuma CPU mask has weight 0. Normal send/receive path for CPU-
  bearing nodes is unchanged.

**Step 2.3: Bug mechanism**
- Record: Logic/correctness in a selftest. Memory-only NUMA nodes are
  present in `numa_nodes_ptr` (the 2021 skip does not drop them) but
  have an empty CPU mask, so pinning returns EINVAL. `is_cpuless_node()`
  uses `numa_allocate_cpumask()` / `numa_node_to_cpus()` /
  `numa_bitmask_weight()`; on helper error it returns false (do not
  skip), which is conservative.

**Step 2.4: Fix quality**
- Record: Obviously correct and minimal. Skipping a CPU-less node is
  right: `bpf_get_numa_node_id()` is the current CPU’s node, so a
  memory-only node can never be the sender. Regression risk is very low
  (userspace test only). Helper allocation failure still hits the old
  abort path.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Loops come from `3c2c3c16aaf6a` (Daniel Borkmann, 2016-10-21,
  “reuseport, bpf: add test case for bpf_get_numa_node_id”), first
  contained in v4.10-rc1. The existing skip is `a38bc45a08e97` (Kleber
  Sacilotto de Souza, 2021-11-01), contained in v5.16-rc1: skip nodes
  not in `numa_nodes_ptr` (non-consecutive IDs). That does not cover
  CPU-less memory nodes.

**Step 3.2: Fixes: tag**
- Record: None. Buggy assumption is in the original 2016 test, still
  present here.

**Step 3.3: File history**
- Record: This tree only has later `0273d10182ec4` (ARRAY_SIZE warning),
  then the 2021 skip, 2018 numa-skip-if-unavailable, SPDX, and the
  original test. No `setup_netns()` in this file (0 matches).
  Standalone; not patch X/Y.

**Step 3.4: Author**
- Record: Feng Tang has other tools/selftests work in this history (e.g.
  mm `compaction_test`) but no other net `reuseport_bpf_numa` commits.
  Not the net maintainer. Applied by Paolo Abeni after Simon Horman’s
  review.

**Step 3.5: Prerequisites**
- Record: Needs existing libnuma usage (`numa_nodes_ptr`,
  `numa_run_on_node`, `-lnuma`). All present. Makefile already has
  `$(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma`. No missing kernel
  APIs. Can apply standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 mbox` for msgid
  `20260807002436.43991-1-feng.tang@linux.alibaba.com` returned 404;
  lore.kernel.org fetches returned 403. Recovered from
  Openwall/LKML/Patchew.
- v1 (`20260730113040.75718-1-...`): check inside `send_from_node()`,
  return -1, no NULL check on `numa_allocate_cpumask()`.
- v2 (`[PATCH net v2]`): lift check into `test()`, add alloc-failure
  handling; typo “unlikeyly”; unnecessary `inline`.
- v3 (`[PATCH net-next v3]`): spelling + drop `inline` (Jakub, Sashiko).
  Committed version matches v3.
- No NAKs. No reviewer `Cc: stable` found.

**Step 4.2: Reviewers**
- Record: To/Cc included Jakub Kicinski, David Miller, Eric Dumazet,
  Paolo Abeni, Simon Horman, Shuah Khan, Andi Kleen, netdev, linux-
  kselftest, bpf. Jakub reviewed v2 (inline). Simon Horman `Reviewed-by`
  on v3. Paolo applied.

**Step 4.3: Bug report**
- Record: Author reproduced on CXL hardware; commit body has the exact
  abort. No syzbot/bugzilla. Severity for testers: hard FAIL after the
  first successful node-0 send.

**Step 4.4: Series**
- Record: Single patch, three revisions. No sibling patches required.

**Step 4.5: Stable list**
- Record: No stable-list hit found. UNVERIFIED that nobody asked for it
  on stable@ (lore 403).

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: Adds `is_cpuless_node()`. Touches `test()`. `send_from_node()`
  unchanged.

**Step 5.2: Callers**
- Record: `is_cpuless_node` only from `test()`. `test()` only from
  `main()` (IPv4/IPv6 × UDP/TCP). Userspace kselftest, not kernel.

**Step 5.3: Callees**
- Record: libnuma `numa_allocate_cpumask`, `numa_node_to_cpus`,
  `numa_bitmask_weight`, `numa_bitmask_free`. Already linked with
  `-lnuma`.

**Step 5.4: Reachability**
- Record: Triggered by running `./reuseport_bpf_numa` on NUMA
  (`CONFIG_NUMA=y` in `tools/testing/selftests/net/config`) with at
  least one CPU-less node. Not a syscall/kernel path.

**Step 5.5: Similar patterns**
- Record: Same file already skips unavailable nodes (`a38bc45a08e97`).
  This is the CPU-less counterpart. No other `numa_run_on_node`
  selftests in this tree.

## Phase 6: This tree (6.12.111)

**Step 6.1: Buggy code present?**
- Record: Yes. Local tree is `pending-6.12` / `p-6.12-3-gc504cf0baa3d8`,
  `make kernelversion` = **6.12.111**. File has the 2016 loops and the
  2021 `numa_nodes_ptr` skip, and still calls `send_from_node()` without
  a CPU-less check (`git merge-base --is-ancestor` for both historical
  commits succeeded). `git log --grep="consider cpuless"` on this file
  is empty. CXL is in this tree (`drivers/cxl/`).

**Step 6.2: Backport difficulty**
- Record: Clean apply. The three functional contexts exist verbatim
  (helper insertion after `attach_bpf()`, two loop sites). Mainline
  trailing `setup_netns()` context is **not** in 6.12 and is not part of
  the v3 hunks. `bool` is already used in other net selftests here
  without extra headers.

**Step 6.3: Related fixes already here?**
- Record: Only the 2021 unavailable-node skip. It does not fix CXL
  memory-only nodes. No equivalent `is_cpuless_node` fix.

## Phase 7: Subsystem context

**Step 7.1:** Record: `tools/testing/selftests/net` — kselftest for
SO_REUSEPORT + `bpf_get_numa_node_id`. Criticality: PERIPHERAL for
production runtime; IMPORTANT for people who run net kselftests (this
6.12.y tree already took ~100 `tools/testing/selftests/net` commits
since `v6.12`).

**Step 7.2:** Record: Net selftests are actively backported here (UAF in
tests, br_netfilter false failures, HZ=100 skips, portable timeouts,
etc.).

## Phase 8: Impact and risk

**Step 8.1:** Record: Testers running this binary on NUMA machines with
CPU-less nodes (CXL memory, similar memory-only nodes). Not a production
kernel path.

**Step 8.2:** Record: Trigger is running the selftest on that topology.
First CPU node can succeed; the next CPU-less node aborts. Unprivileged
if the test is run that way; not a kernel exploit path.

**Step 8.3:** Record: Failure mode = kselftest abort (`error(1, errno,
"failed to pin to node")`). Severity LOW–MEDIUM for the kernel (no
oops/corruption), HIGH for CI on those machines (hard fail).

**Step 8.4:** Record: Benefit medium for CXL/NUMA testers of 6.12.y;
risk very low (userspace, +24 lines, no kernel change). Ratio favors
backport on this tree, which already takes kselftest false-fail fixes.

## Phase 9: Synthesis

**For**
- Real, reproduced FAIL on CXL memory-only NUMA; 6.12 has both the test
  and CXL.
- Completes the 2021 skip: `numa_nodes_ptr` still includes CPU-less
  nodes.
- Small, reviewed, v3 is the applied form; no series deps.
- Applies cleanly here; zero kernel runtime risk.
- This tree regularly backports the same class (e.g. `selftests:
  netfilter: packetdrill: avoid failure on HZ=100 kernel`,
  vxlan/br_netfilter false-fail fixes).
- v2 was sent to `net` as a bugfix.

**Against**
- Not a kernel crash, security hole, or data-corruption fix.
- Affects one selftest on a subset of NUMA topologies.
- Final submission was `net-next`; no `Cc: stable` in the thread I could
  read.

**Unresolved**
- Exact mainline SHA (not on this branch).
- lore.kernel.org / `b4` thread dump (403/404).
- Whether stable@ ever discussed it.

**Stable rules checklist**
1. Obviously correct and tested? **PASS** (libnuma weight 0; Reviewed-by
   Horman; author reproduced).
2. Real bug that bothers people? **PASS** (hard selftest FAIL on real
   CXL hardware).
3. Important (crash/security/corruption/deadlock)? **PASS** under this
   tree’s documented “oh, that’s not good” / kselftest-false-fail
   practice; not a production oops.
4. Small and contained? **PASS** (~24 lines, one file).
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** (contexts verified).

**Exception category:** none of ID/quirk/DT/build/docs; it is a
kselftest correctness/robustness fix, which this 6.12.y tree already
accepts.

The test in 6.12.111 still assumes every exposed NUMA node has CPUs.
That is false on CXL memory-only nodes, so `reuseport_bpf_numa` aborts.
The patch only skips those nodes and does not change kernel behavior.
That is a contained, low-risk fix worth taking on this tree.

### Verification
- [Phase 1] Parsed tags: Reviewed-by Simon Horman; Link msgid; SOBs Feng
  Tang / Paolo Abeni; no Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff: +24 lines, `is_cpuless_node()` + two `continue`s in
  `test()`; `send_from_node()` still `error(1)` on pin failure.
- [Phase 3] `git blame` loops: `3c2c3c16aaf6a` (2016) and
  `a38bc45a08e97` (2021 skip). Both are ancestors of HEAD.
- [Phase 3] `git describe --contains`: original test v4.10-rc1; 2021
  skip v5.16-rc1.
- [Phase 3] `git log --grep="consider cpuless"` on this file: empty (fix
  not in tree).
- [Phase 4] `b4 mbox` msgid: 404; lore WebFetch: 403; used
  Openwall/LKML/Patchew for v1–v3.
- [Phase 4] v1→v3: Sashiko NULL-check; lift skip out of
  `send_from_node`; Jakub spelling/`inline`; Horman Reviewed-by; no NAK.
- [Phase 5] Callers: `main` → `test` → `send_from_node`; userspace only.
  `grep numa_run_on_node` only this file under selftests.
- [Phase 6] `git describe HEAD` / `make kernelversion`: pending-6.12,
  6.12.111. File matches patch contexts (`hunk1 present`, two loop
  sites). No `setup_netns`. `drivers/cxl/` present. `CONFIG_NUMA=y` in
  net selftest config. `-lnuma` already in Makefile.
- [Phase 6] `v6.12..HEAD -- tools/testing/selftests/net/`: 100 commits,
  including false-fail/skip fixes.
- [Phase 8] Failure: selftest abort `failed to pin to node: Invalid
  argument`; not a kernel oops.
- UNVERIFIED: lore.kernel.org full thread; stable@ discussion; mainline
  SHA.

**YES**

 .../selftests/net/reuseport_bpf_numa.c        | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/net/reuseport_bpf_numa.c b/tools/testing/selftests/net/reuseport_bpf_numa.c
index c9ba36aa688e2..b04b511809ad2 100644
--- a/tools/testing/selftests/net/reuseport_bpf_numa.c
+++ b/tools/testing/selftests/net/reuseport_bpf_numa.c
@@ -104,6 +104,26 @@ static void attach_bpf(int fd)
 	close(bpf_fd);
 }
 
+/*
+ * Return true if it is a cpuless node. Return false if it isn't or any
+ * error (very unlikely) happens during the libnuma calls.
+ */
+static bool is_cpuless_node(int node_id)
+{
+	struct bitmask *cpumask;
+	bool ret = false;
+
+	cpumask = numa_allocate_cpumask();
+	if (!cpumask)
+		return ret;
+
+	if (!numa_node_to_cpus(node_id, cpumask) && !numa_bitmask_weight(cpumask))
+		ret = true;
+
+	numa_bitmask_free(cpumask);
+	return ret;
+}
+
 static void send_from_node(int node_id, int family, int proto)
 {
 	struct sockaddr_storage saddr, daddr;
@@ -213,6 +233,8 @@ static void test(int *rcv_fd, int len, int family, int proto)
 	for (node = 0; node < len; ++node) {
 		if (!numa_bitmask_isbitset(numa_nodes_ptr, node))
 			continue;
+		if (is_cpuless_node(node))
+			continue;
 		send_from_node(node, family, proto);
 		receive_on_node(rcv_fd, len, epfd, node, proto);
 	}
@@ -221,6 +243,8 @@ static void test(int *rcv_fd, int len, int family, int proto)
 	for (node = len - 1; node >= 0; --node) {
 		if (!numa_bitmask_isbitset(numa_nodes_ptr, node))
 			continue;
+		if (is_cpuless_node(node))
+			continue;
 		send_from_node(node, family, proto);
 		receive_on_node(rcv_fd, len, epfd, node, proto);
 	}
-- 
2.53.0

