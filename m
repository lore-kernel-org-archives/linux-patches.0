Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6259C99E;
	Thu, 17 Sep 2026 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660916; cv=none; b=OPWcWcKlzMlEWqP2123JpAnHGcHfS6vgacpUar98UwkPvW/k5+8Cvq70riFGSWWdl3B/cA5IU1bLAgC4wPwY+98mZ+aV08TEO/J3cVyOEmRRtTT2m+ITUUtUZgD7XohTPbXkgzKVGq1xVH3GiQoxn9ePlr2w5mPeOP+uzEL9PQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660916; c=relaxed/simple;
	bh=hft8+TyttsTYUngNs40RpCN+PD8axRDM67jf3mu3cuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCWy2Hl0sOgTIX1R2t2xSqzxQBcbqgLeoVLUa9XhdF+JAd5dcKcFb81M7X7P+NaxrQZ/kmCQQTlnuvhyJ9WIGd2FcCrPPFv7I+/FLusDjCLYXdHKtAXZSF1bMdSQwV9ZumnerbbVL/B+opK1ZIWK4vHFbKqblfq/sFOZDNLAeYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGhB+j7T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGhB+j7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711D91F000FF;
	Thu, 17 Sep 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660915;
	bh=JYlkOO5ywiT3cmfAODAnx3JXzfszZnd1s5zEewW9gF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGhB+j7TyeOqBiIckBMeBURYNBSEfZBd9Qe+PegPMNjj4wQp7f6zbELySi6IrRY9n
	 +lcJJxHRLPI8PloSM+R6xJPsSkht4WQZ2OENaymeFyFhZRdL2VCboyGAxxeVReknVs
	 6dnGVS3CySi3woD/LtrHMRIh+7g/h/p3Eu8RyKPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0021/1250] pinctrl: renesas: rzg2l: Add SR register cache for PM suspend/resume
Date: Thu, 17 Sep 2026 15:56:56 +0100
Message-ID: <20260917151552.504281211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 29df31ae3e8a0152dd8e8c2376816aad2f233473 ]

Include the SR (Slew Rate) register in the PM suspend/resume register
cache.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260413182456.811543-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 38 +++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index ab8d64a14dd0a..b4d7e80dd6468 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -322,6 +322,7 @@ struct rzg2l_pinctrl_pin_settings {
  * @pupd: PUPD registers cache
  * @ien: IEN registers cache
  * @smt: SMT registers cache
+ * @sr: SR registers cache
  * @sd_ch: SD_CH registers cache
  * @eth_poc: ET_POC registers cache
  * @oen: Output Enable register cache
@@ -336,6 +337,7 @@ struct rzg2l_pinctrl_reg_cache {
 	u32	*ien[2];
 	u32	*pupd[2];
 	u32	*smt[2];
+	u32	*sr[2];
 	u8	sd_ch[2];
 	u8	eth_poc[2];
 	u8	oen;
@@ -2746,6 +2748,11 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 		if (!cache->smt[i])
 			return -ENOMEM;
 
+		cache->sr[i] = devm_kcalloc(pctrl->dev, nports, sizeof(*cache->sr[i]),
+					    GFP_KERNEL);
+		if (!cache->sr[i])
+			return -ENOMEM;
+
 		/* Allocate dedicated cache. */
 		dedicated_cache->iolh[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
 							sizeof(*dedicated_cache->iolh[i]),
@@ -2758,6 +2765,12 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 						       GFP_KERNEL);
 		if (!dedicated_cache->ien[i])
 			return -ENOMEM;
+
+		dedicated_cache->sr[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
+						      sizeof(*dedicated_cache->sr[i]),
+						      GFP_KERNEL);
+		if (!dedicated_cache->sr[i])
+			return -ENOMEM;
 	}
 
 	pctrl->cache = cache;
@@ -2989,7 +3002,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 	struct rzg2l_pinctrl_reg_cache *cache = pctrl->cache;
 
 	for (u32 port = 0; port < nports; port++) {
-		bool has_iolh, has_ien, has_pupd, has_smt;
+		bool has_iolh, has_ien, has_pupd, has_smt, has_sr;
 		u32 off, caps;
 		u8 pincnt;
 		u64 cfg;
@@ -3010,6 +3023,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		has_ien = !!(caps & PIN_CFG_IEN);
 		has_pupd = !!(caps & PIN_CFG_PUPD);
 		has_smt = !!(caps & PIN_CFG_SMT);
+		has_sr = !!(caps & PIN_CFG_SR);
 
 		if (suspend)
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PFC(off), cache->pfc[port]);
@@ -3061,6 +3075,15 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 							 cache->smt[1][port]);
 			}
 		}
+
+		if (has_sr) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off),
+						 cache->sr[0][port]);
+			if (pincnt >= 4) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off) + 4,
+							 cache->sr[1][port]);
+			}
+		}
 	}
 }
 
@@ -3075,7 +3098,7 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 	 * port offset are close together.
 	 */
 	for (i = 0, caps = 0; i < pctrl->data->n_dedicated_pins; i++) {
-		bool has_iolh, has_ien;
+		bool has_iolh, has_ien, has_sr;
 		u32 off, next_off = 0;
 		u64 cfg, next_cfg;
 		u8 pincnt;
@@ -3097,6 +3120,7 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
 				      PIN_CFG_IOLH_C | PIN_CFG_IOLH_RZV2H));
 		has_ien = !!(caps & PIN_CFG_IEN);
+		has_sr = !!(caps & PIN_CFG_SR);
 		pincnt = hweight8(FIELD_GET(RZG2L_SINGLE_PIN_BITS_MASK, cfg));
 
 		if (has_iolh) {
@@ -3107,7 +3131,10 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + IEN(off),
 						 cache->ien[0][i]);
 		}
-
+		if (has_sr) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off),
+						 cache->sr[0][i]);
+		}
 		if (pincnt >= 4) {
 			if (has_iolh) {
 				RZG2L_PCTRL_REG_ACCESS32(suspend,
@@ -3119,6 +3146,11 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 							 pctrl->base + IEN(off) + 4,
 							 cache->ien[1][i]);
 			}
+			if (has_sr) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend,
+							 pctrl->base + SR(off) + 4,
+							 cache->sr[1][i]);
+			}
 		}
 		caps = 0;
 	}
-- 
2.53.0



