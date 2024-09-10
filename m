Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767C1917C6;
	Tue, 10 Sep 2024 09:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961673; cv=none; b=iDBtSx2Alw7AyJEQxqDyQjnqcLBwNLNOB4c8QE6j11CMBzndN9qNdPSfWX0rT0/34t6vllgg0pRRiDrCwfk+ENKyVIgnstHm3h9wk8OwTXSlMiSFMpAH9vEnUevmn6lY0RF800yoCTvEnRQphAUSTmP5B+nlLE5apYrYtqBT6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961673; c=relaxed/simple;
	bh=c8RO6qmwh+xytvg9R3weqCAE/qTelDs4+xUhwgtSa0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfzKLNh31D+IBrOwciUuofa6n2tmPkoUpsjDuOOLFdzOKUE5/TvWkA74HzvyB8YY34X090OrxsHqW7EpJWfHuZGBKiPUr2abTGLO+LI+KESF/9LDUtl++uL/hWCdagSNKYNZrAls6oQy1gJ1QTEDS5lJPUkdslngWqWZtw8FIsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIgQzbnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIgQzbnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98A1C4CEC3;
	Tue, 10 Sep 2024 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961673;
	bh=c8RO6qmwh+xytvg9R3weqCAE/qTelDs4+xUhwgtSa0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIgQzbnbaPMlVu/+C+7j8sa8PaYwm87atqizteEpd+/QU/u3yYMdJtkvW71YwYVMI
	 rCVsV+jGgseYnQqqmQRgaRpWtgmWD0njXBpOVEFvW59FObvdCA0T8JAXFX6FfEH6Gj
	 LRtrrIMYaUv0UT+0O592trs5rYRiCoJ7b9R1r5m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/375] can: m_can: Remove m_can_rx_peripheral indirection
Date: Tue, 10 Sep 2024 11:29:07 +0200
Message-ID: <20240910092627.504493127@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 40e4552eeef0e3090a5988de15889795936fd38f ]

m_can_rx_peripheral() is a wrapper around m_can_rx_handler() that calls
m_can_disable_all_interrupts() on error. The same handling for the same
error path is done in m_can_isr() as well.

So remove m_can_rx_peripheral() and do the call from m_can_isr()
directly.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-4-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 4d5159bfafa8 ("can: m_can: Do not cancel timer from within timer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index dba1788f7fbb..2d73fa7f8258 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1003,22 +1003,6 @@ static int m_can_rx_handler(struct net_device *dev, int quota, u32 irqstatus)
 	return work_done;
 }
 
-static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
-{
-	struct m_can_classdev *cdev = netdev_priv(dev);
-	int work_done;
-
-	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, irqstatus);
-
-	/* Don't re-enable interrupts if the driver had a fatal error
-	 * (e.g., FIFO read failure).
-	 */
-	if (work_done < 0)
-		m_can_disable_all_interrupts(cdev);
-
-	return work_done;
-}
-
 static int m_can_poll(struct napi_struct *napi, int quota)
 {
 	struct net_device *dev = napi->dev;
@@ -1216,7 +1200,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		} else {
 			int pkts;
 
-			pkts = m_can_rx_peripheral(dev, ir);
+			pkts = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, ir);
 			if (pkts < 0)
 				goto out_fail;
 		}
-- 
2.43.0



