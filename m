Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C761170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC411C433C8;
	Mon, 11 Sep 2023 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441542;
	bh=BaT+VqXaI7dGK4RjxgW65NZws4d3Y6cQiQXER9AF+0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrCu+NtR4MYLce3FElaLiYJzen+XGe+Pmvv1SQi5kbaYPhG6jSRIUWvRZ7byiOPTj
	 ZyOaILe0SFoIsY3qejTCj6fdUixu7C0tN1Hbjgj0ZtK+FL4eI7vetUov/6a3xfucgZ
	 vg5S09Cav4pno2boumYr5UupgZ4tC2jhJ5Z3s4no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 449/739] cgroup/cpuset: Inherit parents load balance state in v2
Date: Mon, 11 Sep 2023 15:44:08 +0200
Message-ID: <20230911134703.704009497@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit c8c926200c55454101f072a4b16c9ff5b8c9e56f ]

Since commit f28e22441f35 ("cgroup/cpuset: Add a new isolated
cpus.partition type"), the CS_SCHED_LOAD_BALANCE bit of a v2 cpuset
can be on or off. The child cpusets of a partition root must have the
same setting as its parent or it may screw up the rebuilding of sched
domains. Fix this problem by making sure the a child v2 cpuset will
follows its parent cpuset load balance state unless the child cpuset
is a new partition root itself.

Fixes: f28e22441f35 ("cgroup/cpuset: Add a new isolated cpus.partition type")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58e6f18f01c1b..170e342b07e3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1588,11 +1588,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		}
 
 		/*
-		 * Skip the whole subtree if the cpumask remains the same
-		 * and has no partition root state and force flag not set.
+		 * Skip the whole subtree if
+		 * 1) the cpumask remains the same,
+		 * 2) has no partition root state,
+		 * 3) force flag not set, and
+		 * 4) for v2 load balance state same as its parent.
 		 */
 		if (!cp->partition_root_state && !force &&
-		    cpumask_equal(tmp->new_cpus, cp->effective_cpus)) {
+		    cpumask_equal(tmp->new_cpus, cp->effective_cpus) &&
+		    (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+		    (is_sched_load_balance(parent) == is_sched_load_balance(cp)))) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -1675,6 +1680,20 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
 		update_tasks_cpumask(cp, tmp->new_cpus);
 
+		/*
+		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
+		 * from parent if current cpuset isn't a valid partition root
+		 * and their load balance states differ.
+		 */
+		if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+		    !is_partition_valid(cp) &&
+		    (is_sched_load_balance(parent) != is_sched_load_balance(cp))) {
+			if (is_sched_load_balance(parent))
+				set_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
+			else
+				clear_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
+		}
+
 		/*
 		 * On legacy hierarchy, if the effective cpumask of any non-
 		 * empty cpuset is changed, we need to rebuild sched domains.
@@ -3222,6 +3241,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 		cs->use_parent_ecpus = true;
 		parent->child_ecpus_count++;
 	}
+
+	/*
+	 * For v2, clear CS_SCHED_LOAD_BALANCE if parent is isolated
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    !is_sched_load_balance(parent))
+		clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+
 	spin_unlock_irq(&callback_lock);
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
-- 
2.40.1



