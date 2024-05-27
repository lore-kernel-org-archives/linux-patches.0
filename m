Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9D0168C4;
	Mon, 27 May 2024 19:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837383; cv=none; b=dZF2He6ukLOqFO22C2ArxqOfQpI2vAOiDHaaKBcxnyDn/iINt13xYBlM+iyU46Ht2B4h9VYQ/Var1JRQJYJEdOwktXvFEAyvAy78A0xR3pHy7aUYFotazo972odjGyW7BZMzdMvReOwddHCGs6hkT5fZHN9qmkAYWnK0LxcHeVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837383; c=relaxed/simple;
	bh=NhV41s+PcMPqQ4xIPa7vQlKQ8EiLiSSgr3EauR2zAkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDxIyMeUpenG45qcxUen/5xEbMkE6J6Ppd77gUuCaNKPEdHQLCiVSO93rKJ4RTacx+CUsCMIybUjee8zcOoq7sSS5MVQEahkJtAjxocZBS9edRiQImOVYDcn0JflSp8HYKg2Wc5N/fFBEpraTWE3sZ2fhls8/vbtwj5eY2uO93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z23bzKJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z23bzKJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2ACC32781;
	Mon, 27 May 2024 19:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837382;
	bh=NhV41s+PcMPqQ4xIPa7vQlKQ8EiLiSSgr3EauR2zAkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z23bzKJ2flFbUkooBFLn/Q4rUG0VEmPSi1SxENhZb73WSMT7zEvMDnWr3p8kgEe7G
	 Zso1RUtE0Pr7fTP9Pkv2JFFl2u/rJjbUD82aGSvw6rGo+bqFmIL3AO0dBv11n6NMFV
	 /lsub8iySzHZs/lK/dPF6W9uW5S9rn9pYiHvvvCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Bursov <vitaly@bursov.com>,
	Ingo Molnar <mingo@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 420/427] sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level
Date: Mon, 27 May 2024 20:57:47 +0200
Message-ID: <20240527185635.701379961@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Bursov <vitaly@bursov.com>

[ Upstream commit a1fd0b9d751f840df23ef0e75b691fc00cfd4743 ]

Change relax_domain_level checks so that it would be possible
to include or exclude all domains from newidle balancing.

This matches the behavior described in the documentation:

  -1   no request. use system default or follow request of others.
   0   no search.
   1   search siblings (hyperthreads in a core).

"2" enables levels 0 and 1, level_max excludes the last (level_max)
level, and level_max+1 includes all levels.

Fixes: 1d3504fcf560 ("sched, cpuset: customize sched domains, core")
Signed-off-by: Vitalii Bursov <vitaly@bursov.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/bd6de28e80073c79466ec6401cdeae78f0d4423d.1714488502.git.vitaly@bursov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c  | 2 +-
 kernel/sched/topology.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4237c8748715d..da24187c4e025 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2948,7 +2948,7 @@ bool current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= sched_domain_level_max)
+	if (val < -1 || val > sched_domain_level_max + 1)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 99ea5986038ce..3127c9b30af18 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1468,7 +1468,7 @@ static void set_domain_attribute(struct sched_domain *sd,
 	} else
 		request = attr->relax_domain_level;
 
-	if (sd->level > request) {
+	if (sd->level >= request) {
 		/* Turn off idle balance on this domain: */
 		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
-- 
2.43.0



