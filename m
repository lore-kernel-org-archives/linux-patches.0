Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09029172BAE;
	Tue, 10 Sep 2024 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964185; cv=none; b=KphNMVHBYIt4Nxzc7OCgK31bpfwSk3q/ZhgbV1ffCaWCdiwoBYEnnq7F+Q8RB/njg9bl/98k0mHVuVEpxdqPHmOxNsANzjZaGjPA+J6tyzfgggVyUf84jtai79ZMle55N9uDDlKww2715LgHpeSnyM9XSo3RTFD7+IlDR+iV1tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964185; c=relaxed/simple;
	bh=wCxwbUfuYgEpxKhnRvrKroVrUDVfyPhacByJOppR0Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czF1cytv4I5vbdw08ID+99x2IPz+VAdZP/d3+Aq7SkjLUoGLeBSQrwkITAFiTVi1vy5FX1qP89k30efc8iMB8m4i7R5LNSffQRepbh5c3cN6TgMDHscLenEKWM/XRXIZica4XWHnjMzNfb7OjbM500iJU187HXjBnhwEQbjNQuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mLbnESd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mLbnESd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8005AC4CEC3;
	Tue, 10 Sep 2024 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964184;
	bh=wCxwbUfuYgEpxKhnRvrKroVrUDVfyPhacByJOppR0Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mLbnESdhLsLlfE/AIZsE1oJDsf3EZidnxt19oMD7RHEl3sRcnXw0uM6ZGhcV6l8L
	 vsCYfVddKub9LLdLk+HeEJpIy47CNNQJaPGPd1Mt7k7glKA9vsNWkS44XEKird87ui
	 P1P9xFWMCAoV+hl5nbTX3YemESphziDtlJDQXqH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/269] can: m_can: Release irq on error in m_can_open
Date: Tue, 10 Sep 2024 11:31:24 +0200
Message-ID: <20240910092611.669578865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 2395b1225cc8..fb77fd74de27 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1871,7 +1871,7 @@ static int m_can_open(struct net_device *dev)
 	/* start the m_can controller */
 	err = m_can_start(dev);
 	if (err)
-		goto exit_irq_fail;
+		goto exit_start_fail;
 
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
@@ -1880,6 +1880,9 @@ static int m_can_open(struct net_device *dev)
 
 	return 0;
 
+exit_start_fail:
+	if (cdev->is_peripheral || dev->irq)
+		free_irq(dev->irq, dev);
 exit_irq_fail:
 	if (cdev->is_peripheral)
 		destroy_workqueue(cdev->tx_wq);
-- 
2.43.0



