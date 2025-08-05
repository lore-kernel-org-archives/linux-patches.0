Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7DF272E7E;
	Tue,  5 Aug 2025 13:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399401; cv=none; b=VjXNYJqUo5kuwh5HN7c2GnIY5SMckjg4jgLHzYM8cbPpoYt+y/s7cDAhJWgVlPvKKKW5Dmd48XCp5TCQSY0Qn+NdlxXFyufnMqp/VLkdHCwVwnH1ScNdZXEv8ohDc0CB0n0vxkIeyYeeIgRtGtT0ykx9wr/eoGiX/Sxd0mIkEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399401; c=relaxed/simple;
	bh=PDR9udD4+zShHPUvTwKjzJ4kWssWjHhepo+x0VPHa78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vDklSVmUS+Bg2V2rnxDDZ6XC5CDPNwgsgxlvz6svANTKJAhJbVhvuy3kXZmglRAtCd3yR5wByi5eeCJXKh3xQhKmHyMCJ2l0sc12Tb/ImI/s440dB42x/5tBlNs0gTussc7tnakPtjE93zb8ZCbpLPG8ui8JsZn9joBA3NqOLqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7ifMCo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7ifMCo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B202C4CEF4;
	Tue,  5 Aug 2025 13:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399401;
	bh=PDR9udD4+zShHPUvTwKjzJ4kWssWjHhepo+x0VPHa78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7ifMCo4Rmb2Glx5yJy9yn+QDDYC541n4Ts8YkGZFEicAzDIEDqRPTT5s+6x+KrGs
	 C26sUMrnTBnPq6nEOXtIpBGGUhAA2Q3G3HYI0WeSptKPxEhpsVPBcdJgkMDMUf31f6
	 RbUvKUJ7jAn7mRUrT4F/oxgaAixyTvCT5V01hkAT/OsiYZuhVWkLOJKptuIJ2zpoc+
	 jjwkjNWRc2EUwjgSaQgLDv79ckUFBmw3vZxnn1v1oYq00EuYkcLQ7lRJT3Z2+38Cl3
	 VDv3oA2Fnf4p5n6licWisPvpsMbTwDMbpoTo66/DVrr9IJt1jgLb9wtrVJwKVPRubL
	 eok/eCp7ddtrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	heiko@sntech.de,
	kwilczynski@kernel.org,
	shawn.lin@rock-chips.com,
	18255117159@163.com,
	jirislaby@kernel.org,
	didi.debian@cknow.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16] PCI: dw-rockchip: Delay link training after hot reset in EP mode
Date: Tue,  5 Aug 2025 09:08:41 -0400
Message-Id: <20250805130945.471732-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

[ Upstream commit c0b93754547dde16c8370b8fdad5f396e7786647 ]

RK3588 TRM, section "11.6.1.3.3 Hot Reset and Link-Down Reset" states that:

  If you want to delay link re-establishment (after reset) so that you can
  reprogram some registers through DBI, you must set app_ltssm_enable =0
  immediately after core_rst_n as shown in above. This can be achieved by
  enable the app_dly2_en, and end-up the delay by assert app_dly2_done.

I.e. setting app_dly2_en will automatically deassert app_ltssm_enable on
a hot reset, and setting app_dly2_done will re-assert app_ltssm_enable,
re-enabling link training.

When receiving a hot reset/link-down IRQ when running in EP mode, we will
call dw_pcie_ep_linkdown(), which may update registers through DBI. Unless
link training is inhibited, these register updates race with the link
training.

To avoid the race, set PCIE_LTSSM_APP_DLY2_EN so the controller never
automatically trains the link after a link-down or hot reset interrupt.
That way any DBI updates done in the dw_pcie_ep_linkdown() path will happen
while the link is still down.  Then allow link training by setting
PCIE_LTSSM_APP_DLY2_DONE

Co-developed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250613101908.2182053-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## 1. Fixes a Clear Race Condition Bug

The commit fixes a race condition between link training and DBI register
updates after a hot reset in EP mode. As stated in the commit message
and evidenced by the code changes:

- **Line 485-487** (original): When `PCIE_LINK_REQ_RST_NOT_INT`
  interrupt occurs, `dw_pcie_ep_linkdown()` is called which updates
  registers through DBI
- Without this fix, these DBI updates race with automatic link re-
  training after reset
