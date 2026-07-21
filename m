Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8586846EC82;
	Tue, 21 Jul 2026 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661835; cv=none; b=A4KF0JJlex2QrLFd2ltqvzBTi76VRXSvt6JHcBIf3eEBPS0DZEr93Oqv+HHXnpuWf2o4fIrfTCUuap+orr6sNawdH3w0Nb9fhVR4UrAsMEhx4YbhaSlauyS6f6T/i5qZd4imYX6/rrbSSdcsdRsiNHWiKBASc5Ccr/s/ZEmDFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661835; c=relaxed/simple;
	bh=1ZRznMGIUgWaRB3Ictci+WZ6MoFmoT98/J6Qk9dgNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtos0R4H/5rwUOOXE8ilElvR2OLidWV/HEhhG0tNrUiV7YacPMrdmSwZOJQDek/wFxS3n9seOgCk4Av8whm3YQFYcyGoahimRBX0gq8z476Lv16RAuTBgllR0d7q3/ye136fXG1LMlwUf9qOlzpCvSDaLGIt739cEIr/p0NklmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qegFz6Sf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qegFz6Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2E81F000E9;
	Tue, 21 Jul 2026 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661834;
	bh=f7l+qxz2ED5iz31gREZB4MJvhi+LYuAcyuOt1X5Ev30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qegFz6Sf9rK6lS0OPVIAQZ4tNT9w683so2FvBTSnSIy1R3670pk1imjqLu5/Bw2HE
	 9ifsIOHLz6QWXqwBx2ToyYBSRRJKjkFkn3X/MWCjUHRlVXPAnEjMBv1ydgRvgLQUsp
	 Lgkz7X3YfR38B/EpzCGyUXZKesE1yt9J1ZG1q2HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0215/1276] nvdimm/btt: Handle preemption in BTT lane acquisition
Date: Tue, 21 Jul 2026 17:10:58 +0200
Message-ID: <20260721152450.896991759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 8d4b989d9c9afe5f185aa5853b666fc4617afe9e ]

BTT lanes serialize access to per-lane metadata and workspace state
during BTT I/O. The btt-check unit test reports data mismatches during
BTT writes due to a race in lane acquisition that can lead to silent
data corruption.

The existing lane model uses a spinlock together with a per-CPU
recursion count. That recursion model stopped being valid after BTT
lanes became preemptible: another task can run on the same CPU,
observe a non-zero recursion count, bypass locking, and use the same
lane concurrently.

BTT lanes are also held across arena_write_bytes() calls. That path
reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
Some provider flush callbacks can sleep, making a spinlock the wrong
primitive for the lane lifetime.

Replace the spinlock-based recursion model with a dynamically
allocated per-lane mutex array and take the lane lock
unconditionally.

Add might_sleep() to catch any future atomic-context caller.

Found with the ndctl unit test btt-check.sh.

Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Assisted-by: Claude-Sonnet:4.5
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260528021625.618462-1-alison.schofield@intel.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/nvdimm/btt.rst |  5 +-
 drivers/nvdimm/nd.h                     | 11 ++---
 drivers/nvdimm/region_devs.c            | 66 +++++++++----------------
 3 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
index 107395c042ae07..cb1afe9dc3cbb9 100644
--- a/Documentation/driver-api/nvdimm/btt.rst
+++ b/Documentation/driver-api/nvdimm/btt.rst
@@ -161,9 +161,8 @@ process::
 	nlanes = min(nfree, num_cpus)
 
 A lane number is obtained at the start of any IO, and is used for indexing into
-all the on-disk and in-memory data structures for the duration of the IO. If
-there are more CPUs than the max number of available lanes, than lanes are
-protected by spinlocks.
+all the on-disk and in-memory data structures for the duration of the IO. Lanes
+are protected by mutexes.
 
 
 d. In-memory data structure: Read Tracking Table (RTT)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5ca06e9a2d2925..28ea8b94bae0bc 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -365,11 +365,6 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
 			res; res = next, next = next ? next->sibling : NULL)
 
-struct nd_percpu_lane {
-	int count;
-	spinlock_t lock;
-};
-
 enum nd_label_flags {
 	ND_LABEL_REAP,
 };
@@ -400,6 +395,10 @@ struct nd_mapping {
 	struct nvdimm_drvdata *ndd;
 };
 
