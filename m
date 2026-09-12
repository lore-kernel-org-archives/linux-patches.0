Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66030CA6F;
	Sat, 12 Sep 2026 10:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208425; cv=none; b=iwEOCtUw/m2pno0sE98eT75TpITTtXiLKPjMe+6hp7ZKnwrqKFO2rZ+94A98/3ripZjRXXbwJI9GbF/EFeeptN9KHMFPOdt7ZbcAD79oHp1gJBbUAxoZtcjKRAvWXir/WAppKDNcwU19Ik9O0F+51J6owGj6whwCbQsZ/AtKUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208425; c=relaxed/simple;
	bh=b2O19cLRwSHP1ceiOhBNdJm9iJ9d9HZNrAPNmOqMCNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+IBgsBDicai2HrnmJPUb8r2d539ctMyQE0+0l/uydnaQMWpoGDK7lPv3sv/pFKfXfDq/v4b9rmHLFTm+HT6qQcq7W9t4ASds+iPEAzooGM3oaA3jMLG9gsYyVfd2iqdVtX2m3CzRGbQV+BwzvP2FM23R5JQHQI7qGHcEMaFldw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2zpJSGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2zpJSGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A791F000FF;
	Sat, 12 Sep 2026 10:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208423;
	bh=u6Qvd/jT90umm2lJb/U26CUfscto0ozVbz8iLHskEKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2zpJSGzepfRP39/+COZKwRJrphS+KgaoaTRdcVP12YFFKhcBropiKTkY4Q2rGCrO
	 N5oF7mrTDjgaiS+1YrQ0kVAt9eOTOAja9S8+VshdqYq+iMfCI792pDxgrPh0pjbeiq
	 yF2l/QhtmtvJUuheIs5HfgHCVGle6kureMnl97Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0615/1518] clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path
Date: Sat, 12 Sep 2026 08:46:24 +0200
Message-ID: <20260912065637.338593667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 540d91480bcb1b28a62d7023aa70947ea44c55b9 ]

When mtk_clk_register_pllfhs function fails to register a PLL, it
unregisters all PLLs and cleans up itself in its error path before
returning, so the function callers don't need to do it.

But contrary to mtk_clk_unregister_pllfhs function, that does almost
the same sequence, it does not free the IO memory mapped on fhctl node,
leading to a leak.

Fix this leak by factorizing the cleanup sequence in a new private
function and use it both mtk_clk_register_pllfhs and
mtk_clk_unregister_pllfhs functions.

Also, change the loop index start value to avoid the -1 operation on
index at each loop.

Fixes: d7964de8a8ea ("clk: mediatek: Add new clock driver to handle FHCTL hardware")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-pllfh.c | 98 ++++++++++++++++----------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/clk/mediatek/clk-pllfh.c b/drivers/clk/mediatek/clk-pllfh.c
index 8ad11023d9112..d8b7eb6d18e1c 100644
--- a/drivers/clk/mediatek/clk-pllfh.c
+++ b/drivers/clk/mediatek/clk-pllfh.c
@@ -197,12 +197,56 @@ static void mtk_clk_unregister_pllfh(struct clk_hw *hw)
 	kfree(fh);
 }
 
