Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640291D0487;
	Wed,  2 Oct 2024 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879212; cv=none; b=Yxc+dCxdfR9swbq2Y9fgmEXXq1guV/2cHf12YjZm1raOaFsaoSAQKH7pXvFXmYAdb9Vb37tioNh+CUogjtZjfdbAbOrP+lczrtocNxIdR/msqZo+HfJ6OyiER0qBEfXnwsKryt8jiB64guUEZBnLngkQaS0SeRwMUdSnjAjm5Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879212; c=relaxed/simple;
	bh=m00PVIg+QB2GrDHjIu5H8fkiu2zybpYrIZ5B9xGtL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI8mVqIR3pS6uzRqhkmnzbSrMkeLLoUsfOT6cWpitdgGms3sHuMyh2TsHiixcCIk/VGcFceAw4Qmh1nTFgJxXmX8I6hZ9KJP4YnRxPMXdOg+PxZ2en58+4bXjq+1SGd8qQ3sPjlkyHoa5VSCrkmKqWbzWWUU4DdU4kIhqWGtx2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyEIx7IU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyEIx7IU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E89C4CEC2;
	Wed,  2 Oct 2024 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879212;
	bh=m00PVIg+QB2GrDHjIu5H8fkiu2zybpYrIZ5B9xGtL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyEIx7IUoQbPdRaMvp9w8oQ5zh2Cc0Byl7pIiqowPzEt4z9uasXRJQ1UxzjFOZ1q5
	 k8mC4+lTOmOlZ/OkQG2aVL5rSy1kMtjYRldMiCnrxDqZiv2PF0gotHD+v/tV3olh3d
	 Eh4q0J84qrI/KNOc8ZZG9mtISxe94kVmQu3BJWxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/538] cpufreq: ti-cpufreq: Introduce quirks to handle syscon fails appropriately
Date: Wed,  2 Oct 2024 14:54:41 +0200
Message-ID: <20241002125753.690386091@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d88ee87b1cd6f..cb5d1c8fefeb4 100644
--- a/drivers/cpufreq/ti-cpufreq.c
+++ b/drivers/cpufreq/ti-cpufreq.c
@@ -61,6 +61,9 @@ struct ti_cpufreq_soc_data {
 	unsigned long efuse_shift;
 	unsigned long rev_offset;
 	bool multi_regulator;
+/* Backward compatibility hack: Might have missing syscon */
+#define TI_QUIRK_SYSCON_MAY_BE_MISSING	0x1
+	u8 quirks;
 };
 
 struct ti_cpufreq_data {
@@ -182,6 +185,7 @@ static struct ti_cpufreq_soc_data omap34xx_soc_data = {
 	.efuse_mask = BIT(3),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -209,6 +213,7 @@ static struct ti_cpufreq_soc_data omap36xx_soc_data = {
 	.efuse_mask = BIT(9),
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = true,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 /*
@@ -223,6 +228,7 @@ static struct ti_cpufreq_soc_data am3517_soc_data = {
 	.efuse_mask = 0,
 	.rev_offset = OMAP3_CONTROL_IDCODE - OMAP3_SYSCON_BASE,
 	.multi_regulator = false,
+	.quirks = TI_QUIRK_SYSCON_MAY_BE_MISSING,
 };
 
 static struct ti_cpufreq_soc_data am625_soc_data = {
@@ -250,7 +256,7 @@ static int ti_cpufreq_get_efuse(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->efuse_offset,
 			  &efuse);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->efuse_offset, 4);
@@ -291,7 +297,7 @@ static int ti_cpufreq_get_rev(struct ti_cpufreq_data *opp_data,
 
 	ret = regmap_read(opp_data->syscon, opp_data->soc_data->rev_offset,
 			  &revision);
-	if (ret == -EIO) {
+	if (opp_data->soc_data->quirks & TI_QUIRK_SYSCON_MAY_BE_MISSING && ret == -EIO) {
 		/* not a syscon register! */
 		void __iomem *regs = ioremap(OMAP3_SYSCON_BASE +
 				opp_data->soc_data->rev_offset, 4);
-- 
2.43.0



