Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF97B2FFDF7;
	Tue, 10 Mar 2026 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142152; cv=none; b=KQbtmLnvPCUftV7LeJU4vgaSEY/yy9+uDhj0E3YunwL4eLOcVVzw6zim/jnQo/m2x0WRdh9wrDANmluUy6acgD7BJ3uMvUoI/HQFsXtxr5413dahBhji5A2w8xjNYHyKoBnXngrOjFWBnWwHM0wuV+crW18m6jlScWPeKlX/+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142152; c=relaxed/simple;
	bh=aNVA/xl+P5kNgSXY4oTnfEGExlKafQ9T53Xqdvay7jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs34Cm94oPemh2aE38psSj9kb2alAhl2wKL3HSY4IqScFqItrNmEIwvFJ7VgCeyQ8JE4EPnFKYqtnz3xSxp7uKust334zHyqi9D7nijyI9Ia6OVu9pYjYefaXjOQz8Aft/gswzCP+8PJCvR611MtgUctB6NP5XPgsGcnVEhLM2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdzxT1CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdzxT1CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A4C19423;
	Tue, 10 Mar 2026 11:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142152;
	bh=aNVA/xl+P5kNgSXY4oTnfEGExlKafQ9T53Xqdvay7jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdzxT1CUSMgkZ5RucPUDkjRqbfzjcg7HqGgxc5vSRd8W1tq9ZXIZw67z0jURs6C4m
	 BW8CqKB6wvA+E+01rp7bQ94h4FiuWia3gXbvGUSIeg2x78+H8qxvVFcR9T2O6XSIxD
	 /QMEBU1lxd/9IEsjiCqPB2O6zMvSqkyA2r6mg2m1Ij68Ryx+94wRepxFomGIYuR6i6
	 ePHFBSNx+Kwh+u9MiP+AkiVDH09NJy83yOg/QH0eQfraJY+eY8mnIlqlbp/AobLgNR
	 OHngRP1SF6hiOX6AX+bWl2TzYaMtbraB/MJGfGR7ayFvk8dk2jymXQ5TIV8CWe1gSV
	 Aokz4jfx3bUPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alban Bedel <alban.bedel@lht.dlh.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/314] can: mcp251x: fix deadlock in error path of mcp251x_open
Date: Tue, 10 Mar 2026 07:18:19 -0400
Message-ID: <a92e72d5214a64ce2a4407c80c457b256f0c4cd2.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit ab3f894de216f4a62adc3b57e9191888cbf26885 ]

The mcp251x_open() function call free_irq() in its error path with the
mpc_lock mutex held. But if an interrupt already occurred the
interrupt handler will be waiting for the mpc_lock and free_irq() will
deadlock waiting for the handler to finish.

This issue is similar to the one fixed in commit 7dd9c26bd6cf ("can:
mcp251x: fix deadlock if an interrupt occurs during mcp251x_open") but
for the error path.

To solve this issue move the call to free_irq() after the lock is
released. Setting `priv->force_quit = 1` beforehand ensure that the IRQ
handler will exit right away once it acquired the lock.

Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20260209144706.2261954-1-alban.bedel@lht.dlh.de
Fixes: bf66f3736a94 ("can: mcp251x: Move to threaded interrupts instead of workqueues.")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index b797e08499d70..b46262e791301 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1214,6 +1214,7 @@ static int mcp251x_open(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
+	bool release_irq = false;
 	unsigned long flags = 0;
 	int ret;
 
@@ -1257,12 +1258,24 @@ static int mcp251x_open(struct net_device *net)
 	return 0;
 
 out_free_irq:
-	free_irq(spi->irq, priv);
+	/* The IRQ handler might be running, and if so it will be waiting
+	 * for the lock. But free_irq() must wait for the handler to finish
+	 * so calling it here would deadlock.
+	 *
+	 * Setting priv->force_quit will let the handler exit right away
+	 * without any access to the hardware. This make it safe to call
+	 * free_irq() after the lock is released.
+	 */
+	priv->force_quit = 1;
+	release_irq = true;
+
 	mcp251x_hw_sleep(spi);
 out_close:
 	mcp251x_power_enable(priv->transceiver, 0);
 	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
+	if (release_irq)
+		free_irq(spi->irq, priv);
 	return ret;
 }
 
-- 
2.51.0

