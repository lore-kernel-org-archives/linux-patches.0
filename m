Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308C0192D6C;
	Tue, 10 Sep 2024 09:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961526; cv=none; b=M6BGkKpll32bQnzd/AVWgYpG1wubiT0vpxZ4rnu/9HyLfz3x3lNUkXwFyteYf6TVR+KUUD9ohYVN0l1f37hNZxJObdOSugxo3l1vFHoDnf9bSzsEpfWHo6i0GPfrF8EoLmNwLQoGjuOzZm6ZUHETM2Pu3cDV8NlywvVk1S6xL2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961526; c=relaxed/simple;
	bh=sCPZztrJNR8edV6SNmfRAHvmvV61NOEfMz9+sHIQAYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9yvFJS0+zbtDUSzPVeQbV+lXy27AhpmTQoHJcZMiX4i1hrcj7sXJ7WskZHny7y+egmGFp0ManIpq+1i+EMzlga3WPD2sLDVibg5rkK9U3oTdwZzmzsrMG1XGbiknALhr6D+dYgDz3e9Js9uKMHlmSPffGocuzckilXvbRYaN4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGyK/+p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGyK/+p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C015C4CEC6;
	Tue, 10 Sep 2024 09:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961526;
	bh=sCPZztrJNR8edV6SNmfRAHvmvV61NOEfMz9+sHIQAYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGyK/+p3lNKNiZF+ckP6HU3zc8QFAsp1CKl25E4chFtvwYNeJaXvRezPxSFOGIv9B
	 Qg/QAtEm/u9WgyBEbfnh287CALEVdg1EUcFTZXeFMFhV3/UjyiCve2TSonI5nvgGOE
	 U2mAEDgiUJ5S8fV18G9vGG4k7zTON7c7QRiMVyBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/375] cgroup/cpuset: Delay setting of CS_CPU_EXCLUSIVE until valid partition
Date: Tue, 10 Sep 2024 11:28:16 +0200
Message-ID: <20240910092625.568580117@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit fe8cd2736e75c8ca3aed1ef181a834e41dc5310f ]

The CS_CPU_EXCLUSIVE flag is currently set whenever cpuset.cpus.exclusive
is set to make sure that the exclusivity test will be run to ensure its
exclusiveness. At the same time, this flag can be changed whenever the
partition root state is changed. For example, the CS_CPU_EXCLUSIVE flag
will be reset whenever a partition root becomes invalid. This makes
using CS_CPU_EXCLUSIVE to ensure exclusiveness a bit fragile.

The current scheme also makes setting up a cpuset.cpus.exclusive
hierarchy to enable remote partition harder as cpuset.cpus.exclusive
cannot overlap with any cpuset.cpus of sibling cpusets if their
cpuset.cpus.exclusive aren't set.

Solve these issues by deferring the setting of CS_CPU_EXCLUSIVE flag
until the cpuset become a valid partition root while adding new checks
in validate_change() to ensure that cpuset.cpus.exclusive of sibling
cpusets cannot overlap.

An additional check is also added to validate_change() to make sure that
cpuset.cpus of one cpuset cannot be a subset of cpuset.cpus.exclusive
of a sibling cpuset to avoid the problem that none of those CPUs will
be available when these exclusive CPUs are extracted out to a newly
enabled partition root. The Documentation/admin-guide/cgroup-v2.rst
file is updated to document the new constraints.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  8 ++++--
 kernel/cgroup/cpuset.c                  | 36 ++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8fbb0519d556..b69f701b2485 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2346,8 +2346,12 @@ Cpuset Interface Files
 	is always a subset of it.
 
 	Users can manually set it to a value that is different from
-	"cpuset.cpus".	The only constraint in setting it is that the
-	list of CPUs must be exclusive with respect to its sibling.
+	"cpuset.cpus".	One constraint in setting it is that the list of
+	CPUs must be exclusive with respect to "cpuset.cpus.exclusive"
+	of its sibling.  If "cpuset.cpus.exclusive" of a sibling cgroup
+	isn't set, its "cpuset.cpus" value, if set, cannot be a subset
+	of it to leave at least one CPU available when the exclusive
+	CPUs are taken away.
 
 	For a parent cgroup, any one of its exclusive CPUs can only
 	be distributed to at most one of its child cgroups.  Having an
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fc1c6236460d..e8f24483e05f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -826,17 +826,41 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/*
 	 * If either I or some sibling (!= me) is exclusive, we can't
-	 * overlap
+	 * overlap. exclusive_cpus cannot overlap with each other if set.
 	 */
 	ret = -EINVAL;
 	cpuset_for_each_child(c, css, par) {
-		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
-		    c != cur) {
+		bool txset, cxset;	/* Are exclusive_cpus set? */
+
+		if (c == cur)
+			continue;
+
+		txset = !cpumask_empty(trial->exclusive_cpus);
+		cxset = !cpumask_empty(c->exclusive_cpus);
+		if (is_cpu_exclusive(trial) || is_cpu_exclusive(c) ||
+		    (txset && cxset)) {
 			if (!cpusets_are_exclusive(trial, c))
 				goto out;
+		} else if (txset || cxset) {
+			struct cpumask *xcpus, *acpus;
+
+			/*
+			 * When just one of the exclusive_cpus's is set,
+			 * cpus_allowed of the other cpuset, if set, cannot be
+			 * a subset of it or none of those CPUs will be
+			 * available if these exclusive CPUs are activated.
+			 */
+			if (txset) {
+				xcpus = trial->exclusive_cpus;
+				acpus = c->cpus_allowed;
+			} else {
+				xcpus = c->exclusive_cpus;
+				acpus = trial->cpus_allowed;
+			}
+			if (!cpumask_empty(acpus) && cpumask_subset(acpus, xcpus))
+				goto out;
 		}
 		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
-		    c != cur &&
 		    nodes_intersects(trial->mems_allowed, c->mems_allowed))
 			goto out;
 	}
@@ -1376,7 +1400,7 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
  */
 static int update_partition_exclusive(struct cpuset *cs, int new_prs)
 {
-	bool exclusive = (new_prs > 0);
+	bool exclusive = (new_prs > PRS_MEMBER);
 
 	if (exclusive && !is_cpu_exclusive(cs)) {
 		if (update_flag(CS_CPU_EXCLUSIVE, cs, 1))
@@ -2624,8 +2648,6 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		retval = cpulist_parse(buf, trialcs->exclusive_cpus);
 		if (retval < 0)
 			return retval;
-		if (!is_cpu_exclusive(cs))
-			set_bit(CS_CPU_EXCLUSIVE, &trialcs->flags);
 	}
 
 	/* Nothing to do if the CPUs didn't change */
-- 
2.43.0



