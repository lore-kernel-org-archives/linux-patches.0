Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687336C0CB;
	Tue,  6 Jan 2026 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722283; cv=none; b=CJwwBxYrzFbboBgG7SG78vk9cMFp0DCePqKH6tbpo3pX1FAe30G4gv6DXnyll+GMKqKQu/uJ8iTQ3E9+Sy/Npw29M3LiLwa5Gnr2C2hkDf3I/oOEOpFLeOPQAEBbd1Q2yEqQuVnit/FBNab0+zqbT6KWb6QjATO/g+2AC9e5KQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722283; c=relaxed/simple;
	bh=8F4B8g3RHTOpHkUBEYvIqbGm+QgWDc/DKkj+3wgrWwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IieYfhHNqap+t442LLdcGD9Cvwb8DLLHauFQANn2Yma5uQRB605NuveQRZK90UwP2d4uwMdQwNtLh3SLXRQoeElKCKJTPTVB1+uUyvM/n6+VrGbOYgmn5XrLhqkEF+cCynvgxfE01b7RZeRFrEDqfpMzafLH2Xjt54QJHzBomAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGaHOB8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGaHOB8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28444C116C6;
	Tue,  6 Jan 2026 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722281;
	bh=8F4B8g3RHTOpHkUBEYvIqbGm+QgWDc/DKkj+3wgrWwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGaHOB8PXeWVGBvq33eKvgTsh4nLmN9vy+nAHyu3IRwu7qpmRWgv9ZomUMymH/Ydc
	 BzDQpqHdqaZc+8FoQa5SY/w8WgiHSOX2Zx3uGEMe84ktnJPUypVajnOO0QgV3iY+2j
	 5UCrPsY6BwxTpr5A+lqesKSCLI7yXaGuINu3TdHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 217/312] pmdomain: mtk-pm-domains: Fix spinlock recursion fix in probe
Date: Tue,  6 Jan 2026 18:04:51 +0100
Message-ID: <20260106170555.693688296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Macpaul Lin <macpaul.lin@mediatek.com>

commit 305f254727bd379bbed0385afa0162f5bde1f51c upstream.

Remove scpsys_get_legacy_regmap(), replacing its usage with
of_find_node_with_property(). Explicitly call of_node_get(np) before each
of_find_node_with_property() to maintain correct node reference counting.

The of_find_node_with_property() function "consumes" its input by calling
of_node_put() internally, whether or not it finds a match.  Currently,
dev->of_node (np) is passed multiple times in sequence without incrementing
its reference count, causing it to be decremented multiple times and
risking early memory release.

Adding of_node_get(np) before each call balances the reference count,
preventing premature node release.

Fixes: c1bac49fe91f ("pmdomains: mtk-pm-domains: Fix spinlock recursion in probe")
Cc: stable@vger.kernel.org
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Tested-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -748,18 +748,6 @@ static void scpsys_domain_cleanup(struct
 	}
 }
 
-static struct device_node *scpsys_get_legacy_regmap(struct device_node *np, const char *pn)
-{
-	struct device_node *local_node;
-
-	for_each_child_of_node(np, local_node) {
-		if (of_property_present(local_node, pn))
-			return local_node;
-	}
-
-	return NULL;
-}
-
 static int scpsys_get_bus_protection_legacy(struct device *dev, struct scpsys *scpsys)
 {
 	const u8 bp_blocks[3] = {
@@ -781,7 +769,8 @@ static int scpsys_get_bus_protection_leg
 	 * this makes it then possible to allocate the array of bus_prot
 	 * regmaps and convert all to the new style handling.
 	 */
-	node = scpsys_get_legacy_regmap(np, "mediatek,infracfg");
+	of_node_get(np);
+	node = of_find_node_with_property(np, "mediatek,infracfg");
 	if (node) {
 		regmap[0] = syscon_regmap_lookup_by_phandle(node, "mediatek,infracfg");
 		of_node_put(node);
@@ -794,7 +783,8 @@ static int scpsys_get_bus_protection_leg
 		regmap[0] = NULL;
 	}
 
-	node = scpsys_get_legacy_regmap(np, "mediatek,smi");
+	of_node_get(np);
+	node = of_find_node_with_property(np, "mediatek,smi");
 	if (node) {
 		smi_np = of_parse_phandle(node, "mediatek,smi", 0);
 		of_node_put(node);
@@ -812,7 +802,8 @@ static int scpsys_get_bus_protection_leg
 		regmap[1] = NULL;
 	}
 
-	node = scpsys_get_legacy_regmap(np, "mediatek,infracfg-nao");
+	of_node_get(np);
+	node = of_find_node_with_property(np, "mediatek,infracfg-nao");
 	if (node) {
 		regmap[2] = syscon_regmap_lookup_by_phandle(node, "mediatek,infracfg-nao");
 		num_regmaps++;


