Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C756458;
	Thu, 13 Jun 2024 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280842; cv=none; b=T7yldVDhv3ymLBiH4L3QJxDPNHZYQsnTxCdnmzkgzhccDu98ZG82zS5zEWDGLPwpfQhNGzR36c2mBmHSCN+2xFkZCnZaUTaqqF1xcq2vTvIE9K1m1st54GzzTxWkSImKXrmBNIHkU4KhwLw/UQheY17EtZTkmMNWSGQ3k6xzFrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280842; c=relaxed/simple;
	bh=ex+gi2fw8sH/lAY07yVysmWgxWvdd2+vDZisjujB45s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkWrX/5pjxIzz1yOw0NevyURZ+aWy4ZQFJufiZgOIvyQFDEq/i5NybaGy2/hdlGlAtLFzdByn0+W1DVmDdDF2jMm5xMRQrDujYsXKl554L4g5HMt0XCHoKSjfKGVeubt6ju/QO5jlz6Vzs10Daim+iQmJusnHWyII6YEQO1YqTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4Sil+uG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4Sil+uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78713C2BBFC;
	Thu, 13 Jun 2024 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280841;
	bh=ex+gi2fw8sH/lAY07yVysmWgxWvdd2+vDZisjujB45s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4Sil+uGCJ7Ic/JpBzQKLtvP4cB0G3j5sdw9TvdBw6B61UgvAeTXVofPD4GQM54lt
	 SlT3MaBZ+2iE6lCd0eyACp6jgBpgqtmg6H5QQ3+aQBugHgeLy1JC/35cYACyLc7rhV
	 A/P7dZiv2+9yuoqw6rsFnthw8eWFunK+qoeT9wKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/317] cpufreq: Reorganize checks in cpufreq_offline()
Date: Thu, 13 Jun 2024 13:31:10 +0200
Message-ID: <20240613113249.560972740@linuxfoundation.org>
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
index 5b4bca71f201d..97999bda188dd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1573,24 +1573,18 @@ static int cpufreq_offline(unsigned int cpu)
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
@@ -1600,6 +1594,12 @@ static int cpufreq_offline(unsigned int cpu)
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



