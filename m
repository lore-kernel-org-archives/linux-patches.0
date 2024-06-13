Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DAB818;
	Thu, 13 Jun 2024 12:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281838; cv=none; b=sFtz+03NYLJFaxT48QfpQHYsV4eCocWZHDhq3KsQ6r3oX8kew2lMjz3pgCMknHEfzznOjIp4X1bH/ZI4DkwppqrWEGBP0n+O2grUJ9GaboqeXrfAbAF0QPqFuRUjGrmyItNIqlCyBpMyDBLz6ynts6GIdPQEhTMHn/txilFCa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281838; c=relaxed/simple;
	bh=tfLHirhVeUH5A+84DdiS5f1Q5baYg506nILXM2hrlhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNx6mjvRWyKA8sSSlccyGQCFL+DSHShsvabZv44WPcR2KCvZqsz1spZBAxjvfjd/4ZcYnET9rVtMdIVmsIFWdJut+hV24vbfpN8UumoQvR1NJeDiR1XBcz+sfgEKcbiON5ttnpuQZOdqllBA85tz43NGkYwxyvI2CIw7YaJTioc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHWRL/K+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHWRL/K+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1256BC2BBFC;
	Thu, 13 Jun 2024 12:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281836;
	bh=tfLHirhVeUH5A+84DdiS5f1Q5baYg506nILXM2hrlhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHWRL/K+7lrrUwacxOzVQlBCjVpY/YPWdE03Q9r3zetqUJlIk6uOpDBD9hoktvcmv
	 kENRBtsiRpZwts2x9ks1Pr3f1Q5KmtA8Ejsj55SvTKnYP2UgPwvB9kk8uBlVrwC61I
	 KO7lu8x1plQqCkLM7zsKTwTCeuDwXAuKJCOQP+sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/402] cpufreq: Reorganize checks in cpufreq_offline()
Date: Thu, 13 Jun 2024 13:30:29 +0200
Message-ID: <20240613113304.945348441@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e1e962c5b9edbc628a335bcdbd010331a12d3e5b ]

Notice that cpufreq_offline() only needs to check policy_is_inactive()
once and rearrange the code in there to make that happen.

No expected functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b8f85833c057 ("cpufreq: exit() callback is optional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c2227be7bad88..b65dc6af19f08 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1586,24 +1586,18 @@ static int cpufreq_offline(unsigned int cpu)
 	}
 
 	down_write(&policy->rwsem);
+
 	if (has_target())
 		cpufreq_stop_governor(policy);
 
 	cpumask_clear_cpu(cpu, policy->cpus);
 
-	if (policy_is_inactive(policy)) {
-		if (has_target())
-			strncpy(policy->last_governor, policy->governor->name,
-				CPUFREQ_NAME_LEN);
-		else
-			policy->last_policy = policy->policy;
-	} else if (cpu == policy->cpu) {
-		/* Nominate new CPU */
-		policy->cpu = cpumask_any(policy->cpus);
-	}
-
-	/* Start governor again for active policy */
 	if (!policy_is_inactive(policy)) {
+		/* Nominate a new CPU if necessary. */
+		if (cpu == policy->cpu)
+			policy->cpu = cpumask_any(policy->cpus);
+
+		/* Start the governor again for the active policy. */
 		if (has_target()) {
 			ret = cpufreq_start_governor(policy);
 			if (ret)
@@ -1613,6 +1607,12 @@ static int cpufreq_offline(unsigned int cpu)
 		goto unlock;
 	}
 
+	if (has_target())
+		strncpy(policy->last_governor, policy->governor->name,
+			CPUFREQ_NAME_LEN);
+	else
+		policy->last_policy = policy->policy;
+
 	if (cpufreq_thermal_control_enabled(cpufreq_driver)) {
 		cpufreq_cooling_unregister(policy->cdev);
 		policy->cdev = NULL;
-- 
2.43.0



