Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1651D0438;
	Wed,  2 Oct 2024 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879379; cv=none; b=BasupNFFUF7MiCSm3BR/hRHdUnZ6eY2epXlyw34n+mm5gBOu+2AWmryvu0g0mB0AeFikTzYy7u/4bcUunKfHbI3gQFmqJVn0uWMLPvgHNaoB6uM6ugRA7ft9ibUf67b8DqmYx8oS1FECdgNC10HSXQZKYDn+kXTwvbb9UzmYs/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879379; c=relaxed/simple;
	bh=UkUFlm8qOG4tx6omc+j7fh2Hg0XpFSGTUOn5mBhOCjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3AmIt8rwNu4OiM6zUFIx2iHdtIa0S8yb2+GvVFj23xREeFs7CsB6HvAiDsIKTg+VCWU/gZwhebEnuLNcsF/rZIlWFkVds25UgKzYlcPdM33ZBC5Vjd4NtVZp4BNlT6iAcdFIReh/JtjvhE/+rE3z7xLMrEBVAI5y7gh35r6xQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpLodng7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpLodng7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CAFC4CEC2;
	Wed,  2 Oct 2024 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879378;
	bh=UkUFlm8qOG4tx6omc+j7fh2Hg0XpFSGTUOn5mBhOCjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpLodng7Q8uUnAo/yexa5qiKitRBg88WBgrGG2FXTdOA9+HoZevMRq5ZjBZocLQE1
	 illUjnlZrktsFSTGaPuvNS0NgaOHbrbhsHaP5TpZYzNTwEjq9MnzeiYomln9RW4xVu
	 SK2ZhbrGkj+/j8tba7j/wOHfD/N1SZsBkYA2uyws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/538] can: m_can: m_can_close(): stop clocks after device has been shut down
Date: Wed,  2 Oct 2024 14:55:06 +0200
Message-ID: <20241002125754.855340773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 66221fdf785f8..97666a7595959 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1600,7 +1600,6 @@ static int m_can_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
 
 	if (cdev->is_peripheral) {
@@ -1614,6 +1613,7 @@ static int m_can_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	m_can_clk_stop(cdev);
 	phy_power_off(cdev->transceiver);
 
 	return 0;
-- 
2.43.0



