Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6036F8F5;
	Wed, 30 Sep 2026 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784120; cv=none; b=T8Gn5nCs+oBDRodZFS/WKDPrwxphlcLfIYGc0q4faFchD9WRMAxu3LEN/Qb+jxv7HtqOfyPyTUU60u23EA+L+cFkwxyBzfgVCWGCz+ZiDsLjWBvLL/+NYMZv6t5PtWE1h5jYyon9gzUyKctPoWvVXpoFyat4hEP5wsFmhfkdTe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784120; c=relaxed/simple;
	bh=FEvO36pdokFba4kqyXTLg4kT4I49lPoDROa7P3iA4eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkqfPpRrGu1bnAywiZUKrfoYN+dmLslekLw3R21nfAsTWilkkiIGRLLvaiqsWlFgi3zi+2Foex3SasObuFZrb/ZRsDQkpS/Dc3PASmVNJ5wTsZNXxuTrvOgEmNgUmD0Nov1E/aqYI1a7Gng5aCou9ktd6Fg/8FM3rzfiigJq9cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qB/OkJiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qB/OkJiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401331F00898;
	Wed, 30 Sep 2026 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784116;
	bh=TWEg7mSbIpr/dh5lHjpRPpzev2pp7BLEFvwm6wxF9/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qB/OkJiQFRTlNU9tZcbj4X6U+7hRZRBibSLk7ZWgea5F9rlwgKp0GS7x0/Me+cES8
	 gsUeuaRaI+pvtGhyeowZawxVGhpUcxBs69ioFtSZpoFB+uuYY8eVR8Z74a3ZS1VPXJ
	 YK5NPN8taEvm5iAlvvEzddqHHAnHzNZ1OMmWc1Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/982] clk: samsung: exynos850: mark APM I3C clocks as critical
Date: Wed, 30 Sep 2026 17:12:58 +0200
Message-ID: <20260930152417.700280687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 44984aaf1aa727ff944dd4b72fcf069d08b0056d ]

The Exynos850 APM co-processor relies on the I3C bus to communicate with
the PMIC. Currently, there is no dedicated PMIC consumer driver managing
these clocks, so the clock subsystem automatically gates them during the
initialisation. Once gated, any subsequent ACPM communication with APM
results in timeouts.

As a temporary workaround (and let's hope it doesn't become permanent),
mark both `gout_i3c_pclk` and `gout_i3c_sclk` as CLK_IS_CRITICAL ones to
prevent the clock subsystem from disabling them. This makes the ACPM
communication functional. This workaround should be reverted once a
proper ACPM PMIC driver is implemented to manage these clocks.

Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260430-exynos850-i3c-criticalclocks-v1-1-6e1fd8dfa21b@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos850.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos850.c b/drivers/clk/samsung/clk-exynos850.c
index 87e463ad42741..8d1205de7fd9a 100644
--- a/drivers/clk/samsung/clk-exynos850.c
+++ b/drivers/clk/samsung/clk-exynos850.c
@@ -580,10 +580,11 @@ static const struct samsung_gate_clock apm_gate_clks[] __initconst = {
 	     CLK_CON_GAT_GOUT_APM_APBIF_RTC_PCLK, 21, 0, 0),
 	GATE(CLK_GOUT_TOP_RTC_PCLK, "gout_top_rtc_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_APBIF_TOP_RTC_PCLK, 21, 0, 0),
+	/* TODO: Should be dealt with or enabled in PMIC ACPM driver */
 	GATE(CLK_GOUT_I3C_PCLK, "gout_i3c_pclk", "dout_apm_bus",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_PCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_I3C_SCLK, "gout_i3c_sclk", "mout_apm_i3c",
-	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, 0, 0),
+	     CLK_CON_GAT_GOUT_APM_I3C_APM_PMIC_I_SCLK, 21, CLK_IS_CRITICAL, 0),
 	GATE(CLK_GOUT_SPEEDY_PCLK, "gout_speedy_pclk", "dout_apm_bus",
 	     CLK_CON_GAT_GOUT_APM_SPEEDY_APM_PCLK, 21, 0, 0),
 	/* TODO: Should be enabled in GPIO driver (or made CLK_IS_CRITICAL) */
-- 
2.53.0



