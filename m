Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0357018FC93;
	Tue, 10 Sep 2024 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963706; cv=none; b=RvPSJr27WjsKhgtwMBKHQRvfVq2rIWPm8Y3Pd0OGJrYw6Cu85a/dBG44p9R/g0Vbts2cz8d5s9hmjdAnxqy0/QKo2t+EsZaGa9rd1tE89Isgwx4jxGNvBc+KJLJibGG0A+i4uWXNUsVpkCgA29chdojU4WgQqh3rd2hWyQj1T8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963706; c=relaxed/simple;
	bh=qUMOLRjn0bPaMN4K5tI9ElL83PTxcGvQSzlk/q+PJME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTrEOCGAvJkMztm5kUKdof84QfL4aySIfRf1anQKgS/nGSjwoq0A2HWTWchZJsOKZ9d9uBALYLRkKK6oulpIBv4co560u7Sgbe+BE0DIe0E2/4AV1uWUfkLjcY6FjiWwSVd3PBVrldjrY0qA6fcx16DDrlr6qSfFsNlGcnSTZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIGZWTvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIGZWTvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767B4C4CEC3;
	Tue, 10 Sep 2024 10:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963705;
	bh=qUMOLRjn0bPaMN4K5tI9ElL83PTxcGvQSzlk/q+PJME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIGZWTvt390cuyvS853YnaBLtEx1gQRD2Xun+YGF42HVrJuIXm48uTrdavLb+jVdp
	 N4pdkx0i8elgnc4Ke3/HQ9l+zMid7tJ4N6c7ZFZCn8Eh22lbUlgxCNf05wMeTnPM47
	 R6ztoJTq5Def+ER7BQElDK9S5j+eD132bZNnHTSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/214] can: m_can: Release irq on error in m_can_open
Date: Tue, 10 Sep 2024 11:32:23 +0200
Message-ID: <20240910092603.717421525@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit 06d4ef3056a7ac31be331281bb7a6302ef5a7f8a ]

It appears that the irq requested in m_can_open() may be leaked
if an error subsequently occurs: if m_can_start() fails.

Address this by calling free_irq in the unwind path for
such cases.

Flagged by Smatch.
Compile tested only.

Fixes: eaacfeaca7ad ("can: m_can: Call the RAM init directly from m_can_chip_config")
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/all/20240805-mcan-irq-v2-1-7154c0484819@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e027229c1955..07f61ee76ca6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1840,7 +1840,7 @@ static int m_can_open(struct net_device *dev)
 	/* start the m_can controller */
 	err = m_can_start(dev);
 	if (err)
-		goto exit_irq_fail;
+		goto exit_start_fail;
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
@@ -1851,6 +1851,9 @@ static int m_can_open(struct net_device *dev)
 
 	return 0;
 
+exit_start_fail:
+	if (cdev->is_peripheral || dev->irq)
+		free_irq(dev->irq, dev);
 exit_irq_fail:
 	if (cdev->is_peripheral)
 		destroy_workqueue(cdev->tx_wq);
-- 
2.43.0



