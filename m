Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7135957;
	Mon, 23 Mar 2026 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279326; cv=none; b=JUsHise0t12aXPWtCnYBBqjQoYJUvXfHts9Ve4N++4jfv4GuRDE2bJ8/Mc/566fHIH7ihbvMm0YGJKthcOlxKaGx4lreYi1xNzMN6M9Btgw6u6sNoOQrdcLm4nQj1A3Lume4j6LYgkniJ57gx5aPIQGUOtTuqbIH+m6U3HYwBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279326; c=relaxed/simple;
	bh=p2kOCfh1DPQzbUABEUlvTNWn6fgSOncVPYDtTyuDpQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYqOKX6nDL4Sav8Ihjub7NDcp5xeWkuKMiydWPNInAl43y+RnhArlDEQf6tdoree/DEpCNqBcjCUfIcQOhJWBJs2LOYOaYXLHR4pUCyDP0vkkLG8axxY1Z1wmSQZEKu8GbUdmw6ZIpVeA8ddJsczFwpp4Cxsw40ZzxSVuDXjy2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNCJx3yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNCJx3yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DB2C4CEF7;
	Mon, 23 Mar 2026 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279326;
	bh=p2kOCfh1DPQzbUABEUlvTNWn6fgSOncVPYDtTyuDpQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNCJx3yFiP1cUG+MWtOXoizo20H3CsV80NhLx7hDcx3mhoU7LZZWOUzPN75DvGQBO
	 8Q3fP8Zz7xTiv0015FKksqdBAqIW04zVVvXxoCfPN3HQ0i14uNxb/YsGmqF+8fHos3
	 Y77VhkpKs+bPxNlE41xtHIseMZYH3qsgdXVjX3/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Hammad Ijaz <mhijaz@amazon.com>,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 546/567] net: mvpp2: guard flow control update with global_tx_fc in buffer switching
Date: Mon, 23 Mar 2026 14:47:46 +0100
Message-ID: <20260323134547.514918957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Muhammad Hammad Ijaz <mhijaz@amazon.com>

[ Upstream commit 8a63baadf08453f66eb582fdb6dd234f72024723 ]

mvpp2_bm_switch_buffers() unconditionally calls
mvpp2_bm_pool_update_priv_fc() when switching between per-cpu and
shared buffer pool modes. This function programs CM3 flow control
registers via mvpp2_cm3_read()/mvpp2_cm3_write(), which dereference
priv->cm3_base without any NULL check.

When the CM3 SRAM resource is not present in the device tree (the
third reg entry added by commit 60523583b07c ("dts: marvell: add CM3
SRAM memory to cp11x ethernet device tree")), priv->cm3_base remains
NULL and priv->global_tx_fc is false. Any operation that triggers
mvpp2_bm_switch_buffers(), for example an MTU change that crosses
the jumbo frame threshold, will crash:

  Unable to handle kernel NULL pointer dereference at
  virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000096000006
    EC = 0x25: DABT (current EL), IL = 32 bits
  pc : readl+0x0/0x18
  lr : mvpp2_cm3_read.isra.0+0x14/0x20
  Call trace:
   readl+0x0/0x18
   mvpp2_bm_pool_update_fc+0x40/0x12c
   mvpp2_bm_pool_update_priv_fc+0x94/0xd8
   mvpp2_bm_switch_buffers.isra.0+0x80/0x1c0
   mvpp2_change_mtu+0x140/0x380
   __dev_set_mtu+0x1c/0x38
   dev_set_mtu_ext+0x78/0x118
   dev_set_mtu+0x48/0xa8
   dev_ifsioc+0x21c/0x43c
   dev_ioctl+0x2d8/0x42c
   sock_ioctl+0x314/0x378

Every other flow control call site in the driver already guards
hardware access with either priv->global_tx_fc or port->tx_fc.
mvpp2_bm_switch_buffers() is the only place that omits this check.

Add the missing priv->global_tx_fc guard to both the disable and
re-enable calls in mvpp2_bm_switch_buffers(), consistent with the
rest of the driver.

Fixes: 3a616b92a9d1 ("net: mvpp2: Add TX flow control support for jumbo frames")
Signed-off-by: Muhammad Hammad Ijaz <mhijaz@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Link: https://patch.msgid.link/20260316193157.65748-1-mhijaz@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index aabc39f7690f8..410c9dea4fa2e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5012,7 +5012,7 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 	if (priv->percpu_pools)
 		numbufs = port->nrxqs * 2;
 
-	if (change_percpu)
+	if (change_percpu && priv->global_tx_fc)
 		mvpp2_bm_pool_update_priv_fc(priv, false);
 
 	for (i = 0; i < numbufs; i++)
@@ -5037,7 +5037,7 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 			mvpp2_open(port->dev);
 	}
 
-	if (change_percpu)
+	if (change_percpu && priv->global_tx_fc)
 		mvpp2_bm_pool_update_priv_fc(priv, true);
 
 	return 0;
-- 
2.51.0



