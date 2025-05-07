Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949F221504D;
	Wed,  7 May 2025 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645094; cv=none; b=d0xopY9p4uFm0HkZRgYcdUFK3LWKoTyB42puSSSYmU5F4zsL9u2RhTHnQ4k5QoWfQFepR+lL+Oe+2z8Q9Nu9Tt/TyA+/UhofjjnHlRY4KRmWo9jW0W+YqAmyhfvmwjfD9U/p1fjMwvpml1XPdtKVMerlJdC8eW1r6th6MxzGa/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645094; c=relaxed/simple;
	bh=Qk5tQnWfj0C5QdgcWKjRJ62BSGcGLMmNrjPnxtS2U7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ic8ICL/4r9HMWJPkfBTilvvIyR4AByCTkkkrwy28h1GHzNgJPcWPvA1JfEO8axim8u9xti5ZqIYcXibwPc4eWhgKSuvaKEvIB34jeTRNMbJQW8wCmmevFG/cnEwZIL0vttLvtlcJlIw+LbxCeMkq7s7QgOfYGznC3Laas9ZvkQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQmakYj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQmakYj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2529C4CEE2;
	Wed,  7 May 2025 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645094;
	bh=Qk5tQnWfj0C5QdgcWKjRJ62BSGcGLMmNrjPnxtS2U7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQmakYj3LF01I2kTQqeBDYh0FDvUw0PgI70iMaRv4gadcoHOwbOcSE6ArDQl212oW
	 bdQkq0cOHTCeCuafa91ArWRbfOzodGCFCc8q7qtoeamJPOHrTZWcm25WKSbu3MBxim
	 t8yDslfaCkwtdM6LGm8mOxh/67fm5VVl3MTobwHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/129] net: vertexcom: mse102x: Fix possible stuck of SPI interrupt
Date: Wed,  7 May 2025 20:40:28 +0200
Message-ID: <20250507183817.227157133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 55f362885951b2d00fd7fbb02ef0227deea572c2 ]

The MSE102x doesn't provide any SPI commands for interrupt handling.
So in case the interrupt fired before the driver requests the IRQ,
the interrupt will never fire again. In order to fix this always poll
for pending packets after opening the interface.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 8f67c39f479ee..45f4d2cb5b31a 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -509,6 +509,7 @@ static irqreturn_t mse102x_irq(int irq, void *_mse)
 static int mse102x_net_open(struct net_device *ndev)
 {
 	struct mse102x_net *mse = netdev_priv(ndev);
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
 	int ret;
 
 	ret = request_threaded_irq(ndev->irq, NULL, mse102x_irq, IRQF_ONESHOT,
@@ -524,6 +525,13 @@ static int mse102x_net_open(struct net_device *ndev)
 
 	netif_carrier_on(ndev);
 
+	/* The SPI interrupt can stuck in case of pending packet(s).
+	 * So poll for possible packet(s) to re-arm the interrupt.
+	 */
+	mutex_lock(&mses->lock);
+	mse102x_rx_pkt_spi(mse);
+	mutex_unlock(&mses->lock);
+
 	netif_dbg(mse, ifup, ndev, "network device up\n");
 
 	return 0;
-- 
2.39.5



