Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FB11991D0;
	Thu,  5 Sep 2024 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529718; cv=none; b=Ta+nUxisrrc2r1IQsANPPGPJ1kk9U0ltOEx7EhN4oR7PsINvSfiJtc0QrLquVVhQext6cPD2KVSORrOK3zAEIWTKML0GbQToRNB0hN9G5LRyH4TArOw3mqSY6mOuy5m0PUDKRpq37qoasA7pDDmK6FcE8kMI4/jlpujtQ7nEHco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529718; c=relaxed/simple;
	bh=V5r0XvR4BP/U3Hl1yZH66aDOUik5Yn05Nrx+OLhAcDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnWq9BVcFjGMCcR2nEAvfk/VNjc7AmOS1l3JVhY+BUHU2jQE8qEmm/CA/i1od0msmjFgsvWgZwmDcGfkfBPHtwMUXh0Zv5XtZSMB4JdXkBa3NCL95/Kufw067bC9kWXS9njjIeJ/HMzOl52JPRJv0wdjTRJ50lNMmpL76WDVAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMs10DDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMs10DDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39330C4CEC6;
	Thu,  5 Sep 2024 09:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529718;
	bh=V5r0XvR4BP/U3Hl1yZH66aDOUik5Yn05Nrx+OLhAcDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMs10DDA7TMuXlYFCEAVSnn5QqjsrE8xD+qwWMQlMVGE5/eggZ+SQMXMJla2uYC8D
	 4yrj/4Grc/+Y9nWuwns37b6wk7WyAYGFDqpK5/n/6Q+Z0SUQX9wHbaDaZr6VuY06hS
	 dNnWjTbGA9KXsMB1kzaFub1rpZypq02vCsk6HCJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <quic_jkona@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/184] cpufreq: scmi: Avoid overflow of target_freq in fast switch
Date: Thu,  5 Sep 2024 11:40:33 +0200
Message-ID: <20240905093736.915296929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <quic_jkona@quicinc.com>

[ Upstream commit 074cffb5020ddcaa5fafcc55655e5da6ebe8c831 ]

Conversion of target_freq to HZ in scmi_cpufreq_fast_switch()
can lead to overflow if the multiplied result is greater than
UINT_MAX, since type of target_freq is unsigned int. Avoid this
overflow by assigning target_freq to unsigned long variable for
converting it to HZ.

Signed-off-by: Jagadeesh Kona <quic_jkona@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index 3b4f6bfb2f4c..b87fd127aa43 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -63,9 +63,9 @@ static unsigned int scmi_cpufreq_fast_switch(struct cpufreq_policy *policy,
 					     unsigned int target_freq)
 {
 	struct scmi_data *priv = policy->driver_data;
+	unsigned long freq = target_freq;
 
-	if (!perf_ops->freq_set(ph, priv->domain_id,
-				target_freq * 1000, true))
+	if (!perf_ops->freq_set(ph, priv->domain_id, freq * 1000, true))
 		return target_freq;
 
 	return 0;
-- 
2.43.0



