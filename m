Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF03859EA;
	Tue, 10 Mar 2026 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141219; cv=none; b=kdkJ88XOSP9mpe0WnQbTj8dQDE7GHcZH8xP1UP0M52e6sb0Ay0SQ9YVT985lNQAmQi1SHoJfwQG9VijhATfsc0yrMznHaaqdDqn+nQf2HGTIRyVmLCMGGQPutgm4vPSh+daQhepQRnzfvh1kgh/A/LXadReLFg2+lLPUYE98VD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141219; c=relaxed/simple;
	bh=fkxiTKcbsPiSAqgE8uqpugt4oyUOwi12Vo0j/AU4jLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShK7ycl52wJEw0cCJ1sAhBi+5fCDsOncrrbOkF2MD3cAx5pu0V0I3wGbQ47u2udjyjqDAaUPaOTAuYw/90uMP7LDxlOUPer6h0og+/cj/tnF0W5Cf0aHuNfrhEzjl3JewMMdhrWGeWrivRe7o8WvZ/xkW5yvdrvaKffzS3HjRS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nb6F+QRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nb6F+QRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5897AC2BC86;
	Tue, 10 Mar 2026 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141218;
	bh=fkxiTKcbsPiSAqgE8uqpugt4oyUOwi12Vo0j/AU4jLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nb6F+QRZtXzR/D7NSCPKjqln2p0q15r7Cg/8KLbCuHPW1K5FUMNyqwBMgRSjVeAnd
	 TvFPRosw2Wn4HNqMK9/lBK1BWs6q1jJ5ec/OJBXBblcDPTn+HUHk58p9NcHyIfeKyg
	 3DC5WkQ6MhLgiOMESg2Ra8XQ746HuO1Kyf8yzdrX/VnTD+5pY52J5aLWMkZ2BNlIQU
	 U+/VKPDX1gbR41/2CCXB0uCvFg/Bc71l4ugRqXeRP6XeapMdxuvm3FKi+VS5nxZXmS
	 ywbRnFRBBuOalJjeqB54An5hTdqbEb9XKJPJdLcqRk/9VgDxeoTb4LFewv4tq2pnRH
	 YISg5Z5OL6YQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alban Bedel <alban.bedel@lht.dlh.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 220/311] can: mcp251x: fix deadlock in error path of mcp251x_open
Date: Tue, 10 Mar 2026 07:04:27 -0400
Message-ID: <f68ebc30611153ddf6c9076ebcde1a6ca2b366d2.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index fa97adf25b734..bb7782582f401 100644
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

