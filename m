Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48893D3D04;
	Fri, 24 Apr 2026 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037709; cv=none; b=mbX9xolWYCzABkZ+McZGnp85kU6zbVxZpAVDWTnHr5Ggl/C0odOiYu3pYgyvb2zAZiVQJZHEvR4RjpTZEz568PLBHJvF7IglhM6rEWG0/Bub24vCq65b2ZEa1Dt+vQAq9g7DAdSCfh9iRpuhH3CkcNs8sNr5sWzzw8M15LXR8QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037709; c=relaxed/simple;
	bh=n+dIhvZOWD/BtOhXeCSlbpcenMuvCrO9LK1vo88TpCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM/Vc+CwxEsJxc3/3iO/f5Tx/HdLQlJazSbEv7Dgq/AJm0AUaTCGP6Obi2tkjSrnQdVqF8SuQvh9Md468LkVHCISp5iZw5sX5Xy6qaUoAtBcH2B3RYgZCkZshl9mdn/zRlU0Q51Lx5FrmIwMj772Ce4U7HFpJoIQ1eMCsANLA0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzIccQn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzIccQn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7D9C19425;
	Fri, 24 Apr 2026 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037708;
	bh=n+dIhvZOWD/BtOhXeCSlbpcenMuvCrO9LK1vo88TpCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzIccQn2fc1EGx76RX+HFp03EeukAGzZo8VgazZimTrvc0gYUJgGOslHn2yCbfhdH
	 52DY7rc+r7CuOdOe/AG3gYc5f3DmenYDo94UBTby8vJSQfujkHpNdKN0ru1zgRhAXN
	 uESo393Swk7nt6lDxg4rWNrxPP0/OCtfqOecZ5cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/166] net: stmmac: Fix PTP ref clock for Tegra234
Date: Fri, 24 Apr 2026 15:29:13 +0200
Message-ID: <20260424132541.051315495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index 760405b805f40..e950016d10914 100644
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



