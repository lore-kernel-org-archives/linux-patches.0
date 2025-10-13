Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7A30F55D;
	Mon, 13 Oct 2025 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366943; cv=none; b=PMw6A6hDL0wzDw1kCPQ0DVjH6ABd3xMFmhi7CBqpXFPG38kGOJvredurxEDVgPhL7Ea97cdvQaxxNaIQ58Zb6q4wX8XDzysilctuYhObnDzgx0axA2Wd2r48rtDv0m+EngawBbW7X4XDUhnzm+J7xr4WN40lllR2iRfxpxVxagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366943; c=relaxed/simple;
	bh=ZPXH9nQInaUlLDUrnJ94HGlDZXWZ0vEjQD3m/BmlLA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsYtDMmk3CH7xkoUN8hGS3Nb/B505BJREGVisw+jHI0UB8yvv1AX/x2Ggb7BHMEEE4DnJ+7YaULLo+TYlcRqYdK/yQDHFKAn2Lq96bRiiLGH05AOwDHPwL9dCqZlmeQ401Al9s4tqAPqJTXxfx4jMu+Jc7uQfjUwXDjGdlXI42Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+LitHN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+LitHN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9702EC4CEE7;
	Mon, 13 Oct 2025 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366943;
	bh=ZPXH9nQInaUlLDUrnJ94HGlDZXWZ0vEjQD3m/BmlLA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+LitHN6R+gEHWn1URJZnBcP5W2Eb9yiwzRzWPtXFfqyBDBwP7+iips46ZlEpQ5Kx
	 C4yrYzu2pLCSazUQG7I+BSTDUVJvJFIRFZinWq+Uwnjygwp1mIj9h6mnkK73+iPXzD
	 VCgIQWgdXHZ76jOIIOS29TFtf72/dWY0o34gnSYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Tranh Ha <tranh.ha.xb@renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/196] can: rcar_canfd: Fix controller mode setting
Date: Mon, 13 Oct 2025 16:43:30 +0200
Message-ID: <20251013144315.929277331@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duy Nguyen <duy.nguyen.rh@renesas.com>

[ Upstream commit 5cff263606a10102a0ea19ff579eaa18fd5577ad ]

Driver configures register to choose controller mode before
setting all channels to reset mode leading to failure.
The patch corrects operation of mode setting.

Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Signed-off-by: Tranh Ha <tranh.ha.xb@renesas.com>
Link: https://patch.msgid.link/TYWPR01MB87434739F83E27EDCD23DF44B416A@TYWPR01MB8743.jpnprd01.prod.outlook.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index a1f68b74229e6..3d6daeea83553 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -717,9 +717,6 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
-
 	/* Transition all Channels to reset mode */
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
@@ -739,6 +736,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 			return err;
 		}
 	}
+
+	/* Set the controller into appropriate mode */
+	rcar_canfd_set_mode(gpriv);
+
 	return 0;
 }
 
-- 
2.51.0



