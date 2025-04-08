Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0AB26A0C1;
	Tue,  8 Apr 2025 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114258; cv=none; b=uuPpwjR8SbcLaWcQKSoq8tU0gE2MLdllZRGk1fLc48qgSzZBCjHI0k1fhM52XlS8aNI3LQiCfiRGC8k1i7QVzxEjapXyVRQXjVF7jZa50tQizdq9c/RCTaVZduPaMjk+L3DeH5YV/BVVcC4MBWtBJXcgKoKiii1o9iP2fv3FQ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114258; c=relaxed/simple;
	bh=8e09fVLTSTRyQj6TPYOnyzYDaAIdUsSDOPSek8ifqz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR2Q6bTWsQFqUXXdoTTtec5GoM4W+AUyWrBxvhslLZF0tD/Fs19hLAPrqn1JLKZiByWl9huXLuUa5Y+4oqnbmxf5+j9t/7dqhsmh19cIlQAlH0b6ggBw8q4sYdJ1MY1a7xbhVI5CpiIVoUo70c66XB66QFzutmnYVS3W9Kh5Tso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgyYCA4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgyYCA4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE58C4CEE5;
	Tue,  8 Apr 2025 12:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114258;
	bh=8e09fVLTSTRyQj6TPYOnyzYDaAIdUsSDOPSek8ifqz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgyYCA4Fq5rLJo/B6tKloEZropUm/w/WM5nUQctAiA4qfd5ToCUKd6JXrQm8RGhuH
	 zN+cjvl5Y+lldgfNeHorzJq5en2cK3S1Ih1aUH4uxeIh4ZcbNiTNCT9jHGmtMwDmNk
	 Yihi0wiLJfefEJr34fJVgX1fOXsSooKnMgVE3U6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zuoqian <zuoqian113@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 004/499] cpufreq: scpi: compare kHz instead of Hz
Date: Tue,  8 Apr 2025 12:43:36 +0200
Message-ID: <20250408104851.365184672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zuoqian <zuoqian113@gmail.com>

[ Upstream commit 4742da9774a416908ef8e3916164192c15c0e2d1 ]

The CPU rate from clk_get_rate() may not be divisible by 1000
(e.g., 133333333). But the rate calculated from frequency(kHz) is
always divisible by 1000 (e.g., 133333000).
Comparing the rate causes a warning during CPU scaling:
"cpufreq: __target_index: Failed to change cpu frequency: -5".
When we choose to compare kHz here, the issue does not occur.

Fixes: 343a8d17fa8d ("cpufreq: scpi: remove arm_big_little dependency")
Signed-off-by: zuoqian <zuoqian113@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scpi-cpufreq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scpi-cpufreq.c b/drivers/cpufreq/scpi-cpufreq.c
index cd89c1b9832c0..9e09565e41c09 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -39,8 +39,9 @@ static unsigned int scpi_cpufreq_get_rate(unsigned int cpu)
 static int
 scpi_cpufreq_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	u64 rate = policy->freq_table[index].frequency * 1000;
+	unsigned long freq_khz = policy->freq_table[index].frequency;
 	struct scpi_data *priv = policy->driver_data;
+	unsigned long rate = freq_khz * 1000;
 	int ret;
 
 	ret = clk_set_rate(priv->clk, rate);
@@ -48,7 +49,7 @@ scpi_cpufreq_set_target(struct cpufreq_policy *policy, unsigned int index)
 	if (ret)
 		return ret;
 
-	if (clk_get_rate(priv->clk) != rate)
+	if (clk_get_rate(priv->clk) / 1000 != freq_khz)
 		return -EIO;
 
 	return 0;
-- 
2.39.5



