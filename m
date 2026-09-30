Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6374522F1F;
	Wed, 30 Sep 2026 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793709; cv=none; b=tjRPiKB8OCTUbLaRreqd9Os9GA0PR7ir/vPIwyT/kDMLNpV7mF+9wLXXdRRIZKtdzWud6XUUYmY3llC+MbsjOho4ZQnOIQKAo+nCgRIWAMbacyLddSPtZrXc825sKqaGh0Vo2+EA7qu0A4o201g0W/h2wyVXi7MsGxbllq7umfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793709; c=relaxed/simple;
	bh=B+TnPhamw+y7RwPg07/deEzLlltzxcS5e4jUjr7gkiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHIfKO+I+LLqOfhv0RbDhoBpXPO0enQ8ARvBP/AoBHVsH71qTb4YGOdahkEnxx2YVTk+bYqBTCvyV11bI2iyltIGjInEKGgJ5Kl1ptkbCpWsIw7glB7cJa8mSrob0JuF+ZLx8Qa4Z84OLi7gYyBVYVcuB3oK+4YGReWJwdjrYsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTneuTxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTneuTxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8631F000FF;
	Wed, 30 Sep 2026 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793707;
	bh=WtUO8sDXY3djrTX4OhI5cLEa8rWQCCvw1QcTv8Gd+Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTneuTxI68hiR/G704go1CgL0pX0dRaA3XlI3SAoJcwGyYHZOQ7VGiipzbBX2H+sh
	 1XrkTZ5dgQQcbsLvmBsVH46u40k7eEv51UtKM0d1wPHTovLgsV20hs5BYhQE6zVYVF
	 lzIQ3yIHm7is3a6fIt1kCOwv6AnIjSgBh9RCsYnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/395] cgroup/cpuset: Move up prstate_housekeeping_conflict() helper
Date: Wed, 30 Sep 2026 17:30:11 +0200
Message-ID: <20260930152348.249348489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6cfeddbf4ade9202849d75c27c4d0c82b42c73d1 ]

Move up the prstate_housekeeping_conflict() helper so that it can be
used in remote partition code.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 31c88350b7dd ("cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1449,6 +1449,26 @@ static bool isolated_cpus_can_update(str
 	return res;
 }
 
+/*
+ * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
+ * @prstate: partition root state to be checked
+ * @new_cpus: cpu mask
+ * Return: true if there is conflict, false otherwise
+ *
+ * CPUs outside of boot_hk_cpus, if defined, can only be used in an
+ * isolated partition.
+ */
+static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
+{
+	if (!have_boot_isolcpus)
+		return false;
+
+	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
+		return true;
+
+	return false;
+}
+
 static void update_isolation_cpumasks(bool isolcpus_updated)
 {
 	int ret;
@@ -1751,26 +1771,6 @@ invalidate:
 	remote_partition_disable(cs, tmp);
 }
 
-/*
- * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
- * @prstate: partition root state to be checked
- * @new_cpus: cpu mask
- * Return: true if there is conflict, false otherwise
- *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
- * isolated partition.
- */
-static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
-{
-	if (!have_boot_isolcpus)
-		return false;
-
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
-		return true;
-
-	return false;
-}
-
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state


