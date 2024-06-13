Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70A814659D;
	Thu, 13 Jun 2024 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279410; cv=none; b=kUN+7JzuS/cer3/591Usmj/GZYD19iwq4y2C7MR7Hyl7kZhZhbdQBtU39aW1Y5tRCzZ4tJWhAOU61Tq4l9RuyM1hJrmtLz5xu+PA+kOSsUR34JZkj7lJeLLJFVsQu+aPIkKVQBMpl0w6uK8l9bIg17/g+ThzeJ/D4XmNnDSoJNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279410; c=relaxed/simple;
	bh=pMMXgV0SK9taN60iUoF0ltkYaCL1yCcevDK2fa5vBG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7B97MdGhALk84ylj1GAHm076pXvCg0J1jr+8x8JS5HX9++lcM4cJPEC3pmm0QebVLG6q31DE8yV4eTYKHMXb5aPQtf3ayS/DVsWmK+rAuYUFxEla3fYHxdgLvWyNigi9w/c4JvV5vzqSiNcNB5mpSnI6qFiWIRXtusk8gL6JF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwezIXx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwezIXx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F082C2BBFC;
	Thu, 13 Jun 2024 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279410;
	bh=pMMXgV0SK9taN60iUoF0ltkYaCL1yCcevDK2fa5vBG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwezIXx1u9jsLEXODrvJhqxiAKXaudmkndcclgxNLbOqf0qertsmP3B27kOIYuufU
	 qCF7rvTa6VgtkjD0iX3nCgmmtpTQxXodEdu4i9fXpocb77OCYJmlNvjtbMfDCgotzy
	 WGgYpTwOTpFDm+Bk0H7rvQaoy5N4JX7ifrM5irGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 067/157] clk: qcom: clk-alpha-pll: fix rate setting for Stromer PLLs
Date: Thu, 13 Jun 2024 13:33:12 +0200
Message-ID: <20240613113230.014995971@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 3c5b3e17b8fd1f1add5a9477306c355fab126977 upstream.

The clk_alpha_pll_stromer_set_rate() function writes inproper
values into the ALPHA_VAL{,_U} registers which results in wrong
clock rates when the alpha value is used.

The broken behaviour can be seen on IPQ5018 for example, when
dynamic scaling sets the CPU frequency to 800000 KHz. In this
case the CPU cores are running only at 792031 KHz:

  # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
  800000
  # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
  792031

This happens because the function ignores the fact that the alpha
value calculated by the alpha_pll_round_rate() function is only
32 bits wide which must be extended to 40 bits if it is used on
a hardware which supports 40 bits wide values.

Extend the clk_alpha_pll_stromer_set_rate() function to convert
the alpha value to 40 bits before wrinting that into the registers
in order to ensure that the hardware really uses the requested rate.

After the change the CPU frequency is correct:

  # cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
  800000
  # cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
  800000

Cc: stable@vger.kernel.org
Fixes: e47a4f55f240 ("clk: qcom: clk-alpha-pll: Add support for Stromer PLLs")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/r/20240328-alpha-pll-fix-stromer-set-rate-v3-1-1b79714c78bc@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2489,6 +2489,8 @@ static int clk_alpha_pll_stromer_set_rat
 	rate = alpha_pll_round_rate(rate, prate, &l, &a, ALPHA_REG_BITWIDTH);
 
 	regmap_write(pll->clkr.regmap, PLL_L_VAL(pll), l);
+
+	a <<= ALPHA_REG_BITWIDTH - ALPHA_BITWIDTH;
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), a);
 	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL_U(pll),
 		     a >> ALPHA_BITWIDTH);


