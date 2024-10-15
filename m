Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D671E8855;
	Tue, 15 Oct 2024 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992461; cv=none; b=E9iz18eGDT/gn8Hdjp247mxguZ2/ZhlNowx7MsU7b62D58rNIA6s2e2VIrQtBWCbrnBoheJjiQEAayuJTQC73gt87qEc2Zq825IS3iVnuj1pcz7Vn5IBdVqfZJbDIHMAZ0cNDvYncTobluGOgzQjVgsiCXOu6uhini5PDuwr5Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992461; c=relaxed/simple;
	bh=M3wnIW62kwmExU3vcFGFAwJau4r+raIZ6QOvq4AZ41U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNTPb8bl14myhrV4niLNaD+IjVwKmn98HxkapRVxXA8I1z5rpOR1KY/bBupwVU/+85nDlXLrlOxRk1h81vmVZ9+kH7Xm0IsX1/FTYhD2xd2KOolQgPgnvKDf/v2sFxQQ+Axc+sz/dnePYKAENhV5lVRXgEDZwYm/aYvUs3FIGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOkeF/38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOkeF/38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD7DC4CECE;
	Tue, 15 Oct 2024 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992460;
	bh=M3wnIW62kwmExU3vcFGFAwJau4r+raIZ6QOvq4AZ41U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOkeF/38Z0FyFj3q8eyX6XGOY+jBew1ZjIkL7OOwicrEI/TdDK77ky3iEcbFDOrrN
	 Y7Zb774qd4KHhZg4bRLEssG6Nt3smiZz1YDh1lluHYQQNMiGzmiwZxXt2Ni1Q/oFm0
	 xghKaLMCMbwicGwgPeTdo+HAIA/TAaLLaM/K+gJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/691] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Tue, 15 Oct 2024 13:21:12 +0200
Message-ID: <20241015112445.279052259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 07f61ee76ca60..a87f6ce86cea3 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1583,7 +1583,6 @@ static int m_can_close(struct net_device *dev)
 		napi_disable(&cdev->napi);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	if (cdev->is_peripheral) {
@@ -1598,6 +1597,7 @@ static int m_can_close(struct net_device *dev)
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



