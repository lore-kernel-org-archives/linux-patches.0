Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA51ABEB5;
	Mon, 14 Oct 2024 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917436; cv=none; b=D3Z/AXQ0eYrDWSZokrxzVuKmNE4Wt5hIBKJe5TXf8wKAW/xot7gu0uCq+AnSorPoOfxyIixRVV+tHBAdi9A2nUlADVyEF0JcFt/xmk87vUhz1r1UFjEEpz5N0PDVcqEv1HsbbPRSkLRFyYa9dHxBPRDah/LJDk0ujNTtpYV4tjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917436; c=relaxed/simple;
	bh=1kbV6BY0mDjViJyHFrSwiY0iR8yVPySFWy6Lw+ZPoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PImYmAz3IuMdnciPSgteU8/lK96+kLwnOymAHskwrlxz6WW33UJapmH7YGY0uHtI12tI3lHX2cnTQivDeFCJlsIjyjTnU5E7Tx3upCnnxs5U9b4yhN/JHVCHxZVHPZBrj3tR8HZ0DB+HdSBaEoFTVZf+bYLb2qOqT20qbizfO/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcJbzN7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcJbzN7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C26C4CEC3;
	Mon, 14 Oct 2024 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917436;
	bh=1kbV6BY0mDjViJyHFrSwiY0iR8yVPySFWy6Lw+ZPoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcJbzN7NE5YTf90dqqGY/U2v2q40OigrJW8KGtzTX72gmeozyJoFH7CyjCPE+swue
	 3s8RvTLXnFjhyAmGIKPxIChVYF3pNC/EG0pgZ6WyH1FeRNP7JsW74sR/1ZuVaSpClI
	 auMf+P9Ti0+2sfK7dhjf3/V/kLMV513ujM/NIEcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/798] cpufreq: ti-cpufreq: Introduce quirks to handle syscon fails appropriately
Date: Mon, 14 Oct 2024 16:09:49 +0200
Message-ID: <20241014141219.323661643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 15e2ef8303508..9e3c7478fc204 100644
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
@@ -155,6 +158,7 @@ static struct ti_cpufreq_soc_data omap34xx_soc_data = {
 	.efuse_mask = BIT(3),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -182,6 +186,7 @@ static struct ti_cpufreq_soc_data omap36xx_soc_data = {
 	.efuse_mask = BIT(9),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = true,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -196,6 +201,7 @@ static struct ti_cpufreq_soc_data am3517_soc_data = {
 	.efuse_mask = 0,
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 
@@ -215,7 +221,7 @@ static int ti_cpufreq_get_efuse(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->efuse_offset,
 			  &efuse);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->efuse_offset, 4);
@@ -256,7 +262,7 @@ static int ti_cpufreq_get_rev(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->rev_offset,
 			  &revision);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->rev_offset, 4);
-- 
2.43.0



