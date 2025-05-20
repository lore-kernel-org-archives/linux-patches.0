Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972F3243371;
	Tue, 20 May 2025 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750546; cv=none; b=VgEZXLcaH0UYIlGsf3SRm+7ZKuUWWMtUguE9dPy1ANDzL6UBa3aeuAyi1HXKR8il6Xco6RBMVMVM85ERaSf9BCj4mvhoLaBCyOJm9d+Yw/54FnqW1g8RpRvPJVRQhTX1wu30B6mjwWAy2atQJxO6VrGVhL9Jep1eg9o9sWmO8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750546; c=relaxed/simple;
	bh=jw+jNYNDcgDYJ/YAU43vzR8HDJ0xfkViZ1VEMmusJKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D64kAM6CnkgEHZqDNt+us4tJhAUvmlkjzKbww0/u/0NBCRtYlOBO9xxld6fRhmHHeEWrFf0tZcVPCQuU3sy75hrSB9K4Nqm4w+y+H027KBoCGFNFZboNDF7TM4UKRVWP3Bj+ZtgWp/TpHTubiatoVv55iVJzzR/sJmy6ag+iy34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHNj5EkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHNj5EkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F25CC4CEE9;
	Tue, 20 May 2025 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750546;
	bh=jw+jNYNDcgDYJ/YAU43vzR8HDJ0xfkViZ1VEMmusJKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHNj5EkVNj4PXa64XhRjmebXOVszBd7ITpsgtrX5pB3xj41DQdw1dZU1hOC/kw6h/
	 cXHcFKSRa+0rPdXOT06aeyjt2JAvOe6X5+Nh8XhW17Eub2KwrOWt6TpbB0Okw2x/KS
	 ao0M4S5Ty9M+35C1fCssaSx5XPGRIWevYL5Re0/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 013/145] cgroup/cpuset: Extend kthread_is_per_cpu() check to all PF_NO_SETAFFINITY tasks
Date: Tue, 20 May 2025 15:49:43 +0200
Message-ID: <20250520125811.068409445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 1287274ae1ce9..6fbffdca0c741 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1116,9 +1116,11 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
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



