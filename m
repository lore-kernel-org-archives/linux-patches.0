Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AF96FAF;
	Tue,  5 Dec 2023 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFTEl7xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9216C433C7;
	Tue,  5 Dec 2023 03:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746668;
	bh=QHSyFHGtWuFY3kuECALoyK/2i2eJnyKD0Ax0caaQEhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFTEl7xBRV9VQhyLp3Xff6U3EVBtSJlgBcWDHwUEeCDjhd1SAk8r3NK+bOlb8q9Vt
	 +WmC1yqq50RQWKQqAe/KbRs8TZS+B8teNzmjUHXdnPoXaytDCrR4pHOE/dg/7lVwkl
	 yhMfcTChzGurKIWmaR1N9xh+Dw1xg9fxuhi6iopg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/134] dpaa2-eth: increase the needed headroom to account for alignment
Date: Tue,  5 Dec 2023 12:15:59 +0900
Message-ID: <20231205031540.967460368@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit f422abe3f23d483cf01f386819f26fb3fe0dbb2b ]

Increase the needed headroom to account for a 64 byte alignment
restriction which, with this patch, we make mandatory on the Tx path.
The case in which the amount of headroom needed is not available is
already handled by the driver which instead sends a S/G frame with the
first buffer only holding the SW and HW annotation areas.

Without this patch, we can empirically see data corruption happening
between Tx and Tx confirmation which sometimes leads to the SW
annotation area being overwritten.

Since this is an old IP where the hardware team cannot help to
understand the underlying behavior, we make the Tx alignment mandatory
for all frames to avoid the crash on Tx conf. Also, remove the comment
that suggested that this is just an optimization.

This patch also sets the needed_headroom net device field to the usual
value that the driver would need on the Tx path:
	- 64 bytes for the software annotation area
	- 64 bytes to account for a 64 byte aligned buffer address

Fixes: 6e2387e8f19e ("staging: fsl-dpaa2/eth: Add Freescale DPAA2 Ethernet driver")
Closes: https://lore.kernel.org/netdev/aa784d0c-85eb-4e5d-968b-c8f74fa86be6@gin.de/
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 15bab41cee48d..774377db0b4bd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1073,14 +1073,12 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	dma_addr_t addr;
 
 	buffer_start = skb->data - dpaa2_eth_needed_headroom(skb);
-
-	/* If there's enough room to align the FD address, do it.
-	 * It will help hardware optimize accesses.
-	 */
 	aligned_start = PTR_ALIGN(buffer_start - DPAA2_ETH_TX_BUF_ALIGN,
 				  DPAA2_ETH_TX_BUF_ALIGN);
 	if (aligned_start >= skb->head)
 		buffer_start = aligned_start;
+	else
+		return -ENOMEM;
 
 	/* Store a backpointer to the skb at the beginning of the buffer
 	 * (in the private data area) such that we can release it
@@ -4967,6 +4965,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_dl_port_add;
 
+	net_dev->needed_headroom = DPAA2_ETH_SWA_SIZE + DPAA2_ETH_TX_BUF_ALIGN;
+
 	err = register_netdev(net_dev);
 	if (err < 0) {
 		dev_err(dev, "register_netdev() failed\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index bfb6c96c3b2f0..834cba8c3a416 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -740,7 +740,7 @@ static inline bool dpaa2_eth_rx_pause_enabled(u64 link_options)
 
 static inline unsigned int dpaa2_eth_needed_headroom(struct sk_buff *skb)
 {
-	unsigned int headroom = DPAA2_ETH_SWA_SIZE;
+	unsigned int headroom = DPAA2_ETH_SWA_SIZE + DPAA2_ETH_TX_BUF_ALIGN;
 
 	/* If we don't have an skb (e.g. XDP buffer), we only need space for
 	 * the software annotation area
-- 
2.42.0



