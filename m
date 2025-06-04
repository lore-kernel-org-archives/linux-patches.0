Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5A11F5834;
	Wed,  4 Jun 2025 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998895; cv=none; b=jYihP3E2TlCHNKmSPLmMTKUboa6Vl6wg2rjc2HgfOwAIQj2feYtlV2T3G9q4YFmjNYpYXgoS+8E4OVac7NlI++q0MFU8Q1SAFsXNcxZvQEs21I+nkCytqCyDAn4r9K4irCZtK2GQmw0By0VG5bC3F8Y/oq0BAdQxrJNKLIyMhro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998895; c=relaxed/simple;
	bh=dOd6XaSZpdYSKJ19JNfevYC70ozIjITQTvyOKjNHziY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1hjssSBZMtDHgVe6tBPvDEvDabUQv4mDI1YcAeOUfFPMeATsmrHKXepdUAFxfzp8bAk6fkiKgmW4vSX3GdesGSPk3jR7Q4EQ3KWsv5xRZB2elwLtWS0+/ZZ0/n0rljOuz0h4NNtLsWuP9UYQsPTmuEsclZXPCm8c7eiNKQ1ZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aaK7Hcig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aaK7Hcig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992C7C4CEED;
	Wed,  4 Jun 2025 01:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998894;
	bh=dOd6XaSZpdYSKJ19JNfevYC70ozIjITQTvyOKjNHziY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaK7HcigM0xGAJOTwDZ+TDZPGYqF7zJBQgYq9mVkSVIhDdwhOP15eHxPYm4Pipchn
	 adpTCWlKmR7ubU787X0plm50xARSvTUg0loz1X6yvH9MabQYZZ+ADEjg3bfY2mmkpR
	 SRbqjqjdQQFFlRkSGVqf0zn7kg6iEPmi9JjPW74IkhUpzyGlnKvDtVmsJ1V6DnhIHa
	 3Cj5iXFgPyfP73zMRw8JBkepSu/Mz1wKvBVOD7N+Hw6Dju9wmwgnvoJiTzK8IUfoe/
	 9bCbjuBRQxIoQS6a5a9HVrxKeC5xTKLk5llwKPlOkquPRBAqs9bpoL6aMDAYKTzhZn
	 +829mb7Unb5/A==
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
Subject: [PATCH AUTOSEL 6.12 73/93] net: ethernet: ti: am65-cpsw: handle -EPROBE_DEFER
Date: Tue,  3 Jun 2025 20:58:59 -0400
Message-Id: <20250604005919.4191884-73-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index a21e7c0afbfdc..ddda5274f5b2c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2693,7 +2693,9 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			goto of_node_put;
 
 		ret = of_get_mac_address(port_np, port->slave.mac_addr);
-		if (ret) {
+		if (ret == -EPROBE_DEFER) {
+			goto of_node_put;
+		} else if (ret) {
 			am65_cpsw_am654_get_efuse_macid(port_np,
 							port->port_id,
 							port->slave.mac_addr);
@@ -3586,6 +3588,16 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
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
@@ -3602,16 +3614,6 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
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

