Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C456458;
	Thu, 13 Jun 2024 12:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280845; cv=none; b=reXYGEXbn0f+7NTwnBy6n7oukuPmR9g0Ihj3cg/FBJN4MPyl8mYbbMXNi41uEWSzt58rrIkXpLjXatOSD45cBI+XBgzaeLc7YS0Nz/Jw+Z4lW3T0J6SRCHb4XYlwlBAXc6E1+Lq1SghW0wWCzT2yXtvT8L94kwoD8dIUmtvCZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280845; c=relaxed/simple;
	bh=SCKYIlv+hFEcYhs7yG1SaZIubeN7mj9O1iqcBhzR7U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7+MPvSCCZepJsNRhIjA2ky0UzfkQzBBhYtybIhuFyiwL7QvqDjUwM50VvO+7Y4vkPSFB6gMDuvNwxBIwJFvnMMe9D9xFEwOC2O082hKs3mJE1yg2YBZM2m7nxO6ivJj4HTMw8bmxJ0ro0Hid6U8S42TBLxhfFBEqJGeEVjAKFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haYUXkfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haYUXkfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697A8C2BBFC;
	Thu, 13 Jun 2024 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280844;
	bh=SCKYIlv+hFEcYhs7yG1SaZIubeN7mj9O1iqcBhzR7U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haYUXkfLk0SJQtVe0tVDDzKz3M+EQd7HE7LsAIFYZ5ywT78EeTnSEjwDivaBz0mQF
	 hOZAR9QSb7PWF5X3ZTQJsZ5MS8ZE0arm+wXArWNDF7TSNkyaNMkTzCif9ZeQ+NZT0d
	 pH4I/VF6/vPnGYod0HPdwH0AhrS5urec7AgDm4UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/317] cpufreq: Split cpufreq_offline()
Date: Thu, 13 Jun 2024 13:31:11 +0200
Message-ID: <20240613113249.599138201@linuxfoundation.org>
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
index 97999bda188dd..dd1acb55fe717 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1559,21 +1559,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
 
@@ -1591,7 +1580,7 @@ static int cpufreq_offline(unsigned int cpu)
 				pr_err("%s: Failed to start governor\n", __func__);
 		}
 
-		goto unlock;
+		return;
 	}
 
 	if (has_target())
@@ -1621,8 +1610,24 @@ static int cpufreq_offline(unsigned int cpu)
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



