Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BDC2D9787;
	Thu, 28 May 2026 20:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999740; cv=none; b=Yu1wPssWDmyJlNv9ZFxEV4mncPJ7FtqN+9sFJsFPKUAlin0Cn5S7BLRuvpa2d0ZRKlUKAySCmTonOlEScl9mHpjuoIYhy8xBTkhRNigM4Ke6TNjSTUg+Tuo9iiFif2hKyhhg2FC5POmx3jA5Y1mvTP7l7+BFD8dPMQhy1Nd3r+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999740; c=relaxed/simple;
	bh=BRGLqmQ8WJcVkbq72MxTXXyHJSBqd2yxdJwAbUg9d+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVhtARAmUi0HGqIshAYe3LviVZ246IzbXXGQV0NPriLVX8ntM0UPJry/FAeuOwdzb2mwy09jh0MMN5JXg9ji093Kz4jRFdM2/lKj+12az1jh3Ub4K5CWc0HS0Vz3m8FPX3v85umZTNtg3qUmxZwlPsrA6xTSrh41/lItARQBjpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0BdAUY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0BdAUY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12DD1F000E9;
	Thu, 28 May 2026 20:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999739;
	bh=3JlilkD1Edi+K57CGI8ml4Hqbx6FnTwhpHJxWWHLwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0BdAUY30sIlskkOh2hJdBFpwOg7onzki8zd0Puz5cCdbrfEiUYBIXx0XWgC8jUdJ
	 O9Wla56gfSfpROkDDmM1+RdhqYYupvnjnfDLC4EOkuoGz0RE8ChGYmj77aFi41HnZA
	 BaJf5zPgUoGYOZ7sSGG8PGBg2cgHKwQRFyNCrPs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/377] pinctrl: renesas: rzg2l: Fix SMT register cache handling
Date: Thu, 28 May 2026 21:46:52 +0200
Message-ID: <20260528194643.465868479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

[ Upstream commit c88ab9407986836820848128ce1f90f2fa49da95 ]

Store SMT register cache per bank instead of using a single array.

On RZ/V2H(P), RZ/V2N, and RZ/G3E, the SMT register is split across two
32-bit registers: bits 0/8/16/24 control pins 0-3, while pins 4-7 are
controlled by the corresponding bits in the next register.  The previous
implementation cached only a single SMT register, leading to incomplete
save/restore of SMT state.

Convert cache->smt to a per-bank array and allocate storage for both
halves.  Update suspend/resume handling to save and restore both SMT
registers when present.

Fixes: 837afa592c623 ("pinctrl: renesas: rzg2l: Add suspend/resume support for Schmitt control registers")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260413182456.811543-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index df784e3807af0..aaa783c79e6dd 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -335,7 +335,7 @@ struct rzg2l_pinctrl_reg_cache {
 	u32	*iolh[2];
 	u32	*ien[2];
 	u32	*pupd[2];
-	u32	*smt;
+	u32	*smt[2];
 	u8	sd_ch[2];
 	u8	eth_poc[2];
 	u8	oen;
@@ -2723,10 +2723,6 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 	if (!cache->pfc)
 		return -ENOMEM;
 
-	cache->smt = devm_kcalloc(pctrl->dev, nports, sizeof(*cache->smt), GFP_KERNEL);
-	if (!cache->smt)
-		return -ENOMEM;
-
 	for (u8 i = 0; i < 2; i++) {
 		u32 n_dedicated_pins = pctrl->data->n_dedicated_pins;
 
@@ -2745,6 +2741,11 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 		if (!cache->pupd[i])
 			return -ENOMEM;
 
+		cache->smt[i] = devm_kcalloc(pctrl->dev, nports, sizeof(*cache->smt[i]),
+					     GFP_KERNEL);
+		if (!cache->smt[i])
+			return -ENOMEM;
+
 		/* Allocate dedicated cache. */
 		dedicated_cache->iolh[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
 							sizeof(*dedicated_cache->iolh[i]),
@@ -3052,8 +3053,14 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 			}
 		}
 
-		if (has_smt)
-			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SMT(off), cache->smt[port]);
+		if (has_smt) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SMT(off),
+						 cache->smt[0][port]);
+			if (pincnt >= 4) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SMT(off) + 4,
+							 cache->smt[1][port]);
+			}
+		}
 	}
 }
 
-- 
2.53.0



