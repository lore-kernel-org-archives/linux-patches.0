Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0640214813;
	Wed,  7 May 2025 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644166; cv=none; b=YOcYsp2ADv595LHKYF36imQrG3BYk1SkSmUvVjkeUfO9w07ZH3T+P8yIFWBIxg2IkiWCFOVT0JjkvoPebZC4XKHFYLAEXVf8KPwu9WlVhxoY5QU6IxIqImXoyoYLZIMl1isOfezy/D05/6D8vPMYy9b1sXdgv4lRxe8QL0P3l2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644166; c=relaxed/simple;
	bh=bbHFcL1BLWRoDcJ9a/IGyPBlePqtecCk8jgpbAKaXSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWmYe0H3M+Klyoi8sBLePTcfHJzEDrwjXSh6mI2LyvXgv+XtdysgC3HyHUiLUpTjxH0KmpKJKGVL8wlqPDTh6S/ZaFlyTQyBc5eKEAiL06LGaYyidjlxnLTUS8u6mdyRygyaye9K31XuWfARfK6U3vq2MDGlH42SpcOSPdpfdkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afa0oMiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afa0oMiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CE3C4CEE2;
	Wed,  7 May 2025 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644165;
	bh=bbHFcL1BLWRoDcJ9a/IGyPBlePqtecCk8jgpbAKaXSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afa0oMiGKYKa8d5F8Ex9+OlzXhR7usu8bg5AzTTPBU82ufNJe0gsjnSAaF+3hp0sI
	 KdJ30mJiGLyeGGq1UjOpQ0bkRhMF+HeUONGQYLJd0Ra6OFxWINO/0JwKggxZDVEoR1
	 MMDWEoczoZAVocDnQ2mEKEkMy7USiQIUf57F4oRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 113/183] net: mdio: mux-meson-gxl: set reversed bit when using internal phy
Date: Wed,  7 May 2025 20:39:18 +0200
Message-ID: <20250507183829.403467104@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Da Xue <da@libre.computer>

[ Upstream commit b23285e93bef729e67519a5209d5b7fde3b4af50 ]

This bit is necessary to receive packets from the internal PHY.
Without this bit set, no activity occurs on the interface.

Normally u-boot sets this bit, but if u-boot is compiled without
net support, the interface will be up but without any activity.
If bit is set once, it will work until the IP is powered down or reset.

The vendor SDK sets this bit along with the PHY_ID bits.

Signed-off-by: Da Xue <da@libre.computer>
Fixes: 9a24e1ff4326 ("net: mdio: add amlogic gxl mdio mux support")
Link: https://patch.msgid.link/20250425192009.1439508-1-da@libre.computer
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mux-meson-gxl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
index 00c66240136b1..3dd12a8c8b03e 100644
--- a/drivers/net/mdio/mdio-mux-meson-gxl.c
+++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
@@ -17,6 +17,7 @@
 #define  REG2_LEDACT		GENMASK(23, 22)
 #define  REG2_LEDLINK		GENMASK(25, 24)
 #define  REG2_DIV4SEL		BIT(27)
+#define  REG2_REVERSED		BIT(28)
 #define  REG2_ADCBYPASS		BIT(30)
 #define  REG2_CLKINSEL		BIT(31)
 #define ETH_REG3		0x4
@@ -65,7 +66,7 @@ static void gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
 	 * The only constraint is that it must match the one in
 	 * drivers/net/phy/meson-gxl.c to properly match the PHY.
 	 */
-	writel(FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
+	writel(REG2_REVERSED | FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
 	       priv->regs + ETH_REG2);
 
 	/* Enable the internal phy */
-- 
2.39.5



