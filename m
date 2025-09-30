Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3BF302163;
	Tue, 30 Sep 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244325; cv=none; b=T7B8QPcyna5AaWG7F2ny5WzgmvSE2c4n5vow9QWHc6rHAZAl7b0mUaTINnwpZ27SY04D0ncaYjS1Xw8ziyxGsjAUbVzaXontG+8I88qcvRwGxdAYFSTTnXU2OGhX+MSLohllykeQ+iknx8Cw1E/1/7+9AW9K6Gb+Ooo8s9oSK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244325; c=relaxed/simple;
	bh=dwRUfmJ4rGOxbpFwCb6+ZRe4pAGsZM1+cGIjoDc8sI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+M8QvZF+CatMdqlvX67Qi8N3OOycIrz0D6oCGMXkFom0JI9KAwXg+5dyk5mHjJU62fpUPplk8oCpb5Jjsf5H8DvF3ZencrA49w+8W5obA/ustlH9DlwOQAENx0wMIBRqLmSaBNMyhcKp5XtCdDFn26iydhGM49+R/XDP74/Vd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKd3vjkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKd3vjkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A72FC4CEF0;
	Tue, 30 Sep 2025 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244325;
	bh=dwRUfmJ4rGOxbpFwCb6+ZRe4pAGsZM1+cGIjoDc8sI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKd3vjkEHMswB8oegue1SJlLErVvGSP1nvvCqel5ILBa5C8Kr/rMZ/M8Ospfscn5H
	 B6TiEEAd4nkEyB6dgn5Cu7nm3YsUnsB+L271lQAVRkp8v8PjwrwZUClHCSsbgV3JeF
	 P+EUMJT24koVg+y1/jjSgwHlPe44fyHZ6+0NODnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/122] can: rcar_can: rcar_can_resume(): fix s2ram with PSCI
Date: Tue, 30 Sep 2025 16:47:07 +0200
Message-ID: <20250930143826.919726215@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 5c793afa07da6d2d4595f6c73a2a543a471bb055 ]

On R-Car Gen3 using PSCI, s2ram powers down the SoC.  After resume, the
CAN interface no longer works, until it is brought down and up again.

Fix this by calling rcar_can_start() from the PM resume callback, to
fully initialize the controller instead of just restarting it.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/699b2f7fcb60b31b6f976a37f08ce99c5ffccb31.1755165227.git.geert+renesas@glider.be
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_can.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 134eda66f0dcf..e759d940977a8 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -867,7 +867,6 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct rcar_can_priv *priv = netdev_priv(ndev);
-	u16 ctlr;
 	int err;
 
 	if (!netif_running(ndev))
@@ -879,12 +878,7 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 		return err;
 	}
 
-	ctlr = readw(&priv->regs->ctlr);
-	ctlr &= ~RCAR_CAN_CTLR_SLPM;
-	writew(ctlr, &priv->regs->ctlr);
-	ctlr &= ~RCAR_CAN_CTLR_CANM;
-	writew(ctlr, &priv->regs->ctlr);
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+	rcar_can_start(ndev);
 
 	netif_device_attach(ndev);
 	netif_start_queue(ndev);
-- 
2.51.0



