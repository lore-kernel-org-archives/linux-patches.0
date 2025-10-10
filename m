Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7DC2877DC;
	Fri, 10 Oct 2025 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102539; cv=none; b=Ma91SCgkKhvW8ixw1CqpLQAcjoTNfPNka13dX/sdo3uXhTrhTjmDyOvB0vHxmgUX1GctXQ523Pe+kbhv2B6SwO6FWSBO6jsQIUgSRjE4Ia17nEBvxozrw+bSRZUVgWiW7MQTYV72r6OUQPBkfIFPfHZ0q/U3wxlvFb1wxBOEjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102539; c=relaxed/simple;
	bh=LdCbdmIpkN+tclxG9pU3nSRo8BzFQWHLysIGpGpRpq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzp9z8K5lQBlKqFBTIi0nU8UwLIMt1KLYP/06yCH06FNSIZJASR0z67qJxaXIaIIAyelLWp58QiWTR0ITQmz0k0B2aydVe+gNVJATWACWBxLwMoVrQMCTf43AIArcri7SwdvAph3bVBaknwfyuP7qnXINYZ013+BD6TNTZVym40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMm/3MX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMm/3MX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72142C4CEF1;
	Fri, 10 Oct 2025 13:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102538;
	bh=LdCbdmIpkN+tclxG9pU3nSRo8BzFQWHLysIGpGpRpq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMm/3MX7Bqz/ssKWPNqjkr1/3xPqukiE3poMMtdyQ04p1DA2t2cWoA8gxlQbPoYKM
	 rpL/ttN/4uca2glOHZtStffxvzdUUzoSTCmH/LZA59PwyZub1XwbNPLfpLXF25yWyf
	 YnK+djD/y4DBEtOUQ07wpx06PDl11H81K67SpOcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Tranh Ha <tranh.ha.xb@renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/28] can: rcar_canfd: Fix controller mode setting
Date: Fri, 10 Oct 2025 15:16:32 +0200
Message-ID: <20251010131330.883685434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e501b55678d1d..ae4ebcee60779 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -738,9 +738,6 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
-
 	/* Transition all Channels to reset mode */
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
@@ -760,6 +757,10 @@ static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
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



