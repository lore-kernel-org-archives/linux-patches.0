Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2BB22D7A8;
	Tue, 20 May 2025 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750095; cv=none; b=MRH3FTUs6pVDNNMSUZ3VbnEfoFKGPcOR9gNbRD5q7OhnboHbOW/+oXg28frlBBf1dz0OXh4dOh+hd2VNuGjBWWloaGf4QTw9G4wL8JJOD33oijqoCewRadeqRO0zLe7+gK0vo2UU+Xh39cVk85+BVj3u4TDkku0TO0l7dNFUD0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750095; c=relaxed/simple;
	bh=GSQqL9Kauw2w0XShKF1nAncE+ppkjFkHlgpGfqOmc7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gucTpBSOJMDf5lDi9zB3oCfjtPWDYElSGrDFCO/11XIZVXW+n4Me5CaQ9OO/5s61AxQcHiTRr6beeaB++Z1Yy6xlDayGkCCelFS8gFdqhFXEJXUMYPYWNYAT+nu/v1O3z2HQSUhtFx6gv97Edgy8fcdZtMl6sA1Ct1ECb99pCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPf1G4EB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPf1G4EB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A74C4CEE9;
	Tue, 20 May 2025 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750095;
	bh=GSQqL9Kauw2w0XShKF1nAncE+ppkjFkHlgpGfqOmc7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPf1G4EBG80gfOYcuYhtCO11RTWgFWUWHvXfHzIWW41+h2d5X1liBNJDzugOKKXJO
	 dJyerNzrLJC6mizP8TSBhg2kr43DlGVsnDxRZkpBCuvXCmykGATDOvujc+4QWlxOy7
	 aXxc0MIBw1feJFedu+E05lQRuT24XxNHQj3uqCNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/143] cgroup/cpuset: Extend kthread_is_per_cpu() check to all PF_NO_SETAFFINITY tasks
Date: Tue, 20 May 2025 15:49:25 +0200
Message-ID: <20250520125810.455314609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

[ Upstream commit 39b5ef791d109dd54c7c2e6e87933edfcc0ad1ac ]

Commit ec5fbdfb99d1 ("cgroup/cpuset: Enable update_tasks_cpumask()
on top_cpuset") enabled us to pull CPUs dedicated to child partitions
from tasks in top_cpuset by ignoring per cpu kthreads. However, there
can be other kthreads that are not per cpu but have PF_NO_SETAFFINITY
flag set to indicate that we shouldn't mess with their CPU affinity.
For other kthreads, their affinity will be changed to skip CPUs dedicated
to child partitions whether it is an isolating or a scheduling one.

As all the per cpu kthreads have PF_NO_SETAFFINITY set, the
PF_NO_SETAFFINITY tasks are essentially a superset of per cpu kthreads.
Fix this issue by dropping the kthread_is_per_cpu() check and checking
the PF_NO_SETAFFINITY flag instead.

Fixes: ec5fbdfb99d1 ("cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c709a05023cd9..d1fb4bfbbd4c3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1100,9 +1100,11 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 		if (top_cs) {
 			/*
-			 * Percpu kthreads in top_cpuset are ignored
+			 * PF_NO_SETAFFINITY tasks are ignored.
+			 * All per cpu kthreads should have PF_NO_SETAFFINITY
+			 * flag set, see kthread_set_per_cpu().
 			 */
-			if (kthread_is_per_cpu(task))
+			if (task->flags & PF_NO_SETAFFINITY)
 				continue;
 			cpumask_andnot(new_cpus, possible_mask, subpartitions_cpus);
 		} else {
-- 
2.39.5



