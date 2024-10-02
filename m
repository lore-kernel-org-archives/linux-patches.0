Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FD1D0788;
	Wed,  2 Oct 2024 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877473; cv=none; b=Q29u+9CD4F02ZD5ymRm7tJZdkOWzqOV3R7R6MLotFnMFmAfTcK0JMXhlsYkMCxpb/VAP0vpP4yL5iu8LK+NAkeQESB2IMb673KCtezlqxwy5BorM+37h0jBOkfP8OEVcb1Oe34KReutzIGe7S/sxyl2UdlNTMw1L8G1PcPrkUIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877473; c=relaxed/simple;
	bh=eWr8+Ir/AjGfduZ46CRJwvUBFhD+cNunGEJZJAHvJyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4OtFhtwYpcPdIJzyrKu/wqadF8bmV11tz7ugCTSv1lvr//RVVeOnBCCGIa6cHi15slz0Xvk13xH42Jts5V7eK124RM4YlkmgGQEyU9C5noKIGKfSMDDqeni6UpjQacQwU6qmfA2HNHgZhaoNAwqz4h9llgGk5e+jMgN5I6M9Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEGS8kDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEGS8kDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E33AC4AF61;
	Wed,  2 Oct 2024 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877473;
	bh=eWr8+Ir/AjGfduZ46CRJwvUBFhD+cNunGEJZJAHvJyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEGS8kDgDxeYuwmFltPRWWYZlxuW7BQi2LQYy011bERMfGdVKnp58nTj0jY6b6poi
	 yetQ6bB0IPfQhkxrbb9to7UieQzHyP0JeJ+n9bhVSrhNzW6R3jBtajzf7F75moeMgH
	 urs6f8bCm3yy6Irt+rrP+WIWKljo4BwfaCtpCFnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Hamby <Jake.Hamby@Teledyne.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 090/634] can: m_can: enable NAPI before enabling interrupts
Date: Wed,  2 Oct 2024 14:53:10 +0200
Message-ID: <20241002125814.664008416@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index ddde067f593fc..2baf4451a9b5e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1720,9 +1720,6 @@ static int m_can_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (!cdev->is_peripheral)
-		napi_disable(&cdev->napi);
-
 	m_can_stop(dev);
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
@@ -1733,6 +1730,8 @@ static int m_can_close(struct net_device *dev)
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
 		can_rx_offload_disable(&cdev->offload);
+	} else {
+		napi_disable(&cdev->napi);
 	}
 
 	close_candev(dev);
@@ -1987,6 +1986,8 @@ static int m_can_open(struct net_device *dev)
 
 	if (cdev->is_peripheral)
 		can_rx_offload_enable(&cdev->offload);
+	else
+		napi_enable(&cdev->napi);
 
 	/* register interrupt handler */
 	if (cdev->is_peripheral) {
@@ -2020,9 +2021,6 @@ static int m_can_open(struct net_device *dev)
 	if (err)
 		goto exit_start_fail;
 
-	if (!cdev->is_peripheral)
-		napi_enable(&cdev->napi);
-
 	netif_start_queue(dev);
 
 	return 0;
@@ -2036,6 +2034,8 @@ static int m_can_open(struct net_device *dev)
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



