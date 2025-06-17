Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39692F237D;
	Tue, 17 Jun 2025 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176466; cv=none; b=JwNoFSlEtY2eMHER6Hh9Rw9EXuqkgiy/mXytycGV/UkTUxa8yXwhplIqhfYESqppa5VSlyOMdMPmdCZfABrOVVIVey2GgC1/DJ89m3DMuUh/fgPFhjDh2hq8WNJQcdN6Y3MoauZm1xzCqNAOvrdkQD7T1e39t0cxxBLEuiLO0DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176466; c=relaxed/simple;
	bh=Ui/ruLhag3k+atPterpib4JAQJMG1GDr5G81vs09HYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwPUKvMo/dhwW6ORDmwKWxpKX7OoJicUXAEHeZcJSvQl/u0Q39oxVna2YIE1R3GZ38jHBIWyFiJVhQWszcwIPx1s19v+DltNdkqkOpBbW7R12ArSkbKG4Pj+su951xSFXKFyDmR11OLk43QGZ8J/0sT4xfaxbacSoVz9ljYwHkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dddngtFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dddngtFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13231C4CEE3;
	Tue, 17 Jun 2025 16:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176466;
	bh=Ui/ruLhag3k+atPterpib4JAQJMG1GDr5G81vs09HYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dddngtFt7hTUuPO+2G0MxYk0Lk6n2fplGT+QV18q4BRw2fbXUvno4CW0ERf1O2nRW
	 G2oswGEiRMfM62GncUle08u0T+na1XAt7gY++6qNI/+3GDbCkGge0nbqX5UGxyoYE+
	 kB9UwLD5Th4YlWXhrvFVyWYrfl2kj+LrAvlGarqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/356] net: dsa: b53: do not enable RGMII delay on bcm63xx
Date: Tue, 17 Jun 2025 17:26:20 +0200
Message-ID: <20250617152348.870901356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 4af523551d876ab8b8057d1e5303a860fd736fcb ]

bcm63xx's RGMII ports are always in MAC mode, never in PHY mode, so we
shouldn't enable any delays and let the PHY handle any delays as
necessary.

This fixes using RGMII ports with normal PHYs like BCM54612E, which will
handle the delay in the PHY.

Fixes: ce3bf94871f7 ("net: dsa: b53: add support for BCM63xx RGMIIs")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250602193953.1010487-3-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d2ff2c2fcbbfc..7ca42170d8666 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1237,24 +1237,7 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
 		off = B53_RGMII_CTRL_P(port);
 
 	b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_RGMII_ID:
-		rgmii_ctrl |= (RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
-		break;
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-		rgmii_ctrl &= ~(RGMII_CTRL_DLL_TXC);
-		rgmii_ctrl |= RGMII_CTRL_DLL_RXC;
-		break;
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC);
-		rgmii_ctrl |= RGMII_CTRL_DLL_TXC;
-		break;
-	case PHY_INTERFACE_MODE_RGMII:
-	default:
-		rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
-		break;
-	}
+	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
 
 	if (port != dev->imp_port) {
 		if (is63268(dev))
-- 
2.39.5



