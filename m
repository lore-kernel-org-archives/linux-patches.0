Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDF63AA1B2;
	Thu, 15 Jan 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499667; cv=none; b=BLYhnmqcck3Ihf8e8GuYYRhWJ4mT35hVAeQjZZ2itQ2iPTNYaKz/tcqHadxzQHjPPwMi3yZcynw95VAhp5dUBg0Zd+Ktba+ndgx0mJ6zb7iJIWtxt/G4ogNRgWtdI9yu1QrPteeu52rVc4FZeVABEAMv5ybACk1QbBO5ijmUwAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499667; c=relaxed/simple;
	bh=r09wft6PoxxCJZGptvNBzgwX1e/vBmg3RJIe/ciczUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/2MzEKrkRozOog12ORyIO4HZKRLUOXY5WjgLY8vE0fYU7hM+VQgpplWOuZ4ou5BBK5kSypL5YNTW4V3MR5rZuKWuK7E4M8m4U2uPrD1SxZrH+o1+ina/95UnPbw69jgDZybdzzaZMeJI11PWuNgX/wCGVhSrbnP5wZaM7fjZ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLnbd6nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLnbd6nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD938C116D0;
	Thu, 15 Jan 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499667;
	bh=r09wft6PoxxCJZGptvNBzgwX1e/vBmg3RJIe/ciczUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLnbd6nZK2vdXsbPwjz6EX/SOT4ciAG87MmZu0em7UScrggVX5R1YYLGWdcP7wy1u
	 4HVtN9o9WKrRivnFiY1AzNG9VgzuW0MXrAPszyYZz2uubBAtn+unVxemhA9Vx24APv
	 t5aYd/awlTblqrUQzjccrJGEsrUUZVlHkUh8CsIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/451] net: mdio: aspeed: add dummy read to avoid read-after-write issue
Date: Thu, 15 Jan 2026 17:47:56 +0100
Message-ID: <20260115164240.833255406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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



