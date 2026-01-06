Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD635FF4E;
	Tue,  6 Jan 2026 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721742; cv=none; b=ZRj7bv/qv6e8YgOF3w8YK4msDr/FPDNnkStaHAHtuRXefJ+1spVm13y66Gf7Vzw9hSXrZaaMPsNnf+JUHPY7bVSN9+L0r43qZDOJy+XnunL/pJPZK8IxyPigQazOCaCRHHtOMpIsv3msiJr4LseMgCb55MWtmZDZdaHszx87HLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721742; c=relaxed/simple;
	bh=xWKslqp4rjQmnb6aWlfAX7zogASUghSZnXADOXzAR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWl7dKEphQXEA9eO6wmRNvFD4bnilvUtTSyEtV91HrzQzQFTN5gZjAeidffrMGVMOX3gwNIRwE0HFE4yf0y92XXZkL8nMdx4ye5f7u5KSsEsCMSQvOolWfrpQtqyAR5KSxiYAfin59A0gey4wyRUtYgr+pVxsASDvIOJlom5PxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KszgFjCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KszgFjCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D7BC116C6;
	Tue,  6 Jan 2026 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721741;
	bh=xWKslqp4rjQmnb6aWlfAX7zogASUghSZnXADOXzAR6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KszgFjCYQpr/x9YQETJBtIiR4/CuXopXQf17s1BszQ/+dL0PsdOcJHMjaaFPZR6cy
	 ntnRTVftdS7gM3xK3567f5i/v3gzxqpDMyM/0nBTKumGvLY0ZhOjL8dQHWMKiiNDw9
	 pdwthHkvtR12iMNkZaTAy6ZcsPDCNUoMyVi+waEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Chou <jacky_chou@aspeedtech.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/312] net: mdio: aspeed: add dummy read to avoid read-after-write issue
Date: Tue,  6 Jan 2026 18:01:40 +0100
Message-ID: <20260106170548.803143890@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e55be6dc9ae7..d6b9004c61dc 100644
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



