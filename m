Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DA73090C1;
	Sat, 14 Feb 2026 21:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104439; cv=none; b=Mgge8HdZUytiha11xW1WfAcZ/vZi2qvrw2wYFJFWiK6eq8kEQPYF9o9lC9AeeEAMrgSwgfwXrVLiWsCT/dkEVzNqOGeISjZpGquMJMPDsQl0azyyRodEW1E+cwTa35FOXAjut1Fe8uow/QFh+S832KMkfyJmke9XIkEMeosO/ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104439; c=relaxed/simple;
	bh=5B+y1/9UFO5UHwNM95mpU5Yo9tgGTHgo0lH4ZEMMc7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRzm0jSVR9+oYmlLW/PbqYPW2MUfooE4L64/bkHBtKi9ou4VAYpTF7sfrID/F/RdoXPubU1sn3Ghx+txShtQf453StWgr7iWdzNjCVfdf3msYPlpxDHfH87RIwZ3eBHNdKolNofTkz4ADEWPFUPgl43LKOh8vF8JiQ8H9kt8xRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c476ZOg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c476ZOg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA8C19423;
	Sat, 14 Feb 2026 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104439;
	bh=5B+y1/9UFO5UHwNM95mpU5Yo9tgGTHgo0lH4ZEMMc7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c476ZOg5znoDeYJ/j14m2k0Al9UpEO53uRQ2SEgKAE9g35Kn8gZJ4lht2s1UzwgZ8
	 8thLwKn8bRw4sCobvmBd7HNl4XJO+0nk4dc3Vgt6qufc6ZGdDv/VlLP07BBKCT4pQc
	 a6htomWUJ5Pqqwrd4HEfGlxWBJbOV4LLxqWli+eRlz1XQFuqhLvWOkI1K9TRL8UKIg
	 xRhULfIrr1AEFRlFLhq7gMs3U+7tOUKC9f+3BrVMumwKroCaA3af1Z1Oryz2ePsv3/
	 Y/D4dUzI20+OW4q3Vdmmqh+MWJKKYfYF4nvMsZmQzzv0jS3H6D7bdu2zeBJOBJugUA
	 opGFSKtoUn0zg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>,
	l.stach@pengutronix.de,
	linux-pci@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	imx@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.18] PCI: imx6: Add CLKREQ# override to enable REFCLK for i.MX95 PCIe
Date: Sat, 14 Feb 2026 16:23:49 -0500
Message-ID: <20260214212452.782265-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 27a064aba2da6bc58fc36a6b8e889187ae3bf89d ]

The CLKREQ# is an open drain, active low signal that is driven low by
the card to request reference clock. It's an optional signal added in
PCIe CEM r4.0, sec 2. Thus, this signal wouldn't be driven low if it's
not exposed on the slot.

On the i.MX95 EVK board, REFCLK to the host and endpoint is gated by this
CLKREQ# signal. So if the CLKREQ# signal is not driven by the endpoint, it
will gate the REFCLK to host too, leading to operational failure.

Hence, enable the REFCLK on this SoC by enabling the CLKREQ# override using
imx95_pcie_clkreq_override() helper during probe. This override should only
be cleared when the CLKREQ# signal is exposed on the slot.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251015030428.2980427-11-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is very instructive. The same author (Richard Zhu) previously fixed
the same kind of issue for i.MX8MM — CLKREQ# not being asserted causing
operational failures. That commit had a `Fixes:` tag and was clearly a
bug fix. This commit for i.MX95 is the same pattern — the same bug, same
root cause, same type of fix, just for a different SoC.

### Summary Assessment

**What the commit fixes**: On i.MX95, PCIe is non-functional when the
endpoint doesn't drive the CLKREQ# signal (which is optional per PCIe
CEM spec). Without this fix, the reference clock to the host is gated,
causing complete operational failure of PCIe.

**Nature of the fix**: This is a hardware workaround — it enables
CLKREQ# override so the reference clock isn't gated. It's analogous to
the `imx8mm_pcie_enable_ref_clk` which does the same thing (assert
CLKREQ# override) for i.MX8MQ/8MM/8MP.

**Dependencies**: The `enable_ref_clk` callback infrastructure (commit
256867b74625a) must be present. This was added in the 6.11 timeframe
along with i.MX95 support. The code should exist in stable trees that
have i.MX95 support.

**Risk**: Very low — only affects i.MX95 PCIe. Simple register writes.
Uses well-established callback pattern already in use by all other SoC
variants.

**User impact**: HIGH for i.MX95 users — PCIe may be completely non-
functional without this fix when CLKREQ# is not driven by the endpoint.

**Stable criteria**:
- Fixes a real bug (PCIe non-functional) — YES
- Obviously correct (simple register writes, tested, reviewed) — YES
- Small and contained (~30 lines, single file) — YES
- No new features (it's a hardware workaround for existing platform) —
  YES

This is essentially a hardware quirk/workaround that makes an existing
driver work correctly. It falls squarely into the category of hardware-
specific workarounds that are acceptable for stable backporting. The
same class of fix was previously done for i.MX8MM with a `Fixes:` tag.

**YES**

 drivers/pci/controller/dwc/pci-imx6.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 4668fc9648bff..34f8f69ddfae9 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -52,6 +52,8 @@
 #define IMX95_PCIE_REF_CLKEN			BIT(23)
 #define IMX95_PCIE_PHY_CR_PARA_SEL		BIT(9)
 #define IMX95_PCIE_SS_RW_REG_1			0xf4
+#define IMX95_PCIE_CLKREQ_OVERRIDE_EN		BIT(8)
+#define IMX95_PCIE_CLKREQ_OVERRIDE_VAL		BIT(9)
 #define IMX95_PCIE_SYS_AUX_PWR_DET		BIT(31)
 
 #define IMX95_PE0_GEN_CTRL_1			0x1050
@@ -706,6 +708,22 @@ static int imx7d_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 	return 0;
 }
 
+static void imx95_pcie_clkreq_override(struct imx_pcie *imx_pcie, bool enable)
+{
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_1,
+			   IMX95_PCIE_CLKREQ_OVERRIDE_EN,
+			   enable ? IMX95_PCIE_CLKREQ_OVERRIDE_EN : 0);
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IMX95_PCIE_SS_RW_REG_1,
+			   IMX95_PCIE_CLKREQ_OVERRIDE_VAL,
+			   enable ? IMX95_PCIE_CLKREQ_OVERRIDE_VAL : 0);
+}
+
+static int imx95_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
+{
+	imx95_pcie_clkreq_override(imx_pcie, enable);
+	return 0;
+}
+
 static int imx_pcie_clk_enable(struct imx_pcie *imx_pcie)
 {
 	struct dw_pcie *pci = imx_pcie->pci;
@@ -1913,6 +1931,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.core_reset = imx95_pcie_core_reset,
 		.init_phy = imx95_pcie_init_phy,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
+		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 	},
 	[IMX8MQ_EP] = {
 		.variant = IMX8MQ_EP,
@@ -1969,6 +1988,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 		.core_reset = imx95_pcie_core_reset,
 		.wait_pll_lock = imx95_pcie_wait_for_phy_pll_lock,
 		.epc_features = &imx95_pcie_epc_features,
+		.enable_ref_clk = imx95_pcie_enable_ref_clk,
 		.mode = DW_PCIE_EP_TYPE,
 	},
 };
-- 
2.51.0

