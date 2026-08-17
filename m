Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E6C41B8EB;
	Mon, 17 Aug 2026 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975202; cv=none; b=F12SdM87d2LC234492DF4hOtDStb/fB5uGVxc4uTDypybt6K8wF+x1WgZ8f1wfNCpeuo4rQDR3kmpwek16+2YrKeCpQN55uWogzrdyCr+bPwa5ZOTNsPDJGUs1urM0UhQrDMpOoutgvF5Y0+sGLEJAh30+bDvAx8oj1hBKwMvvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975202; c=relaxed/simple;
	bh=wzjw/APZYMn7ALsncBunyewUbsOSM5aUcXRApbaTmt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkiEGgGH6tOwRdpjURfi95Rf38dVLFWrJcvH1wOrbCUKJqX/hNmQG5VCTCTp9LQIBTpwLyzOL1h6676Tqz6ySNwgEnljFp3XfloBcCJ3gICbya2XcGYTkt+S+Nac+GK2hwoPXHzPq4xSDzdiiJVloI7fUeUWxHk2Ga/BzkDzpHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rsy8R7GX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rsy8R7GX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291DC1F000E9;
	Mon, 17 Aug 2026 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975201;
	bh=LVaemS9cP5MYbF15PPfgQTRYXSXUZucNdVJxVsiJ/N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rsy8R7GXZFCSZx8q3iSzKBsJkeMri4JyE6b94aOnV6SK6VrKGpB4sdHkoqZfwjLE9
	 /YB6XRJzgMOKWznN+krwtGei7jVJJjWMmoZl84uQ9D094+NZ/o7slpMsZELRu1EYkQ
	 7HYllR+tlqTxT0uKBDfZ4NBneGbvWS8iQsFIYTsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 195/250] net: phy: mediatek: fix TX blink masks using the RX bits
Date: Mon, 17 Aug 2026 15:32:36 +0200
Message-ID: <20260817132544.529376993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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


