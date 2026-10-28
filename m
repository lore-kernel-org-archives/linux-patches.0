Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214878;
	b=dNxI8+MzG4M1nx4FpTxTrOpNwaqZPGMoHvAurZ7Ol9iUmpM9wIScKtH5AfC0yvWTC1Yr
	 8Wo53JfDg3A/75zAnBzWlckA65oGfq3KfcbGdI/Z4b5UtuhV2+ast5SI9Ww4lqoMa95vs
	 EEQXKhEHDYRRb5k9j0SB0uWrap3/Mj0GvBbxRJ2cuoB+7ZVCIPw07BPWI6O+WTgS6OIvC
	 uvDyb4zWqqQ+NnO8DVnmDPJk5TBc6G0Tsxqvo4F4jk7y/IFAuYDYFpdmlafzNoblC6oZ4
	 F9l4jhOy2Zm2pT5srcOTMmZOhJs6dZyzJSY5b621K72N7962SsEYDgy+8MAf3BRxpaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/uW7WFm2b7L08msGnMuIya51wCMMtGPMQvUe2jOw804=;
	b=DpS3cL8/SbAXpfKWgkTfjvLQ9Hzhlc7YSgpwHW9YSO7dXXmTgLdzwIathZBnsSl/Va2Z
	 Y6Gi61bCI1rMrhQ7+ik6hi/V9SGRBQfp4xD0pLSlvAOM4DsfoWp5GgGeXzJdKrCKwfw2x
	 oxBByCTaNMWZdXOmUf7l+6Kmt6CyLP+BvlNDuzHfFY2TFXXGm+jUesaLIsdLvxYD0492b
	 5VsN0wy2IFMO4WC6RiIV7z3Yrcc+uwiVCH6vJrwc7+eIYWNufc9NkLizR27o6IRI7yTrl
	 IoMTvreq9s6OMZfy9ZNyaVmUOwmrAGomMwYjUhyGIeyDy7Ef/ReuIGYonGzMsIq2fRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vhMV1vV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93349606A337;
	Wed, 28 Oct 2026 19:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vhMV1vV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4E91F01825;
	Wed, 28 Oct 2026 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214878;
	bh=/uW7WFm2b7L08msGnMuIya51wCMMtGPMQvUe2jOw804=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vhMV1vVk8ll0Y0qfOAUtOJ8wo0OGe5Xq+QMaopURttqlseGYaqFmc+2+anpJ/pBp
	 UklvvG9FEnvOXXVCN/JWKOMbjpCJ2p4GujrgSEbS4CFRpk65eywtc7LGTiOrzsqUlW
	 q+x+o+V0A7h7QeRquPa+VJ/lG29jzVcGUl9s+Rx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1014/1887] i3c: mipi-i3c-hci: Fix race in DMA ring dequeue
Date: Wed, 28 Oct 2026 17:51:50 +0100
Message-ID: <20261028170522.492186865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1dca8aee80eea76d2aae21265de5dd64f6ba0f09 ]

The HCI DMA dequeue path (hci_dma_dequeue_xfer()) may be invoked for
multiple transfers that timeout around the same time.  However, the
function is not serialized and can race with itself.

When a timeout occurs, hci_dma_dequeue_xfer() stops the ring, processes
incomplete transfers, and then restarts the ring.  If another timeout
triggers a parallel call into the same function, the two instances may
interfere with each other - stopping or restarting the ring at unexpected
times.

Add a mutex so that hci_dma_dequeue_xfer() is serialized with respect to
itself.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 2 ++
 drivers/i3c/master/mipi-i3c-hci/dma.c  | 2 ++
 drivers/i3c/master/mipi-i3c-hci/hci.h  | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 3c5ce4a64f808..b9a6073499ee2 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -751,6 +751,8 @@ static int i3c_hci_probe(struct platform_device *pdev)
 	if (IS_ERR(hci->base_regs))
 		return PTR_ERR(hci->base_regs);
 
+	mutex_init(&hci->control_mutex);
+
 	platform_set_drvdata(pdev, hci);
 	/* temporary for dev_printk's, to be replaced in i3c_master_register */
 	hci->master.dev.init_name = dev_name(&pdev->dev);
diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 7b13508ccca66..60da4be20c5f2 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -450,6 +450,8 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	bool did_unqueue = false;
 	u32 ring_status;
 
+	guard(mutex)(&hci->control_mutex);
+
 	ring_status = rh_reg_read(RING_STATUS);
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
diff --git a/drivers/i3c/master/mipi-i3c-hci/hci.h b/drivers/i3c/master/mipi-i3c-hci/hci.h
index f109923f6c3f3..39490bc9f84f6 100644
--- a/drivers/i3c/master/mipi-i3c-hci/hci.h
+++ b/drivers/i3c/master/mipi-i3c-hci/hci.h
@@ -43,6 +43,7 @@ struct i3c_hci {
 	const struct hci_io_ops *io;
 	void *io_data;
 	const struct hci_cmd_ops *cmd;
+	struct mutex control_mutex;
 	atomic_t next_cmd_tid;
 	u32 caps;
 	unsigned int quirks;
-- 
2.53.0



