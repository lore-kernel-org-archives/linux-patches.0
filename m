Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAFA384;
	Thu, 13 Jun 2024 12:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281839; cv=none; b=QT+yr8+PXBtah6iDivko7apj7VBqcunBl8pOStFn2IMWGM9QyfzxQAYg36aZimud48g4FE/lhy+hXlbkIPoIHEvZmsSbnk5zwdQTcZX7PKX9b5WTjCgOz67rO8Arml4ZByIPKk8AOczeP/JEFKHdzCAmlovN5X9AFBY/EuibMnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281839; c=relaxed/simple;
	bh=t5BrudpJIs79pmw5VKtgSIda0Dw8F+sXZYZvQessegU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRZ0gwy9cmWhi9hxomIw8dsYAAnxrycW1+mDSAnWGtTpfWnYMGnjNAkxakKLI7PSakcQlLfPM4k04ZvKl/WFIaGVpTE8RwgF+ZreWNFG8s6SXFfU1KKdWN7PQzOUmI/dYtC1s6bFSNrnmqZ9A3Nm49qpzcM3AHVxCyxJT6a8dm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emqVDsUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emqVDsUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A26CC32786;
	Thu, 13 Jun 2024 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281839;
	bh=t5BrudpJIs79pmw5VKtgSIda0Dw8F+sXZYZvQessegU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emqVDsUA8k5qbRuYiqINlL4Ik06fbxokxmmEosLl+1OjoFuUpkNO5GRckBmAAptcd
	 PKOQCP5jMWDZREwVbju1pNjUwO6eXqi4VilxiSAjg//nokafOge8bkFlEEyayd/Zc+
	 9ycPGRAmXvetR701HTmxg9ZNCFnS/0qyDzCO4jWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/402] cpufreq: Split cpufreq_offline()
Date: Thu, 13 Jun 2024 13:30:30 +0200
Message-ID: <20240613113304.983831319@linuxfoundation.org>
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
index b65dc6af19f08..ce7d718bdfced 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1572,21 +1572,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
 
@@ -1604,7 +1593,7 @@ static int cpufreq_offline(unsigned int cpu)
 				pr_err("%s: Failed to start governor\n", __func__);
 		}
 
-		goto unlock;
+		return;
 	}
 
 	if (has_target())
@@ -1631,8 +1620,24 @@ static int cpufreq_offline(unsigned int cpu)
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



