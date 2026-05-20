Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616923E123F;
	Wed, 20 May 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298694; cv=none; b=Om5CwShKXrFk4IlOryg7+WbzimK77sUEa+TSrPJV3rSXwduULqCjbfy95+aj5GpSdlfLTneefy0WuZiu1tKnDyQDhBo8DQL442ub84VDohUiq3g/L14O71qHocAzzcBCbOD2AT6Bj1NT/QPuTmYJcWqm3IGk2nGRpP6oIEutX8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298694; c=relaxed/simple;
	bh=QLa8pnxM3ayuVGkvBBGDbFCPKMtVBeLEjis8l7jzLA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKkB3v6HDtqhLwz6N/jgnL95xpv/70Dt0EhJ5kz3Gkh7z9NWMQYjudMAc2a5L91T6gGDdtrEYmiMvuIEUW6BbLnHAv0y/5M5wf5Lw1PO42rph99WfRVUGVNN8mguEdfB5uyJQnyxEHfMalAEm3QU6+AM8oBF8ywxebyXC18dg5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dn7Ekvl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dn7Ekvl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B7A1F000E9;
	Wed, 20 May 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298693;
	bh=wsDI5K2HQsrHoDp8EVURSVJUqg/tJ8/4xkrhyJzc3fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dn7Ekvl9olBP+TKTGeCNRrnON+Ly6bULqGXT2Zi2BFwEfqfzz/I4GA58dSzsYYf49
	 Rl2dgTsA10enXiSOORuiC91OwXWnKpcybQaSc1ZWEpMP43XNncUuu5S1Hv2kjnhlFN
	 f8wcXx7t7W9FTYb8+CcfRNreY8d+9S7p7dBfIqGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/957] pinctrl: renesas: rzg2l: Fix save/restore of {IOLH,IEN,PUPD,SMT} registers
Date: Wed, 20 May 2026 18:16:31 +0200
Message-ID: <20260520162145.553642133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit d9a60e367919752a1d398ebeba667f1e200fae1e ]

The rzg2l_pinctrl_pm_setup_regs() handles save/restore of
{IOLH,IEN,PUPD,SMT} registers during s2ram, but only for ports where all
pins share the same pincfg. Extend the code to also support ports with
variable pincfg per pin, so that {IOLH,IEN,PUPD,SMT} registers are
correctly saved and restored for all pins.

Fixes: 254203f9a94c ("pinctrl: renesas: rzg2l: Add suspend/resume support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260326162459.101414-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index c2711b2de374d..ca360185740a8 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2997,6 +2997,13 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		off = RZG2L_PIN_CFG_TO_PORT_OFFSET(cfg);
 		pincnt = hweight8(FIELD_GET(PIN_CFG_PIN_MAP_MASK, cfg));
 
+		if (cfg & RZG2L_VARIABLE_CFG) {
+			unsigned int pin = port * RZG2L_PINS_PER_PORT;
+
+			for (unsigned int i = 0; i < RZG2L_PINS_PER_PORT; i++)
+				cfg |= *(u64 *)pctrl->desc.pins[pin + i].drv_data;
+		}
+
 		caps = FIELD_GET(PIN_CFG_MASK, cfg);
 		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B | PIN_CFG_IOLH_C));
 		has_ien = !!(caps & PIN_CFG_IEN);
-- 
2.53.0



