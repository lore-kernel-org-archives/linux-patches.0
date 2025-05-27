Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0C2110E;
	Tue, 27 May 2025 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365544; cv=none; b=h3O+ZFUC1CRshI5Grzl7Y/mblP6XgSi1mCbZw+IQYPlD1YY2zRabe40og02Rphykk1CBFz5BDvVhidTdmB0gXajmMKxw80QpI4rCQIX8lR8rHnOYgnxKG/XRqNYN/3nwCpmBnGfR3uOBTaQD8XhPbC6RY/b6NF/WIzru2gK7zLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365544; c=relaxed/simple;
	bh=jlut9F5UDL9NwDYkb9dm7odifTltC6mRaN5wYqzUGqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcKWNU9s77atYwP3gefK0FDW2ophHGEQ2tPY6Sz1kFXfgXAKmGo3F3QLiy8aJIuGezxeOtQ8FzBVNK73DfGQm8PoJLgH5lLaUaZdNIV7zBQw/qMUr/U7bebnP3sE7m9f0tnGupI55mYq165qZchR1C9vzJBsqQUJ6YfWYxE6aIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dq4ppA/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dq4ppA/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A22C4CEE9;
	Tue, 27 May 2025 17:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365543;
	bh=jlut9F5UDL9NwDYkb9dm7odifTltC6mRaN5wYqzUGqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dq4ppA/7FYcIWCBU52LH5sTawngOhKd1VB498wlqlp0ED9k05y0cIsITMjHVfwqqP
	 ffJhOqEa0pVTmgdbLMcRmo5akYL7sCjuNqLaeODOelUp9G8vidYEfX7ZUSog4Lsm4/
	 NM9i4r/NwPhyR0DPwPnPjPbTfdbVCfB2n3MdTMqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/626] pinctrl: renesas: rzg2l: Add suspend/resume support for pull up/down
Date: Tue, 27 May 2025 18:24:33 +0200
Message-ID: <20250527162500.454690065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit b2bd65fbb617353e3c46ba5206b3b030fa0f260c ]

The Renesas RZ/G3S supports a power-saving mode where power to most of
the SoC components is lost, including the PIN controller.  Save and
restore the pull-up/pull-down register contents to ensure the
functionality is preserved after a suspend/resume cycle.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250205100116.2032765-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index d90685cfe2e1a..bde58f5a743cb 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -311,6 +311,7 @@ struct rzg2l_pinctrl_pin_settings {
  * @pmc: PMC registers cache
  * @pfc: PFC registers cache
  * @iolh: IOLH registers cache
+ * @pupd: PUPD registers cache
  * @ien: IEN registers cache
  * @sd_ch: SD_CH registers cache
  * @eth_poc: ET_POC registers cache
@@ -324,6 +325,7 @@ struct rzg2l_pinctrl_reg_cache {
 	u32	*pfc;
 	u32	*iolh[2];
 	u32	*ien[2];
+	u32	*pupd[2];
 	u8	sd_ch[2];
 	u8	eth_poc[2];
 	u8	eth_mode;
@@ -2539,6 +2541,11 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 		if (!cache->ien[i])
 			return -ENOMEM;
 
+		cache->pupd[i] = devm_kcalloc(pctrl->dev, nports, sizeof(*cache->pupd[i]),
+					      GFP_KERNEL);
+		if (!cache->pupd[i])
+			return -ENOMEM;
+
 		/* Allocate dedicated cache. */
 		dedicated_cache->iolh[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
 							sizeof(*dedicated_cache->iolh[i]),
@@ -2779,7 +2786,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 	struct rzg2l_pinctrl_reg_cache *cache = pctrl->cache;
 
 	for (u32 port = 0; port < nports; port++) {
-		bool has_iolh, has_ien;
+		bool has_iolh, has_ien, has_pupd;
 		u32 off, caps;
 		u8 pincnt;
 		u64 cfg;
@@ -2791,6 +2798,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		caps = FIELD_GET(PIN_CFG_MASK, cfg);
 		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B | PIN_CFG_IOLH_C));
 		has_ien = !!(caps & PIN_CFG_IEN);
+		has_pupd = !!(caps & PIN_CFG_PUPD);
 
 		if (suspend)
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PFC(off), cache->pfc[port]);
@@ -2809,6 +2817,15 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 			}
 		}
 
+		if (has_pupd) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PUPD(off),
+						 cache->pupd[0][port]);
+			if (pincnt >= 4) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PUPD(off),
+							 cache->pupd[1][port]);
+			}
+		}
+
 		RZG2L_PCTRL_REG_ACCESS16(suspend, pctrl->base + PM(off), cache->pm[port]);
 		RZG2L_PCTRL_REG_ACCESS8(suspend, pctrl->base + P(off), cache->p[port]);
 
-- 
2.39.5



