Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F91B39E182;
	Mon, 20 Apr 2026 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690944; cv=none; b=vFYez1YdXOF8dyFB6738uQe2ea56/SGAvUltMnjjU0g4jrg0hKXAPbwqAlKpMXnat08Jh4OpMzbIgQtIQPVRhGG16mXhE/tmx6iEkVAUJX+jF6+qDTBqBn7cTJ6towGpCn8SWUAhEJRzD+AxbvQRoPvqjVGImM0k1pLIvum2vcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690944; c=relaxed/simple;
	bh=nbtEepHGcKjFocf8FsJ2bVcEcjjJDHtrZnTX6JgzQFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKnCxe4gLP/7OfL6KckY/8PE0icqEUCcWBMu49GPbBZCSJ/nKfi7xi9Bdz4gGfL4x8RReXFL04jOuGSjL0w43/RJ2ngJSnDqgg8BuqCKh7hFG/Ey4/87bZ4oZDwsW9DGqj47gRPbrhtex6RApFj5tjH5FbcAcbn3zgNDuWF7GOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HumKejWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HumKejWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45751C2BCB7;
	Mon, 20 Apr 2026 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690944;
	bh=nbtEepHGcKjFocf8FsJ2bVcEcjjJDHtrZnTX6JgzQFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HumKejWe7qIhwPaC0X4XqES8bxWuB5nSPYAkQJQqcjo2p/7Rmz1rmBiNc7AfEgAa3
	 4WLsdGmQBSwXWyk19+eOmNF8LWcvumLQYly89ehv+v4IDGlNwFze4FsFs++i6T/Ati
	 u8vYH0yJ2PncMt0iEY+zGvrploArpUfp38VYXqczqk6O8efuTWOPq0b3kblTNf3gZr
	 mZskCmdVoyGmCc3jghGsAIvV1kxQ0fo2oQnuXF0uQHcAXOljmON6T5NurRd11KnLc7
	 GJUWqP1oXTUDBy7utgWraLGy28Eh1uXVBF5tR+ZLUoMwGzTfmkrzKtTT4Rjuax8hXO
	 g3aG1iDZLPWwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jon Hunter <jonathanh@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	thierry.reding@gmail.com,
	vbhadram@nvidia.com,
	ruppala@nvidia.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: stmmac: Fix PTP ref clock for Tegra234
Date: Mon, 20 Apr 2026 09:07:48 -0400
Message-ID: <20260420131539.986432-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 1345e9f4e3f3bc7d8a0a2138ae29e205a857a555 ]

Since commit 030ce919e114 ("net: stmmac: make sure that ptp_rate is not
0 before configuring timestamping") was added the following error is
observed on Tegra234:

 ERR KERN tegra-mgbe 6800000.ethernet eth0: Invalid PTP clock rate
 WARNING KERN tegra-mgbe 6800000.ethernet eth0: PTP init failed

It turns out that the Tegra234 device-tree binding defines the PTP ref
clock name as 'ptp-ref' and not 'ptp_ref' and the above commit now
exposes this and that the PTP clock is not configured correctly.

In order to update device-tree to use the correct 'ptp_ref' name, update
the Tegra MGBE driver to use 'ptp_ref' by default and fallback to using
'ptp-ref' if this clock name is present.

Fixes: d8ca113724e7 ("net: stmmac: tegra: Add MGBE support")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260401102941.17466-2-jonathanh@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index d765acbe37548..21a0a11fc0118 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -9,7 +9,7 @@
 #include "stmmac_platform.h"
 
 static const char *const mgbe_clks[] = {
-	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp-ref", "mac"
+	"rx-pcs", "tx", "tx-pcs", "mac-divider", "mac", "mgbe", "ptp_ref", "mac"
 };
 
 struct tegra_mgbe {
@@ -215,6 +215,7 @@ static int tegra_mgbe_probe(struct platform_device *pdev)
 {
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_resources res;
+	bool use_legacy_ptp = false;
 	struct tegra_mgbe *mgbe;
 	int irq, err, i;
 	u32 value;
@@ -257,9 +258,23 @@ static int tegra_mgbe_probe(struct platform_device *pdev)
 	if (!mgbe->clks)
 		return -ENOMEM;
 
-	for (i = 0; i <  ARRAY_SIZE(mgbe_clks); i++)
+	/* Older device-trees use 'ptp-ref' rather than 'ptp_ref'.
+	 * Fall back when the legacy name is present.
+	 */
+	if (of_property_match_string(pdev->dev.of_node, "clock-names",
+				     "ptp-ref") >= 0)
+		use_legacy_ptp = true;
+
+	for (i = 0; i < ARRAY_SIZE(mgbe_clks); i++) {
 		mgbe->clks[i].id = mgbe_clks[i];
 
+		if (use_legacy_ptp && !strcmp(mgbe_clks[i], "ptp_ref")) {
+			dev_warn(mgbe->dev,
+				 "Device-tree update needed for PTP clock!\n");
+			mgbe->clks[i].id = "ptp-ref";
+		}
+	}
+
 	err = devm_clk_bulk_get(mgbe->dev, ARRAY_SIZE(mgbe_clks), mgbe->clks);
 	if (err < 0)
 		return err;
-- 
2.53.0

