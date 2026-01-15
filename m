Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE21C3D3311;
	Thu, 15 Jan 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498189; cv=none; b=K8S5ChA11WZBXcj2kM9tBOtQq8UMPb4dj+i8bP8L5jGbHNk0HoPJnO7CmGAg1y7PDF9nhs24okoi2klfKN3Z/QJHE2i11An2ZlkRRSnbllgFZlgvKXfAek0NOtDG2CBrXKb7RBHgOMwqzZi3lZ8RzbfphNnT5iJ9UoyPuin+GKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498189; c=relaxed/simple;
	bh=bwRrVX2PtxeWK9NoFP0iw5U43sV5o2mz+OT5AbIHda0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx5KnU9zB5Qfq8CZkIvo/KlcL22YRPb6i53Vk14mr1dvizU75BwojjkVJBdqxVxRf3woJEvjC9Xd44iqng58/NZYcUywg/kHd7T6QjZTyBuQudIHzz0ie6C/bJo8gRuofFIHBlJmjWzB/Won9BM4bLh5qzi3J1CuUIDNHwyES6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QopqzinT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QopqzinT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C22AC116D0;
	Thu, 15 Jan 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498189;
	bh=bwRrVX2PtxeWK9NoFP0iw5U43sV5o2mz+OT5AbIHda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QopqzinTZcAImNwAmxJs1Mq1p/BHptVD516mERLoYTzaASdy8ejBdQGmCz5lD/fB6
	 RxrfDuT1bDPGQJSknsv/xrhzaXnvmMjQUMD5W0agoNdF9dRyTAP29IvmWMNeqSOJ4B
	 /b8RYItrAuYqeCNg/ZouT1Npm0pc+qLI4AZB+Af8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/554] net: mdio: aspeed: add dummy read to avoid read-after-write issue
Date: Thu, 15 Jan 2026 17:46:49 +0100
Message-ID: <20260115164258.644808978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Chou <jacky_chou@aspeedtech.com>

[ Upstream commit d1a1a4bade4b20c0858d0b2f81d2611de055f675 ]

The Aspeed MDIO controller may return incorrect data when a read operation
follows immediately after a write. Due to a controller bug, the subsequent
read can latch stale data, causing the polling logic to terminate earlier
than expected.

To work around this hardware issue, insert a dummy read after each write
operation. This ensures that the next actual read returns the correct
data and prevents premature polling exit.

This workaround has been verified to stabilize MDIO transactions on
affected Aspeed platforms.

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Signed-off-by: Jacky Chou <jacky_chou@aspeedtech.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251211-aspeed_mdio_add_dummy_read-v3-1-382868869004@aspeedtech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-aspeed.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index f22be2f069e9..a929399a10d1 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -57,6 +57,13 @@ static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
+	/* Workaround for read-after-write issue.
+	 * The controller may return stale data if a read follows immediately
+	 * after a write. A dummy read forces the hardware to update its
+	 * internal state, ensuring that the next real read returns correct data.
+	 */
+	ioread32(ctx->base + ASPEED_MDIO_CTRL);
+
 	return readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
 				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
 				ASPEED_MDIO_INTERVAL_US,
-- 
2.51.0



