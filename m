Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E63148820;
	Thu, 13 Jun 2024 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279788; cv=none; b=HAWLGUdR5Qxyt8Kw4XN7v2Brrguid8J1kcsZDEix9TTpYYGco3+8DYxaDDG/80pCK3EqKtFusWeG7Bj7CVgMe9l/nbJV5bX/qHUaoDJfnHfP4LxswDkzE9B0mujfaLZRu19WC09dY35ZT+jy5xVfVwigi/sxiQf6viImJaFZkVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279788; c=relaxed/simple;
	bh=pzrmjmVa6Qn+ZgglUTAM76dWRMwymeN6K02Wjp3RyJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHL+lFQZLnt3lNY++MP2WyTUzg+v6WuwQrcd2Ho+r/6GvHWb4z1BZKwfQP5BGqcZOert7mrD+p69wn8w6rqFDMVl0GazA7ofB/iwyHnlCLWAGtN5mlhnJspgfLuEcsdFvNFGQngH8MAAPrCOM7gNbJRm1cUd0Dvrr1zBpyhRe18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpMxGv+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpMxGv+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D552CC2BBFC;
	Thu, 13 Jun 2024 11:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279788;
	bh=pzrmjmVa6Qn+ZgglUTAM76dWRMwymeN6K02Wjp3RyJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpMxGv+u05qgnZ/mxxrPHs3sepFtuBEgnqDGkTFvHWhGQfizsjlF7TZRTLuXEHKIK
	 8eKsGraMlTBm0OT7r4nr7X0FITSlXAPdpmP7lt/IK81e0igDYVYuncll0hEIUwcdyP
	 AoLta96Fx7qqaHqD/+MkAPGH4CNvSzJDhagNlbyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/202] cpufreq: Split cpufreq_offline()
Date: Thu, 13 Jun 2024 13:32:15 +0200
Message-ID: <20240613113229.204987368@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fddd8f86dff4a24742a7f0322ccbb34c6c1c9850 ]

Split the "core" part running under the policy rwsem out of
cpufreq_offline() to allow the locking in cpufreq_remove_dev() to be
rearranged more easily.

As a side-effect this eliminates the unlock label that's not needed
any more.

No expected functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b8f85833c057 ("cpufreq: exit() callback is optional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 09be815190124..549788a2a9676 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1553,21 +1553,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	return 0;
 }
 
-static int cpufreq_offline(unsigned int cpu)
+static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
 {
-	struct cpufreq_policy *policy;
 	int ret;
 
-	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
-
-	policy = cpufreq_cpu_get_raw(cpu);
-	if (!policy) {
-		pr_debug("%s: No cpu_data found\n", __func__);
-		return 0;
-	}
-
-	down_write(&policy->rwsem);
-
 	if (has_target())
 		cpufreq_stop_governor(policy);
 
@@ -1585,7 +1574,7 @@ static int cpufreq_offline(unsigned int cpu)
 				pr_err("%s: Failed to start governor\n", __func__);
 		}
 
-		goto unlock;
+		return;
 	}
 
 	if (has_target())
@@ -1615,8 +1604,24 @@ static int cpufreq_offline(unsigned int cpu)
 		cpufreq_driver->exit(policy);
 		policy->freq_table = NULL;
 	}
+}
+
+static int cpufreq_offline(unsigned int cpu)
+{
+	struct cpufreq_policy *policy;
+
+	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
+
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (!policy) {
+		pr_debug("%s: No cpu_data found\n", __func__);
+		return 0;
+	}
+
+	down_write(&policy->rwsem);
+
+	__cpufreq_offline(cpu, policy);
 
-unlock:
 	up_write(&policy->rwsem);
 	return 0;
 }
-- 
2.43.0



