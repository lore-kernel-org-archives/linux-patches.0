Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9023A995;
	Tue, 30 Sep 2025 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246150; cv=none; b=FTofYMBgSQA5ZK/t83mdLLn3QeG8uVz/cSOrFci8QhQRM6o5hkZ/8Gv2AGnzWHMxKOlkMPqvxilOfDVzaKrSxanO7FIoYV5ulrqBIIWVFv5F0UxsMli39ImCFhjKHRQKJz4QfPHDnPof+jKd0bJ06Xv6v4L0K/2WYMF0++AOxBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246150; c=relaxed/simple;
	bh=d9VC0li5aGyfQPcWVB3f+9n9ZE0p6HiyuvQbaX4qo/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7intJ61hQgL6bpmCr62EF9vvpMe4I/v9BOhRHDRc2aAqaeJ1vs+SK4ah/+djLDAixtUjmA4Yd/whTelF1JwBxf/uIYIHzTBWPosRvU905NFtOswSgwnSttEIM1lrV8z+gdR/OwEDgXZh3jaatrXIyMAEmKhfNnhkDNrx9QngM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5hiwhJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5hiwhJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ACBC4CEF0;
	Tue, 30 Sep 2025 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246149;
	bh=d9VC0li5aGyfQPcWVB3f+9n9ZE0p6HiyuvQbaX4qo/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5hiwhJw16k9kE0XEg9zAjnDSr4on5Mi7kVMgU98hRmOqSuCTHpzC/+D8/v1B8sEI
	 +hdZ8WsnqV4w5+dEdRZV5FGxq0P9goP/eK9HYNrIEDsBT1z/CFUzN4d3ynD0nZp2ob
	 vE5qa5pSNxgDfr1aOVaF5ZiP62D37zVS3FerpxMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 37/89] can: rcar_can: rcar_can_resume(): fix s2ram with PSCI
Date: Tue, 30 Sep 2025 16:47:51 +0200
Message-ID: <20250930143823.459262284@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b7dd359f27b7..8569178b66df7 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -861,7 +861,6 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct rcar_can_priv *priv = netdev_priv(ndev);
-	u16 ctlr;
 	int err;
 
 	if (!netif_running(ndev))
@@ -873,12 +872,7 @@ static int __maybe_unused rcar_can_resume(struct device *dev)
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



