Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F79268C79;
	Tue,  8 Apr 2025 11:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110381; cv=none; b=FiLLrVJqUkRefbuVTygQgYw29Zs5jfd4PTu0XJ+B54SK/7VyK/7XVJ5XRwuCsSWHh2rOMMIKLjfs41kyV7eIn3+APP/z8p+5moc9BduYz9/iCVS0t9jx4Kjmv4qtZcIcWZBOZgchXg9JgdLc3JPyczSg+zigf3drLzLysWUu2Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110381; c=relaxed/simple;
	bh=qm/HTukDqCWE7pjHUPiEaQ6Ej6V2hvwWzkmeByUSVdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLXYUVjDtmFtUjTAQMuDgf8WyiS4VG/FZvpyjuY+fVTCIjGbo6aLlEdyMiFEPgegq2N/EfVXnVofN6LZJYseiQXCihZpj3xmjcPdhQArZKr+ch7znww/0LGYptmlnzZgeBCp5xJjLbyOCzr4GPVl7gy9O7wjXq3wvrZTIMDxfiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2SUtnYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2SUtnYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC57C4CEE5;
	Tue,  8 Apr 2025 11:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110379;
	bh=qm/HTukDqCWE7pjHUPiEaQ6Ej6V2hvwWzkmeByUSVdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2SUtnYs0pAs/MdwoNqzLEZ5dZPd4PUBw2ae+6v6/51gLy7PPzIGvZwE/Qr7fekIj
	 i17X+FD/97GVDw+24vNhEiXNQj3Rxisk0XokiwM55ReJ1OTI8OvDu3WoOXwDibjOm7
	 3hFifuxCUhPWG+gFCP8Vy0RAJXuTJ/IxqRIJENak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zuoqian <zuoqian113@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 006/731] cpufreq: scpi: compare kHz instead of Hz
Date: Tue,  8 Apr 2025 12:38:23 +0200
Message-ID: <20250408104914.406864061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



