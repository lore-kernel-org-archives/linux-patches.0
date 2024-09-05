Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F518D65E;
	Thu,  5 Sep 2024 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530221; cv=none; b=jwPPPns9iV5gS7J5sxvtSFSPQOS7yyTM2NbzhYSOtceSstsW/YO6M+P7rDiSWoqN9tmmD2qHKN4iLUpOq05gY0MUev022VZwdz0RwfDNV1FtXATZSkblgswov3a+xcZkfE3VhRsAMrh3TilQhGH68bCeB+eLenhJAIxxe78Bk6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530221; c=relaxed/simple;
	bh=1r3pJLDtZycLcjrScchixL7XbsXbMfljhPopm6VhJVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzFCldUb2OygDZNK02erMLKEAfyiF5lfq2evSyQhjDpGeGu63USk4YeIRYu+tFhZCCNlPdL5iDHbl8ipFhS2tBxqZQcj0Ewz2f2O3PhpXko1byWxxVtatg/CUhuqqw0Gjr+crN2EmEgdLGls1NLnN94BVJEmTdCRXWR5B0hxsw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQNrnJli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQNrnJli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971DBC4CEC3;
	Thu,  5 Sep 2024 09:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530221;
	bh=1r3pJLDtZycLcjrScchixL7XbsXbMfljhPopm6VhJVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQNrnJliPd0E4A0LR1hz9FrvPgEcmXCAKIox2dm+42w+eTuxrhKYzK0zwboeAFImq
	 htyhYfPoFELtRHPLBWC1Zo2Gw6wda7B2PSIQwc/5vuroNmvOBpPLoRycQJDyQv5Iq9
	 TYRY7zXIWHKz8WLH4dJG8BRLw+3yraKUGuIL2ng8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <quic_jkona@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/132] cpufreq: scmi: Avoid overflow of target_freq in fast switch
Date: Thu,  5 Sep 2024 11:41:17 +0200
Message-ID: <20240905093725.745353541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 028df8a5f537..079940c69ee0 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -62,9 +62,9 @@ static unsigned int scmi_cpufreq_fast_switch(struct cpufreq_policy *policy,
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



