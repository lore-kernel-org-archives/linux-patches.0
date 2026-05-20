Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FA981AA8;
	Wed, 20 May 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300942; cv=none; b=WGWcvjX69zCW8UYOzu9Xj80DAzUduBIMxlkjTRmYbtszVUI3m9BuTt5DIxUBk2/WVEL4ighKds2k/tlM0jV/VeTOvOEG8Pp/R4Y7O6zkUT0kCzSY0BOrpUqx+jx97X81htS2kxUHn6udH5rnl7hay04peZcjm7fBBHbrZTqmeJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300942; c=relaxed/simple;
	bh=ZP+qidQzg8iHAjF7NeUresYK7DKlg/nqJy24RHKVPkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pajSfTwUVHjYBSVRXcS94OjmU2OunhEKdGuPxTC1nep3BtYvMchik576FWYzLSoFHxzCD60QZ4S+MpbWvxN+IkQC+FmmFZbTkLlQR1Xhbd5NgMcCe3roKR8q6WlFS3dLqZenFBd9NX/4C2Bq7//3Ynx3dVKLggh3EeiFLpAMiKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr2a3nnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr2a3nnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE71F000E9;
	Wed, 20 May 2026 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300940;
	bh=FSK9EJFNQv7nzf+F2aNoKHELqdkpqasaEIlSvrQsH/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cr2a3nnZDR3gmKRyOgIgmQ6TYzp8FQMZyUywR4F2ohx2cpgssLm5UWpNcwK52aKYs
	 CzU7trvtWpNrxCcQALKwJOpILbrD2xUCQXgH3IyGURfQwCaSZCUC9vQCpwqWDxciwI
	 GAFfPIt/xipw+bEl4pFktCcwXl6v9OGTDevtGd30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/666] pinctrl: renesas: rzg2l: Fix save/restore of {IOLH,IEN,PUPD,SMT} registers
Date: Wed, 20 May 2026 18:19:37 +0200
Message-ID: <20260520162119.174526084@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a7eb11df9029..bcb0c39369e05 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2812,6 +2812,13 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
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



