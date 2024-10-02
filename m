Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DD71CFEBA;
	Wed,  2 Oct 2024 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875347; cv=none; b=fPBPTpcLW7dMJHPcUD7j1Bc1fQOZevSsl6HQ4EIXehQjZa6XH3hSStQd9DEh8zNLMm6kyo3rYmqkoSXXiLQQjf1YawoFilqxs5CfJ+GmEY9rGbzntXPFH/keSWfv6EA4W9Kg7v77a9weVAe5rV8lIyWDxxj6yzdWJ8bBJ0zZhgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875347; c=relaxed/simple;
	bh=EYQ13RkhJUXilfIWoTjyZRACnLVr+TnX6gDyh/g9T74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri4kiUYjeoNqBsgf7kLFwLWtMB2tnLjyZ79jqFyuEOqXnJB8TXfCXax3SkDchPGm/42okeiV57F7B5oHHGadyMCjqOp0iejhZtJqiW4iR4QFgslCOzKVH/bKd5tZNtWVROFWQD9KhmyFY++ZanPb/pFO33zgG709cvh+IJS8Y8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMWO89yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMWO89yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FEDC4CEC5;
	Wed,  2 Oct 2024 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875347;
	bh=EYQ13RkhJUXilfIWoTjyZRACnLVr+TnX6gDyh/g9T74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMWO89yFnxDQ+//MG6AF6F9KH0c/MTeqhWThDgcVIrMT+N1XJpC7l0jBU36qP2vQ4
	 Ip/0Q8tCmC2WkWINTivrQCwEtXm4RHnvPNXDpaHiuwziqvy0vqM2JHc6qNNpuwiO2h
	 l/+5WyoeYqYp4ax2nAW23/JsffTVQHfWzD11ON5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 071/695] cpufreq: ti-cpufreq: Introduce quirks to handle syscon fails appropriately
Date: Wed,  2 Oct 2024 14:51:09 +0200
Message-ID: <20241002125825.317069419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit abc00ffda43bd4ba85896713464c7510c39f8165 ]

Commit b4bc9f9e27ed ("cpufreq: ti-cpufreq: add support for omap34xx
and omap36xx") introduced special handling for OMAP3 class devices
where syscon node may not be present. However, this also creates a bug
where the syscon node is present, however the offset used to read
is beyond the syscon defined range.

Fix this by providing a quirk option that is populated when such
special handling is required. This allows proper failure for all other
platforms when the syscon node and efuse offsets are mismatched.

Fixes: b4bc9f9e27ed ("cpufreq: ti-cpufreq: add support for omap34xx and omap36xx")
Signed-off-by: Nishanth Menon <nm@ti.com>
Tested-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ti-cpufreq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/ti-cpufreq.c b/drivers/cpufreq/ti-cpufreq.c
index 4d3f27958fbde..62dfa42570e42 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -90,6 +90,9 @@ struct ti_cpufreq_soc_data {
 	unsigned long efuse_shift;
 	unsigned long rev_offset;
 	bool multi_regulator;
+/* Backward compatibility hack: Might have missing syscon */
+#define TI_QUIRK_SYSCON_MAY_BE_MISSING	0x1
+	u8 quirks;
 };
 
 struct ti_cpufreq_data {
@@ -254,6 +257,7 @@ static struct ti_cpufreq_soc_data omap34xx_soc_data = {
 	.efuse_mask = BIT(3),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -281,6 +285,7 @@ static struct ti_cpufreq_soc_data omap36xx_soc_data = {
 	.efuse_mask = BIT(9),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = true,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -295,6 +300,7 @@ static struct ti_cpufreq_soc_data am3517_soc_data = {
 	.efuse_mask = 0,
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 static struct ti_cpufreq_soc_data am625_soc_data = {
@@ -340,7 +346,7 @@ static int ti_cpufreq_get_efuse(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->efuse_offset,
 			  &efuse);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->efuse_offset, 4);
@@ -381,7 +387,7 @@ static int ti_cpufreq_get_rev(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->rev_offset,
 			  &revision);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->rev_offset, 4);
-- 
2.43.0



