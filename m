Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A12C2EAE6;
	Mon, 23 Dec 2024 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969781; cv=none; b=GbWZ0HHBQxChIMhKhiGKQ6joDKjGhi8p/LknO9VvfXPtsMO7pleUtEkm8/AeyyGPOIZ3a01sOs6/P+qLxNu5Yq7Jw8/2157NJ9A8RGhi3S2A63OJm5ryB7Jm9HfSHNNQzvaAxK3MVX4LKY58EQWBIqw90d65+6AItmcw/scYq24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969781; c=relaxed/simple;
	bh=5K8EAGzEFVzZknOfYPc+xQAK4kKr8mIBAW7waa6sOcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogT/1TFOy1CMzeJy8QzyxV5735ijzCt8BHtatyA18Ojbre53WsUHko1GekdkjIlmi5/zeZ01w3cjumOgqQMUSavNs2mb/vxR61nKj/1w9psDqKF4C5Xb7IQIY60Q5ysSwFlueYmQoKS2r7s9Xj9IzLKC+/6z3ra4E7w2OiIfRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzTHSIxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzTHSIxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A912C4CED3;
	Mon, 23 Dec 2024 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969781;
	bh=5K8EAGzEFVzZknOfYPc+xQAK4kKr8mIBAW7waa6sOcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzTHSIxx8w+FFWKyssYpobg9RMtPvcW2croHtCBJXm5DYP5aeZahBQHlzIU01/5E1
	 XomF7EiLaP/BY94MgXhgVDPPZJS411Jt39m1/VXFgqixckb9tZWNOIxiNKRgimhgO8
	 do/Sx43OtvAEgwu82+I2/CjKXSCLDAlR7RhLyeP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/160] can: m_can: set init flag earlier in probe
Date: Mon, 23 Dec 2024 16:57:45 +0100
Message-ID: <20241223155410.772144101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit fca2977629f49dee437e217c3fc423b6e0cad98c ]

While an m_can controller usually already has the init flag from a
hardware reset, no such reset happens on the integrated m_can_pci of the
Intel Elkhart Lake. If the CAN controller is found in an active state,
m_can_dev_setup() would fail because m_can_niso_supported() calls
m_can_cccr_update_bits(), which refuses to modify any other configuration
bits when CCCR_INIT is not set.

To avoid this issue, set CCCR_INIT before attempting to modify any other
configuration flags.

Fixes: cd5a46ce6fa6 ("can: m_can: don't enable transceiver when probing")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/e247f331cb72829fcbdfda74f31a59cbad1a6006.1728288535.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 533bcb77c9f9..67c404fbe166 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1695,6 +1695,14 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 		return -EINVAL;
 	}
 
+	/* Write the INIT bit, in case no hardware reset has happened before
+	 * the probe (for example, it was observed that the Intel Elkhart Lake
+	 * SoCs do not properly reset the CAN controllers on reboot)
+	 */
+	err = m_can_cccr_update_bits(cdev, CCCR_INIT, CCCR_INIT);
+	if (err)
+		return err;
+
 	if (!cdev->is_peripheral)
 		netif_napi_add(dev, &cdev->napi, m_can_poll);
 
@@ -1746,11 +1754,7 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 		return -EINVAL;
 	}
 
-	/* Forcing standby mode should be redundant, as the chip should be in
-	 * standby after a reset. Write the INIT bit anyways, should the chip
-	 * be configured by previous stage.
-	 */
-	return m_can_cccr_update_bits(cdev, CCCR_INIT, CCCR_INIT);
+	return 0;
 }
 
 static void m_can_stop(struct net_device *dev)
-- 
2.39.5



