Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515651D0412;
	Wed,  2 Oct 2024 13:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875447; cv=none; b=l/+Ggbe0ZVKhiR5G4PVWI0zDe76dmgfjHjy/w9Zu0yCjlxMbIbW1UeJUQwGlcvVQbUid72DZh/jt6qqh0O/DBndV68IjW99l2b43poBh8FvOWrY8jpBS/f6t0ZB14uDzbjlUXmoRP4EH+hPLVMF0Qd2zBPa/ihUYdi/fImvseEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875447; c=relaxed/simple;
	bh=S0L0muGts5WJExKljula0vmG0XTe+jRHGz26GT2awdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/JjmDGRUCbaBgi/KS+y5rcVelfQiLpx5uRFSqJXJ+aQ7ZAY0/aVGY+nJRka7EDosM8P/5QLJnfNfkrlCzBScTTLDzbrNIKIt0kqUkeR5FqR5YQVhYLj66O05bWGHSpbQFK+aG+vK2tmbYZ+hBXVWCiqfujjCLnG/Hh/K/Ai+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twBR9AM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twBR9AM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE73C4CEC5;
	Wed,  2 Oct 2024 13:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875446;
	bh=S0L0muGts5WJExKljula0vmG0XTe+jRHGz26GT2awdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twBR9AM/VRntDgqDW0CzmVKZTqCXhPsRefwpgVqwk5aiYNjoRnKfhRHNVtCvhhsqz
	 FrxAD2Ajj1hWXcvFDbnP6wVtb/ubdom7dd56JPhOeZBLtwX42tqLHuJ+aXa+j7TFqs
	 DR/rezu/R0eeBIsVJxKK9Ia9WTepNVQCyWra3zLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Hamby <Jake.Hamby@Teledyne.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 104/695] can: m_can: enable NAPI before enabling interrupts
Date: Wed,  2 Oct 2024 14:51:42 +0200
Message-ID: <20241002125826.625611312@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 012c3d22b01dd..c1a07013433eb 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1763,9 +1763,6 @@ static int m_can_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (!cdev->is_peripheral)
-		napi_disable(&cdev->napi);
-
 	m_can_stop(dev);
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
@@ -1776,6 +1773,8 @@ static int m_can_close(struct net_device *dev)
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
 		can_rx_offload_disable(&cdev->offload);
+	} else {
+		napi_disable(&cdev->napi);
 	}
 
 	close_candev(dev);
@@ -2030,6 +2029,8 @@ static int m_can_open(struct net_device *dev)
 
 	if (cdev->is_peripheral)
 		can_rx_offload_enable(&cdev->offload);
+	else
+		napi_enable(&cdev->napi);
 
 	/* register interrupt handler */
 	if (cdev->is_peripheral) {
@@ -2063,9 +2064,6 @@ static int m_can_open(struct net_device *dev)
 	if (err)
 		goto exit_start_fail;
 
-	if (!cdev->is_peripheral)
-		napi_enable(&cdev->napi);
-
 	netif_start_queue(dev);
 
 	return 0;
@@ -2079,6 +2077,8 @@ static int m_can_open(struct net_device *dev)
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



