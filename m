Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638DEC4;
	Tue, 20 May 2025 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750808; cv=none; b=s4VzyqcOn+VA5BR8VM3yB8t/3tudINnEVT1+mw2dHzWKkY7oo1+XCqn9DwYbG1pue5D7zgqWESPOJBzw+LFHyiGembCSlaaE0GyydT5gUIaWVcNagAjj/CPfYnwCT3jdgoGMYc1CIzP1zvkrpboA0ORNqR3SchSkTlop7xQHTJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750808; c=relaxed/simple;
	bh=CgxGZI47a7l58BRia5Dc22KPfmoUUpJ36nUvffMxLwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSFD/ivsjwZ6C9HoQCqQ2Nx54kHO/tk+VP1/nwMGeWcz9YZsf3XFJ0dfnepuEcv+QX5gGVHbsUf+jC+GBcbHFGzPghg6cA20YFhfyAI3iYCVnubqQSSSpjZ7zD9dNG0oqu9poNuXt8Pfyk3ivlxLriRdhGC+9eks5+AY9UeHwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX8aSNjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX8aSNjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A0AC4CEE9;
	Tue, 20 May 2025 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750808;
	bh=CgxGZI47a7l58BRia5Dc22KPfmoUUpJ36nUvffMxLwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xX8aSNjz0DLEZbwPb/k+gIlB+iH2AOqjS5kzSnh1cgErS1YML5r/D7+FOdx75jRgN
	 LbfMKp0lbQd5jYGI8GCdCAO7zrrCf7EjFQATyPxNabGEZc+BapFWRj6pHz6uBuMLc4
	 +RPy0CKwkJGdjRvputBBr9J+LEjNUiZVVAylEwlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.14 110/145] net: phy: micrel: remove KSZ9477 EEE quirks now handled by phylink
Date: Tue, 20 May 2025 15:51:20 +0200
Message-ID: <20250520125814.862880650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 8c619eb21b8e87ae95877e9cca9fcb0e3115776e upstream.

The KSZ9477 PHY driver contained workarounds for broken EEE capability
advertisements by manually masking supported EEE modes and forcibly
disabling EEE if MICREL_NO_EEE was set.

With proper MAC-side EEE handling implemented via phylink, these quirks
are no longer necessary. Remove MICREL_NO_EEE handling and the use of
ksz9477_get_features().

This simplifies the PHY driver and avoids duplicated EEE management logic.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org # v6.14+
Link: https://patch.msgid.link/20250504081434.424489-3-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c   |    7 -------
 include/linux/micrel_phy.h |    1 -
 2 files changed, 8 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2002,12 +2002,6 @@ static int ksz9477_config_init(struct ph
 			return err;
 	}
 
-	/* According to KSZ9477 Errata DS80000754C (Module 4) all EEE modes
-	 * in this switch shall be regarded as broken.
-	 */
-	if (phydev->dev_flags & MICREL_NO_EEE)
-		phy_disable_eee(phydev);
-
 	return kszphy_config_init(phydev);
 }
 
@@ -5680,7 +5674,6 @@ static struct phy_driver ksphy_driver[]
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= ksz9477_resume,
-	.get_features	= ksz9477_get_features,
 } };
 
 module_phy_driver(ksphy_driver);
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -44,7 +44,6 @@
 #define MICREL_PHY_50MHZ_CLK	BIT(0)
 #define MICREL_PHY_FXEN		BIT(1)
 #define MICREL_KSZ8_P1_ERRATA	BIT(2)
-#define MICREL_NO_EEE		BIT(3)
 
 #define MICREL_KSZ9021_EXTREG_CTRL	0xB
 #define MICREL_KSZ9021_EXTREG_DATA_WRITE	0xC


