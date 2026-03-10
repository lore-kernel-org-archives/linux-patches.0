Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0923E3859CE;
	Tue, 10 Mar 2026 11:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141665; cv=none; b=rWT/dmX0y7i/4E+PdsGDVmcdK1Za+FQSM+4v6qD5gavRUhbPOVmkYphKEW6hV+JRO5Ns1OcZ6uyv2LSiRAORa3OSIt8ZM4J0Sm6UY9ogwZ4QfK8fWpLX5NHfo64wPvC4yxv8Q5fWycvdJA+pv4fn8ViCdZi+0BjT+BxNvhcpZCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141665; c=relaxed/simple;
	bh=2tFn0JzQPfKqoe/l/HZKSpLLjySyyx84dcg/8DX3qTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2c6FSX5HPpiMftVcQa0/s48rrgfny+quW3iNC6FEIN777VD/bgRHMRozociWo9K+q6znsi7H1y1gaS+or5IQ6kYv3hSowwayG9bXRscUDmsxxi2jX4wYOaV0IRzKsOevHTZ3au2x/eq7iyQh3Xm6rsTpjcuTI4SCIBPC0bvcVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=io+YwoRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="io+YwoRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51789C19423;
	Tue, 10 Mar 2026 11:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141664;
	bh=2tFn0JzQPfKqoe/l/HZKSpLLjySyyx84dcg/8DX3qTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=io+YwoROztXAG0lqVjnrq3qH0+yTvT9+7WstD1qdwz9fWGoVAwQWqLsn5At6vrKBD
	 SWBZxp3uuZeUAK30GVaKzb+HlQY4j7Ca0qHsfVOXtpX6IS1BLcLYKIRGLRB1MdV7/H
	 laSAAC3ZfZwEE0mR+99BzLXEue3c+r+gzBLdCGReBwOzg4PVIFugGjdfNvWGMs8XjK
	 nK6Q1TtBhBe8KW6hCY24odDk3CdKadQ4u43qCTVoxZe9Nt0KvbShnlme15JX/fmMHA
	 wR5/CRO/mTdnkRsnx7kSHhF9yv9AQG/0bypTFgGxQXXhV9di/WuLA5RMQVDxtDCXuN
	 glNVTQMyg8wIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/314] cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in update_cpumasks_hier()
Date: Tue, 10 Mar 2026 07:14:51 -0400
Message-ID: <ccae447388b9268fb9e78e4804de096d3e1c8238.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit 68230aac8b9aad243626fbaf3ca170012c17fec5 ]

Commit e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
incorrectly changed the 2nd parameter of cpuset_update_tasks_cpumask()
from tmp->new_cpus to cp->effective_cpus. This second parameter is just
a temporary cpumask for internal use. The cpuset_update_tasks_cpumask()
function was originally called update_tasks_cpumask() before commit
381b53c3b549 ("cgroup/cpuset: rename functions shared between v1
and v2").

This mistake can incorrectly change the effective_cpus of the
cpuset when it is the top_cpuset or in arm64 architecture where
task_cpu_possible_mask() may differ from cpu_possible_mask.  So far
top_cpuset hasn't been passed to update_cpumasks_hier() yet, but arm64
arch can still be impacted. Fix it by reverting the incorrect change.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index abaa54037918a..08b0c264bd268 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2301,7 +2301,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		WARN_ON(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
-		cpuset_update_tasks_cpumask(cp, cp->effective_cpus);
+		cpuset_update_tasks_cpumask(cp, tmp->new_cpus);
 
 		/*
 		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
-- 
2.51.0

