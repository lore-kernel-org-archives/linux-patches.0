Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECB01A3029;
	Tue, 21 Oct 2025 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076939; cv=none; b=WJiwgYyiWq0wvbx9xPmSbrCN69+GJMbQXYx4zXBsKwGG2XDCuIB0AnUtJfHkCjmV0T1eTdWl7iEiuKDkGnm4K4nZJVOH4V4Raz9XZbIUGbE3bLpz4mOCiivxe+loZwUezuhmFKz6s3y3+8UPrK3M0gCN7UdAxL0a/21TVHfeGic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076939; c=relaxed/simple;
	bh=0Cha19oi7uYxl/aLu1xqRzFIJGFCa5TVaS9M1HP6qVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+5HU+kDyFt8C5LvQENHHGfqNKLMC3obBeSeSRINZH2+rVvHSMJZjUUQvhBqq+NHiUDbpjWNfoXlJ3YGoXDvdgpdCB0p8d+s3j8b/Ao/WFnOOKyhmivU4X/SvInofkbmFFSd7uJgABalS/7qjwXFtAmLSO2t6qF1yXU0ul71f0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKkXfpb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKkXfpb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BECDC4CEF1;
	Tue, 21 Oct 2025 20:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076939;
	bh=0Cha19oi7uYxl/aLu1xqRzFIJGFCa5TVaS9M1HP6qVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKkXfpb5RfefveFBgBqYcjNqQjthGLDNO7AMTruMmNrp8XBH7F40gEsJk2pNKOAD9
	 xVAV48k9+AhrCCizJAr7/freSua5GNN8Hfa3ZwVeYk19W9RtZ/5egqoTx2bzJReblC
	 7PIyEsEwtDTECm5ir0svXMgjK16kLDTTSJGq/t/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/136] can: m_can: add deinit callback
Date: Tue, 21 Oct 2025 21:50:36 +0200
Message-ID: <20251021195037.140009925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit baa8aaf79768b72eb7a181c476ca0291613f59e6 ]

This is added in preparation for calling standby mode in the tcan4x5x
driver or other users of m_can.
For the tcan4x5x; If Vsup 12V, standby mode will save 7-8mA, when the
interface is down.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20241122-tcan-standby-v3-1-90bafaf5eccd@geanix.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: a9e30a22d6f2 ("can: m_can: fix CAN state in system PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 7 +++++++
 drivers/net/can/m_can/m_can.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a7e326faca8ca..249263fca748d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1796,6 +1796,13 @@ static void m_can_stop(struct net_device *dev)
 
 	/* set the state as STOPPED */
 	cdev->can.state = CAN_STATE_STOPPED;
+
+	if (cdev->ops->deinit) {
+		ret = cdev->ops->deinit(cdev);
+		if (ret)
+			netdev_err(dev, "failed to deinitialize: %pe\n",
+				   ERR_PTR(ret));
+	}
 }
 
 static int m_can_close(struct net_device *dev)
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index ef39e8e527ab6..bd4746c63af3f 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -68,6 +68,7 @@ struct m_can_ops {
 	int (*write_fifo)(struct m_can_classdev *cdev, int addr_offset,
 			  const void *val, size_t val_count);
 	int (*init)(struct m_can_classdev *cdev);
+	int (*deinit)(struct m_can_classdev *cdev);
 };
 
 struct m_can_tx_op {
-- 
2.51.0



