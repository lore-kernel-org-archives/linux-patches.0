Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0669C215060;
	Tue, 29 Apr 2025 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945523; cv=none; b=gQKmshw95o0ZR0NhnSzRYrabUc/HBUmE8sW0AxzlEXa/bQO3KJibyULp/E97t9cwBEYUCa5GpjrKiuG0EquO5PhBcMbyohZt9wsxSQP6shoDfacjEEE81zDRCdDuqV9gggtWn8fQUfLW2X94/WBzp4JQCd+QnPUiJfpBFsGSta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945523; c=relaxed/simple;
	bh=GswN5RhNiR2cpOWaPT9AqMiYRYDMzuoaI7FMRm6N+wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HT7D+6dYI9qFSmMbQj4O+McsENjA58vIvnDWZoCdHlqRdobtszNUkYmy89SMm6IwdWT9A3ZjrOqC6hJOOjLGqEcMRVzkdPZRFpF0/fVCwoCtTDLJ7vtUxN/Ms3PMIkrUJmNr0qWEwF21iclu9P+6V4szX+Hd5Svo9PgDSDi23Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH2u/nrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH2u/nrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E4BC4CEE3;
	Tue, 29 Apr 2025 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945522;
	bh=GswN5RhNiR2cpOWaPT9AqMiYRYDMzuoaI7FMRm6N+wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JH2u/nrIdzx0WlTUPevmn7/+yDk3BJ4FOsmOdW/Xv3X3WPPviBYh0AMHfvOTalOol
	 mkCv8Q29sbqqdIjVSDAzqWfCj9BBmgNV7Vs1jv8dYkE/WQvoeVKjXc161yS4yPzscK
	 CwkfE2Jg094n7Q/9yhAAitPhmmzhUkhzbm05IRyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/179] cpufreq: scpi: Fix null-ptr-deref in scpi_cpufreq_get_rate()
Date: Tue, 29 Apr 2025 18:41:22 +0200
Message-ID: <20250429161055.100161134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 73b24dc731731edf762f9454552cb3a5b7224949 ]

cpufreq_cpu_get_raw() can return NULL when the target CPU is not present
in the policy->cpus mask. scpi_cpufreq_get_rate() does not check for
this case, which results in a NULL pointer dereference.

Fixes: 343a8d17fa8d ("cpufreq: scpi: remove arm_big_little dependency")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scpi-cpufreq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/scpi-cpufreq.c b/drivers/cpufreq/scpi-cpufreq.c
index b341ffbf56bc3..73539f357c7ae 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -39,9 +39,16 @@ static struct scpi_ops *scpi_ops;
 
 static unsigned int scpi_cpufreq_get_rate(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
-	struct scpi_data *priv = policy->driver_data;
-	unsigned long rate = clk_get_rate(priv->clk);
+	struct cpufreq_policy *policy;
+	struct scpi_data *priv;
+	unsigned long rate;
+
+	policy = cpufreq_cpu_get_raw(cpu);
+	if (unlikely(!policy))
+		return 0;
+
+	priv = policy->driver_data;
+	rate = clk_get_rate(priv->clk);
 
 	return rate / 1000;
 }
-- 
2.39.5



