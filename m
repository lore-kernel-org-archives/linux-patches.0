Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD3C63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4259DC4339B;
	Mon, 20 Feb 2023 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901322;
	bh=z7CVH4gpagHqH1tipKfy2zj+P7bI1FWVqU3HebUaByI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVShTsCj/PuIBCnhFue2D/ym7dX1L2eg/Z1gLHYzvNbYSp2J0DsKWxbVFq70U/6mP
	 trPY4/SuEW38gN7MXL+FzUANqOB07hLExVX6Wb1DGkrNeu5Z+QW2O4QJaJv9xZXG7P
	 037qKVw+kHUYZ1RsJk+p+iPkv6KD6nEeKEC1Wlzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 5.10 31/57] ixgbe: allow to increase MTU to 3K with XDP enabled
Date: Mon, 20 Feb 2023 14:36:39 +0100
Message-Id: <20230220133550.441586416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

commit f9cd6a4418bac6a046ee78382423b1ae7565fb24 upstream.

Recently I encountered one case where I cannot increase the MTU size
directly from 1500 to a much bigger value with XDP enabled if the
server is equipped with IXGBE card, which happened on thousands of
servers in production environment. After applying the current patch,
we can set the maximum MTU size to 3K.

This patch follows the behavior of changing MTU as i40e/ice does.

[1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
[2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6729,6 +6729,18 @@ static void ixgbe_free_all_rx_resources(
 }
 
 /**
+ * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @adapter: device handle, pointer to adapter
+ */
+static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
+{
+	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
+		return IXGBE_RXBUFFER_2K;
+	else
+		return IXGBE_RXBUFFER_3K;
+}
+
+/**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
  * @new_mtu: new value for maximum frame size
@@ -6739,18 +6751,13 @@ static int ixgbe_change_mtu(struct net_d
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->xdp_prog) {
+	if (ixgbe_enabled_xdp_adapter(adapter)) {
 		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
 				     VLAN_HLEN;
-		int i;
-
-		for (i = 0; i < adapter->num_rx_queues; i++) {
-			struct ixgbe_ring *ring = adapter->rx_ring[i];
 
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
-				e_warn(probe, "Requested MTU size is not supported with XDP\n");
-				return -EINVAL;
-			}
+		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
+			e_warn(probe, "Requested MTU size is not supported with XDP\n");
+			return -EINVAL;
 		}
 	}
 


