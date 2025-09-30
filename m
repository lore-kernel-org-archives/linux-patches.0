Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717A308F0B;
	Tue, 30 Sep 2025 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245265; cv=none; b=AxJebvQcK0q0FqYu1GQNuwyLn5EKb8If6LzhAmmjk9VLQbNTrrzQt0Rf8FB5FPBFfQOh1u6vW3kJW8TqZb0R8GpZpGV+z+xs8fM64nuTqtfzyPBHJgPw1v/KmP1YJiW7cagyrtNq2SeVIS7gpRlfJMcSX2MXvLaUhVg11Op6aSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245265; c=relaxed/simple;
	bh=OHAzn37fHH/Q/yP53y6dQCdF2xmpw+1sxvsCEA8hthM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO5w5022vwbkjER/AUa/FLv6M/4AkuzJnGAQAzZRKYsNDEIzn+LQ+vkA0Rro+E8NRd8PxZSbCk5pkJW1mcL03QG1P2R/DCpq53MjIdoTJASD15k3XaUCAswTvIU8qP7lXkBYVNzbZNlex/OWgzOK2A/QQk3FfLcVbVZFacNGEno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6oLFNAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6oLFNAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0E5C113D0;
	Tue, 30 Sep 2025 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245265;
	bh=OHAzn37fHH/Q/yP53y6dQCdF2xmpw+1sxvsCEA8hthM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6oLFNAC8e0sA9cJgzxdjB/nXXiZtgCGxG7scEVrfhu3EZZbSUXDA22N9eQr4RodP
	 whYEVQww3IVcmZ1zAY/svdogJFgVqTvDpaWVfIyp1WNP5oHQRZSyGyQs+HTrhqwuXx
	 jSLsvklnUZI82NtLzQtbnYp++jvczloql3wrdhl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/151] can: rcar_can: rcar_can_resume(): fix s2ram with PSCI
Date: Tue, 30 Sep 2025 16:47:25 +0200
Message-ID: <20250930143832.188564608@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68ad7da5c07e0..e21b73315b986 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -863,7 +863,6 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct rcar_can_priv *priv = netdev_priv(ndev);
-	u16 ctlr;
 	int err;
 
 	if (!netif_running(ndev))
@@ -875,12 +874,7 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
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



