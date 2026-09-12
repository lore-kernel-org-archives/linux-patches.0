Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887B3290B0;
	Sat, 12 Sep 2026 10:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210751; cv=none; b=k7MnjV9Emd6DvM4nWoRhFhNyQEucSiPnamKMSDWIoKoEksDJLxk2CZ7skPySHLbfacjkJmXs3j6X2COBDRMNf720Hxn1QV2PZIFC0/HB08s9dYbSrlj2hso1190umUxEGb7JdGEnQvjzai8+8ndDAzm1Fb43pVOGIZKUVEbs4+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210751; c=relaxed/simple;
	bh=NszlG4/dddsprCJQKCTa23ZgZGr9jTQLOc5xVKm0ksw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+wx3WcT4QgMblHmtUSYwIRFh5FYPbljnDMtZ8VCQI9Jd0vLVcyGxq7HMIQZVBPlgiJxF870D5AOLvqMgwLd1HN4S8B2lg44PDpYGw0ykCMCVIsUnmkxNuUtKXbwKQs5axwEFjTncCsHw0NG63OMqsh3W6+sCimOqjLzxNgHqEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ze6QLSOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze6QLSOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4391F000FF;
	Sat, 12 Sep 2026 10:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210750;
	bh=ukheYT0C97VUYDsU6wWUKe/KvtjhRVEjwxZkxwrqRCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ze6QLSOnX4+sjjhSu31kwtzjn0CvUy2NhYQH9lpXHYfVFA6vHtB3jJ5H9z+9C0MIR
	 8DU0mVVv4jTDoNma+eSbnkLzAUVXFQan2L/W92/M7UNnXsfD0wAHL1hRr9AtJZP0zi
	 /lGS7fRmGnsqPJEoWI9JjXQexjh1iEs9ZFansgRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1089/1518] cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates
Date: Sat, 12 Sep 2026 08:54:18 +0200
Message-ID: <20260912065648.086375797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 26d3a59e0241c3ef9f66ae1ae990f9326acbc059 ]

cpuset_partition_show() reads cs->prs_err without cpuset_mutex using
READ_ONCE(). The field is documented as not lock protected, but several
updates to live cpusets still use plain stores.

Convert the remaining prs_err stores on live cpusets to WRITE_ONCE().

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Assisted-by: LLM
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dacfc7481759b..6ab677c002181 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1618,7 +1618,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	spin_unlock_irq(&callback_lock);
 	update_isolation_cpumasks(isolcpus_updated);
 	cpuset_force_rebuild();
-	cs->prs_err = 0;
+	WRITE_ONCE(cs->prs_err, 0);
 
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
@@ -1697,7 +1697,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
 
 	if (cpumask_empty(excpus)) {
-		cs->prs_err = PERR_CPUSEMPTY;
+		WRITE_ONCE(cs->prs_err, PERR_CPUSEMPTY);
 		goto invalidate;
 	}
 
@@ -1712,13 +1712,13 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	if (adding) {
 		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
 		if (!capable(CAP_SYS_ADMIN))
-			cs->prs_err = PERR_ACCESS;
+			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
-			cs->prs_err = PERR_NOCPUS;
+			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
 		else if ((prs == PRS_ISOLATED) &&
 			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
-			cs->prs_err = PERR_HKEEPING;
+			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -2183,13 +2183,13 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		child->prs_err = 0;
+		WRITE_ONCE(child->prs_err, 0);
 		if (!cpumask_subset(child->effective_xcpus,
 				    cs->effective_xcpus))
-			child->prs_err = PERR_INVCPUS;
+			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
 		else if (populated &&
 			 cpumask_subset(new_ecpus, child->effective_xcpus))
-			child->prs_err = PERR_NOCPUS;
+			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
 
 		if (child->prs_err) {
 			int old_prs = child->partition_root_state;
@@ -2556,8 +2556,10 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
-	if (prs_err)
-		trialcs->prs_err = cs->prs_err = prs_err;
+	if (prs_err) {
+		WRITE_ONCE(cs->prs_err, prs_err);
+		trialcs->prs_err = prs_err;
+	}
 
 	if (is_remote_partition(cs)) {
 		if (trialcs->prs_err)
@@ -4014,7 +4016,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (remote && (cpumask_empty(subpartitions_cpus) ||
 			(cpumask_empty(&new_cpus) &&
 			 partition_is_populated(cs, NULL)))) {
-		cs->prs_err = PERR_HOTPLUG;
+		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
 		remote = false;
-- 
2.53.0



