Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5314389F;
	Thu, 13 Jun 2024 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278926; cv=none; b=I7kv3NTOK+Pn4s43gKk2gC3bt1tdBgYiTbBrrWLDqPbW5yam90MPcxjbKyNxUQG9S+H5K1eCQlQEqMlOTl1u868Q1O9xsRy304PQj/KSQ5tk1LoH2hJT9jRhKrgOnZ4yrZ2AfznzrP8IVVFL/f0FUChO5GajE09bcngYN86q2PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278926; c=relaxed/simple;
	bh=5kDOtj3Aanl55PsJz1eIBkp8CGT3qW/T1Lq1w/9hcxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xc9cZl6zE/o6Ge6U7gmgT6OP9eh70bq2d0VITgzE2dJpzqylAs1m3C6VInDAErj918QqOwfg9Ic3FRgzfiYe6Hpanhh8p6h0r2ztOE7bGrPZXRK+/FUKCnCHNdutzA9LfbgZqZnVelyrpl3Qvlp5aPSaO2iru0lNRsHyTSCmTu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=So00dvPW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="So00dvPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8CFC2BBFC;
	Thu, 13 Jun 2024 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278926;
	bh=5kDOtj3Aanl55PsJz1eIBkp8CGT3qW/T1Lq1w/9hcxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So00dvPWqVo7aSti182E8a/tPZfjosHFU4yrJJmHfO0gWkKsDL/y3Mg9RGMKSjVYq
	 QzMdwqzjWsjV4lEmUL9G6VRy62d2ZS3h8xDd8w1WWxQ5dDetF9MsASIqjILkH8wSJs
	 KM9WfuTn2aYohlcYMY5tnILW2VT/Q2aTkJhexly8=
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
Subject: [PATCH 4.19 086/213] sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level
Date: Thu, 13 Jun 2024 13:32:14 +0200
Message-ID: <20240613113231.327944235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3067d3e5a51d9..af749e265eadd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1269,7 +1269,7 @@ bool current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= sched_domain_level_max)
+	if (val < -1 || val > sched_domain_level_max + 1)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index c171783bda0cf..a00fb3b8a6aad 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -969,7 +969,7 @@ static void set_domain_attribute(struct sched_domain *sd,
 	} else
 		request = attr->relax_domain_level;
 
-	if (sd->level > request) {
+	if (sd->level >= request) {
 		/* Turn off idle balance on this domain: */
 		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
-- 
2.43.0



