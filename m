Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A2A3CB557;
	Sat, 17 Oct 2026 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260191; cv=none; b=bpua95EqxPj2ne0Ouv161CTlHRcubXSsr3Aams5X1dj/9nDPhFyOUxpijoj2Ocm0cYGgcYpejxI0emaTLIaQU6Lcg/vFfhvtrdcxp4J8A+QqutJLz3VolmmTCLlB6hYHXSA7adQ1U8ljIzhq2X9JQ0Q9C27dQSuIzsM+jWiKI3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260191; c=relaxed/simple;
	bh=bVO9WRMeiMbZbrykDIBpobq0D1/Lky1s8fRTyfOukR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6PmnBV+1a4Co3eXzf1+k5EsvNY48MCvlBToBbliK2nMCfHkTvtJG6mWdWV+ErSoaod3+17LbeNVhuQ+2d6U6Hfl+toCF+xpaYeGdNfQ2J+0Iqw0IIkAP6mtQg2lTjVp+6mzpM02UcxOyD8J1o8L/qdSDursxYiC3neoehAPKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKaKbn4O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKaKbn4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9681F000C4;
	Sat, 17 Oct 2026 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260189;
	bh=9xu0UKJVyJ1Cf50Dw/4xx+2wnzmsAluMYHO68L3OfKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKaKbn4OUVMEHy4YTjnAh8yfBPDaJpJLIDMmOtX8c6B3KV1vKui8sV9QeOGla17To
	 TD32FbIKePgMrEEJ+BjFDXFq8ijw07mue0JgFXDZMBMS8BwIQIyMAh6jM4s8WdclDj
	 8aMjh+lf4fRu49ZZKHtMPTfJaPWubfFWVeRKdd1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1464/1674] clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path
Date: Sat, 17 Oct 2026 18:02:16 +0200
Message-ID: <20261017160508.748094312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/clk/mediatek/clk-pllfh.c | 97 ++++++++++++++++----------------
 1 file changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/clk/mediatek/clk-pllfh.c b/drivers/clk/mediatek/clk-pllfh.c
index 094ec8a26d668..6fd70f8d7a584 100644
--- a/drivers/clk/mediatek/clk-pllfh.c
+++ b/drivers/clk/mediatek/clk-pllfh.c
@@ -194,12 +194,55 @@ static void mtk_clk_unregister_pllfh(struct clk_hw *hw)
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
 int mtk_clk_register_pllfhs(struct device_node *node,
 			    const struct mtk_pll_data *plls, int num_plls,
 			    struct mtk_pllfh_data *pllfhs, int num_fhs,
 			    struct clk_hw_onecell_data *clk_data)
 {
-	void __iomem *base;
+	void __iomem *base, *fhctl_base = NULL;
 	int i;
 	struct clk_hw *hw;
 
@@ -235,24 +278,8 @@ int mtk_clk_register_pllfhs(struct device_node *node,
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
@@ -261,38 +288,10 @@ void mtk_clk_unregister_pllfhs(const struct mtk_pll_data *plls, int num_plls,
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



