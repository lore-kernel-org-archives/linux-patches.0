Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14641C3314;
	Wed,  4 Jun 2025 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998707; cv=none; b=LlAq0wqwuZ4iu5JDZo14bJQa1NhwmNVdE31AnKaEMa+C6G7RCa/j6kl+tleQjolbK1TivceyLAEv3nBjwnzTx5LNwoEv8E9wlcIGbXPr/UaaW16llmZQ3eGJ9iWt+uOI3+gJVCo0H/SAyHbgmKFYRAPLd+VAfN6Zp2uEmMXFJg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998707; c=relaxed/simple;
	bh=ZTrE/ELES/4kUWn4ZI002oAiqnoiZmMEIVgmHg208BI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCGP6ov5693lH4+o5L5br/jwrgb/n2V5SN8a4vTlZVUc0EQSuwlC1eewZ4FT2y1k0E6ZbWFEz0XLScjiCBFv4BkZq7mkv2nkppEuHBuTNpwconYFl7Asx3nNZuh6VQ4uR4e7+eMvMUCXZ+DxJrgWYUWNSp+PCy2gNZRmP+bT1Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCgoS1ZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCgoS1ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6403BC4CEED;
	Wed,  4 Jun 2025 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998707;
	bh=ZTrE/ELES/4kUWn4ZI002oAiqnoiZmMEIVgmHg208BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCgoS1ZOaBL5bgDyjEEFyiirYssLtgPDzkXoFpt3TSAYz8cIHy3Nlr0i66+MkV5i/
	 YneDfh/bG5c0E8Wm3XB/brZD0W7HKUvyIsF4nG8hVxH1mg2ve9hOvyxR36C74Un/Pb
	 4B0VsgG0C5HzTvHuXvIny6VrZQG/kkCw7XYlVMQxbO+6WY+bemLqM9zln1Rw74zrgk
	 naHDEVEGiTgsQYdP7kWVj3qQNwPpmxaHo7/fFDoY+6UawMYTiHHQ46nTduoyQWL1bj
	 FEk3IzosLfbQGpOb+Wpy0CcrZkrNwtwHV85e3cuN8TE2+J5U0159D/8Fl9AQ91hhGL
	 +u+OOECjKL06A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Walle <mwalle@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rogerq@kernel.org,
	horms@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH AUTOSEL 6.14 084/108] net: ethernet: ti: am65-cpsw: handle -EPROBE_DEFER
Date: Tue,  3 Jun 2025 20:55:07 -0400
Message-Id: <20250604005531.4178547-84-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 09737cb80b8686ffca4ed1805fee745d5c85604d ]

of_get_mac_address() might fetch the MAC address from NVMEM and that
driver might not have been loaded. In that case, -EPROBE_DEFER is
returned. Right now, this will trigger an immediate fallback to
am65_cpsw_am654_get_efuse_macid() possibly resulting in a random MAC
address although the MAC address is stored in the referenced NVMEM.

Fix it by handling the -EPROBE_DEFER return code correctly. This also
means that the creation of the MDIO device has to be moved to a later
stage as -EPROBE_DEFER must not be returned after child devices are
created.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250414084336.4017237-3-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of this commit and comparison with the similar
commits provided, here is my assessment: **YES** This commit should be
backported to stable kernel trees for the following reasons: ## Analysis
of Code Changes 1. **Proper EPROBE_DEFER Handling**: The commit adds
explicit handling for `-EPROBE_DEFER` from `of_get_mac_address()` by
checking `if (ret == -EPROBE_DEFER)` and properly propagating this error
code up the call stack. This matches the pattern seen in the similar
commits marked as "YES" for backporting. 2. **Critical Timing Issue
Fix**: The code reordering addresses a fundamental probe ordering
problem. Previously, the MDIO device creation happened before MAC
address acquisition, but the commit message explicitly states that
"-EPROBE_DEFER must not be returned after child devices are created."
This reordering moves: - `am65_cpsw_nuss_get_ver(common)` -
`am65_cpsw_nuss_init_host_p(common)` -
`am65_cpsw_nuss_init_slave_ports(common)` (which contains the MAC
address handling) Before the MDIO device creation, ensuring proper defer
handling. 3. **Functional Correctness**: Without this fix, when NVMEM
backing the MAC address isn't ready, the driver would immediately fall
back to `am65_cpsw_am654_get_efuse_macid()` and potentially use a random
MAC address, even though a proper MAC address exists in NVMEM but just
isn't available yet. ## Comparison with Similar Commits This commit
follows the exact same pattern as the "YES" backport commits: -
**dm9000**: Added `else if (PTR_ERR(mac_addr) == -EPROBE_DEFER) return
ERR_CAST(mac_addr);` - **mv643xx_eth**: Added `ret =
of_get_mac_address(pnp, ppd.mac_addr); if (ret) return ret;` -
**mtk_eth_soc**: Added `if (err == -EPROBE_DEFER) return err;` ##
Stability Assessment 1. **Minimal Risk**: The changes are minimal and
surgical - only adding proper error handling for a specific case 2. **No
Architectural Changes**: No new features or major architectural
modifications 3. **Confined to Single Driver**: Changes are isolated to
the TI am65-cpsw driver 4. **Clear Error Path**: The error handling
follows established kernel patterns 5. **No Side Effects**: The
reordering doesn't change functional behavior, only ensures proper defer
semantics ## Backport Suitability Criteria Met ✅ **Fixes Important
Bug**: Prevents incorrect MAC address assignment when NVMEM provider
isn't ready ✅ **Small and Contained**: Only 13 insertions, 11 deletions
across 24 lines ✅ **No New Features**: Pure bugfix for existing
functionality ✅ **Minimal Risk**: Well-established pattern used in other
drivers ✅ **Critical Subsystem**: Network driver functionality ✅ **Clear
Problem Statement**: Commit message clearly explains the issue and
solution The commit addresses a real-world scenario where MAC addresses
stored in NVMEM (common in embedded systems) would be ignored due to
probe timing, leading to random MAC addresses and potential network
configuration issues.

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index cac67babe4559..ab1df0ea09f4a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2769,7 +2769,9 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
-		if (ret) {
+		if (ret == -EPROBE_DEFER) {
+			goto of_node_put;
+		} else if (ret) {
 			am65_cpsw_am654_get_efuse_macid(port_np,
 							port->port_id,
 							port->slave.mac_addr);
@@ -3647,6 +3649,16 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	am65_cpsw_nuss_get_ver(common);
+
+	ret = am65_cpsw_nuss_init_host_p(common);
+	if (ret)
+		goto err_pm_clear;
+
+	ret = am65_cpsw_nuss_init_slave_ports(common);
+	if (ret)
+		goto err_pm_clear;
+
 	node = of_get_child_by_name(dev->of_node, "mdio");
 	if (!node) {
 		dev_warn(dev, "MDIO node not found\n");
@@ -3663,16 +3675,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	}
 	of_node_put(node);
 
-	am65_cpsw_nuss_get_ver(common);
-
-	ret = am65_cpsw_nuss_init_host_p(common);
-	if (ret)
-		goto err_of_clear;
-
-	ret = am65_cpsw_nuss_init_slave_ports(common);
-	if (ret)
-		goto err_of_clear;
-
 	/* init common data */
 	ale_params.dev = dev;
 	ale_params.ale_ageout = AM65_CPSW_ALE_AGEOUT_DEFAULT;
-- 
2.39.5

