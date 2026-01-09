Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CC6320CB6;
	Fri,  9 Jan 2026 12:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960737; cv=none; b=rMvF9b4qUcUy0uR/4/0bI4plKkdye134BQil/sMGPLCn8Nbougmu5DLLxzBKzjGv4qZN51tl+9cztz5IrgCWBnWcesKPhURt091gXl00Ql711KDl50QhOQtEQxItBKzig6NZ0f7q6ZTeF/e6029ZnrTOm7IS+MY8WdDfT8zSxQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960737; c=relaxed/simple;
	bh=5AB6rgfgWGIyDKD8nXeAB9a6Ue3hvlbghoS1UxeRsew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/ixPImkI/DiY5kU2zOpNSbPBSfeTFy3WdcsZcZbUfcCCgIcWdP5TPr9L42xO++HFtO7KCsEpTORFWmYuxmt1gNO0dzk5q0epXd34qLFO4eWXDb4/MuflAbJPmtECyyv+EeE75sbzDX5Xxdz7pVZVYbCj3H7zsmXdsc5gsdCUa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alLgB10d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alLgB10d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E29C4CEF1;
	Fri,  9 Jan 2026 12:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960737;
	bh=5AB6rgfgWGIyDKD8nXeAB9a6Ue3hvlbghoS1UxeRsew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alLgB10dwV8VEZEa8hIG24BnlN0MoaLOwoAyYPLNt1zerqMtpk3RIwU5bUV4AVhqW
	 DLeDwU+hKirzXBicLcKoVz6LR7LluYSxMW7OD2wh98tangiJwqv+2fADoxQ9VLdRSS
	 haeJcM4nHONv4iAzQkQ2mfj8SAkt+0mup7dhVU54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 508/737] net: mdio: aspeed: add dummy read to avoid read-after-write issue
Date: Fri,  9 Jan 2026 12:40:47 +0100
Message-ID: <20260109112153.107783702@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c727103c8b05..339198a4dbc0 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -63,6 +63,13 @@ static int aspeed_mdio_op(struct mii_bus *bus, u8 st, u8 op, u8 phyad, u8 regad,
 
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



