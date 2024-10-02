Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9721CF28B;
	Wed,  2 Oct 2024 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875450; cv=none; b=QTtsQAR/nkpajYqueUhFOFlMxtKXiXxSV9XiJGGItTxibsS3moT7XlJSiouDnQbGyUHCQwE9cO9gRdUfMin3PJpJb1k0taVbyttfn9wnOXVMF0DpXyVd5fcDEd/fC9VSome1XujEfmoTiuF+Fa9vqs13NGWbIKDyrdg5VYQFI9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875450; c=relaxed/simple;
	bh=yp5lKI+2Dnk9KoMirpVP5iumwoSpwS1dY/JtzUz1ZUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hi4/TlS5yzV6Gei21QJRkoaISbpB3pTNoEijtvMhoZMk+eZn7ey2VXhm1J6UImt3J36nqXRAeh38wX0M/yvVu/7kGBrdcT50Kn6d1+oxpLYo0qTiIHeTzpUngzSxhTSWliRG82+SK4LNrUfx/1h5JuMkAUfy+rJ4X64D/lfrGSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMIuPTX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMIuPTX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67517C4CEC5;
	Wed,  2 Oct 2024 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875449;
	bh=yp5lKI+2Dnk9KoMirpVP5iumwoSpwS1dY/JtzUz1ZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMIuPTX3+7eFT7GmvulGYpqD+g7BDYMVgWwFMgWK/Z5mBxp4jysr9z/pnSxpFgIPm
	 htfQC64ld+R2zY0wtZtfvsypdsdHkNfEmGZV0Zs59dTtARuJcM6E9relaCGtMhL773
	 yEfNrWGEK5LdIxTNCpNrL3U150dOOO1n8Fw23uiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 105/695] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Wed,  2 Oct 2024 14:51:43 +0200
Message-ID: <20241002125826.666007924@linuxfoundation.org>
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
index c1a07013433eb..7fec04b024d5b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1764,7 +1764,6 @@ static int m_can_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	m_can_clean(dev);
@@ -1779,6 +1778,7 @@ static int m_can_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



