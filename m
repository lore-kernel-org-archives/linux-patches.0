Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4621D95AB;
	Tue, 15 Oct 2024 11:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992542; cv=none; b=QvmrxRKDC7rrq/QMTcbun4Slw3OIJGZEwM0MbxDt1sZAwO/ALF3Mp5hfD86hW5A+Q/x0sTpkt7nMc72H1y1zefXMuZfHCcSg1w9r8QUDUWqjYOePp6i8sRt6N6p4yEJzccNoo+qAoA1uSUq1tYRmnRPeBxuDVpwk+EK0abAo88c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992542; c=relaxed/simple;
	bh=iOcvd6ymRG6HKRNojeR3g6sCV86vkhrGnxgZCYxx4EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASWk6cYWlCTdR1h1lxHO5aSMjbP4ci5fx9PqCmH16CVYXMihjSa7Wjvc407WuGnT3/lseSydWQCG0Soeh6h+78XKUHTbuQbG+sJj4/Xww3K7w2PshDxNKfQbCbih1CJ7o6i85gyvsarRFNDVMNlSM2gNiQp56NUS/K17yRuHuCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqYhvUCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqYhvUCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DF1C4CEC6;
	Tue, 15 Oct 2024 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992542;
	bh=iOcvd6ymRG6HKRNojeR3g6sCV86vkhrGnxgZCYxx4EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqYhvUCsGoup4ICBKqOSGUvtMZLm8XP2MSQUyEikt4eJn6gaglmAKcrDEcjRGhxAw
	 xSZ+XTmyFU2i1A1htkzaDdH2DlbEF1XCNWt06NWyxeVc+5RVRCzgL+So2E2ec5EgSA
	 X02NPvKkI5ldvLvKLVNWrZTw8uyeWYl38JEAUBTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/691] cpufreq: ti-cpufreq: Introduce quirks to handle syscon fails appropriately
Date: Tue, 15 Oct 2024 13:21:03 +0200
Message-ID: <20241015112444.923928713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88bffa0bd0139..c91d416fc5809 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -53,6 +53,9 @@ struct ti_cpufreq_soc_data {
 	unsigned long efuse_shift;
 	unsigned long rev_offset;
 	bool multi_regulator;
+/* Backward compatibility hack: Might have missing syscon */
+#define TI_QUIRK_SYSCON_MAY_BE_MISSING	0x1
+	u8 quirks;
 };
 
 struct ti_cpufreq_data {
@@ -156,6 +159,7 @@ static struct ti_cpufreq_soc_data omap34xx_soc_data = {
 	.efuse_mask = BIT(3),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -183,6 +187,7 @@ static struct ti_cpufreq_soc_data omap36xx_soc_data = {
 	.efuse_mask = BIT(9),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = true,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -197,6 +202,7 @@ static struct ti_cpufreq_soc_data am3517_soc_data = {
 	.efuse_mask = 0,
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 
@@ -216,7 +222,7 @@ static int ti_cpufreq_get_efuse(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->efuse_offset,
 			  &efuse);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->efuse_offset, 4);
@@ -257,7 +263,7 @@ static int ti_cpufreq_get_rev(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->rev_offset,
 			  &revision);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->rev_offset, 4);
-- 
2.43.0



