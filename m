Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FDE301022;
	Sat, 25 Oct 2025 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409107; cv=none; b=OxXFo+fHIuwwmBdthQq2virik9gq2N/01KmPbCOHXSotYL8kf3ReVfSnQhGqJRTZQkrji5rqCm7SxeDbq6rg9Jp4db8JsuAcvESuXLW/zyxrQqcomG55+83l5tKvhDnpJRZ2Ky9pWcLT2fP8zUSIH+VWNzmxztxl+M0HCPAlo2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409107; c=relaxed/simple;
	bh=EWaw2WEUOQXg8HuyAL2v8w6+3oHdfjUw3HZvwCMb+h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aqq8uJ2310FChKg7Y6Z3sA4VClGjIH9GftqH+ks4NMb+8jgHeuZmk3i4yb5hS4O4zp9UpcoDTci3HmDDcguWcGCRwL8a7+WYtBIpT+3ZLFQgRqX4RqLi6THKQp7PkGEwveSuH9db/WfIOkXe+8NVCW6hgqgT56YGTnkEe2sc06g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrKquWBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrKquWBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECA2C4CEF5;
	Sat, 25 Oct 2025 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409107;
	bh=EWaw2WEUOQXg8HuyAL2v8w6+3oHdfjUw3HZvwCMb+h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrKquWBEQEl4lQWZOf1npascd2OKagqEzXNq7as9zir0W1yMOReoEnEQcaubpqry1
	 QeDSVY9MMvf1ITycI6AQQeLjsyiXei+psjm/9xWXyuXOPCxsnzhxPafQ29UWsJk0li
	 IPoqts82xvRv8eWoMLFNXp3sRCU/iHkPjvXEEsWn5xLy5g+vQpaddDajTdMBNHM8J4
	 9506H719sYvoFtNnOOc0Fmd6sUxUGk+BdJ+cXnIILENUvEqOkd0Xz/k5Dfvp4r5Q0c
	 89FLAxnz8cJY3gbagdySbJGwBWHmHCZaqefjX1y76bIZWecspqdKjk33om5U9uV3QF
	 ywr+XC51gotgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Kumar <krikku@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@fomichev.me,
	kuniyu@google.com,
	alexandre.f.demers@gmail.com,
	aleksander.lobakin@intel.com,
	atenart@kernel.org,
	yajun.deng@linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] net: Prevent RPS table overwrite of active flows
Date: Sat, 25 Oct 2025 11:57:13 -0400
Message-ID: <20251025160905.3857885-202-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Kumar <krikku@gmail.com>

[ Upstream commit 97bcc5b6f45425ac56fb04b0893cdaa607ec7e45 ]

This patch fixes an issue where two different flows on the same RXq
produce the same hash resulting in continuous flow overwrites.

Flow #1: A packet for Flow #1 comes in, kernel calls the steering
         function. The driver gives back a filter id. The kernel saves
	 this filter id in the selected slot. Later, the driver's
	 service task checks if any filters have expired and then
	 installs the rule for Flow #1.
Flow #2: A packet for Flow #2 comes in. It goes through the same steps.
         But this time, the chosen slot is being used by Flow #1. The
	 driver gives a new filter id and the kernel saves it in the
	 same slot. When the driver's service task runs, it runs through
	 all the flows, checks if Flow #1 should be expired, the kernel
	 returns True as the slot has a different filter id, and then
	 the driver installs the rule for Flow #2.
Flow #1: Another packet for Flow #1 comes in. The same thing repeats.
         The slot is overwritten with a new filter id for Flow #1.

This causes a repeated cycle of flow programming for missed packets,
wasting CPU cycles while not improving performance. This problem happens
at higher rates when the RPS table is small, but tests show it still
happens even with 12,000 connections and an RPS size of 16K per queue
(global table size = 144x16K = 64K).

This patch prevents overwriting an rps_dev_flow entry if it is active.
The intention is that it is better to do aRFS for the first flow instead
of hurting all flows on the same hash. Without this, two (or more) flows
on one RX queue with the same hash can keep overwriting each other. This
causes the driver to reprogram the flow repeatedly.

