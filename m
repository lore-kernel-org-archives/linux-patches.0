Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FFE28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F99C433F1;
	Mon, 12 Dec 2022 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851786;
	bh=K4h1LllvwlNc1f/xDUX88nq0rFIad23DyAbdzb2zCdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBejRDVXHSSPHpkQp+k1uqgz9OFQcs4S4Mb2wqFv0tvM749wWgJOi5cEJ0D250cwj
	 Xw/4adK85cp8l1SOhiqf4Gg1uSI2BjK0YImit4OwrMkVPBIpc6UXD8KvEc62AsXTFG
	 05JAWaEtP01d93a2r+ZvzAPUhawBjCttPtdsN8M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 070/123] e1000e: Fix TX dispatch condition
Date: Mon, 12 Dec 2022 14:17:16 +0100
Message-Id: <20221212130929.902664786@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

[ Upstream commit eed913f6919e253f35d454b2f115f2a4db2b741a ]

e1000_xmit_frame is expected to stop the queue and dispatch frames to
hardware if there is not sufficient space for the next frame in the
buffer, but sometimes it failed to do so because the estimated maximum
size of frame was wrong. As the consequence, the later invocation of
e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
remained forever, resulting in a watchdog failure.

This change fixes the estimated size by making it match with the
condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
account for the following lines which determines the space requirement
for not causing NETDEV_TX_BUSY:
    ```
    	/* reserve a descriptor for the offload context */
    	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
    		count++;
    	count++;

    	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);
    ```

This issue was found when running http-stress02 test included in Linux
Test Project 20220930 on QEMU with the following commandline:
```
qemu-system-x86_64 -M q35,accel=kvm -m 8G -smp 8
	-drive if=virtio,format=raw,file=root.img,file.locking=on
	-device e1000e,netdev=netdev
	-netdev tap,script=ifup,downscript=no,id=netdev
```

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 407bbb4cc236..7e41ce188cc6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5941,9 +5941,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
-- 
2.35.1



