Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6014A1519A4;
	Wed,  5 Feb 2025 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764936; cv=none; b=TH77F30oGsCO6Q4seeXVmg0Ny1b3CMXjN34WC9OuGrpHiliZP9xolZxGn35n01s8JXvmTQ1q8Z3GIm7++GoCNReCJGAO3qwEXclNtkSH9GhC2o4qMw+rExcgSyShNDiNwIfeoImoF+HVgzQbb7S49wsXutsViYLeS8RYS24lc+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764936; c=relaxed/simple;
	bh=YB5JXLR0q7BQQ8DZA3F+R5LLJz4KwlUjh2N/Jas+dTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Syoj9C8zwNoLWGlljtKMPhDSx6VftlTX7+Q3aohtkbXsqZyty2B42UsWXhZ5IFJVoSsFGQzv1WCxLuEtv8NzVIztTDtmfZjxk8Cdm0rjYk9IrNXKpjWp0DoC+IQ0O8XTeYJqkB3TRhYXmzD4kdYSDubqwLDPmqHlEyRo0px+Li8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pvdhMCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pvdhMCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1002C4CEDD;
	Wed,  5 Feb 2025 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764936;
	bh=YB5JXLR0q7BQQ8DZA3F+R5LLJz4KwlUjh2N/Jas+dTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pvdhMCe9vYDDdWz8MR1K/nu096lLfiaCmp41cotE+k6FhJTO8gCQ5bRWXx6+FgVd
	 7gA4pTtjGbAw6PQU3Gapo93xI+pk0HcuQTmYi5k7fKa/KpByLgEVbln8gBRTldgeVI
	 G1EFhNkbpS0kBJVsNATk00Lb0aQvnt3C5y7dX9bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 128/623] cpufreq: qcom: Implement clk_ops::determine_rate() for qcom_cpufreq* clocks
Date: Wed,  5 Feb 2025 14:37:50 +0100
Message-ID: <20250205134501.123061799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit a9ba290d0b829012574b6821ba08815046e60c94 ]

determine_rate() callback is used by the clk_set_rate() API to get the
closest rate of the target rate supported by the clock. If this callback
is not implemented (nor round_rate() callback), then the API will assume
that the clock cannot set the requested rate. And since there is no parent,
it will return -EINVAL.

This is not an issue right now as clk_set_rate() mistakenly compares the
target rate with cached rate and bails out early. But once that is fixed
to compare the target rate with the actual rate of the clock (returned by
recalc_rate()), then clk_set_rate() for this clock will start to fail as
below:

cpu cpu0: _opp_config_clk_single: failed to set clock rate: -22

So implement the determine_rate() callback that just returns the actual
rate at which the clock is passed to the CPUs in a domain.

Fixes: 4370232c727b ("cpufreq: qcom-hw: Add CPU clock provider support")
Reported-by: Johan Hovold <johan+linaro@kernel.org>
Suggested-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index c145ab7b0bb21..b2e7e89feaac4 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -626,8 +626,21 @@ static unsigned long qcom_cpufreq_hw_recalc_rate(struct clk_hw *hw, unsigned lon
 	return __qcom_cpufreq_hw_get(data->policy) * HZ_PER_KHZ;
 }
 
+/*
+ * Since we cannot determine the closest rate of the target rate, let's just
+ * return the actual rate at which the clock is running at. This is needed to
+ * make clk_set_rate() API work properly.
+ */
+static int qcom_cpufreq_hw_determine_rate(struct clk_hw *hw, struct clk_rate_request *req)
+{
+	req->rate = qcom_cpufreq_hw_recalc_rate(hw, 0);
+
+	return 0;
+}
+
 static const struct clk_ops qcom_cpufreq_hw_clk_ops = {
 	.recalc_rate = qcom_cpufreq_hw_recalc_rate,
+	.determine_rate = qcom_cpufreq_hw_determine_rate,
 };
 
 static int qcom_cpufreq_hw_driver_probe(struct platform_device *pdev)
-- 
2.39.5



