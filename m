Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843B632A3FF;
	Thu, 28 May 2026 20:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999737; cv=none; b=u2HZwz2C6c+QJMoWQ7plAZwJ2DJiP4FxF88Fw77IhOa/cDifkKka1c4+B5DHNIhrrkpajp2N32+7MuHYwy9Ac3QAYXl/1A1pDPEEwiaH+4Wprdn5hWrDydSba4T8SHIrFmFueNm9+yVA10Q+ywXoqH+WU3TBbKp58j7A//ILpDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999737; c=relaxed/simple;
	bh=CIIWd8gx4qQwSywSCkHiHizBNtzEbEWbBz7Y/m2hKeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyg5v3yU5onMdFsIR4QT/X2glKP0TJaWC1yhEB2QzGEMi1OausGM8zc7T28oLXtIoJv1sSvJNUbZCx72mYeKOujtT7e9ac9ozgC6NbzscLYNPZax/1Y0g5oj48LAUUFiSMwR5KXNOn6m+lBOxSX2j9x6iu7T7f66W3X0zdcg9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usVdrrST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usVdrrST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EB31F000E9;
	Thu, 28 May 2026 20:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999736;
	bh=VvtRfW6S7yMFo+FxQqZUO6oWJ8GrFWW7YF14qqITjjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usVdrrSTkxaA84eEDu3mBtVja/a3lnp3Pcanpv0/7pRBKf5fLT2bkOhwsM7TkKIvV
	 GpY4vElRUCTeBoeTVVRvInynIsO33bTUfsAXcJ80KwJrzlwBLScKhJqm/0SHkvGsYH
	 QJ5P65OPRK53zjnFCN5Und2FSthJyCdor+U59zCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/377] pinctrl: renesas: rzg2l: Fix incorrect PUPD register offset for high pins during suspend/resume
Date: Thu, 28 May 2026 21:46:51 +0200
Message-ID: <20260528194643.438859737@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 6dba9b7268cc50166bce47608670192fd874e363 ]

When saving/restoring pull-up/down register state during suspend/resume,
the second PUPD register access was incorrectly using the same base offset
as the first, effectively reading/writing the same register twice instead
of the adjacent one.

Add the correct + 4 byte offset to the second RZG2L_PCTRL_REG_ACCESS32
call so that pupd[1][port] is properly saved and restored from the next
32-bit register in the PUPD register pair, covering pins 4–7 of ports
with 4 or more pins.

Fixes: b2bd65fbb617 ("pinctrl: renesas: rzg2l: Add suspend/resume support for pull up/down")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260328090548.84124-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index ca360185740a8..df784e3807af0 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3035,7 +3035,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PUPD(off),
 						 cache->pupd[0][port]);
 			if (pincnt >= 4) {
-				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PUPD(off),
+				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PUPD(off) + 4,
 							 cache->pupd[1][port]);
 			}
 		}
-- 
2.53.0



