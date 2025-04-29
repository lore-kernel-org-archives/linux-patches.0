Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274A824111D;
	Tue, 29 Apr 2025 18:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949746; cv=none; b=mutIOgPde61tFYViBsm8lGEQ/QlYY8HH3g5jGoYJQ4R6fuRddIkoRJXCqjdq/mNnhYU9n1fCagFkltbOapOVWKao6ysOBMMX9X/EGmrehl2OMouTvYS6vZYty1astvxlZ9zww10qid1GFDc85OR8AMDMJZ8PRYHLhc03GAbL4I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949746; c=relaxed/simple;
	bh=hQpr0NVEcLgUdBe6AQqclnVyXxiTYo6QnEugS91NDbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZYuZ1r+fVfJBDUC/aBGd7aT0Yk9Dpv1N4ZP6Kq7Tly+bTtWHOaXxA5yHLzW7UE6XhN5/E91y0aIgsDbnLUqIh8DKmxwZjN0cYjbJbx8Y50EBm+ltO7/SUbYRcFCaKqPfcS1EMmbZrvvlYr884m2OZP17EmEAIg2MYtnz1Plg3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3DaZHUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3DaZHUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91732C4CEE3;
	Tue, 29 Apr 2025 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949746;
	bh=hQpr0NVEcLgUdBe6AQqclnVyXxiTYo6QnEugS91NDbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3DaZHUlrm7a0Wo0Q+gQAYQ9QPIB78f9jadulZU+/sS59Oec5RaP+lkRZSSvu/lnF
	 uQU0DbmUqqNcPjtU0yx2MFqCAPXhThlHiT8Hu/ULCiQf0qTHZH1R22nI22blLHfuek
	 XqUGJvgd5wzwi4A0UtHEJxe9W5ZJT/2xzy8VGt8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/167] cpufreq: scmi: Fix null-ptr-deref in scmi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:42:32 +0200
Message-ID: <20250429161053.541020629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 079940c69ee0b..e4989764efe2a 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -33,11 +33,17 @@ static const struct scmi_perf_proto_ops *perf_ops;
 
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