Changes:
  1. Add a new 'hash' field to struct rps_dev_flow.
  2. Add rps_flow_is_active(): a helper function to check if a flow is
     active or not, extracted from rps_may_expire_flow(). It is further
     simplified as per reviewer feedback.
  3. In set_rps_cpu():
     - Avoid overwriting by programming a new filter if:
        - The slot is not in use, or
        - The slot is in use but the flow is not active, or
        - The slot has an active flow with the same hash, but target CPU
          differs.
     - Save the hash in the rps_dev_flow entry.
  4. rps_may_expire_flow(): Use earlier extracted rps_flow_is_active().

Testing & results:
  - Driver: ice (E810 NIC), Kernel: net-next
  - #CPUs = #RXq = 144 (1:1)
  - Number of flows: 12K
  - Eight RPS settings from 256 to 32768. Though RPS=256 is not ideal,
    it is still sufficient to cover 12K flows (256*144 rx-queues = 64K
    global table slots)
  - Global Table Size = 144 * RPS (effectively equal to 256 * RPS)
  - Each RPS test duration = 8 mins (org code) + 8 mins (new code).
  - Metrics captured on client

Legend for following tables:
Steer-C: #times ndo_rx_flow_steer() was Called by set_rps_cpu()
Steer-L: #times ice_arfs_flow_steer() Looped over aRFS entries
Add:     #times driver actually programmed aRFS (ice_arfs_build_entry())
Del:     #times driver deleted the flow (ice_arfs_del_flow_rules())
Units:   K = 1,000 times, M = 1 million times

  |-------|---------|------|     Org Code    |---------|---------|
  | RPS   | Latency | CPU  | Add    |  Del   | Steer-C | Steer-L |
  |-------|---------|------|--------|--------|---------|---------|
  | 256   | 227.0   | 93.2 | 1.6M   | 1.6M   | 121.7M  | 267.6M  |
  | 512   | 225.9   | 94.1 | 11.5M  | 11.2M  | 65.7M   | 199.6M  |
  | 1024  | 223.5   | 95.6 | 16.5M  | 16.5M  | 27.1M   | 187.3M  |
  | 2048  | 222.2   | 96.3 | 10.5M  | 10.5M  | 12.5M   | 115.2M  |
  | 4096  | 223.9   | 94.1 | 5.5M   | 5.5M   | 7.2M    | 65.9M   |
  | 8192  | 224.7   | 92.5 | 2.7M   | 2.7M   | 3.0M    | 29.9M   |
  | 16384 | 223.5   | 92.5 | 1.3M   | 1.3M   | 1.4M    | 13.9M   |
  | 32768 | 219.6   | 93.2 | 838.1K | 838.1K | 965.1K  | 8.9M    |
  |-------|---------|------|   New Code      |---------|---------|
  | 256   | 201.5   | 99.1 | 13.4K  | 5.0K   | 13.7K   | 75.2K   |
  | 512   | 202.5   | 98.2 | 11.2K  | 5.9K   | 11.2K   | 55.5K   |
  | 1024  | 207.3   | 93.9 | 11.5K  | 9.7K   | 11.5K   | 59.6K   |
  | 2048  | 207.5   | 96.7 | 11.8K  | 11.1K  | 15.5K   | 79.3K   |
  | 4096  | 206.9   | 96.6 | 11.8K  | 11.7K  | 11.8K   | 63.2K   |
  | 8192  | 205.8   | 96.7 | 11.9K  | 11.8K  | 11.9K   | 63.9K   |
  | 16384 | 200.9   | 98.2 | 11.9K  | 11.9K  | 11.9K   | 64.2K   |
  | 32768 | 202.5   | 98.0 | 11.9K  | 11.9K  | 11.9K   | 64.2K   |
  |-------|---------|------|--------|--------|---------|---------|

Some observations:
  1. Overall Latency improved: (1790.19-1634.94)/1790.19*100 = 8.67%
  2. Overall CPU increased:    (777.32-751.49)/751.45*100    = 3.44%
  3. Flow Management (add/delete) remained almost constant at ~11K
     compared to values in millions.

Signed-off-by: Krishna Kumar <krikku@gmail.com>
Link: https://patch.msgid.link/20250825031005.3674864-2-krikku@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why**
- Fixes a real bug in aRFS/RPS: collisions in the per-RX-queue RPS flow
  table cause active flows to overwrite each other, triggering
  continuous hardware filter reprogramming and CPU churn without benefit
  (as described in the commit message).
- The change prevents overwriting a slot when it holds an active flow
  for a different hash, eliminating the reprogramming loop and improving
  latency.
