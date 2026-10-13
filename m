Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0C4D98E6;
	Tue, 13 Oct 2026 11:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892492; cv=none; b=PIBqwTclgxx/DFG4lIFnC5fFp6W3dryIp+RA4jeAUe4s6uLeQ0mvgcgoGOB/5S3BIXnWkI64Pat0SoS5esFnKsox4j0n2uOfwmsC5skcmN1J7yon8keCb+QzCnyveYN5GXAMXoHR89DP2aZVc99aRlkb1SP8iMMPCEfKL9ZE3uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892492; c=relaxed/simple;
	bh=hsZKHge1CFhc1A+kGoF+GCMzXsqpzpHn36dsTU/U9mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBGeBvenSMmQY1IaUMT4xCCZWAD7isIFjGJ+9+UmqcSdvAzL0nq5R02NwHBghVdtTCFbM0zpXt1hhV3ir2g2zc0qQhDThoFxdxxEHV9AyhTaMF2VVQGCojvxhWj5NPSpdMUwzlwebUxcGfkY+/100iuuyHs2kiSiRcqtIMJPyOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhysAsRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhysAsRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162451F000FF;
	Tue, 13 Oct 2026 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892491;
	bh=VE+ce63qBxdliHxclhXiQ5qNGrJGDEFE4gQHNtIxEkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhysAsRKi4TcxPlXNdkW406i4QVy9skeNdQvz9Yk2zfGUuqofyY4kYcjXOP6m4DwG
	 T88klZ+dxGU2X18GjrhrH6FG2Kud598kJ1FeiHCaGLoHaIRtv3EBZAcfQKmsoSGd8Z
	 aw7tJ4XrEu/jXf29gghxwg4muNHx3TjtTVrWPcqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 191/281] cgroup/cpuset: Dont access cpuset_cgrp_subsys.root in is_in_v2_mode()
Date: Tue, 13 Oct 2026 13:38:27 +0200
Message-ID: <20261013112859.801386780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

[ Upstream commit e06b678e3b4e12fdaa0b51a7a5a54abc5dbd6469 ]

After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
me realize that is_in_v2_mode() may be called in a context where a new
cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
pointer. Avoid this potential UaF situation by adding a new cpuset_v2_mode
flag which is set when the cpuset_v2_mode mount option is used. This
flag is written into only when cpuset_bind() is being called with a
stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
modified to read the new cpuset_v2_mode flag instead of accessing
cpuset_cgrp_subsys.root directly.

[1] https://lore.kernel.org/lkml/20260929084124.626693-2-arighi@nvidia.com

Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2b86b76dba56b..16c554df4a50e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -151,6 +151,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
  */
 static bool		update_housekeeping;	/* RWCS */
 
+/*
+ * Set if "cpuset_v2_mode" mount option is used
+ * Cached at bind time and not lock protected; accessed via {READ,WRITE}_ONCE
+ */
+static bool		cpuset_v2_mode;
+
 /*
  * Copy of isolated_cpus to be passed to housekeeping_update()
  */
@@ -403,8 +409,7 @@ static inline bool cpuset_v2(void)
  */
 static inline bool is_in_v2_mode(void)
 {
-	return cpuset_v2() ||
-	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
+	return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
 }
 
 /**
@@ -3602,6 +3607,8 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 	mutex_lock(&cpuset_mutex);
 	spin_lock_irq(&callback_lock);
 
+	WRITE_ONCE(cpuset_v2_mode,
+		   !!(cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE));
 	if (is_in_v2_mode()) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
 		cpumask_copy(top_cpuset.effective_xcpus, cpu_possible_mask);
-- 
2.53.0



