Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021233;
	b=i8wi9qZFAOvvF2XXn4lxnljEXuTbpAnW1MD9bBxSgBC9CrTzBjxblRrvuVs5nFw4MLF4
	 vrpRKAZtGov861oKaA9sWz7GkzQ5dGCJEWDq7NMQzYyL8MFMl3gMJhj6Qbcdsrd0GD9st
	 0eJQ6xIrJ0S9Ujea9bAHl5AmYjk2ixYWP7VRNgYxZ2HfxyZ0OZWOee8bKeM+Ci+8N6yuX
	 ptKA7FcB4E1L23qiHj/TLmqT2cb76Xma5JKiEeD5XfRewZb/w4SsDnBgyUmzflDvWwStz
	 B5VfmZXYTJe0Ct1EYmq21s+bfTjtw2a9mYBCHg/5vJ0sRq65vSBPIUHyDQanNTqpP0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuXiMAk60aMk65POWT0VL/Kni+LMgOcFGgSRa2Q/rU0=;
	b=fLsK7D3Kr0SaGNzRFtUBYIOdNKBrDit2l1Sdp1iczng6srul9Ys76I92xygs/RiKxr++
	 0VmvwvuqZ+TLXYTiEeagEZeMZZN0DdV/ze6nklhKAscIxgofYeJKZwR4PlRuJ6FURnleJ
	 k/xxoZ70vTjz7x1Fc8Gk8MvdC5MG24ovU6Ln+sdHd37GNUw/qrHSEKSnF0Ln5LvKvipVT
	 qT7UaP4bdqSFi+6RO3jjdogDHP8NjLxxkAzcsKps1WVd89aCxAPajGpPNIi1gnvK2sTng
	 3DLzak/UeI3KJFiGKXqxuflxFKy4FeOe2uvO3+Fe8N//bT0ATGB1NRNo9LmL+0ujKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcJ0EDOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF91606A32A;
	Wed, 18 Nov 2026 17:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcJ0EDOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE23B1F000C4;
	Wed, 18 Nov 2026 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021233;
	bh=MuXiMAk60aMk65POWT0VL/Kni+LMgOcFGgSRa2Q/rU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcJ0EDODtw/3uUfeNnnvDpg8L5MnuVbSV98ZZQkKJdmEg1pdW5csfZ54fnXdmLrR+
	 8XR2pzcCqDVQOz5BcjaGwQVrNg1S+UMT3IJaRJ/2xbyLNxlwoD6nbrB1heZZfYdfNn
	 62lMcV34rYBVB/Xh/CcOIOyux4Qw53hYcKr1o8mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2183/2651] cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()
Date: Wed, 18 Nov 2026 15:57:03 +0100
Message-ID: <20261118150404.361437549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 57 +++++++++++++++++--
 .../selftests/cgroup/test_cpuset_prs.sh       |  6 +-
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4a3c8882dec88..f4a6259e9838a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2178,6 +2178,25 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
@@ -2270,7 +2289,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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
@@ -2278,12 +2300,37 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
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
index f7cc9da57b556..6859cde73af1a 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -292,9 +292,9 @@ TEST_MATRIX=(
 								       A1:P0|A2:P2|A3:P1 2-4|2-3"
 	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
 								       A1:P0|A2:P2|A3:P1 2"
-	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
-				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
-								       A1:P0|A2:P-2|A3:P-1 ."
+	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
+				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
+								       A1:P0|A2:P-1|A3:P-2 ."
 	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
 								       A1:P0|A2:P2|A3:P-1 2-4"
-- 
2.53.0



