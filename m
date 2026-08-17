Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B022E43F4A0;
	Mon, 17 Aug 2026 13:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974570; cv=none; b=XieRYSJFPw/nSg4JhVGL00TdKhiIfu5opqz0EEuNLUaeROGGyfjbhEycr9K2p8UYwpoZWpA3uH8S71sZ1vzmJ6DvO//NxVMS5l8TNlFT+uzF6Py2HfsjjFiz3rbOvWUflQE9HeRyQlUV3qppMbhozCtadfJL4VivoeR0H+lGeNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974570; c=relaxed/simple;
	bh=QYH7vDlYUoCEAeDEonc8RaJhBhfQ5rrfCZc9sSl1ngA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htnRpmi9P3B2e8chd6/julNv7TiuiYzF7NlU18C+IjCdd7Vdo09wXMPgI9J1dDFVCu6PRSol/IPo+6RiVvJbJHJ3Mgw3+MVAWfwx0t8sfz7F3sCtXe2iCmWBrwdO/uwt3LB9/upY8Wl/6WeYlgsMjrw7oQgyeKRekERRaCJ7rE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn5vELOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn5vELOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347011F00A3A;
	Mon, 17 Aug 2026 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974566;
	bh=3vpwQVTlMSqckN6/OHjSRFWG4fAVPVV5BT+Hh4bJX8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fn5vELOjLQuzAgSgkq07Nt3CsvFfd0NzM6Vzct0WYsc7SGGwHDfqT3sGuEfsZCNQh
	 yCep+Y+FH4csWM8midKVy7d3Plo8qTpPcYmmmcAsn9mIftclyCGQmLqC57dtBasirS
	 NCMytiYKMVvv/K2rDx4Vqkb9DHRdCrzNvodPFYLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 211/271] net: phy: mediatek: fix TX blink masks using the RX bits
Date: Mon, 17 Aug 2026 15:32:16 +0200
Message-ID: <20260817132545.486862635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Naseef <naseefkm@gmail.com>

commit f684c514f7965385dae21f2535f99938e73ec1af upstream.

MTK_GPHY_LED_TX_BLINK_SET and MTK_2P5GPHY_LED_TX_BLINK_SET are built
from the RX blink bits instead of the TX ones, so both TX masks are
identical to their RX counterparts. The TX bits they should be using,
MTK_PHY_LED_BLINK_{10,100,1000,2500}TX, are otherwise only referenced
by the per-speed branch of mtk_phy_led_hw_ctrl_set().

A TX trigger selected without a link trigger therefore programs the RX
blink bits, and the LED blinks on received traffic. The masks are also
used to decode the blink register in mtk_phy_led_hw_ctrl_get(), which
as a result cannot tell the two triggers apart: an RX-only
configuration reads back as RX and TX, and a TX-only configuration
reads back as neither.

Fixes: 7f9c320c98db ("net: phy: mediatek: Move LED helper functions into mtk phy lib")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260804113511.3371248-1-naseefkm@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek/mtk.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/mediatek/mtk.h
+++ b/drivers/net/phy/mediatek/mtk.h
@@ -53,15 +53,15 @@
 #define MTK_GPHY_LED_RX_BLINK_SET		(MTK_PHY_LED_BLINK_1000RX | \
 						 MTK_PHY_LED_BLINK_100RX | \
 						 MTK_PHY_LED_BLINK_10RX)
-#define MTK_GPHY_LED_TX_BLINK_SET		(MTK_PHY_LED_BLINK_1000RX | \
-						 MTK_PHY_LED_BLINK_100RX | \
-						 MTK_PHY_LED_BLINK_10RX)
+#define MTK_GPHY_LED_TX_BLINK_SET		(MTK_PHY_LED_BLINK_1000TX | \
+						 MTK_PHY_LED_BLINK_100TX | \
+						 MTK_PHY_LED_BLINK_10TX)
 
 #define MTK_2P5GPHY_LED_ON_SET			(MTK_PHY_LED_ON_LINK2500 | \
 						 MTK_GPHY_LED_ON_SET)
 #define MTK_2P5GPHY_LED_RX_BLINK_SET		(MTK_PHY_LED_BLINK_2500RX | \
 						 MTK_GPHY_LED_RX_BLINK_SET)
-#define MTK_2P5GPHY_LED_TX_BLINK_SET		(MTK_PHY_LED_BLINK_2500RX | \
+#define MTK_2P5GPHY_LED_TX_BLINK_SET		(MTK_PHY_LED_BLINK_2500TX | \
 						 MTK_GPHY_LED_TX_BLINK_SET)
 
 #define MTK_PHY_LED_STATE_FORCE_ON	0


