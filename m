Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6F43AA9;
	Mon, 14 Oct 2024 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917534; cv=none; b=BSjAc4lKCTjRcOpRSUveilulRj2ktT89ya7NPTzn8rSwxG9OVc/ZoDnJlyzMmAiEiRdLBekkdvLrKM28h3dylpM+g/TKcyL5YuD44lY/pvyeglKcYgauSx0APefnp0p7WkzXGx/y0scC+6iv4iNzbbFvYo0WDVADyOY/F8gF+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917534; c=relaxed/simple;
	bh=NBDxGNmqXGvRiKCuYQUTlgAXTlOQfkie0VYAypn0WjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNhyzdhFziInfKBcOr8hNgw1g4pWxVhJQH3jTn4zwnb4RZQqsbj9tb5fNbJHMFxpGfWiYIMKQiyvpB+NpjX7TqjuIRCml66AQrCcPV9cI6oIHtd36tPxjf/3CAmL6P1f57QRM1IL6DPCCa78jD82foiZqn3w1QKDhov25vrAfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eA0ZJDhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eA0ZJDhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFE3C4CEC3;
	Mon, 14 Oct 2024 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917534;
	bh=NBDxGNmqXGvRiKCuYQUTlgAXTlOQfkie0VYAypn0WjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA0ZJDhA7tPaKvgwLPxtavbpncAbbpfIen3HyS57hWx6OPUxuoqVl+eodHtFTTAEH
	 JfsxNpCKM1yB023Qm9jNf0cIC2W5fHc3bdejDQuMpH2pl674RzShCJD2th9tYRcxkz
	 GPKeMwMBUoECMPluSo5k71s8kPYpztXo5uAeKq6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/798] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Mon, 14 Oct 2024 16:10:07 +0200
Message-ID: <20241014141220.027301984@linuxfoundation.org>
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
index d8e6a081118b7..e77b4b60f4e61 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1556,7 +1556,6 @@ static int m_can_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	if (cdev->is_peripheral) {
@@ -1570,6 +1569,7 @@ static int m_can_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



