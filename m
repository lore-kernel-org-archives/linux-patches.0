Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF7B28368
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdHxA+PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24FDC433C8;
	Wed, 15 Nov 2023 19:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076713;
	bh=5EZKTYGISfa1mgLJpEtiK75GjvMD95aztiPnYtXNed8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdHxA+PFgEqSnMk8gXMQouujSIX1mnPWPqt0xrY3cpC8YkCGpuj2+pk22+zYsPuv4
	 3/ICpZ2ByJusjNpRqZZ9ulfqf59QgtGQm0p4CAWApmFOk66nhT5RFpCRb4ghkL/BTk
	 PK91QmGEqIwztx8OyRZaSUJYZ/rE3UXbfzPpopgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/603] numa: Generalize numa_map_to_online_node()
Date: Wed, 15 Nov 2023 14:09:07 -0500
Message-ID: <20231115191613.291923126@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit b1f099b1cf51d553c510c6c8141c27d9ba7ea1fe ]

The function in fact searches the nearest node for a given one,
based on a N_ONLINE state. This is a common pattern to search
for a nearest node.

This patch converts numa_map_to_online_node() to numa_nearest_node()
so that others won't need to opencode the logic.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/20230819141239.287290-2-yury.norov@gmail.com
Stable-dep-of: 617f2c38cb5c ("sched/topology: Fix sched_numa_find_nth_cpu() in CPU-less case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/numa.h |  7 +++++--
 mm/mempolicy.c       | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/numa.h b/include/linux/numa.h
index 59df211d051fa..fb30a42f0700d 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -25,7 +25,7 @@
 #include <asm/sparsemem.h>
 
 /* Generic implementation available */
-int numa_map_to_online_node(int node);
+int numa_nearest_node(int node, unsigned int state);
 
 #ifndef memory_add_physaddr_to_nid
 static inline int memory_add_physaddr_to_nid(u64 start)
@@ -44,10 +44,11 @@ static inline int phys_to_target_node(u64 start)
 }
 #endif
 #else /* !CONFIG_NUMA */
-static inline int numa_map_to_online_node(int node)
+static inline int numa_nearest_node(int node, unsigned int state)
 {
 	return NUMA_NO_NODE;
 }
+
 static inline int memory_add_physaddr_to_nid(u64 start)
 {
 	return 0;
@@ -58,6 +59,8 @@ static inline int phys_to_target_node(u64 start)
 }
 #endif
 
+#define numa_map_to_online_node(node) numa_nearest_node(node, N_ONLINE)
+
 #ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
 extern const struct attribute_group arch_node_dev_group;
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 29ebf1e7898cf..e52e3a0b8f2e6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -131,22 +131,26 @@ static struct mempolicy default_policy = {
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
 /**
- * numa_map_to_online_node - Find closest online node
+ * numa_nearest_node - Find nearest node by state
  * @node: Node id to start the search
+ * @state: State to filter the search
  *
- * Lookup the next closest node by distance if @nid is not online.
+ * Lookup the closest node by distance if @nid is not in state.
  *
- * Return: this @node if it is online, otherwise the closest node by distance
+ * Return: this @node if it is in state, otherwise the closest node by distance
  */
-int numa_map_to_online_node(int node)
+int numa_nearest_node(int node, unsigned int state)
 {
 	int min_dist = INT_MAX, dist, n, min_node;
 
-	if (node == NUMA_NO_NODE || node_online(node))
+	if (state >= NR_NODE_STATES)
+		return -EINVAL;
+
+	if (node == NUMA_NO_NODE || node_state(node, state))
 		return node;
 
 	min_node = node;
-	for_each_online_node(n) {
+	for_each_node_state(n, state) {
 		dist = node_distance(node, n);
 		if (dist < min_dist) {
 			min_dist = dist;
@@ -156,7 +160,7 @@ int numa_map_to_online_node(int node)
 
 	return min_node;
 }
-EXPORT_SYMBOL_GPL(numa_map_to_online_node);
+EXPORT_SYMBOL_GPL(numa_nearest_node);
 
 struct mempolicy *get_task_policy(struct task_struct *p)
 {
-- 
2.42.0



