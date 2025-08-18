Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3089E2C235D;
	Mon, 18 Aug 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525500; cv=none; b=KUKvbTqbkRcSaIemA4ATeU3OdWRZu5KePXU6fW9At0kvxc4iEatWQloKZ+4i6shaeuOj7x74xdPN7VYHAXo6cyj8892TKtNM9q4v/zccT6XwJVLYk17nTChZWu7m/PW0q+qj5mTv2S7JmDO/DPUTRzrHBllvP1GwPxvZuql0B9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525500; c=relaxed/simple;
	bh=0u695So/c/otXT2p0jnrRoKyLQYL28MznKLchnpP6OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIO0DNXRjmO+zrl6JWo7spVG0OpZjyLx8/Tg+zOFWNpeEFZFjc5B4VC1jI8lmGA6gEE/mXkiWhPjF8HeZY+bnaYOQdLszY4WMUAVRsyM+Ux9BORfoB+FuEE4g0COVNtHXOBmLJdpEkgo/Si/sBit1FvVJ8VZmIn2RkzBnbz2FRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFeAf7tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFeAf7tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7508C4CEEB;
	Mon, 18 Aug 2025 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525500;
	bh=0u695So/c/otXT2p0jnrRoKyLQYL28MznKLchnpP6OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFeAf7tOWK4/gPGXWuG4l/sW353qCnFUxDRzLblSaMrEZ7WA7QaFZuDjLd7L1CxQW
	 lVFYm6A7RleHNUEGqY/egdq/TYIbxnYJoSu7sY98dS/eMx3mFYwNx4gnLCIAxtxRXd
	 ndLYf3nbwAro9aEUCqBTjpOfvr19VHXNtLn1083Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	zhangjianrong <zhangjianrong5@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 282/570] net: thunderbolt: Enable end-to-end flow control also in transmit
Date: Mon, 18 Aug 2025 14:44:29 +0200
Message-ID: <20250818124516.707689365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhangjianrong <zhangjianrong5@huawei.com>

[ Upstream commit a8065af3346ebd7c76ebc113451fb3ba94cf7769 ]

According to USB4 specification, if E2E flow control is disabled for
the Transmit Descriptor Ring, the Host Interface Adapter Layer shall
not require any credits to be available before transmitting a Tunneled
Packet from this Transmit Descriptor Ring, so e2e flow control should
be enabled in both directions.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/20250624153805.GC2824380@black.fi.intel.com
Signed-off-by: zhangjianrong <zhangjianrong5@huawei.com>
Link: https://patch.msgid.link/20250628093813.647005-1-zhangjianrong5@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/thunderbolt/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 0a53ec293d04..643cf67840b5 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -924,8 +924,12 @@ static int tbnet_open(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-	ring = tb_ring_alloc_tx(xd->tb->nhi, -1, TBNET_RING_SIZE,
-				RING_FLAG_FRAME);
+	flags = RING_FLAG_FRAME;
+	/* Only enable full E2E if the other end supports it too */
+	if (tbnet_e2e && net->svc->prtcstns & TBNET_E2E)
+		flags |= RING_FLAG_E2E;
+
+	ring = tb_ring_alloc_tx(xd->tb->nhi, -1, TBNET_RING_SIZE, flags);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Tx ring\n");
 		return -ENOMEM;
@@ -944,11 +948,6 @@ static int tbnet_open(struct net_device *dev)
 	sof_mask = BIT(TBIP_PDF_FRAME_START);
 	eof_mask = BIT(TBIP_PDF_FRAME_END);
 
-	flags = RING_FLAG_FRAME;
-	/* Only enable full E2E if the other end supports it too */
-	if (tbnet_e2e && net->svc->prtcstns & TBNET_E2E)
-		flags |= RING_FLAG_E2E;
-
 	ring = tb_ring_alloc_rx(xd->tb->nhi, -1, TBNET_RING_SIZE, flags,
 				net->tx_ring.ring->hop, sof_mask,
 				eof_mask, tbnet_start_poll, net);
-- 
2.39.5



