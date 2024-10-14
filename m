Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ED71AC459;
	Mon, 14 Oct 2024 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917654; cv=none; b=u84l0sCvjLFyU2LPDqmSs9i/5XRbUvJvHQVyVWVBoTRUCdKCY4D+LEFeEyHMylZqDxHtSF7I1FILaFPVBuvRFnCDHqfF3QKPcG8EcmiR7ifuOkEqa3qCUiyBjezmc2GXVV9TDwoT20zmkQbGkU8uED4kFMHeIbKZU2BevnvEkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917654; c=relaxed/simple;
	bh=HFH2FIbfBlYRCoEWDh5tajAYTkoQ7Z11NgEigTd5PC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM5UYzHeiiml8xpz60TenRMud33TRCz+HUAI0XvWYIut6H81Wur244jY5+fJigxXb5jjqcWKQrB2Svpv7zVq3k3lQdG9306F+SRRavTM3BDDuqHyxh0Hucs4gmtiAQtRU5LI9x0HaUea9LdPa46rxKPI9GdjL0GCyscI8JBwvHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwtC30m2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwtC30m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFCFC4CEC3;
	Mon, 14 Oct 2024 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917654;
	bh=HFH2FIbfBlYRCoEWDh5tajAYTkoQ7Z11NgEigTd5PC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwtC30m2uYRYUFBZ7r+eiU0eEClcJYP10q8m9TbXQq7JUuKRU6VaFhbRoy4gyNu0v
	 AVRlkpCsRIkaBsamC+kRLje7e6JQTvxKT5rTPHzaZ3UNJ05ijmRxKj+vyZ9bmBV+xK
	 ZuSbbsKFq+isTE/JYaQGGZMdV/Y3rCR8iKCshRzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Hamby <Jake.Hamby@Teledyne.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/798] can: m_can: enable NAPI before enabling interrupts
Date: Mon, 14 Oct 2024 16:10:06 +0200
Message-ID: <20241014141219.988349572@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jake Hamby <Jake.Hamby@Teledyne.com>

[ Upstream commit 801ad2f87b0c6d0c34a75a4efd6bfd3a2d9f9298 ]

If an interrupt (RX-complete or error flag) is set when bringing up
the CAN device, e.g. due to CAN bus traffic before initializing the
device, when m_can_start() is called and interrupts are enabled,
m_can_isr() is called immediately, which disables all CAN interrupts
and calls napi_schedule().

Because napi_enable() isn't called until later in m_can_open(), the
call to napi_schedule() never schedules the m_can_poll() callback and
the device is left with interrupts disabled and can't receive any CAN
packets until rebooted.

This can be verified by running "cansend" from another device before
setting the bitrate and calling "ip link set up can0" on the test
device. Adding debug lines to m_can_isr() shows it's called with flags
(IR_EP | IR_EW | IR_CRCE), which calls m_can_disable_all_interrupts()
and napi_schedule(), and then m_can_poll() is never called.

Move the call to napi_enable() above the call to m_can_start() to
enable any initial interrupt flags to be handled by m_can_poll() so
that interrupts are reenabled. Add a call to napi_disable() in the
error handling section of m_can_open(), to handle the case where later
functions return errors.

Also, in m_can_close(), move the call to napi_disable() below the call
to m_can_stop() to ensure all interrupts are handled when bringing
down the device. This race condition is much less likely to occur.

Tested on a Microchip SAMA7G54 MPU. The fix should be applicable to
any SoC with a Bosch M_CAN controller.

Signed-off-by: Jake Hamby <Jake.Hamby@Teledyne.com>
Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Link: https://patch.msgid.link/20240910-can-m_can-fix-ifup-v3-1-6c1720ba45ce@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ead8321ed3bfc..d8e6a081118b7 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1555,9 +1555,6 @@ static int m_can_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (!cdev->is_peripheral)
-		napi_disable(&cdev->napi);
-
 	m_can_stop(dev);
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
@@ -1567,6 +1564,8 @@ static int m_can_close(struct net_device *dev)
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
 		can_rx_offload_disable(&cdev->offload);
+	} else {
+		napi_disable(&cdev->napi);
 	}
 
 	close_candev(dev);
@@ -1784,6 +1783,8 @@ static int m_can_open(struct net_device *dev)
 
 	if (cdev->is_peripheral)
 		can_rx_offload_enable(&cdev->offload);
+	else
+		napi_enable(&cdev->napi);
 
 	/* register interrupt handler */
 	if (cdev->is_peripheral) {
@@ -1815,9 +1816,6 @@ static int m_can_open(struct net_device *dev)
 	if (err)
 		goto exit_start_fail;
 
-	if (!cdev->is_peripheral)
-		napi_enable(&cdev->napi);
-
 	netif_start_queue(dev);
 
 	return 0;
@@ -1831,6 +1829,8 @@ static int m_can_open(struct net_device *dev)
 out_wq_fail:
 	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
+	else
+		napi_disable(&cdev->napi);
 	close_candev(dev);
 exit_disable_clks:
 	m_can_clk_stop(cdev);
-- 
2.43.0



