Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D9E27BF8D;
	Tue, 27 May 2025 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368097; cv=none; b=FSa/VmW6guezh2CX9hiNnzLOIhMDdHMuvLcsmyZUGUjFxKidyeDMqJgUQPzYfzTB5IW9HrsJrvzoVVWeskcU8xKBCBNzT5YNYM7RuOgosgcfCKMqH6Jt3c75n0rjQGK0NmzKuF/4g9/2byzg4e1/yUkp+KrIit8wUUNH3K7y0d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368097; c=relaxed/simple;
	bh=EHsMu1IxQOcnZQdTwwXK7plbseNrPTgyF0X6X7cDQAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwFqo8tE5zv4//roXBvnjaQ39PRty29istJBdo2/9p1nOKf31iq3SmKlvbwYGCyKSykJA53/XTJCApIErMViUEx3fsNLn8F9zRiT3UzCxigAVBG45S5NjV9UKcJkstH2711pdI0r5115zQbB0kys51HGOEn608kRVRT+bj7ul/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wppnIvK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wppnIvK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3021CC4CEE9;
	Tue, 27 May 2025 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368097;
	bh=EHsMu1IxQOcnZQdTwwXK7plbseNrPTgyF0X6X7cDQAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wppnIvK+hC58AQ19pgxlkeWrgV4mwpyl/6DxpMtJFkIYXt3VfMQxgAeOoLhbu7OeM
	 8eRbePk4MqE0GQXEfFtfhQnQjWmsfPvqU1u7n4/Mi5BsW9wx+56yJwhZtRP2PYMrhE
	 8iFYdbi4ThNb4EEPfV2A4HuKCbSqdtirqEFSClpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 597/783] clk: renesas: rzg2l-cpg: Refactor Runtime PM clock validation
Date: Tue, 27 May 2025 18:26:34 +0200
Message-ID: <20250527162537.450260037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit f6f73b891bf6beff069fcacc7b4a796e1009bf26 ]

Refactor rzg2l_cpg_attach_dev to delegate clock validation for Runtime PM
to the updated rzg2l_cpg_is_pm_clk function. Ensure validation of clocks
associated with the power domain while excluding external and core clocks.
Prevent incorrect Runtime PM management for clocks outside the domain's
scope.

Update rzg2l_cpg_is_pm_clk to operate on a per-power-domain basis. Verify
clkspec.np against the domain's device node, check argument validity, and
validate clock type (CPG_MOD). Use the no_pm_mod_clks array to exclude
specific clocks from PM management.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241216210201.239855-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 102 +++++++++++++++++---------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 4bd8862dc82be..91928db411dcd 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1549,28 +1549,6 @@ static int rzg2l_cpg_reset_controller_register(struct rzg2l_cpg_priv *priv)
 	return devm_reset_controller_register(priv->dev, &priv->rcdev);
 }
 
-static bool rzg2l_cpg_is_pm_clk(struct rzg2l_cpg_priv *priv,
-				const struct of_phandle_args *clkspec)
-{
-	const struct rzg2l_cpg_info *info = priv->info;
-	unsigned int id;
-	unsigned int i;
-
-	if (clkspec->args_count != 2)
-		return false;
-
-	if (clkspec->args[0] != CPG_MOD)
-		return false;
-
-	id = clkspec->args[1] + info->num_total_core_clks;
-	for (i = 0; i < info->num_no_pm_mod_clks; i++) {
-		if (info->no_pm_mod_clks[i] == id)
-			return false;
-	}
-
-	return true;
-}
-
 /**
  * struct rzg2l_cpg_pm_domains - RZ/G2L PM domains data structure
  * @onecell_data: cell data
@@ -1595,45 +1573,73 @@ struct rzg2l_cpg_pd {
 	u16 id;
 };
 
+static bool rzg2l_cpg_is_pm_clk(struct rzg2l_cpg_pd *pd,
+				const struct of_phandle_args *clkspec)
+{
+	if (clkspec->np != pd->genpd.dev.of_node || clkspec->args_count != 2)
+		return false;
+
+	switch (clkspec->args[0]) {
+	case CPG_MOD: {
+		struct rzg2l_cpg_priv *priv = pd->priv;
+		const struct rzg2l_cpg_info *info = priv->info;
+		unsigned int id = clkspec->args[1];
+
+		if (id >= priv->num_mod_clks)
+			return false;
+
+		id += info->num_total_core_clks;
+
+		for (unsigned int i = 0; i < info->num_no_pm_mod_clks; i++) {
+			if (info->no_pm_mod_clks[i] == id)
+				return false;
+		}
+
+		return true;
+	}
+
+	case CPG_CORE:
+	default:
+		return false;
+	}
+}
+
 static int rzg2l_cpg_attach_dev(struct generic_pm_domain *domain, struct device *dev)
 {
 	struct rzg2l_cpg_pd *pd = container_of(domain, struct rzg2l_cpg_pd, genpd);
-	struct rzg2l_cpg_priv *priv = pd->priv;
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args clkspec;
 	bool once = true;
 	struct clk *clk;
+	unsigned int i;
 	int error;
-	int i = 0;
-
-	while (!of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
-					   &clkspec)) {
-		if (rzg2l_cpg_is_pm_clk(priv, &clkspec)) {
-			if (once) {
-				once = false;
-				error = pm_clk_create(dev);
-				if (error) {
-					of_node_put(clkspec.np);
-					goto err;
-				}
-			}
-			clk = of_clk_get_from_provider(&clkspec);
+
+	for (i = 0; !of_parse_phandle_with_args(np, "clocks", "#clock-cells", i, &clkspec); i++) {
+		if (!rzg2l_cpg_is_pm_clk(pd, &clkspec)) {
 			of_node_put(clkspec.np);
-			if (IS_ERR(clk)) {
-				error = PTR_ERR(clk);
-				goto fail_destroy;
-			}
+			continue;
+		}
 
-			error = pm_clk_add_clk(dev, clk);
+		if (once) {
+			once = false;
+			error = pm_clk_create(dev);
 			if (error) {
-				dev_err(dev, "pm_clk_add_clk failed %d\n",
-					error);
-				goto fail_put;
+				of_node_put(clkspec.np);
+				goto err;
 			}
-		} else {
-			of_node_put(clkspec.np);
 		}
-		i++;
+		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			goto fail_destroy;
+		}
+
+		error = pm_clk_add_clk(dev, clk);
+		if (error) {
+			dev_err(dev, "pm_clk_add_clk failed %d\n", error);
+			goto fail_put;
+		}
 	}
 
 	return 0;
-- 
2.39.5



