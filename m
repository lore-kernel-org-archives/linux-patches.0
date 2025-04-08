Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDCF269839;
	Tue,  8 Apr 2025 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116203; cv=none; b=MG+tFxr10vBJrVYJKhu1FsMANI3QlLXxFUNRCSKcIPlP0mz5BpkeGpsD8UZAFid6Fg6ZMGd2iUfotSIJB+RuYJYy4lcidc91xd1iUBHspycesgBAH35Hgl8x+NcRDl8paDBixhaV1lk2NysM4tFwZNOozIVdiw7NW+D3Ui9rnVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116203; c=relaxed/simple;
	bh=TbMD1O2bNwuA0GuAdVKTOM4zy9X+GYomprMBwXglD2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfaQxQ3HcSWPWjSSeabMT4t7qa3x13LIp8ov2OPEF34hrHMApHP4AB52+kkepElwB56bKr+TYpRy1QEPXqvyGJV3AkuNAGITZdFJUv1fPEI+wkocUlNPPfokw4j8x09dXBmV6hCaNjNDYybkK3UwY1bPXephQNyQFupE7Zb6O78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URFrSC92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URFrSC92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3D3C4CEE5;
	Tue,  8 Apr 2025 12:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116203;
	bh=TbMD1O2bNwuA0GuAdVKTOM4zy9X+GYomprMBwXglD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URFrSC92ZMa6YKY4y4xNTg0g2sLz5dSg56t7pFnxVFMfOvRD31FJt0dHjzaAN8mL8
	 ox9nLQuQIhQzUooaza2VXlAzkBuKfTILrrnkAYBS7A+2FeDiFB5RJlXI1fBDRIKwGX
	 A6mGYhLnh5ayfsp3dDZnckIZioXeiNXO+DFFy15o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zuoqian <zuoqian113@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/423] cpufreq: scpi: compare kHz instead of Hz
Date: Tue,  8 Apr 2025 12:45:29 +0200
Message-ID: <20250408104845.769701489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index 8d73e6e8be2a5..f2d913a91be9e 100644
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