+static void mtk_clk_cleanup_pllfhs(void __iomem *iomem_base,
+				   const struct mtk_pll_data *plls, int num_plls,
+				   void __iomem *iomem_fhctl_base,
+				   struct mtk_pllfh_data *pllfhs, int num_fhs,
+				   struct clk_hw_onecell_data *clk_data)
+{
+	void __iomem *base = iomem_base;
+	void __iomem *fhctl_base = iomem_fhctl_base;
+	int i;
+
+	for (i = num_plls - 1; i >= 0; i--) {
+		const struct mtk_pll_data *pll = &plls[i];
+		struct mtk_pllfh_data *pllfh;
+		bool use_fhctl;
+
+		if (IS_ERR_OR_NULL(clk_data->hws[pll->id]))
+			continue;
+
+		pllfh = get_pllfh_by_id(pllfhs, num_fhs, pll->id);
+		use_fhctl = fhctl_is_supported_and_enabled(pllfh);
+
+		if (!base)
+			base = mtk_clk_pll_get_base(clk_data->hws[pll->id],
+							pll);
+
+		if (use_fhctl) {
+			if (!fhctl_base)
+				fhctl_base = pllfh->state.base;
+			mtk_clk_unregister_pllfh(clk_data->hws[pll->id]);
+		} else {
+			mtk_clk_unregister_pll(clk_data->hws[pll->id]);
+		}
+
+		clk_data->hws[pll->id] = ERR_PTR(-ENOENT);
+	}
+
+	if (fhctl_base)
+		iounmap(fhctl_base);
+
+	if (base)
+		iounmap(base);
+}
+
+
 int mtk_clk_register_pllfhs(struct device *dev,
 			    const struct mtk_pll_data *plls, int num_plls,
 			    struct mtk_pllfh_data *pllfhs, int num_fhs,
 			    struct clk_hw_onecell_data *clk_data)
 {
-	void __iomem *base;
+	void __iomem *base, *fhctl_base = NULL;
 	int i;
 	struct clk_hw *hw;
 
@@ -238,24 +282,8 @@ int mtk_clk_register_pllfhs(struct device *dev,
 	return 0;
 
 err:
-	while (--i >= 0) {
-		const struct mtk_pll_data *pll = &plls[i];
-		struct mtk_pllfh_data *pllfh;
-		bool use_fhctl;
-
-		pllfh = get_pllfh_by_id(pllfhs, num_fhs, pll->id);
-		use_fhctl = fhctl_is_supported_and_enabled(pllfh);
-
-		if (use_fhctl)
-			mtk_clk_unregister_pllfh(clk_data->hws[pll->id]);
-		else
-			mtk_clk_unregister_pll(clk_data->hws[pll->id]);
-
-		clk_data->hws[pll->id] = ERR_PTR(-ENOENT);
-	}
-
-	iounmap(base);
-
+	mtk_clk_cleanup_pllfhs(base, plls, i, fhctl_base, pllfhs, num_fhs,
+			       clk_data);
 	return PTR_ERR(hw);
 }
 EXPORT_SYMBOL_GPL(mtk_clk_register_pllfhs);
@@ -264,38 +292,10 @@ void mtk_clk_unregister_pllfhs(const struct mtk_pll_data *plls, int num_plls,
 			       struct mtk_pllfh_data *pllfhs, int num_fhs,
 			       struct clk_hw_onecell_data *clk_data)
 {
-	void __iomem *base = NULL, *fhctl_base = NULL;
-	int i;
-
 	if (!clk_data)
 		return;
 
-	for (i = num_plls; i > 0; i--) {
-		const struct mtk_pll_data *pll = &plls[i - 1];
-		struct mtk_pllfh_data *pllfh;
-		bool use_fhctl;
-
-		if (IS_ERR_OR_NULL(clk_data->hws[pll->id]))
-			continue;
-
-		pllfh = get_pllfh_by_id(pllfhs, num_fhs, pll->id);
-		use_fhctl = fhctl_is_supported_and_enabled(pllfh);
-
-		if (use_fhctl) {
-			fhctl_base = pllfh->state.base;
-			mtk_clk_unregister_pllfh(clk_data->hws[pll->id]);
-		} else {
-			base = mtk_clk_pll_get_base(clk_data->hws[pll->id],
-						    pll);
-			mtk_clk_unregister_pll(clk_data->hws[pll->id]);
-		}
-
-		clk_data->hws[pll->id] = ERR_PTR(-ENOENT);
-	}
-
-	if (fhctl_base)
-		iounmap(fhctl_base);
-
-	iounmap(base);
+	mtk_clk_cleanup_pllfhs(NULL, plls, num_plls, NULL, pllfhs,
+			       num_fhs, clk_data);
 }
 EXPORT_SYMBOL_GPL(mtk_clk_unregister_pllfhs);
-- 
2.53.0