- Scope is small and contained to RPS/aRFS logic; behavior outside
  CONFIG_RFS_ACCEL is unchanged.

**Code Changes (what and how)**
- Track flow identity in table entries:
  - Add `u32 hash` to `struct rps_dev_flow` (only under
    `CONFIG_RFS_ACCEL`) to identify which flow currently owns a slot:
    include/net/rps.h:35-37.
- Centralize and reuse “flow activity” test:
  - New helper `rps_flow_is_active()` replicates existing activity
    heuristic (queue-head − last_qtail < 10 × table size), factoring it
    out for reuse and clarity: net/core/dev.c:4902-4917.
  - `rps_may_expire_flow()` now uses the helper instead of duplicating
    the logic; semantics unchanged: net/core/dev.c:5101-5123.
- Prevent programming when it would overwrite an active different flow:
  - In `set_rps_cpu()`, before calling `ndo_rx_flow_steer()`, the code:
    - Looks up the slot entry and its `cpu` and `filter`.
    - If the slot has a filter and the flow is active, it skips
      programming unless it’s the same flow (same `hash`) migrating
      CPUs; also avoids reprogramming if the target CPU is already the
      same: net/core/dev.c:4949-4957.
    - On programming success, records the filter and saves the `hash`
      into the slot; clears old filter when appropriate:
      net/core/dev.c:4961-4972.
- Ensure clean initialization:
  - When allocating a new `rps_dev_flow_table` from sysfs, initialize
    both `cpu` and `filter` fields, so the new overwrite-prevention
    logic never interprets uninitialized `filter` as “active”:
    net/core/net-sysfs.c:1123-1126.

**Risk and Compatibility**
- Behavior-only change under `CONFIG_RFS_ACCEL` and only when the NIC
  supports `NETIF_F_NTUPLE` + `rx_cpu_rmap`; generic receive path
  remains unchanged.
- No user-visible ABI changes; struct growth is internal. Slight per-
  entry memory increase (4 bytes) under `CONFIG_RFS_ACCEL` is acceptable
  for a correctness/robustness fix.
- Concurrency is handled with existing `READ_ONCE()`/`WRITE_ONCE()`
  patterns; the activity heuristic is identical to prior code.
- Worst case: a colliding second flow is not hardware-accelerated while
  the first flow is active; packet delivery remains correct and this
  avoids pathological reprogramming.

**Stable Criteria**
- Fixes a real, user-visible problem (thrash, elevated CPU, latency
  impact).
- Minimal, targeted changes; no architectural shifts.
- No new features; purely corrective with measurable improvements.
- Touches net core RPS/aRFS code but in a contained way, behind existing
  config guards.

Given the bug’s impact and the small, well-scoped fix, this is a good
candidate for stable backport.

 include/net/rps.h    |  7 +++--
 net/core/dev.c       | 64 +++++++++++++++++++++++++++++++++++++++-----
 net/core/net-sysfs.c |  4 ++-
 3 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/include/net/rps.h b/include/net/rps.h
index d8ab3a08bcc48..9917dce42ca45 100644
--- a/include/net/rps.h
+++ b/include/net/rps.h
@@ -25,13 +25,16 @@ struct rps_map {
 
 /*
  * The rps_dev_flow structure contains the mapping of a flow to a CPU, the
- * tail pointer for that CPU's input queue at the time of last enqueue, and
- * a hardware filter index.
+ * tail pointer for that CPU's input queue at the time of last enqueue, a
+ * hardware filter index, and the hash of the flow if aRFS is enabled.
  */
 struct rps_dev_flow {
 	u16		cpu;
 	u16		filter;
 	unsigned int	last_qtail;
+#ifdef CONFIG_RFS_ACCEL
+	u32		hash;
+#endif
 };
 #define RPS_NO_FILTER 0xffff
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 5194b70769cc5..a374efa23f079 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4849,6 +4849,36 @@ static u32 rfs_slot(u32 hash, const struct rps_dev_flow_table *flow_table)
 	return hash_32(hash, flow_table->log);
 }
 
