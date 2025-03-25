Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FAB2580DE;
	Tue, 25 Mar 2025 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906015; cv=none; b=PJ14p0tYuUD2CHgmesvOm864mQtNtht18PvUoVpoLW6tZXBeunhzSlVo+iU5EdWOLj1yLzbJNvtMbw7vFa+BNzxsxZMaiVBYULL6fDs/D5footqOxrpTuA45eQ+qniViH9lg82UhWk9bbGKQOr1BJDfiG1bFDx6CYAAPiX9bQ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906015; c=relaxed/simple;
	bh=1njYjMLRNtqKhoJ9YZPXDIzJsN5MN4pRtY8FzdyU0a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5aCRZZVZsz6S5YgdMvGYion3V/2WhDf4JwsQkjdgyxgHxHMRkkjZ15VSUzDKXZXVYcCPbj3ib8ZtBwetmwnsgJ97EZs2w7G4hk5XTFOtGBFFCVO5bHelguIy+mME0I0tR6m1cu288Y9g3qspDh0/576aBbc/YaOBpYh74r0jJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqgySEX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqgySEX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF28CC4CEE4;
	Tue, 25 Mar 2025 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906015;
	bh=1njYjMLRNtqKhoJ9YZPXDIzJsN5MN4pRtY8FzdyU0a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqgySEX0Z/BtAufy3kQTpopYa9UDvR7DeZOn5eo2X4kLHPvdBtmtpOaoQw26KiHJ5
	 B1zwcLwVbiJishqXhtJ8MCPp67c8VZO9bdCuayv5E8I9R9i8WKLJNeIIllA7NHxZ8t
	 OI8QZw6pQNNF053swWVriFcfFIFV20a3CX0hSi0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.13 059/119] can: flexcan: only change CAN state when link up in system PM
Date: Tue, 25 Mar 2025 08:21:57 -0400
Message-ID: <20250325122150.562413004@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit fd99d6ed20234b83d65b9c5417794343577cf3e5 upstream.

After a suspend/resume cycle on a down interface, it will come up as
ERROR-ACTIVE.

$ ip -details -s -s a s dev flexcan0
3: flexcan0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN group default qlen 10
    link/can  promiscuity 0 allmulti 0 minmtu 0 maxmtu 0
    can state STOPPED (berr-counter tx 0 rx 0) restart-ms 1000

$ sudo systemctl suspend

$ ip -details -s -s a s dev flexcan0
3: flexcan0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN group default qlen 10
    link/can  promiscuity 0 allmulti 0 minmtu 0 maxmtu 0
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 1000

And only set CAN state to CAN_STATE_ERROR_ACTIVE when resume process
has no issue, otherwise keep in CAN_STATE_SLEEPING as suspend did.

Fixes: 4de349e786a3 ("can: flexcan: fix resume function")
Cc: stable@vger.kernel.org
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250314110145.899179-1-haibo.chen@nxp.com
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20250314-married-polar-elephant-b15594-mkl@pengutronix.de
[mkl: add newlines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan/flexcan-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2266,8 +2266,9 @@ static int __maybe_unused flexcan_suspen
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
+
+		priv->can.state = CAN_STATE_SLEEPING;
 	}
-	priv->can.state = CAN_STATE_SLEEPING;
 
 	return 0;
 }
@@ -2278,7 +2279,6 @@ static int __maybe_unused flexcan_resume
 	struct flexcan_priv *priv = netdev_priv(dev);
 	int err;
 
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	if (netif_running(dev)) {
 		netif_device_attach(dev);
 		netif_start_queue(dev);
@@ -2298,6 +2298,8 @@ static int __maybe_unused flexcan_resume
 
 			flexcan_chip_interrupts_enable(dev);
 		}
+
+		priv->can.state = CAN_STATE_ERROR_ACTIVE;
 	}
 
 	return 0;


