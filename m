Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137632143E;
	Mon, 27 Oct 2025 19:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593177; cv=none; b=UPY7wZD+7ATfrsDHD26X1rYCRDCx4Z4nnLBMdmzrtoWf5uA/uQ4XEKZiuNMRk0KscLXwoTIHLqO9EYQ8sXkRwTCNpZjQ+cI9GFFrLHzZvGzRso4x4z6LzE8OsvAq61oaf3gI2unDnvL9j7jYBHswoQDZJNXgbW1h8j9PaQX7ydQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593177; c=relaxed/simple;
	bh=+z1CAQeIpH2kPNgtlx5t/4tF+W2q4/STWEm9o5lN9iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzQANrwLec+jGHuW7PCgM5Fk6VlDWgXDH2rgbVNgBMMsEu+7ctMxdcTmsXI2F0PG+Q3rzsf7iBv6wu5+JES3Dv2JIuy5lXut6jKUD1j9WA1O31Yn7Jyh83n26sq18dR3a516tNguzRufb/Vf0ZB0mZH4WLOlqY/2clSXlbq09TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX9eKvXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX9eKvXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC189C4CEF1;
	Mon, 27 Oct 2025 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593177;
	bh=+z1CAQeIpH2kPNgtlx5t/4tF+W2q4/STWEm9o5lN9iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xX9eKvXPl6+n0jGTloU0jxOQkJsrPWA3qydn89z0GBZQBo6nY+15t3XVOiQqwyehW
	 n9H/JwagKDbVtvGXOW+nMB1oMDiHdKQvaSYh5nNKNGBD02OuBAE3xCvutpNcyzbPz0
	 I0ys6F3eKdm5Q6RTqwNl7EiD650f1COn873794yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 043/184] can: esd: acc_start_xmit(): use can_dev_dropped_skb() instead of can_dropped_invalid_skb()
Date: Mon, 27 Oct 2025 19:35:25 +0100
Message-ID: <20251027183516.066788852@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 0bee15a5caf36fe513fdeee07fd4f0331e61c064 ]

In addition to can_dropped_invalid_skb(), the helper function
can_dev_dropped_skb() checks whether the device is in listen-only mode and
discards the skb accordingly.

Replace can_dropped_invalid_skb() by can_dev_dropped_skb() to also drop
skbs in for listen-only mode.

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/all/20251017-bizarre-enchanted-quokka-f3c704-mkl@pengutronix.de/
Fixes: 9721866f07e1 ("can: esd: add support for esd GmbH PCIe/402 CAN interface family")
Link: https://patch.msgid.link/20251017-fix-skb-drop-check-v1-2-556665793fa4@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/esd/esdacc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
index c80032bc1a521..73e66f9a3781c 100644
--- a/drivers/net/can/esd/esdacc.c
+++ b/drivers/net/can/esd/esdacc.c
@@ -254,7 +254,7 @@ netdev_tx_t acc_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	u32 acc_id;
 	u32 acc_dlc;
 
-	if (can_dropped_invalid_skb(netdev, skb))
+	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
 
 	/* Access core->tx_fifo_tail only once because it may be changed
-- 
2.51.0



