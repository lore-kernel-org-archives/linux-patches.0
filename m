Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B356A1D07A3;
	Wed,  2 Oct 2024 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877476; cv=none; b=sFFoFNJIhvzisSt4EiQ6fE+NIgxSAX9vrSn1PO8RrQmO+Bz/RAGX3TJns/fi5nYK1THBY6pjY2sfFr+mM5c/2z/Faj9DMf8A0GAa/eNQqYWamkPLfKLm0N9JPqb0CfYKSrzyhT3xFMxs5LwNmbPD26cI4X6vwFljWzc4pORqd24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877476; c=relaxed/simple;
	bh=AqjjEfsGKORjyuV386R2k3spgxayJgd+vQ1kR9Ctj2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbytmVe7vP2mN5OEkN7pP1p/UnqGJsYjRdf6jxqzWXQkE4qoyctjuzHXXo/NVhbSgPhb6cDYpTJ2qQqK+v6SHbdhV5ZqtrLa8NEWdVjG3FupMDzs2+YUSAfCGCh7yFaHf35gv85nTrQqXUlFtZCDXEuRsaNfTf4gN0JJwTHTPg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wheo4S/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wheo4S/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1D3C4DDE2;
	Wed,  2 Oct 2024 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877476;
	bh=AqjjEfsGKORjyuV386R2k3spgxayJgd+vQ1kR9Ctj2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wheo4S/FCfB1pPP2Qa/nn0SW2M5virnYL632ysjY4p0bPEdLzEogf9btjtDC2/HqI
	 3RE4DzXVt79wX+MIMEi8gCd9nlPwT8VVAiS2E+4xIm8ttFMpebTKP/Whfdd3x5BC/z
	 3dIOWpgOc1mW1gjSmkpobzkdN/MsSCOQ7MFYiOYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 091/634] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Wed,  2 Oct 2024 14:53:11 +0200
Message-ID: <20241002125814.702831807@linuxfoundation.org>
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
index 2baf4451a9b5e..0f9f17fdb3bb8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1721,7 +1721,6 @@ static int m_can_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	m_can_clean(dev);
@@ -1736,6 +1735,7 @@ static int m_can_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



