Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD46E2F94B2;
	Tue, 17 Jun 2025 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177669; cv=none; b=k1ZdDHJWl7BQkeJ8DxGWbx7kr/l4aXk1mBC7Muf1MI4ae1uMMSwJyfUmEPwIDkQOY3bqLa40ci8pXIC6sgY6z8omNQyU0rnVvgB654nLQvRT4XjCpyL8cxwmNsaUX0e4uPDiA5pjAMXqXy0iaBvxa4fI2YVqfoez+1rq7c0vN2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177669; c=relaxed/simple;
	bh=/bi2Ri1B/q5QpSJZHPjyKHzLw3USQMZg2TuKYtbJ13U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewOHSfRZHpklppgqImNFJ77iHn1XuJ5uHKNWyQhOczfZOY25Kr2VODgYSYX6F+tfQJt9IVbNb7YpjbLCcTEacngNhbd91htpn3uxNFZNVk6OT8k5Gtos7gVZgdYLZYU6+q8u6xtotHuOJpdYOdXldZC3ryCg4ye0BjzrFIVsfTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbL3HuRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbL3HuRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD99C4CEE3;
	Tue, 17 Jun 2025 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177668;
	bh=/bi2Ri1B/q5QpSJZHPjyKHzLw3USQMZg2TuKYtbJ13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbL3HuRFJrtKuM+Rd3GBWaV5r/5KZZQtjOKsKWRnZDUKm6kzZ9xW+LsZm+dBsXLV7
	 CawVm6YXoH7lr4c5IO+mOxiK/bdvmQNInGXds9wbz4pozdZAWOjM2m8aX7b2SyQJwP
	 nnkAnBWnzxNc/lLRQZjnjOX3w9BWFLDmqK2cUpMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/512] net: dsa: b53: do not enable RGMII delay on bcm63xx
Date: Tue, 17 Jun 2025 17:25:45 +0200
Message-ID: <20250617152434.949247175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 0168ad495e6c9..2747a507e3ce9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1326,24 +1326,7 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
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



