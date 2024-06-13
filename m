Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4947143747;
	Thu, 13 Jun 2024 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281172; cv=none; b=bA0fPxjXZi5jAl9L/s1Sl59tZSKngo7cE4nBOTX0TobSUjMlp99B2Scv8MA8T3mVXOjrogzgf5wPmmow4sBL2PC9TBb2q9dqhbiudglBDm8yqU0Ty0NVt3l14v/3t+RI3J1iAK5LjBqIPaztfhk+T1T31eJG5D1Hu2+xuFyNKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281172; c=relaxed/simple;
	bh=al0RZAlTLueBxvOtEhNcR6iZc40WT5F7ssN44/kE7TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl7B1jjCeh+oCfN3xB0ktyihgwSClk194iRW/ZckP9cfFiHEkATaSJhwRbzADUGXYBzSV9fJwcCwNin60IjGO/aSgeDAoYCxdgV6j0Pa1l3dEmjEC6MmwTKEAkx1pLass6ZzAJzpSvVz92Uw3FnqEMxB7SjSSlNIl1hbsDxF1Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYlCOsNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYlCOsNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC2DC2BBFC;
	Thu, 13 Jun 2024 12:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281171;
	bh=al0RZAlTLueBxvOtEhNcR6iZc40WT5F7ssN44/kE7TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYlCOsNSKmHHGmHhgQOS7snqGJoq0zww12XS+63OBjKlzvnFKmn5QJlIPLcduTm6d
	 W9K2lHdgMYaeSqyJDoL2yp7SeqteE+Ue097BFcVqbXdZP0GwzPoI6RMk9IyF/FYOWQ
	 Koa3lOhKdjoPk1CcfQB2IXy4WFYWIhR++S/dd3Hg=
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
Subject: [PATCH 5.10 134/317] sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level
Date: Thu, 13 Jun 2024 13:32:32 +0200
Message-ID: <20240613113252.740645960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 195f9cccab20b..9f2a93c829a91 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1901,7 +1901,7 @@ bool current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= sched_domain_level_max)
+	if (val < -1 || val > sched_domain_level_max + 1)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index ff2c6d3ba6c79..6eb0996ef859f 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1217,7 +1217,7 @@ static void set_domain_attribute(struct sched_domain *sd,
 	} else
 		request = attr->relax_domain_level;
 
-	if (sd->level > request) {
+	if (sd->level >= request) {
 		/* Turn off idle balance on this domain: */
 		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
-- 
2.43.0



