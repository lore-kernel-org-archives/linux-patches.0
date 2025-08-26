Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0C629BD98;
	Tue, 26 Aug 2025 11:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208811; cv=none; b=pMiZ4vqxrELSDljCSC/cEVEkLnPnLd9Z9rkT6baY/nNupI0x0BCheZokoVri0n3H4RJcVstTph7b65AzuaEZE+Ng+aMIeLeUcpUtgLunlBYnifA5dV6BicHXDmzBpaVZDrwtpxTkBdaldJKSd4Oovj6vlo1760OpMRKObKnq/VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208811; c=relaxed/simple;
	bh=oKgIT+k7S214UgybvZ/v3Pmcb0rW7rm9GuUUezmKWj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGCpKU0iCppWyTNKadZmAxH3ULsOMDR1UlQ2+uKvR4iaAHyWcMMV+Xs9mP/D3SU28z2RynWFRBLIWKODIfIh83qQGuA/MJML7nj8sO3xKBo8gOnoTleZPSKPF+qLM8t4vEbZOM/p/I7A4wAwUF1kliigMX/u8o9bq5KeGNujDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbRBrqhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbRBrqhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324EFC4CEF1;
	Tue, 26 Aug 2025 11:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208811;
	bh=oKgIT+k7S214UgybvZ/v3Pmcb0rW7rm9GuUUezmKWj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbRBrqhyQk325mUztuinprpqjSUkxqzpUk+4/MYTz04AtyWJZW4iD9E669KGvoJNR
	 49QPX6ABHkPOeWXWyCYf6eIlTGKtYRBwzqqYHkEHT3f4xSfEpY/tov4rMgVnKai7A0
	 5e/yXdW7P6EJoRZ8EbiBK91rpACmE4xMgw31P+ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/322] cgroup/cpuset: Fix a partition error with CPU hotplug
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826110922.232827737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 150e298ae0ccbecff2357a72fbabd80f8849ea6e ]

It was found during testing that an invalid leaf partition with an
empty effective exclusive CPU list can become a valid empty partition
with no CPU afer an offline/online operation of an unrelated CPU. An
empty partition root is allowed in the special case that it has no
task in its cgroup and has distributed out all its CPUs to its child
partitions. That is certainly not the case here.

The problem is in the cpumask_subsets() test in the hotplug case
(update with no new mask) of update_parent_effective_cpumask() as it
also returns true if the effective exclusive CPU list is empty. Fix that
by addding the cpumask_empty() test to root out this exception case.
Also add the cpumask_empty() test in cpuset_hotplug_update_tasks()
to avoid calling update_parent_effective_cpumask() for this special case.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index af5dc30bfe4b..25f9565f798d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1771,7 +1771,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
 						xcpus, parent->effective_xcpus);
-		} else if (is_partition_invalid(cs) &&
+		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
 			   cpumask_subset(xcpus, parent->effective_xcpus)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
@@ -3792,9 +3792,10 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		partcmd = partcmd_invalidate;
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-	 * back to a regular one.
+	 * back to a regular one with a non-empty effective xcpus.
 	 */
-	else if (is_partition_valid(parent) && is_partition_invalid(cs))
+	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
+		 !cpumask_empty(cs->effective_xcpus))
 		partcmd = partcmd_update;
 
 	if (partcmd >= 0) {
-- 
2.50.1



