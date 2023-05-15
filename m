Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29F2FC0D
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255E6C433EF;
	Mon, 15 May 2023 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171862;
	bh=VCs9TONJQwmpJhocphEBRrgDKpKLs9hlhybImOeBahg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZI2cAz2wMYvDk41Q1Z6HNKmDEnNYdQ3z1F2yUs8hdxyf0ibetg42GHxk2ljY91yU
	 n2xTi92Zo0fkUkCkSz3k2WE6iFhkEIrnnOsyko3lS7QFCjSsDkvdZX4fcHPYUpXr9x
	 9+44n5karTyanr0yHPDvDt9UG2Jo4CNVp5c6qX58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vandita Kulkarni <vandita.kulkarni@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/134] drm/i915/dg2: Support 4k@30 on HDMI
Date: Mon, 15 May 2023 18:29:39 +0200
Message-Id: <20230515161706.524778323@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vandita Kulkarni <vandita.kulkarni@intel.com>

[ Upstream commit edd34368c4c3b45b1386b15f78b2229420f8c6d4 ]

This patch adds a fix to support 297MHz of dot clock by calculating
the pll values using synopsis algorithm.
This will help to support 4k@30 mode for HDMI monitors on DG2.

v2: As per the algorithm, set MPLLB VCO range control bits to 3,
in register SNPS_PHY_MPLLB_DIV for 297Mhz. (Matt)

v3: Fix typo. (Ankit)

Signed-off-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525080401.1253511-1-ankit.k.nautiyal@intel.com
Stable-dep-of: d46746b8b13c ("drm/i915/dg2: Add HDMI pixel clock frequencies 267.30 and 319.89 MHz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_snps_phy.c | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_snps_phy.c b/drivers/gpu/drm/i915/display/intel_snps_phy.c
index 536b319ffe5ba..1e6ba0a377265 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -582,6 +582,37 @@ static const struct intel_mpllb_state dg2_hdmi_148_5 = {
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+/* values in the below table are calculted using the algo */
+static const struct intel_mpllb_state dg2_hdmi_297 = {
+	.clock = 297000,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 6) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 3),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 86) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 26214) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 26214),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_594 = {
 	.clock = 594000,
 	.ref_control =
@@ -616,6 +647,7 @@ static const struct intel_mpllb_state *dg2_hdmi_tables[] = {
 	&dg2_hdmi_27_0,
 	&dg2_hdmi_74_25,
 	&dg2_hdmi_148_5,
+	&dg2_hdmi_297,
 	&dg2_hdmi_594,
 	NULL,
 };
-- 
2.39.2



