Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D88485
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A5C433EF;
	Fri, 10 Mar 2023 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456834;
	bh=28+v0AZXtdLnjA1qVQTal/PjRTzRuO/Je+nT+ocQfY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfzqxAHWLmTI4dH7THACFoPx03w0/9cv/+Ve9xuLBPHBjjA3Iw1tWi18jkskqm8ZN
	 FlrXeUQTrA88UalG1gA+RfCN6+Xvxj3OPrFP5nR7sj1B1KWf9iuCT8U9yOYSmhkZ0+
	 usXzblUB84P99u2NLVETjSNDD5A/DI4Tp5bkiVfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 139/211] cacheinfo: Fix shared_cpu_map to handle shared caches at different levels
Date: Fri, 10 Mar 2023 14:38:39 +0100
Message-Id: <20230310133722.967289208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 198102c9103fc78d8478495971947af77edb05c1 ]

The cacheinfo sets up the shared_cpu_map by checking whether the caches
with the same index are shared between CPUs. However, this will trigger
slab-out-of-bounds access if the CPUs do not have the same cache hierarchy.
Another problem is the mismatched shared_cpu_map when the shared cache does
not have the same index between CPUs.

CPU0	I	D	L3
index	0	1	2	x
	^	^	^	^
index	0	1	2	3
CPU1	I	D	L2	L3

This patch checks each cache is shared with all caches on other CPUs.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Link: https://lore.kernel.org/r/20230117105133.4445-2-yongxuan.wang@sifive.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 950b22cdb5f7c..f05acf3c16c6b 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -256,7 +256,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int index;
+	unsigned int index, sib_index;
 	int ret = 0;
 
 	if (this_cpu_ci->cpu_map_populated)
@@ -284,11 +284,13 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 
 			if (i == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
-
-			sib_leaf = per_cpu_cacheinfo_idx(i, index);
-			if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
-				cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
-				cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(i); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(i, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+					break;
+				}
 			}
 		}
 		/* record the maximum cache line size */
@@ -302,7 +304,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 static void cache_shared_cpu_map_remove(unsigned int cpu)
 {
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int sibling, index;
+	unsigned int sibling, index, sib_index;
 
 	for (index = 0; index < cache_leaves(cpu); index++) {
 		this_leaf = per_cpu_cacheinfo_idx(cpu, index);
@@ -313,9 +315,14 @@ static void cache_shared_cpu_map_remove(unsigned int cpu)
 			if (sibling == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
 
-			sib_leaf = per_cpu_cacheinfo_idx(sibling, index);
-			cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
-			cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(sibling); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(sibling, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+					break;
+				}
+			}
 		}
 	}
 }
-- 
2.39.2



