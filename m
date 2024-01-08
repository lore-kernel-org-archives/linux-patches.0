Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AF65102B;
	Mon,  8 Jan 2024 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUbqgmgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28B5C433CA;
	Mon,  8 Jan 2024 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728554;
	bh=7axXAyp83HwxyaU67v//cNSmTXErz6W1J/2Q29dknNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUbqgmgk0xVvnmYlnDjmBsT36pcRTdwtJTiy1Z0xDqkMaiVz+1MTNbcesCoFR/dAi
	 k44I25nn6u4/KGLoUid3lfelytffY7mgzfJOYGwUQjg0WD00jWixHNbUFYLA+itdNX
	 qI5NvLN32nxeicrdYT05n1GU67liOYnfJs0PD4Ns=
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
Subject: [PATCH 6.1 113/150] genirq/affinity: Pass affinity managed mask array to irq_build_affinity_masks
Date: Mon,  8 Jan 2024 16:36:04 +0100
Message-ID: <20240108153516.400258551@linuxfoundation.org>
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

[ Upstream commit 1f962d91a15af54301c63febb8ac2ba07aa3654f ]

Pass affinity managed mask array to irq_build_affinity_masks() so that the
index of the first affinity managed vector is always zero.

This allows to simplify the implementation a bit.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20221227022905.352674-3-ming.lei@redhat.com
Stable-dep-of: 0263f92fadbb ("lib/group_cpus.c: avoid acquiring cpu hotplug lock in group_cpus_evenly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/affinity.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 3361e36ebaa1e..da6379cd27fd4 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -246,14 +246,13 @@ static void alloc_nodes_vectors(unsigned int numvecs,
 
 static int __irq_build_affinity_masks(unsigned int startvec,
 				      unsigned int numvecs,
-				      unsigned int firstvec,
 				      cpumask_var_t *node_to_cpumask,
 				      const struct cpumask *cpu_mask,
 				      struct cpumask *nmsk,
 				      struct irq_affinity_desc *masks)
 {
 	unsigned int i, n, nodes, cpus_per_vec, extra_vecs, done = 0;
-	unsigned int last_affv = firstvec + numvecs;
+	unsigned int last_affv = numvecs;
 	unsigned int curvec = startvec;
 	nodemask_t nodemsk = NODE_MASK_NONE;
 	struct node_vectors *node_vectors;
@@ -273,7 +272,7 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 			cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
 			cpumask_or(&masks[curvec].mask, &masks[curvec].mask, nmsk);
 			if (++curvec == last_affv)
-				curvec = firstvec;
+				curvec = 0;
 		}
 		return numvecs;
 	}
@@ -321,7 +320,7 @@ static int __irq_build_affinity_masks(unsigned int startvec,
 			 * may start anywhere
 			 */
 			if (curvec >= last_affv)
-				curvec = firstvec;
+				curvec = 0;
 			irq_spread_init_one(&masks[curvec].mask, nmsk,
 						cpus_per_vec);
 		}
@@ -336,11 +335,10 @@ static int __irq_build_affinity_masks(unsigned int startvec,
  *	1) spread present CPU on these vectors
  *	2) spread other possible CPUs on these vectors
  */
-static int irq_build_affinity_masks(unsigned int startvec, unsigned int numvecs,
+static int irq_build_affinity_masks(unsigned int numvecs,
 				    struct irq_affinity_desc *masks)
 {
-	unsigned int curvec = startvec, nr_present = 0, nr_others = 0;
-	unsigned int firstvec = startvec;
+	unsigned int curvec = 0, nr_present = 0, nr_others = 0;
 	cpumask_var_t *node_to_cpumask;
 	cpumask_var_t nmsk, npresmsk;
 	int ret = -ENOMEM;
@@ -360,9 +358,8 @@ static int irq_build_affinity_masks(unsigned int startvec, unsigned int numvecs,
 	build_node_to_cpumask(node_to_cpumask);
 
 	/* Spread on present CPUs starting from affd->pre_vectors */
-	ret = __irq_build_affinity_masks(curvec, numvecs, firstvec,
-					 node_to_cpumask, cpu_present_mask,
-					 nmsk, masks);
+	ret = __irq_build_affinity_masks(curvec, numvecs, node_to_cpumask,
+					 cpu_present_mask, nmsk, masks);
 	if (ret < 0)
 		goto fail_build_affinity;
 	nr_present = ret;
@@ -374,13 +371,12 @@ static int irq_build_affinity_masks(unsigned int startvec, unsigned int numvecs,
 	 * out vectors.
 	 */
 	if (nr_present >= numvecs)
-		curvec = firstvec;
+		curvec = 0;
 	else
-		curvec = firstvec + nr_present;
+		curvec = nr_present;
 	cpumask_andnot(npresmsk, cpu_possible_mask, cpu_present_mask);
-	ret = __irq_build_affinity_masks(curvec, numvecs, firstvec,
-					 node_to_cpumask, npresmsk, nmsk,
-					 masks);
+	ret = __irq_build_affinity_masks(curvec, numvecs, node_to_cpumask,
+					 npresmsk, nmsk, masks);
 	if (ret >= 0)
 		nr_others = ret;
 
@@ -463,7 +459,7 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 		unsigned int this_vecs = affd->set_size[i];
 		int ret;
 
-		ret = irq_build_affinity_masks(curvec, this_vecs, masks);
+		ret = irq_build_affinity_masks(this_vecs, &masks[curvec]);
 		if (ret) {
 			kfree(masks);
 			return NULL;
-- 
2.43.0



