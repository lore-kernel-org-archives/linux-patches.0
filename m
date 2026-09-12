Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF173BE175;
	Sat, 12 Sep 2026 07:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196898; cv=none; b=Pi3L0ZL1LKdvyuLOKbjnOJe+b3OI/UvD2ACdoVaeiH2FTY4Y/3aQ010vARchCslsXN3H6Kead1iA+mWZghgoIKNiM/3Y9P+Wyb0jB7+BDDXwgfFe/QHfTY0cB+a/PUgooSsfjBHN/Aeb2gNHbIvRA9h0EdEHA6IWoU86lJUIfiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196898; c=relaxed/simple;
	bh=9plSxbzIR9/y5Z7pLr51EjskLMOfEP/EW8p8ge76UU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNiPG+v8KAKbt4tMbPqgQORjK9bnOKZh48wGEFAlFcgksV5pW4oNINSACq0XEVSaP33CqfE4RC6GWC6qIWztsVr63fKtws1/Q+9LLIsTVsBektGV6iMKKbkYLzNppqJN0VeYbj/mUhxZjmmzsQB1RyocYRIay2dJL68mKoI+wUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx4svdiz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx4svdiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CFC1F000FF;
	Sat, 12 Sep 2026 07:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196896;
	bh=o771KH/07E5TIwKs+lEbg1C2Iw0PKV9EWFnNeWWsXZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zx4svdizLZULL7ozpTY15EiKWTVmzXX4ZeW1GLZGVeu3ad72M21hDUHTl4X9jygXt
	 QNRP1hx72pUgZYI6KLhn3qmPzQD/JbBEAJedcbjHkXLHAhK2/5bzgaqMSGp17U60VR
	 5x1NJAt+dfzPRico/dzyDz+RnOStTpquIJDLLmgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <ridong.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0060/1815] cgroup/cpuset: Avoid unnecessary cpus & mems update in cpuset_hotplug_update_tasks()
Date: Sat, 12 Sep 2026 08:30:10 +0200
Message-ID: <20260912065650.421726085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 866f587e9c70566a0391bf402123555605a82f81 ]

As reported by sashiko [1], cpuset_hotplug_update_tasks() may perform
unnecessary task iteration and updating of tasks' CPU and node masks
when mems_allowed and/or cpus_allowed are not set in cpuset v2. It is
due to the fact that the temporary new_cpus and new_mems masks do not
inherit parent's effective_cpus/mems when they are empty which is the
expected behavior for cpuset v2 since commit 4ec22e9c5a90 ("cpuset:
Enable cpuset controller in default hierarchy").

Fix that and avoid unnecessary work by enhancing
compute_effective_cpumask() to add the empty cpumask check
and inheriting the parent's versions if empty when in v2. A new
compute_effective_nodemask() helper is also added to perform a similar
function for new effective_mems.

Add new test_cpuset_prs.sh test cases to confirm that effective_cpus
will inherit the parent's version if cpuset.cpus is empty.

[1] https://sashiko.dev/#/patchset/20260621032816.1806773-1-longman%40redhat.com

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Fixes: 4ec22e9c5a90 ("cpuset: Enable cpuset controller in default hierarchy")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 45 +++++++++++--------
 .../selftests/cgroup/test_cpuset_prs.sh       | 11 ++++-
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 45944b3e31ca4..cce1f0e292ade 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1089,12 +1089,35 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
  * @cs: the cpuset the need to recompute the new effective_cpus mask
  * @parent: the parent cpuset
  *
+ * For v2, the parent's effective_cpus is inherited if cpumask is empty.
  * The result is valid only if the given cpuset isn't a partition root.
  */
 static void compute_effective_cpumask(struct cpumask *new_cpus,
 				      struct cpuset *cs, struct cpuset *parent)
 {
-	cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
+	bool has_cpus;
+
+	has_cpus = cpumask_and(new_cpus, cs->cpus_allowed, parent->effective_cpus);
+	if (!has_cpus && is_in_v2_mode())
+		cpumask_copy(new_cpus, parent->effective_cpus);
+}
+
+/**
+ * compute_effective_nodemask - Compute the effective nodemask of the cpuset
+ * @new_mems: the temp variable for the new effective_mems mask
+ * @cs: the cpuset the need to recompute the new effective_mems mask
+ * @parent: the parent cpuset
+ *
+ * For v2, the parent's effective_mems is inherited if nodemask is empty.
+ */
+static void compute_effective_nodemask(nodemask_t *new_mems,
+				       struct cpuset *cs, struct cpuset *parent)
+{
+	bool has_mems;
+
+	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
+	if (!has_mems && is_in_v2_mode())
+		nodes_copy(*new_mems, parent->effective_mems);
 }
 
 /*
@@ -2143,15 +2166,6 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			goto update_parent_effective;
 		}
 
-		/*
-		 * If it becomes empty, inherit the effective mask of the
-		 * parent, which is guaranteed to have some CPUs unless
-		 * it is a partition root that has explicitly distributed
-		 * out all its CPUs.
-		 */
-		if (is_in_v2_mode() && !remote && cpumask_empty(tmp->new_cpus))
-			cpumask_copy(tmp->new_cpus, parent->effective_cpus);
-
 		/*
 		 * Skip the whole subtree if
 		 * 1) the cpumask remains the same,
@@ -2697,14 +2711,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 
-		bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
-
-		/*
-		 * If it becomes empty, inherit the effective mask of the
-		 * parent, which is guaranteed to have some MEMs.
-		 */
-		if (is_in_v2_mode() && !has_mems)
-			*new_mems = parent->effective_mems;
+		compute_effective_nodemask(new_mems, cp, parent);
 
 		/* Skip the whole subtree if the nodemask remains the same. */
 		if (nodes_equal(*new_mems, cp->effective_mems)) {
@@ -3778,7 +3785,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	parent = parent_cs(cs);
 	compute_effective_cpumask(&new_cpus, cs, parent);
-	nodes_and(new_mems, cs->mems_allowed, parent->effective_mems);
+	compute_effective_nodemask(&new_mems, cs, parent);
 
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 0d41aa0d343d9..ca9bc38fdb95d 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -495,13 +495,20 @@ REMOTE_TEST_MATRIX=(
 	# Narrowing cpuset.cpus to previously sibling-excluded CPUs should
 	# not return CPUs that were never actually owned.
 	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
-	      .      .     .         C3    .       .     p1:4|c11:1-2|c12:3 \
+	      .      .     .       C3      .       .     p1:4|c11:1-2|c12:3 \
 							 p1:P1|c11:P1|c12:P2 3"
 	# Expanding cpuset.cpus to include a previously sibling-excluded CPU
 	# after the sibling has become a member should correctly request it.
 	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
-	      .      .      P0     C2-3    .       .     p1:1,4|c11:1|c12:2-3 \
+	      .      .     P0      C2-3    .       .     p1:1,4|c11:1|c12:2-3 \
 							 p1:P1|c11:P0|c12:P2 2-3"
+	# Cpusets with empty cpuset.cpus should inherit parent's effective_cpus
+	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
+	      .      P1    P1      .       .       .     p1:3-4|p2:5-6|c11:1-2|c12:3-4|c21:5|c22:5-6 \
+							 p1:P1|p2:P1|c11:P1"
+	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
+	      .      P1    P1      .      O5=0     .     p1:3-4|p2:6|c11:1-2|c12:3-4|c21:6|c22:6 \
+							 p1:P1|p2:P1|c11:P1"
 )
 
 #
-- 
2.53.0



