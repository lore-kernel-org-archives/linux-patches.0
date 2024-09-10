Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A6D18C336;
	Tue, 10 Sep 2024 10:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962904; cv=none; b=dV6n7qvBSQMSltMa5eViGh6g88d8zq5QbAuLQcL6dp2CG9xzrtDD5qwyddefmAHSvMQ7lCQBP5CywlPnPrdyYJPGCd9Odoi8mOUCwABIDsza3RELj3p0vHa5p4L3bsR4GGg24uJ2kyRsEfLVBUBhmAnT9szEt6s1xg4XLDXG4JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962904; c=relaxed/simple;
	bh=BFXJ7edtuQVGvpDgJA05nNtCEQNFhODpE5v5wFjgpDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQNtMai7XdSuqiYjphA2NEUEmC3pVcxuhtDGwrfZ9q0rpLIvaNllPSBTieCAhu45UAGvBAeJhKS3DHEhWmcsE2d9ls9GDGm7ZbRkeOog4kP71O6mW0piDUP9p+Rs7Ck3sUlEK+0L50g8/vd0CFTSeORSAKS3LabBi1wQ58vdg48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbLyuV7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbLyuV7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F795C4CEC3;
	Tue, 10 Sep 2024 10:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962904;
	bh=BFXJ7edtuQVGvpDgJA05nNtCEQNFhODpE5v5wFjgpDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbLyuV7rrTkv4Y0McF4bZyXLcvHBaLmr8Pvw7EJkVedmQI4n8V3Tcxz+RHHsJ1d7S
	 MqCEH6S7+e4vQvOEVRy2pQ9BDhQzn/kBm4RZ/oWcEgCXzI+0NcwFHo2rjHC7bIC7Sb
	 LhbTA3u2m18Iv924jr5heXpl7luoPcx3UQC3BcRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/192] can: m_can: Release irq on error in m_can_open
Date: Tue, 10 Sep 2024 11:31:33 +0200
Message-ID: <20240910092600.844735387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 2de998b98cb5..561f25cdad3f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1815,7 +1815,7 @@ static int m_can_open(struct net_device *dev)
 	/* start the m_can controller */
 	err = m_can_start(dev);
 	if (err)
-		goto exit_irq_fail;
+		goto exit_start_fail;
 
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
@@ -1824,6 +1824,9 @@ static int m_can_open(struct net_device *dev)
 
 	return 0;
 
+exit_start_fail:
+	if (cdev->is_peripheral || dev->irq)
+		free_irq(dev->irq, dev);
 exit_irq_fail:
 	if (cdev->is_peripheral)
 		destroy_workqueue(cdev->tx_wq);
-- 
2.43.0