- The RK3588 TRM explicitly documents this race condition and the proper
  mitigation

## 2. Small and Contained Fix

The changes are minimal and well-contained:
- Adds only 2 new bit definitions (`PCIE_LTSSM_APP_DLY2_EN` and
  `PCIE_LTSSM_APP_DLY2_DONE`)
- Modifies 3 locations with simple bit operations:
  - **Line 477**: Changes variable declaration to add `val`
  - **Lines 488-491**: Adds 3 lines to re-enable link training after DBI
    updates
  - **Lines 574-577**: Modifies initialization to enable automatic delay

## 3. Affects User-Visible Functionality

Without this fix, EP mode operation can experience:
- Corrupted register updates during hot reset scenarios
- Unpredictable behavior when the host performs hot reset
- Potential link training failures

## 4. Recent Feature with Active Bug Fixes

EP mode support was only added in commit e242f26f6320 (June 2024),
making this a relatively new feature that's still being stabilized. The
driver has seen multiple recent fixes:
- 286ed198b899: Fixed PHY function call sequence
- 7d9b5d611553: Fixed link up check
- 28b8d7793b85: Fixed PERST# GPIO value

## 5. Hardware-Documented Issue

This isn't a theoretical bug - it's explicitly documented in the RK3588
TRM section 11.6.1.3.3, providing clear hardware documentation that this
sequence is required for correct operation.

## 6. No Architectural Changes

The fix:
- Doesn't introduce new features
- Doesn't change APIs or interfaces
- Only ensures proper hardware sequencing per vendor documentation
- Has minimal risk of regression (only affects RK3588 EP mode operation)

The commit meets all criteria for stable backporting: it fixes a real
bug that affects users, is small and contained, doesn't introduce
features, and has minimal regression risk.

 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 93171a392879..cd1e9352b21f 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -58,6 +58,8 @@
 
 /* Hot Reset Control Register */
 #define PCIE_CLIENT_HOT_RESET_CTRL	0x180
+#define  PCIE_LTSSM_APP_DLY2_EN		BIT(1)
+#define  PCIE_LTSSM_APP_DLY2_DONE	BIT(3)
 #define  PCIE_LTSSM_ENABLE_ENHANCE	BIT(4)
 
 /* LTSSM Status Register */
@@ -474,7 +476,7 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	struct rockchip_pcie *rockchip = arg;
 	struct dw_pcie *pci = &rockchip->pci;
 	struct device *dev = pci->dev;
-	u32 reg;
+	u32 reg, val;
 
 	reg = rockchip_pcie_readl_apb(rockchip, PCIE_CLIENT_INTR_STATUS_MISC);
 	rockchip_pcie_writel_apb(rockchip, reg, PCIE_CLIENT_INTR_STATUS_MISC);
@@ -485,6 +487,10 @@ static irqreturn_t rockchip_pcie_ep_sys_irq_thread(int irq, void *arg)
 	if (reg & PCIE_LINK_REQ_RST_NOT_INT) {
 		dev_dbg(dev, "hot reset or link-down reset\n");
 		dw_pcie_ep_linkdown(&pci->ep);
+		/* Stop delaying link training. */
+		val = HIWORD_UPDATE_BIT(PCIE_LTSSM_APP_DLY2_DONE);
+		rockchip_pcie_writel_apb(rockchip, val,
+					 PCIE_CLIENT_HOT_RESET_CTRL);
 	}
 
 	if (reg & PCIE_RDLH_LINK_UP_CHGED) {
@@ -566,8 +572,11 @@ static int rockchip_pcie_configure_ep(struct platform_device *pdev,
 		return ret;
 	}
 
-	/* LTSSM enable control mode */
-	val = HIWORD_UPDATE_BIT(PCIE_LTSSM_ENABLE_ENHANCE);
+	/*
+	 * LTSSM enable control mode, and automatically delay link training on
+	 * hot reset/link-down reset.
+	 */
+	val = HIWORD_UPDATE_BIT(PCIE_LTSSM_ENABLE_ENHANCE | PCIE_LTSSM_APP_DLY2_EN);
 	rockchip_pcie_writel_apb(rockchip, val, PCIE_CLIENT_HOT_RESET_CTRL);
 
 	rockchip_pcie_writel_apb(rockchip, PCIE_CLIENT_EP_MODE,
-- 
2.39.5

