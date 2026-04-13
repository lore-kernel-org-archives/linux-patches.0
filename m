Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9593223E342;
	Mon, 13 Apr 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098743; cv=none; b=Gmv7/zGDMXcbOzUOEihin5Tt+Co80OQxUoIk8d/o4TzUoNH0z0JPNCmomZyaVhKBnHdcF9TDXkWzDAlutBkZxVvDr/E7Eo3Oe4njRL7oaQL8H1+GhLkz2hg+MrGbKvW2SHvfGtc6wN5S7sOKaBlhTdKwi0pMwzPqnyuvQaiWD48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098743; c=relaxed/simple;
	bh=nx4I5fuD9WvWDqtSt8ywOeLisfKBKl1GhWu+CfMD9+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smhHZcfFInTZ7qncjK0cfMqxU2yTdXOflfA1WzeRdfD80K3AwcgNVKrtFtvI0ilBg6/4/vsDN/MBeWO1N4lSi7JonpuxcBxMM9av//g7YqkmqiohcdKz6eaigbh5H7lfxcF245YUtbfE2kmoqqnt28idsOXUPpWnLn78uzYL93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P90ifz95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P90ifz95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E948BC2BCAF;
	Mon, 13 Apr 2026 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098743;
	bh=nx4I5fuD9WvWDqtSt8ywOeLisfKBKl1GhWu+CfMD9+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P90ifz95KaB6klFoAdr/YAvn0itkm/0SXVEbttPrX3tHv3IiZqf8Mvvt11yjUcdZe
	 8jZX062do3S3iSbJrGLrIOBH+hg1ZJfyjw+zE9L/OQnCr63KC7VrEcEUIefqH5KZ0d
	 elFE6RrGzbO7upAUF47rkDw+p5NUmkV3BkPK1UNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/491] can: mcp251x: fix deadlock in error path of mcp251x_open
Date: Mon, 13 Apr 2026 17:54:44 +0200
Message-ID: <20260413155820.516750511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 88d065718e990..b06b15debafac 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1207,6 +1207,7 @@ static int mcp251x_open(struct net_device *net)
 {
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
+	bool release_irq = false;
 	unsigned long flags = 0;
 	int ret;
 
@@ -1252,12 +1253,24 @@ static int mcp251x_open(struct net_device *net)
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



