Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622673;
	b=i7u6yRcHyKrSNtXp0e+hkFtz1rgYWE1HJiK7B1ViaTjTHgC3bRL0dD6Cyu2/IgmfK5xX
	 y2JbLOb+SQbflHOn68mrCjbY531Jn/bMN2TEv+nJV1/KrrGGchRD/8Y2zbQjFGJEDmmQ9
	 KHBt1umN8tHWOKC/Mb6CqCpPBB2zgxDm/hmaO3BxRv3FRqTdd42rBbnGvfIKu6Cs2aoI1
	 ifuSapp+OQNpNUqO9eMNFmrsSxa+WQ6rYmKAXrm6CPcF9MbOgcO5PilItsB9FDzzJB25w
	 vvAnPu0rvcZSbZB/HujWZoQcUXRovEpWR9lSLnZmP+Uj4TjVbwveW+dOnUL3qeGZiEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrCGuQm8PeFn9NEKNU1DfFXBQl7dHpZ73lTiQp1JZew=;
	b=1io0usT+ty1JbNVHJL0UUzb8jYrKP/acqIQgHVsRyNQsreqlfwo2LmesEf8HPXLJdpGL
	 GEwS+pNpUiBH1f3Bix4QoaxridlrlYjzOT9kEyOjoGrDUoZ+00dZ/Mo/CKQQy7h5QfztU
	 IETx7+Fbmn5eZhEylsTZCt89pyaMuBoDuwecXvOsRahNWo7ci/qAcy6f0o9pKGLtUTme8
	 6QXnvxCkhrCF7MHyBRgtLG/8Kz+saJX3V1mBBrlTy3XyDtTgyHrAoGqnFta2e+7U98a+O
	 J3AP9vqtiiCNqWVbnvT+kB9aIG3AFSOPJ5P/VWvIr4LiXU8OV/RveEeoHGGJ3kLxOHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+5fL4hC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4637606A321;
	Wed, 25 Nov 2026 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+5fL4hC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1729B1F000D1;
	Wed, 25 Nov 2026 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622673;
	bh=hrCGuQm8PeFn9NEKNU1DfFXBQl7dHpZ73lTiQp1JZew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+5fL4hCzOWvyt6gZFjvYckkUV9r7u/zbw4WR5H3K89J3ejdai3f3B9LjgAr7Nzw/
	 L5ipLaUqkGrmsXOUAtfbPV7Zxi1hVrXRhulsoRUG0V2b2TbASCqgW+cec99EmtX5Ps
	 OpUeYTwEcfm3vJIyT4P7FMzW7IQIw5lWK8WOce/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 612/990] cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()
Date: Wed, 25 Nov 2026 15:32:59 +0100
Message-ID: <20261125143836.428365921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 46b885416c27214072272b85adb898ed91801062 ]

It is found that when a local isolated partition is being invalidated
because its parent partition is no longer valid, the isolated_cpus
cpumask may not be properly updated. Those isolated CPUs may or may
not needed to be removed from isolated_cpus depending on if there is
a local isolated partition ancestor that will now own those isolated
CPUs instead.

Fix that by calling a new ancestor_partition() helper to return the
closeset valid partition root ancestor. If that ancestor is PRS_ROOT,
the isolated CPUs will have to be removed from isolated_cpus. For
a PRS_ISOLATED ancestor, the isolated CPUs are checked against
the ancestor's ones to see if any of them should be removed as it is
possible that the invalidation of the parent may be caused by change in
the effective xcpus of that ancestor. If any of the isolated CPUs should
be removed, isolated_cpus_update() will be called under callback_lock.

An existing test case in test_cpuset_prs.sh is modifed and a new one
added to test that.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Selftest TEST_MATRIX rows were adapted to the older format with explicit ":S+" markers on non-leaf cpusets, while the cpuset.c changes match upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 57 +++++++++++++++++--
 .../selftests/cgroup/test_cpuset_prs.sh       |  6 +-
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e90fb48cf0f9b..3ef103c4b68d3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2232,6 +2232,25 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
+/*
+ * ancestor_partition - Find and return the closest valid partition root ancestor
+ * @cs: the current cpuset
+ *
+ * Return: The closet partition root ancestor cpuset
+ */
+static struct cpuset *ancestor_partition(struct cpuset *cs)
+{
+	struct cpuset *ancestor = parent_cs(cs);
+
+	/*
+	 * The top_cpuset is always a valid partition root which will stop
+	 * the loop if it is reached.
+	 */
+	while (!is_partition_valid(ancestor))
+		ancestor = parent_cs(ancestor);
+	return ancestor;
+}
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -2334,7 +2353,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * cpuset if the parent's effective_cpus changes.
 		 */
 		if ((cp != cs) && old_prs) {
-			switch (parent->partition_root_state) {
+			int parent_prs = parent->partition_root_state;
+			struct cpumask *del_cpus = NULL;
+
+			switch (parent_prs) {
 			case PRS_ROOT:
 			case PRS_ISOLATED:
 				update_parent = true;
@@ -2342,12 +2364,37 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
 			default:
 				/*
-				 * When parent is not a partition root or is
-				 * invalid, child partition roots become
-				 * invalid too.
+				 * When parent is not a valid partition root,
+				 * child partition roots become invalid too.
+				 *
+				 * For a to be invalidated isolated partition,
+				 * its isolated CPUs may or may not need to be
+				 * removed from isolated_cpus depending on if
+				 * its closest partition root ancestor is a root
+				 * or isolated partition. With a PRS_ISOLATED
+				 * ancestor, the CPUs are checked against its
+				 * effective xcpus to see if any of them needed
+				 * to be removed.
 				 */
 				if (is_partition_valid(cp))
-					new_prs = -cp->partition_root_state;
+					new_prs = -old_prs;
+
+				if (old_prs == PRS_ISOLATED) {
+					struct cpuset *ancestor = ancestor_partition(cp);
+
+					if (ancestor->partition_root_state == PRS_ROOT)
+						del_cpus = cp->effective_xcpus;
+					else if (cpumask_andnot(tmp->delmask,
+								cp->effective_xcpus,
+								ancestor->effective_xcpus))
+						del_cpus = tmp->delmask;
+
+					if (del_cpus) {
+						spin_lock_irq(&callback_lock);
+						isolated_cpus_update(old_prs, new_prs, del_cpus);
+						spin_unlock_irq(&callback_lock);
+					}
+				}
 				WRITE_ONCE(cp->prs_err,
 					   is_partition_invalid(parent)
 					   ? PERR_INVPARENT : PERR_NOTPART);
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 6f7e387f68e5b..ffa030cf1984d 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -291,9 +291,9 @@ TEST_MATRIX=(
 								       A1:P0|A2:P2|A3:P1 2-4|2-3"
 	" C0-4:S+ C1-4:S+ C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
 								       A1:P0|A2:P2|A3:P1 2"
-	" C0-4:X2-4:S+ C1-4:X2-4:S+:P2 C2-4:X4:P1 \
-				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
-								       A1:P0|A2:P-2|A3:P-1 ."
+	" C1-4:X2-4:S+ C2-4:X3-4:S+:P1 C3-4:X4:P2 \
+				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
+								       A1:P0|A2:P-1|A3:P-2 ."
 	" C0-4:X2-4:S+ C1-4:X2-4:S+:P2 C2-4:X4:P1 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
 								       A1:P0|A2:P2|A3:P-1 2-4"
-- 
2.53.0



