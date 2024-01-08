Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A0254674;
	Mon,  8 Jan 2024 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxaVdosN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC802C433C8;
	Mon,  8 Jan 2024 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728557;
	bh=aIbcDS5UNU854i82BZ93bl7AJGSKcxkVVpF6YZE2pXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxaVdosNAofikUTexYzGzD1NeX/8kRyUM99rivIfpPjmdRpqYfu50oKGe7dtGD81j
	 so9sp7Gyy0x4tIxEmx2rbQjD6IDB6FyMTLO8uS/sQwsLrw720aD7A4w14tYlGlvMTG
	 Tvhqdmy4F6HQovlIKklsIvD66SR2aEZ7xfnYJmK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/150] genirq/affinity: Dont pass irq_affinity_desc array to irq_build_affinity_masks
Date: Mon,  8 Jan 2024 16:36:05 +0100
Message-ID: <20240108153516.439744892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit e7bdd7f0cbd1c001bb9b4d3313edc5ee094bc3f8 ]

Prepare for abstracting irq_build_affinity_masks() into a public function
for assigning all CPUs evenly into several groups.

Don't pass irq_affinity_desc array to irq_build_affinity_masks, instead
return a cpumask array by storing each assigned group into one element of
the array.

This allows to provide a generic interface for grouping all CPUs evenly
from a NUMA and CPU locality viewpoint, and the cost is one extra allocation
in irq_build_affinity_masks(), which should be fine since it is done via
GFP_KERNEL and irq_build_affinity_masks() is a slow path anyway.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20221227022905.352674-4-ming.lei@redhat.com
Stable-dep-of: 0263f92fadbb ("lib/group_cpus.c: avoid acquiring cpu hotplug lock in group_cpus_evenly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/affinity.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index da6379cd27fd4..00bba1020ecb2 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -249,7 +249,7 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 				      cpumask_var_t *node_to_cpumask,
 				      const struct cpumask *cpu_mask,
 				      struct cpumask *nmsk,
-				      struct irq_affinity_desc *masks)
+				      struct cpumask *masks)
 {
 	unsigned int i, n, nodes, cpus_per_vec, extra_vecs, done = 0;
 	unsigned int last_affv = numvecs;
@@ -270,7 +270,7 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 		for_each_node_mask(n, nodemsk) {
 			/* Ensure that only CPUs which are in both masks are set */
 			cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
-			cpumask_or(&masks[curvec].mask, &masks[curvec].mask, nmsk);
+			cpumask_or(&masks[curvec], &masks[curvec], nmsk);
 			if (++curvec == last_affv)
 				curvec = 0;
 		}
@@ -321,7 +321,7 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 			 */
 			if (curvec >= last_affv)
 				curvec = 0;
-			irq_spread_init_one(&masks[curvec].mask, nmsk,
+			irq_spread_init_one(&masks[curvec], nmsk,
 						cpus_per_vec);
 		}
 		done += nv->nvectors;
@@ -335,16 +335,16 @@ static int __irq_build_affinity_masks(unsigned int startvec,
  *	1) spread present CPU on these vectors
  *	2) spread other possible CPUs on these vectors
  */
-static int irq_build_affinity_masks(unsigned int numvecs,
-				    struct irq_affinity_desc *masks)
+static struct cpumask *irq_build_affinity_masks(unsigned int numvecs)
 {
 	unsigned int curvec = 0, nr_present = 0, nr_others = 0;
 	cpumask_var_t *node_to_cpumask;
 	cpumask_var_t nmsk, npresmsk;
 	int ret = -ENOMEM;
+	struct cpumask *masks = NULL;
 
 	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
-		return ret;
+		return NULL;
 
 	if (!zalloc_cpumask_var(&npresmsk, GFP_KERNEL))
 		goto fail_nmsk;
@@ -353,6 +353,10 @@ static int irq_build_affinity_masks(unsigned int numvecs,
 	if (!node_to_cpumask)
 		goto fail_npresmsk;
 
+	masks = kcalloc(numvecs, sizeof(*masks), GFP_KERNEL);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
 	/* Stabilize the cpumasks */
 	cpus_read_lock();
 	build_node_to_cpumask(node_to_cpumask);
@@ -386,6 +390,7 @@ static int irq_build_affinity_masks(unsigned int numvecs,
 	if (ret >= 0)
 		WARN_ON(nr_present + nr_others < numvecs);
 
+ fail_node_to_cpumask:
 	free_node_to_cpumask(node_to_cpumask);
 
  fail_npresmsk:
@@ -393,7 +398,11 @@ static int irq_build_affinity_masks(unsigned int numvecs,
 
  fail_nmsk:
 	free_cpumask_var(nmsk);
-	return ret < 0 ? ret : 0;
+	if (ret < 0) {
+		kfree(masks);
+		return NULL;
+	}
+	return masks;
 }
 
 static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
@@ -457,13 +466,18 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 	 */
 	for (i = 0, usedvecs = 0; i < affd->nr_sets; i++) {
 		unsigned int this_vecs = affd->set_size[i];
-		int ret;
+		int j;
+		struct cpumask *result = irq_build_affinity_masks(this_vecs);
 
-		ret = irq_build_affinity_masks(this_vecs, &masks[curvec]);
-		if (ret) {
+		if (!result) {
 			kfree(masks);
 			return NULL;
 		}
+
+		for (j = 0; j < this_vecs; j++)
+			cpumask_copy(&masks[curvec + j].mask, &result[j]);
+		kfree(result);
+
 		curvec += this_vecs;
 		usedvecs += this_vecs;
 	}
-- 
2.43.0



