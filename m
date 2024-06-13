Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5671D4A0F;
	Thu, 13 Jun 2024 12:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282138; cv=none; b=YV1nKYk2EPWQpBmOnlLw7h/OmISuSmOm+kWBsrEHt5hu0U3UZAQWbUKJczX1LRxXFA4ove+AuSkds1Xo2qYBFA7m1iHZjfL30jIUFJx7HvSudM6y9nLfA1ro1aG4UVYdmmhEauTGOTY3ELPApywJJd/DcZmPnXiN+unmaQxW2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282138; c=relaxed/simple;
	bh=y+mgoWgpHiQ9gftRBes/4CjSGkfinuIORFqosFKnHgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGCNhbGSNEGumFCRS0/38BAVtGeiS8sK+5qgOWoJty1UbemoEHRQ7ksvyURF3B7xgz3twwxgQ5hrv1Kz9mvyLKEwG51IP+RoFBGKYdO9oAtaqFNfeXqJrtjqMEWiZPwLw1gc1t+K/ePlIkwFCQd9PYOux7Nkp8kVDEYoq0E4eiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqDrc4cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqDrc4cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34D9C2BBFC;
	Thu, 13 Jun 2024 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282138;
	bh=y+mgoWgpHiQ9gftRBes/4CjSGkfinuIORFqosFKnHgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqDrc4cMLs1d8qCB0OlqG+sO+eqP2TK59AMQyDkHsJC0pthIfeEDZVgnC6VEbT5CY
	 FEOmMqRsieMKIXGuTpZFHcWsaw2thVnhj2Wtd4nQF5Jlx+64ol3vCSkY/cMMSEWG/l
	 aV8OIOfqGV8aKp4hwNmfomLGdSS5qNQNd4Tz9lh4=
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
Subject: [PATCH 5.15 175/402] sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level
Date: Thu, 13 Jun 2024 13:32:12 +0200
Message-ID: <20240613113308.970625177@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6905079c15c25..82df5a07a8696 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1938,7 +1938,7 @@ bool current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= sched_domain_level_max)
+	if (val < -1 || val > sched_domain_level_max + 1)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 4e8698e62f075..8c82ca3aa652f 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1405,7 +1405,7 @@ static void set_domain_attribute(struct sched_domain *sd,
 	} else
 		request = attr->relax_domain_level;
 
-	if (sd->level > request) {
+	if (sd->level >= request) {
 		/* Turn off idle balance on this domain: */
 		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
-- 
2.43.0