+#ifdef CONFIG_RFS_ACCEL
+/**
+ * rps_flow_is_active - check whether the flow is recently active.
+ * @rflow: Specific flow to check activity.
+ * @flow_table: per-queue flowtable that @rflow belongs to.
+ * @cpu: CPU saved in @rflow.
+ *
+ * If the CPU has processed many packets since the flow's last activity
+ * (beyond 10 times the table size), the flow is considered stale.
+ *
+ * Return: true if flow was recently active.
+ */
+static bool rps_flow_is_active(struct rps_dev_flow *rflow,
+			       struct rps_dev_flow_table *flow_table,
+			       unsigned int cpu)
+{
+	unsigned int flow_last_active;
+	unsigned int sd_input_head;
+
+	if (cpu >= nr_cpu_ids)
+		return false;
+
+	sd_input_head = READ_ONCE(per_cpu(softnet_data, cpu).input_queue_head);
+	flow_last_active = READ_ONCE(rflow->last_qtail);
+
+	return (int)(sd_input_head - flow_last_active) <
+		(int)(10 << flow_table->log);
+}
+#endif
+
 static struct rps_dev_flow *
 set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 	    struct rps_dev_flow *rflow, u16 next_cpu)
@@ -4859,8 +4889,11 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		struct netdev_rx_queue *rxqueue;
 		struct rps_dev_flow_table *flow_table;
 		struct rps_dev_flow *old_rflow;
+		struct rps_dev_flow *tmp_rflow;
+		unsigned int tmp_cpu;
 		u16 rxq_index;
 		u32 flow_id;
+		u32 hash;
 		int rc;
 
 		/* Should we steer this flow to a different hardware queue? */
@@ -4875,14 +4908,32 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		flow_table = rcu_dereference(rxqueue->rps_flow_table);
 		if (!flow_table)
 			goto out;
-		flow_id = rfs_slot(skb_get_hash(skb), flow_table);
+
+		hash = skb_get_hash(skb);
+		flow_id = rfs_slot(hash, flow_table);
+
+		tmp_rflow = &flow_table->flows[flow_id];
+		tmp_cpu = READ_ONCE(tmp_rflow->cpu);
+
+		if (READ_ONCE(tmp_rflow->filter) != RPS_NO_FILTER) {
+			if (rps_flow_is_active(tmp_rflow, flow_table,
+					       tmp_cpu)) {
+				if (hash != READ_ONCE(tmp_rflow->hash) ||
+				    next_cpu == tmp_cpu)
+					goto out;
+			}
+		}
+
 		rc = dev->netdev_ops->ndo_rx_flow_steer(dev, skb,
 							rxq_index, flow_id);
 		if (rc < 0)
 			goto out;
+
 		old_rflow = rflow;
-		rflow = &flow_table->flows[flow_id];
+		rflow = tmp_rflow;
 		WRITE_ONCE(rflow->filter, rc);
+		WRITE_ONCE(rflow->hash, hash);
+
 		if (old_rflow->filter == rc)
 			WRITE_ONCE(old_rflow->filter, RPS_NO_FILTER);
 	out:
@@ -5017,17 +5068,16 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index,
 	struct rps_dev_flow_table *flow_table;
 	struct rps_dev_flow *rflow;
 	bool expire = true;
-	unsigned int cpu;
 
 	rcu_read_lock();
 	flow_table = rcu_dereference(rxqueue->rps_flow_table);
 	if (flow_table && flow_id < (1UL << flow_table->log)) {
+		unsigned int cpu;
+
 		rflow = &flow_table->flows[flow_id];
 		cpu = READ_ONCE(rflow->cpu);
-		if (READ_ONCE(rflow->filter) == filter_id && cpu < nr_cpu_ids &&
-		    ((int)(READ_ONCE(per_cpu(softnet_data, cpu).input_queue_head) -
-			   READ_ONCE(rflow->last_qtail)) <
-		     (int)(10 << flow_table->log)))
+		if (READ_ONCE(rflow->filter) == filter_id &&
+		    rps_flow_is_active(rflow, flow_table, cpu))
 			expire = false;
 	}
 	rcu_read_unlock();
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index c28cd66654447..5ea9f64adce3e 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1120,8 +1120,10 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 			return -ENOMEM;
 
 		table->log = ilog2(mask) + 1;
-		for (count = 0; count <= mask; count++)
+		for (count = 0; count <= mask; count++) {
 			table->flows[count].cpu = RPS_NO_CPU;
+			table->flows[count].filter = RPS_NO_FILTER;
+		}
 	} else {
 		table = NULL;
 	}
-- 
2.51.0

