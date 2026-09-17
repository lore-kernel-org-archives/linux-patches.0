Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D905437C9;
	Thu, 17 Sep 2026 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658796; cv=none; b=HRCCF1wHaGC/M70SMu9Vf7NhdfgR6fxokt+AbHhHhhdR1ELRDo3wxrUA6791jxPW8uHUrX08eu4JCgMlfHok9BSdnzop0G2lVEwv2H+hIDtIQ5jlobKYdPAwKpveuHj3NdF0NkxF+GOjRX4fzmm1T6k0iBr/+HMz7r6yYFtm1Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658796; c=relaxed/simple;
	bh=2bIRECT9fCaguuJCkYNC12R1Z0c8w3ZNwXOUWMsXUn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENhydAY5FGhPLxtmLrjOay+bE6pM4qx2xpr8icz0B4EpVpr4TRMmaYzJu6mpP+vkp/MC0xT6ki8k1FK4yMrUtb6CaTdYf2v8ngjaIuOk0cqn5Mmhl2+k4YKbqq/3mmAo6UDTCm/HEO4/GBmtcF1z581k0XSHY6JgkKka/I1miXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/d8xCJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/d8xCJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694BC1F00899;
	Thu, 17 Sep 2026 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658773;
	bh=tGGMhYSLyFM4p+kz9GcdjwsLRZNWf9ww16pft7mOLGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/d8xCJNITJQGrtyEKJFCf4d/ay7xTJcRBqsRWbPf+fLPjoWEecJcX5Ls4bGLAnN8
	 x92pwosq0B9jEfs+Z4n9BenVf5J/u8ZeJHQNm/6/QvL452f20T4fZAn64tIfgQPPZZ
	 f04WUnlpRDy6MBc8ZX++qckZcVMtaA5iAHdm+sOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 033/733] cgroup/cpuset: Preserve boot-isolated CPUs on partition release
Date: Thu, 17 Sep 2026 16:05:41 +0100
Message-ID: <20260917151351.560072032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 6c37d7e074a4be1ba8da59f4ed5df8977b3daa43 ]

isolated_cpus tracks CPUs isolated with isolcpus= as well as CPUs in
isolated cpuset partitions. When an isolated partition is released,
isolated_cpus_update() removes its whole CPU mask. This also clears CPUs
which were already isolated at boot.

This can be reproduced on a cgroup v2 system booted with
isolcpus=domain,15:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir cpuset-repro
    echo 15 > cpuset-repro/cpuset.cpus
    echo isolated > cpuset-repro/cpuset.cpus.partition
    echo member > cpuset-repro/cpuset.cpus.partition
    cat cpuset.cpus.isolated

CPU 15 is absent before the change. It must remain in
cpuset.cpus.isolated after the partition is released.

Update isolated_cpus one CPU at a time and keep CPUs outside the
boot-time domain housekeeping mask isolated.

Fixes: c188f33c864e ("cgroup/cpuset: Account for boot time isolated CPUs")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1c6d568006688..69ff86e03c630 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1220,6 +1220,28 @@ static void reset_partition_data(struct cpuset *cs)
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 }
 
+/* Return true if isolated_cpus changes. */
+static bool isolated_cpu_update(int new_prs, int cpu)
+{
+	lockdep_assert_held(&callback_lock);
+	lockdep_assert_held(&cpuset_mutex);
+
+	if (new_prs == PRS_ISOLATED) {
+		if (cpumask_test_cpu(cpu, isolated_cpus))
+			return false;
+		cpumask_set_cpu(cpu, isolated_cpus);
+		return true;
+	}
+
+	/* CPUs isolated at boot must remain isolated. */
+	if (!cpumask_test_cpu(cpu,
+			      housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)) ||
+	    !cpumask_test_cpu(cpu, isolated_cpus))
+		return false;
+	cpumask_clear_cpu(cpu, isolated_cpus);
+	return true;
+}
+
 /*
  * isolated_cpus_update - Update the isolated_cpus mask
  * @old_prs: old partition_root_state
@@ -1228,19 +1250,16 @@ static void reset_partition_data(struct cpuset *cs)
  */
 static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask *xcpus)
 {
+	bool updated = false;
+	int cpu;
+
 	WARN_ON_ONCE(old_prs == new_prs);
 	lockdep_assert_held(&callback_lock);
 	lockdep_assert_held(&cpuset_mutex);
-	if (new_prs == PRS_ISOLATED) {
-		if (cpumask_subset(xcpus, isolated_cpus))
-			return;
-		cpumask_or(isolated_cpus, isolated_cpus, xcpus);
-	} else {
-		if (!cpumask_intersects(xcpus, isolated_cpus))
-			return;
-		cpumask_andnot(isolated_cpus, isolated_cpus, xcpus);
-	}
-	update_housekeeping = true;
+	for_each_cpu(cpu, xcpus)
+		updated |= isolated_cpu_update(new_prs, cpu);
+	if (updated)
+		update_housekeeping = true;
 }
 
 /*
-- 
2.53.0



