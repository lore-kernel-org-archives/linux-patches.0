Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4A18BBBB;
	Tue, 29 Apr 2025 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947620; cv=none; b=BvFv3DzhWXnMhPfdhF5EJ8R4yGgAfEmIeXRhtprA3yl7cp1Y8BC6atDjcPRBJoZwveNsBA/NVtixdVwznIsDAXFVfFvfJNwxPcxGq44yCqKpJFJeR5NUZh+GEjj/2j5LpDfzdZICcKwbHwIXgSoqXax81V54nBz5WqieAvcjWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947620; c=relaxed/simple;
	bh=KMk6LRWbQUDEzphhG5IWSU5GdG8zV5fT2Qr3laPPFnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoRzPDnIekl17SvRLWZrmZShgrVHqp+oLe4XSsiIrRjX14r1Q+o6DmMsi4MTNMRhMJ5SA/QL/u6+573oAJINfoXp2ut+8/MWJgMvZn2bNfPBaUDpNPwvHQkwHig2woKK6GtgQn6DBr7LPYcz3Glk7c2vsUOWPQt5MxFSNWqPo8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXtXv5Xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXtXv5Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208A2C4CEE3;
	Tue, 29 Apr 2025 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947620;
	bh=KMk6LRWbQUDEzphhG5IWSU5GdG8zV5fT2Qr3laPPFnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXtXv5XenFwtLEwkj+CXifBb09yU1VegGWMg8c1+ayj5tiS3lifQKSfUgG1MJctXD
	 GKhSH6DzX9T2Mr6dBdFBeRTCMZy/4PwcHhdH3Yf3aRF+1hQtlruJeiNzY8W7FBPt2R
	 aVEMO2sPCwgo4rV+lB5W5I1wSDQ2+QN6AX434o/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/280] cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:39:55 +0200
Message-ID: <20250429161117.331348621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 484d3f15cc6cbaa52541d6259778e715b2c83c54 ]

cpufreq_cpu_get_raw() can return NULL when the target CPU is not present
in the policy->cpus mask. scmi_cpufreq_get_rate() does not check for
this case, which results in a NULL pointer dereference.

Add NULL check after cpufreq_cpu_get_raw() to prevent this issue.

Fixes: 99d6bdf33877 ("cpufreq: add support for CPU DVFS based on SCMI message protocol")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index 07d6f9a9b7c82..7e7c1613a67c6 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -34,11 +34,17 @@ static struct cpufreq_driver scmi_cpufreq_driver;
 
 static unsigned int scmi_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
-	struct scmi_data *priv = policy->driver_data;
+	struct cpufreq_policy *policy;
+	struct scmi_data *priv;
 	unsigned long rate;
 	int ret;
 
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+
 	ret = perf_ops->freq_get(ph, priv->domain_id, &rate, false);
 	if (ret)
 		return 0;
-- 
2.39.5



