Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948BC1A6803;
	Tue, 16 Jun 2026 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623735; cv=none; b=daKwCugcTg8mimsbl+38Q4wrxgszH0VFrjRuuCLci4nV+b+epO0klRIJ1SedLD3v2QnRapP+bBiIFp50yS7oG1SmAqtOVTq45cL2gAz8Y4iLyf2Id3m/TZVGXDS9ptDHnF/5+lnhCligPBdxVQ+noI2wau/zCGGcqWB/773VHFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623735; c=relaxed/simple;
	bh=dE81CNlwl+aIpShqf3U2O/NRdS4hmPCzPMF0DUypy6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/OaAKoXF8mIuUz/hGyTb3aIaCDOhWzsBvqQndJgttEeePYuKhHevDXhRR7XlEB3UfqC3sy3wm1HMSOsT3SlwcFIV1h5r75/6XNa0t8F3gURAkphWD6dpt4dhJ4Ov6Nh8hSowQKti0qh2+tsUQuvmTEDFAhSZMpaXIqdfDQ4cUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npxzUAuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npxzUAuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0386F1F000E9;
	Tue, 16 Jun 2026 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623733;
	bh=Cnj8XdyETqbvYzRlpy9d1CRq6kXmQ9Qc95IkJUPzlPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npxzUAuTAs8acGJxKjNUivlWMhEiJ0BCdbZcDS5pPki9Iz6RIgAl1lSGWrYGR1Hqv
	 byfxYttoEboFekZ2ZMr9fswgvUIEngsf8gm8iXXADIHFpFQ72I/Pizj3TthpNLDiVU
	 k0qhhtEVNEfVXYYtdpUEbMDnxSLfer8GEg2jL+9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Guopeng <zhangguopeng@kylinos.cn>,
	Sun Shaojie <sunshaojie@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.0 186/378] cgroup/cpuset: Use effective_xcpus in partcmd_update add/del mask calculation
Date: Tue, 16 Jun 2026 20:26:57 +0530
Message-ID: <20260616145120.169512940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun Shaojie <sunshaojie@kylinos.cn>

commit 0a68853de27b522bca2b9934127277185374a24f upstream.

When sibling CPU exclusion occurs, a partition's user_xcpus may contain
CPUs that were never actually granted to it. These CPUs are present in
user_xcpus(cs) but not in cs->effective_xcpus.

The partcmd_update path in update_parent_effective_cpumask() uses
user_xcpus(cs) (via the local variable xcpus) to compute the addmask
(CPUs to return to parent) and delmask (CPUs to request from parent).
This is incorrect:

 1) When newmask removes a CPU that was previously excluded by a
    sibling, addmask incorrectly includes that CPU and tries to return
    it to the parent even though the partition never actually owned it,
    causing CPU overlap with sibling partitions and triggering warnings
    in generate_sched_domains().

 2) When newmask adds a previously excluded CPU that is now available,
    delmask fails to request it from the parent because user_xcpus(cs)
    already includes it.

Fix this by using cs->effective_xcpus instead of user_xcpus(cs) in all
partcmd_update paths that calculate addmask or delmask, including the
PERR_NOCPUS error handling paths.

Reproducers:

  Example 1 - Removing a sibling-excluded CPU incorrectly returns it:

    # cd /sys/fs/cgroup
    # echo "0-1" > a1/cpuset.cpus
    # echo "root" > a1/cpuset.cpus.partition
    # echo "0-2" > b1/cpuset.cpus
    # echo "root" > b1/cpuset.cpus.partition
    # echo "2" > b1/cpuset.cpus
    # cat cpuset.cpus.effective
    # Actual: 0-1,3    Expected: 3

  Example 2 - Expanding to a previously excluded CPU fails to request it:

    # cd /sys/fs/cgroup
    # echo "0-1" > a1/cpuset.cpus
    # echo "root" > a1/cpuset.cpus.partition
    # echo "0-2" > b1/cpuset.cpus
    # echo "root" > b1/cpuset.cpus.partition
    # echo "member" > a1/cpuset.cpus.partition
    # echo "1-2" > b1/cpuset.cpus
    # cat cpuset.cpus.effective
    # Actual: 0-1,3    Expected: 0,3

Fixes: 2a3602030d80 ("cgroup/cpuset: Don't invalidate sibling partitions on cpuset.cpus conflict")
Cc: stable@vger.kernel.org # v7.0+
Suggested-by: Zhang Guopeng <zhangguopeng@kylinos.cn>
Signed-off-by: Sun Shaojie <sunshaojie@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5c33ab20cc20..c9e14fda3d6f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1811,9 +1811,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 * Compute add/delete mask to/from effective_cpus
 		 *
 		 * For valid partition:
-		 *   addmask = exclusive_cpus & ~newmask
+		 *   addmask = effective_xcpus & ~newmask
 		 *			      & parent->effective_xcpus
-		 *   delmask = newmask & ~exclusive_cpus
+		 *   delmask = newmask & ~effective_xcpus
 		 *		       & parent->effective_xcpus
 		 *
 		 * For invalid partition:
@@ -1825,11 +1825,11 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			deleting = cpumask_and(tmp->delmask,
 					newmask, parent->effective_xcpus);
 		} else {
-			cpumask_andnot(tmp->addmask, xcpus, newmask);
+			cpumask_andnot(tmp->addmask, cs->effective_xcpus, newmask);
 			adding = cpumask_and(tmp->addmask, tmp->addmask,
 					     parent->effective_xcpus);
 
-			cpumask_andnot(tmp->delmask, newmask, xcpus);
+			cpumask_andnot(tmp->delmask, newmask, cs->effective_xcpus);
 			deleting = cpumask_and(tmp->delmask, tmp->delmask,
 					       parent->effective_xcpus);
 		}
@@ -1868,7 +1868,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			part_error = PERR_NOCPUS;
 			deleting = false;
 			adding = cpumask_and(tmp->addmask,
-					     xcpus, parent->effective_xcpus);
+					     cs->effective_xcpus, parent->effective_xcpus);
 		}
 	} else {
 		/*
@@ -1890,7 +1890,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
-						xcpus, parent->effective_xcpus);
+						     cs->effective_xcpus,
+						     parent->effective_xcpus);
 		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
 			   cpumask_subset(xcpus, parent->effective_xcpus)) {
 			struct cgroup_subsys_state *css;
-- 
2.54.0



