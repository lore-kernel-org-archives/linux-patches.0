Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042822;
	b=A3JnHA1bF8mNBJFcL/fJpTOl/b5ErF7lLbWWpiDTOWXuNfRlqk8Eg/YCoMb0uJH4cX1b
	 NcYv0bnyEGv4C6CGJ2knqA51fBSM2QQntMZOfDNuPiDY9U8GS1DKpqlZFGDQeOvD4kBqs
	 /9Rx7yBn972Px+wsn7XOHZrYl24ndoUflKGYemJ5Z+MQ1oPLoXWHENzARYnW4bS1rPBPq
	 jO8lm0s6fK5Ugg/8F5Ck+zyvQa+EY1+eXlh5oSDq4GIOKlNHz5sYYx7KRD3AKbvbs/7Fm
	 QjziRMVapIs2gupfycESU2NgFEjjaBs9bPZq4LmEA3eEFO3b6V3GvXB0mg6/QXMKmew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RrIG6W8qok7gUnRk6uX45y9OWoQKRX1lU/dV6f5775s=;
	b=G2Cr6M9MRZ1nh+xCksAB6Kz2iEIFng/ivO561msNPji1OWXTLHUCb0XHLc9jsGS3HcL5
	 hq+asLCP6zfqHBYebXoFOW79eagMkJIKfHKZJn5/ngBKSMG0lYaxFp5pBJnBlZDPE4/sj
	 LlupayRffYA3/RiG3FOh+TpKIzYFCU4+d35Oz+VQgrqeKkeqVP/elAQPkWe6Vef67F0bH
	 VxxGDWCovUaI1OtoB7fgwaObAQoqCZ7T75j4SJaEL0HNNnw09EMtQZBmuvjvLCm9hnSwI
	 DY7o/6k2vp6odvGSg3bnFDVhksYtwfqv9q3Tt+RA0pqh6OEsISu3vzqvJpo4Ji3BxRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osnePMhM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30572606A332;
	Wed, 18 Nov 2026 23:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osnePMhM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B961F000C4;
	Wed, 18 Nov 2026 23:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042821;
	bh=RrIG6W8qok7gUnRk6uX45y9OWoQKRX1lU/dV6f5775s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osnePMhM4IVfZ4g010sISBDhVTStDROJDguQr6lnT6OePkedgJ/RiYfoIIpraJYhM
	 hmAylTF7h379tmAN8PLaoabWz8DVgkaIUWdPisF6CFe3ztNZDia80jFbUcD7PhXrN+
	 LjG7OpJSxunVqYBMLxtL8dq0BIUaHN6IV0Zi4tsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 3307/3318] net: bcmgenet: if UMAC was suspended in SW_RESET, restore it to SW_RESET
Date: Wed, 18 Nov 2026 16:05:29 +0100
Message-ID: <20261118150458.798066154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

commit 5857e5a196b069766a39ceb754736326a43bc6bc upstream.

When the revised suspend/resume sequence was introduced this led to an edge
case where the TX is left disabled in the following sequence.

1. phy link is down, so UMAC is held in reset and then network interface
   is WoL enabled
2. Enter suspend, bcmgenet_wol_power_down_cfg() enables UMAC_RX since MAC
   is in SW_RESET
4. Enter resume, UMAC_RX is left enabled. Since we only enable UMAC_TX
   and UMAC_RX in SW_RESET. The UMAC_TX is never enabled again on link up.

The issue was hit in production and I verified the sequence keeps
the TX  disabled in my standalone test. I tested on an internal
development board with bcm77122, but should be reproducible
on any genet HW that supports power management.

Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260930230634.3132729-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -253,6 +253,17 @@ int bcmgenet_wol_power_up_cfg(struct bcm
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+
+	/*
+	 * Mirror wol_power_down_cfg(). If only UMAC_RX
+	 * is enabled, then we must place the UMAC back
+	 * into SW_RESET.
+	 */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if ((reg & CMD_RX_EN) && !(reg & CMD_TX_EN)) {
+		reg |= CMD_SW_RESET;
+		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	}
 	spin_unlock_bh(&priv->reg_lock);
 
 	/* Resume link status tracking */


