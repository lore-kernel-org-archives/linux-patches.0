Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33218CBE8;
	Tue, 10 Sep 2024 09:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961667; cv=none; b=D7nsb5jVPlRkO2DczvkJk/ZeV/d74qVi+v/fj84Q3epB0aPwiKCFNmEAgNzaQtYySOUIEc9qrb1dSJN+Cd/iAWvCsmtmdzB3zp5S98HnXrZQKKG6IiDmwrtuJrKcMdAZbYkdWglu7cGLilGJYNIM7iixpfjwDO2SbsRCQXfeGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961667; c=relaxed/simple;
	bh=fxQpZcv3xPnRX6fi3VxbV9061gv0RU5gfST40Lw9w4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWzhwpppoQMX7BWYbnEzLdpM295kvAO1/AplxKuEcbtV2LMbo4dATb3OU5ExXMZ4HczihNdCeaErsCZ8S+tWTws6Vb2LTWReQ4Dt6a/8x+Y61bBf2hoz8ncbh/pigareqpPUKNFW+PuEB5RZ8WkEkNHzl5xw7n9gcXN8QYi+Ytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/hMTsF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/hMTsF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28F1C4CEC3;
	Tue, 10 Sep 2024 09:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961667;
	bh=fxQpZcv3xPnRX6fi3VxbV9061gv0RU5gfST40Lw9w4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/hMTsF4GQEI8k9cVxLi50u/gWooqJCA3S6Xn39q87QXS+DNC/bpLePbPTfumZsIF
	 aIEBGaW0Fh8upy3HJNfYISJFjZWUUFU4aezKxCY+cYEAHjq9SVYYHYASn1kDvqV8Cq
	 V6gzCd4iyL9P/Sm7o1Yg3m432w8E1FBc7VDM+Tgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/375] can: m_can: Reset coalescing during suspend/resume
Date: Tue, 10 Sep 2024 11:29:05 +0200
Message-ID: <20240910092627.440566400@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit a651261ac74298535f6d6316ebe27beceb6b17b1 ]

During resume the interrupts are limited to IR_RF0N and the chip keeps
running. In this case if coalescing is enabled and active we may miss
waterlevel interrupts during suspend. It is safer to reset the
coalescing by stopping the timer and adding IR_RF0N | IR_TEFN to the
interrupts.

This is a theoratical issue and probably extremely rare.

Cc: Martin Hundebøll <martin@geanix.com>
Fixes: 4a94d7e31cf5 ("can: m_can: allow keeping the transceiver running in suspend")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-2-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 205a6cb4470f..257d5bc0ae9e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2387,12 +2387,15 @@ int m_can_class_suspend(struct device *dev)
 		netif_device_detach(ndev);
 
 		/* leave the chip running with rx interrupt enabled if it is
-		 * used as a wake-up source.
+		 * used as a wake-up source. Coalescing needs to be reset then,
+		 * the timer is cancelled here, interrupts are done in resume.
 		 */
-		if (cdev->pm_wake_source)
+		if (cdev->pm_wake_source) {
+			hrtimer_cancel(&cdev->hrtimer);
 			m_can_write(cdev, M_CAN_IE, IR_RF0N);
-		else
+		} else {
 			m_can_stop(ndev);
+		}
 
 		m_can_clk_stop(cdev);
 	}
@@ -2422,6 +2425,13 @@ int m_can_class_resume(struct device *dev)
 			return ret;
 
 		if (cdev->pm_wake_source) {
+			/* Restore active interrupts but disable coalescing as
+			 * we may have missed important waterlevel interrupts
+			 * between suspend and resume. Timers are already
+			 * stopped in suspend. Here we enable all interrupts
+			 * again.
+			 */
+			cdev->active_interrupts |= IR_RF0N | IR_TEFN;
 			m_can_write(cdev, M_CAN_IE, cdev->active_interrupts);
 		} else {
 			ret  = m_can_start(ndev);
-- 
2.43.0



