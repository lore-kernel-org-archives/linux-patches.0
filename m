Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A9338944D;
	Wed, 30 Sep 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787840; cv=none; b=omZhjboh5nB+1cKZry0AC3wwoa/41/9u1YUjy3pxBcV1k0KCfDI6P+lt3Er9fOjXcf2EaL5st0WS+JWiQcpdJ0mZMxo+5b1JZU1uPEkEE/ZWDhguTmLYAseU7bsbhgWn+fuLHbp6t4KOQIzqO8hkrWLttDOiofGWu82abOm/m5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787840; c=relaxed/simple;
	bh=Rs/RjNDEF1eDjPIp9ob8woFMeor+gWqrzeLIlAybF0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVMMrcSHT0PSA1+htOF3kat7PKNjhPTbGrePIqSTUbmwh/Y8csjzkCf7IkQdpHHLzrgBi4ay/fBeHisfRC50OfOtbMD++FkUNYayLf1a3AgPazVSSIwgEBLML+Uyjnldo3c23xhkV7St6EJcF4f0ZEqYaoplIrK01pkg2pRglVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1OnT/ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1OnT/ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F641F000FF;
	Wed, 30 Sep 2026 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787839;
	bh=zsTF7/VGY6mOkXiq1rcfGsBcRpINC9gg0GJrfQyyo6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1OnT/ayiIYCDbxWuokFhiqh6xcZKSMie3rJ5/MkkOswz45evOfPVWk79F26ssJCL
	 Umg0MCw0KD+rtJaEqnPQNvaUyqHVL4anYY0pLex0cjCk2rOx2010EBvRouDusHR0df
	 DU48IJ+4IzXTrwNq6LzjZ1hREcA+c+KBirdlsdnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.2 372/457] pinctrl: mpfs-mssio: use correct regmap function to set bank voltage
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152354.035225257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 8039b75af5808572ff3656eaed07d348aed3989a upstream.

regmap_assign_bits() is not the correct function to use for an RMW
operation, as it maps to regmap_set_bits() or regmap_clear_bits() and
the former will never zero a bit. Use regmap_update_bits() instead,
which will actually set the bank voltages to what have been requested.

CC: stable@vger.kernel.org
Fixes: 488d704ed7b7 ("pinctrl: add polarfire soc mssio pinctrl driver")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
index dafca82f3e54..92d38e5336de 100644
--- a/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
+++ b/drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c
@@ -156,10 +156,10 @@ static void mpfs_pinctrl_set_bank_voltage(struct mpfs_pinctrl *pctrl, unsigned i
 	u32 val = FIELD_PREP(MPFS_PINCTRL_BANK_VOLTAGE_MASK, bank_voltage);
 
 	if (pin < MPFS_PINCTRL_BANK2_START)
-		regmap_assign_bits(pctrl->sysreg_regmap, MPFS_PINCTRL_MSSIO_BANK4_CFG_CR,
+		regmap_update_bits(pctrl->sysreg_regmap, MPFS_PINCTRL_MSSIO_BANK4_CFG_CR,
 				   MPFS_PINCTRL_BANK_VOLTAGE_MASK, val);
 	else
-		regmap_assign_bits(pctrl->sysreg_regmap, MPFS_PINCTRL_MSSIO_BANK2_CFG_CR,
+		regmap_update_bits(pctrl->sysreg_regmap, MPFS_PINCTRL_MSSIO_BANK2_CFG_CR,
 				   MPFS_PINCTRL_BANK_VOLTAGE_MASK, val);
 }
 
-- 
2.55.0



