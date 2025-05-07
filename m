Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570A01482F5;
	Wed,  7 May 2025 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644201; cv=none; b=FCdPq5QlXh2TNlPmKIi7pcH93idH2KexfKaBfojn0d1Q0b0YSz7jPu2sYSXtshM/nxXQUu4bmPbg/vgwBKyXFNxazvmasN1LjN06M0902t3FZvSemAvBYM2TlwfCKCiGUSvUAko5Q++ZzL96L7LrbXav4ut2nkADGMGvX5ChsT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644201; c=relaxed/simple;
	bh=k36pJw46zdcFIa8PbqsfVQ2gaqDeKYiNmQvtnuceJ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZSWKzMSmhmZyeHHW/6lxKUJ5ywqgy9SJyFRT44g/p/R+qYZpFE9w+rl9t2abvo99Wu8TGG5OreRLT9aJAsR9M7EXM9L4t1tiSX9372jNn84aIo2MxDF6k2oRSAlCynJWxwsR6p3ZJZ2eTKV+tHl2gamtzCXYaGSeHzlXWzH09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRvnXp0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRvnXp0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABCEC4CEE2;
	Wed,  7 May 2025 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644201;
	bh=k36pJw46zdcFIa8PbqsfVQ2gaqDeKYiNmQvtnuceJ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRvnXp0DBpkClPs/uK1EFJH1xObFozEIhYlRjkNZc/NY0UTvzg2zu5I92QPrWxN3L
	 5RSZa2imM3HWoIEqtkqtKWvbPv8MNRfG5TKT4FZ57AXFRotc1OBAcKbt0lzm5mXMSJ
	 qTP50TgQ+OyqZq+VNh5k+5MiqqSZva/qUns+Cxas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 144/183] net: vertexcom: mse102x: Fix possible stuck of SPI interrupt
Date: Wed,  7 May 2025 20:39:49 +0200
Message-ID: <20250507183830.701646873@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 89dc4c401a8de..92ebf16331598 100644
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



