Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901C8254AED;
	Thu, 17 Apr 2025 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915103; cv=none; b=Oqz//UXH53SVJmKRWbLasecqjsSMeXRfpPQVOqzU3ZwAImhSomaGyfluDdh0kVT0t2Kgy8MwU2tVw4w2PwuMIPeEVCI+9ZDkLMXA5kxQ6699wx7AhXWC5Z8thgJO1M2FIt0jBuBactrVCsuCoPGW3yJbdKj36MTSt6bQY+6kJwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915103; c=relaxed/simple;
	bh=p19HDgtccFSVoG90STBDcDPYoz5j6llpqMZNkXYvxws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAf4Od38XjOOmtgIO1C+BVN7Mfn/yqQx4vagetuG51oUIKtCb1a/difdQhtpFitLHSzI0yTQ6t4L3omDFNaQs7tPs3/gT5J0CitUZ6bPCHKMUheMJf4HmPdK+g5XWnxma5Hr1Rh11Dh9tRB2hB5HMHChZVvbh8jUK1WfrBlwMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VciUrZRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VciUrZRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B3FC4CEE4;
	Thu, 17 Apr 2025 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915103;
	bh=p19HDgtccFSVoG90STBDcDPYoz5j6llpqMZNkXYvxws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VciUrZRxTHuBDQF9vu0ePHDBlp0gcFmLOhnYMBfCiXlzFhZtTO/h6a7Y/l4/EonPC
	 FdOadk9mM8aE/P6ddKEuye5iMhRQuiSHGIxvjAJz9PjLiLjB2bE/tppQrs4jBhTn2y
	 1dysnzoSL72jhz8JpQwSmeNLgcOp/o/GE+pqlFVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/393] cgroup/cpuset: Fix incorrect isolated_cpus update in update_parent_effective_cpumask()
Date: Thu, 17 Apr 2025 19:46:51 +0200
Message-ID: <20250417175107.656967809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

[ Upstream commit 668e041662e92ab3ebcb9eb606d3ec01884546ab ]

Before commit f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to
partition & cpus changes"), a cpuset partition cannot be enabled if not
all the requested CPUs can be granted from the parent cpuset. After
that commit, a cpuset partition can be created even if the requested
exclusive CPUs contain CPUs not allowed its parent.  The delmask
containing exclusive CPUs to be removed from its parent wasn't
adjusted accordingly.

That is not a problem until the introduction of a new isolated_cpus
mask in commit 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in
isolated partitions") as the CPUs in the delmask may be added directly
into isolated_cpus.

As a result, isolated_cpus may incorrectly contain CPUs that are not
isolated leading to incorrect data reporting. Fix this by adjusting
the delmask to reflect the actual exclusive CPUs for the creation of
the partition.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 24ece85fd3b12..f7ad5651c93db 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1656,9 +1656,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (nocpu)
 			return PERR_NOCPUS;
 
-		cpumask_copy(tmp->delmask, xcpus);
-		deleting = true;
-		subparts_delta++;
+		deleting = cpumask_and(tmp->delmask, xcpus, parent->effective_xcpus);
+		if (deleting)
+			subparts_delta++;
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 	} else if (cmd == partcmd_disable) {
 		/*
-- 
2.39.5



