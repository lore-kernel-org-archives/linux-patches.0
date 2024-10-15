Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E811C07D4;
	Tue, 15 Oct 2024 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997068; cv=none; b=aIBvboWPvAXoHS5gBi61m2Rm29SaPppwxWavNsxGszz1CS7CM0LPKV54jwQ908abE4kNi2RhEKoNBet1t2WlZuJIhUSatPsdDu9nkI5BGXV080uIrMqpoglCuxQvAsKPCbP8A7kBFkIZqpRi2CBrcOAev2/0zpEkv34Tle2t4pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997068; c=relaxed/simple;
	bh=ZAitmWNaHcUXbl050ryi/vLuuto3ueWs8t1+YZLSr/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMzsCTmlC8Otkt8dY8O8ZUhHHwxONirmmm/8GuQ0MQ4RusV5Jisj7LH1hXTIN2mQTVbjGhAszrS6TTbIq+vBpZ1eS1cNFBV/u+LzOkXdxybEy8o0zxV59LuFFs1Vi38o9LU+ThvbbMUkOPlnUv6WV6g1KBKUeONQtsZhZExqIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oxAB5F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oxAB5F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CDBC4CEC6;
	Tue, 15 Oct 2024 12:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997068;
	bh=ZAitmWNaHcUXbl050ryi/vLuuto3ueWs8t1+YZLSr/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oxAB5F+1aot2gmS1C2HOFL4G8g2flSuGdsdG1rv5Hywi7hH8M0ucR+r4R1gOiHho
	 IQLVMPs8uc07/FD1PwUpZi3wnyGeuSC/IVy4UsseTcgMZj1z7IXiSD71nk1yLDEmK2
	 ZlYuttarkUjiFs1mTi6wRg0psDLPbTP42ZV8cPb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/518] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Tue, 15 Oct 2024 14:39:43 +0200
Message-ID: <20241015123920.050163755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 2c09b50efcad985cf920ca88baa9aa52b1999dcc ]

After calling m_can_stop() an interrupt may be pending or NAPI might
still be executed. This means the driver might still touch registers
of the IP core after the clocks have been disabled. This is not good
practice and might lead to aborts depending on the SoC integration.

To avoid these potential problems, make m_can_close() symmetric to
m_can_open(), i.e. stop the clocks at the end, right before shutting
down the transceiver.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Link: https://patch.msgid.link/20240910-can-m_can-fix-ifup-v3-2-6c1720ba45ce@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f314d93aca0d9..6181ac277b62f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1427,7 +1427,6 @@ static int m_can_close(struct net_device *dev)
 		napi_disable(&cdev->napi);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	if (cdev->is_peripheral) {
@@ -1439,6 +1438,7 @@ static int m_can_close(struct net_device *dev)
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



