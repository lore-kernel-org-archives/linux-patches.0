Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C041509BD;
	Wed,  5 Feb 2025 14:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764366; cv=none; b=WZpTYp3amBvjgNJoR9t5/fSKnrc117JcfhkWQEFkRq1bdYkjCtp++rg4xiXNdmlb7baVJmSZ7CWazJb5tQxcsHySWKIbOn79mT/BDMNUq+8kDFEjF7sytrv3g4BVKJZ+FiOIx2lphsTNN/JxZYVJsaiscY64CiHGhKZMnBEP03Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764366; c=relaxed/simple;
	bh=r8Ln1BYLqBGPRaCfdZVHpKBnUXtDzYRYMAwASs1z6PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWTiaaLIrdwaPJyCQ4uK3INb9yu6vLx38755dS4IgNCjm/hWVV/0FYTEpszo2KTku0sLZ83bdoebZSAhI3UMaCxEZQDcA3IDFZiIn0a95UQUsz1H3TYyFRVa90+PsDYr0cp+T+x1KI+vHDCspBgLD/IPmuN6BU/gUqNlSCQfngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMgbdaVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMgbdaVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C932AC4CED1;
	Wed,  5 Feb 2025 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764366;
	bh=r8Ln1BYLqBGPRaCfdZVHpKBnUXtDzYRYMAwASs1z6PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMgbdaVEUvyXebHclCyYVwRAglxWgY2zjUNTYlLGK5SFzEYBKJMWjfKBSQ2nWPeK8
	 HMtNE7oV0pmeOrMIUbrmWs3gYE1TBQAUuXlRRLKAVvsrznmBBq6bgjTM2oZBRXVaaB
	 BTXoPAYqeisjFROsc+NkJvD6J+6YKHddY1QuM7nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/590] cpufreq: qcom: Implement clk_ops::determine_rate() for qcom_cpufreq* clocks
Date: Wed,  5 Feb 2025 14:37:52 +0100
Message-ID: <20250205134459.735082497@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 2d3f00d410207..e739978063839 100644
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