+struct nd_lane {
+	struct mutex lock; /* serialize lane access */
+} ____cacheline_aligned_in_smp;
+
 struct nd_region {
 	struct device dev;
 	struct ida ns_ida;
@@ -420,7 +419,7 @@ struct nd_region {
 	struct kernfs_node *bb_state;
 	struct badblocks bb;
 	struct nd_interleave_set *nd_set;
-	struct nd_percpu_lane __percpu *lane;
+	struct nd_lane *lane;
 	int (*flush)(struct nd_region *nd_region, struct bio *bio);
 	struct nd_mapping mapping[] __counted_by(ndr_mappings);
 };
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 9e4f7ff024a000..849c131f39c757 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -179,7 +179,9 @@ static void nd_region_release(struct device *dev)
 
 		put_device(&nvdimm->dev);
 	}
-	free_percpu(nd_region->lane);
+	for (i = 0; i < nd_region->num_lanes; i++)
+		mutex_destroy(&nd_region->lane[i].lock);
+	kfree(nd_region->lane);
 	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
 		memregion_free(nd_region->id);
 	kfree(nd_region);
@@ -922,52 +924,30 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
  * nd_region_acquire_lane - allocate and lock a lane
  * @nd_region: region id and number of lanes possible
  *
- * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
- * We optimize for the common case where there are 256 lanes, one
- * per-cpu.  For larger systems we need to lock to share lanes.  For now
- * this implementation assumes the cost of maintaining an allocator for
- * free lanes is on the order of the lock hold time, so it implements a
- * static lane = cpu % num_lanes mapping.
+ * A lane correlates to a log slot in the BTT. Lanes are shared across
+ * CPUs using a static lane = cpu % num_lanes mapping, with a per-lane
+ * mutex to serialize access.
  *
- * In the case of a BTT instance on top of a BLK namespace a lane may be
- * acquired recursively.  We lock on the first instance.
- *
- * In the case of a BTT instance on top of PMEM, we only acquire a lane
- * for the BTT metadata updates.
+ * Callers must be in sleepable context. The only in-tree caller is
+ * BTT's ->submit_bio handler (btt_read_pg / btt_write_pg).
  */
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
+	__acquires(&nd_region->lane[lane].lock)
 {
-	unsigned int cpu, lane;
-
-	migrate_disable();
-	cpu = smp_processor_id();
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
+	unsigned int lane;
 
-		lane = cpu % nd_region->num_lanes;
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (ndl_count->count++ == 0)
-			spin_lock(&ndl_lock->lock);
-	} else
-		lane = cpu;
+	might_sleep();
 
+	lane = raw_smp_processor_id() % nd_region->num_lanes;
+	mutex_lock(&nd_region->lane[lane].lock);
 	return lane;
 }
 EXPORT_SYMBOL(nd_region_acquire_lane);
 
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
+	__releases(&nd_region->lane[lane].lock)
 {
-	if (nd_region->num_lanes < nr_cpu_ids) {
-		unsigned int cpu = smp_processor_id();
-		struct nd_percpu_lane *ndl_lock, *ndl_count;
-
-		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
-		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
-		if (--ndl_count->count == 0)
-			spin_unlock(&ndl_lock->lock);
-	}
-	migrate_enable();
+	mutex_unlock(&nd_region->lane[lane].lock);
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
@@ -1038,17 +1018,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 			goto err_id;
 	}
 
-	nd_region->lane = alloc_percpu(struct nd_percpu_lane);
+	nd_region->num_lanes = ndr_desc->num_lanes;
+	if (!nd_region->num_lanes)
+		goto err_percpu;
+	nd_region->lane = kcalloc(nd_region->num_lanes,
+				  sizeof(*nd_region->lane), GFP_KERNEL);
 	if (!nd_region->lane)
 		goto err_percpu;
 
-        for (i = 0; i < nr_cpu_ids; i++) {
-		struct nd_percpu_lane *ndl;
-
-		ndl = per_cpu_ptr(nd_region->lane, i);
-		spin_lock_init(&ndl->lock);
-		ndl->count = 0;
-	}
+	for (i = 0; i < nd_region->num_lanes; i++)
+		mutex_init(&nd_region->lane[i].lock);
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
@@ -1065,7 +1044,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	}
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
-	nd_region->num_lanes = ndr_desc->num_lanes;
 	nd_region->flags = ndr_desc->flags;
 	nd_region->ro = ro;
 	nd_region->numa_node = ndr_desc->numa_node;
-- 
2.53.0



