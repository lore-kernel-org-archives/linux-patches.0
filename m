Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E54FC0B;
	Wed,  5 Feb 2025 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763605; cv=none; b=LJdwAfSRRio2hF6dNiwVyl4DS3ftjPYJmohH4XzCISyxBIonv9wpemD5XHl/vNbZluPw1Sn6JOMtZ5AM/dxTIt1lmln3maYfW69Ary8+A5XnVn5uYEdwus0v0iT0hEJpXlwhQTLYEgToK2/a+5jpv93j0ICh5XbI85GPLg8SY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763605; c=relaxed/simple;
	bh=28bxwGJlQvrMecuj7N/fsL2oOA1qg41qm8rB+J1JuPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUot41hjDE4n4OWA5kungpe/YtkmhshJdKHsLckOcH75jUrQmDqfJ5kFKfIELmUhM0tOVRj2HI2+gzJYLIW3LkxFf2YcWNuDS/wOz+CcrAxr3n0fcTE8zFQDmc7z3ivym4UZpp2y20AK58lHfHWwpBINwJM1+2RnPPJoyG8Wc9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iev0efQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iev0efQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D766DC4CED1;
	Wed,  5 Feb 2025 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763605;
	bh=28bxwGJlQvrMecuj7N/fsL2oOA1qg41qm8rB+J1JuPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iev0efQY1X1mbWB6Fs/AEzMrs9vVstvLQZV971pe+NnJHosajb8UZnO1Y8eOIfnih
	 jizJ262zrzyvAcPtsxF8amrXu15zvVun0R8ywQVP+UTLMmsPuRB9cVwVwdUpAaysW7
	 cN1SC0sJVecshfaA8yIbwj3iU+Tq0WxKxsildWA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/393] cpufreq: qcom: Implement clk_ops::determine_rate() for qcom_cpufreq* clocks
Date: Wed,  5 Feb 2025 14:40:06 +0100
Message-ID: <20250205134423.621301279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a4305df5c119..92c0fc4a3cf60 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -627,8 +627,21 @@ static unsigned long qcom_cpufreq_hw_recalc_rate(struct clk_hw *hw, unsigned lon
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



