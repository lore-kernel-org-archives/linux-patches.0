Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0C15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQo8JaNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3128EC433C7;
	Mon, 23 Oct 2023 11:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060966;
	bh=Oqy30A7LiXtonQhsj0yqSaUOQyOKc6ccUcOI6igwjZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQo8JaNYk3jQdvRJAMIVfk8cF2mQQ9ecoizYjCL1fygAUJYBT0FxORd/+oA/gKb3A
	 kfAgslQM/FpbwsNt0yGxi+NKZ+iFT0Ro2NjamqMaf/NxxamP3qxBImINOeak4r76GT
	 VSTYPPF5g06C016QPhCahGB/wZbcAoJnW3+FvsVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Manish Chopra <manishc@marvell.com>
Subject: [PATCH 5.15 029/137] qed: fix LL2 RX buffer allocation
Date: Mon, 23 Oct 2023 12:56:26 +0200
Message-ID: <20231023104821.991112082@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Chopra <manishc@marvell.com>

commit 2f3389c73832ad90b63208c0fc281ad080114c7a upstream.

Driver allocates the LL2 rx buffers from kmalloc()
area to construct the skb using slab_build_skb()

The required size allocation seems to have overlooked
for accounting both skb_shared_info size and device
placement padding bytes which results into the below
panic when doing skb_put() for a standard MTU sized frame.

skbuff: skb_over_panic: text:ffffffffc0b0225f len:1514 put:1514
head:ff3dabceaf39c000 data:ff3dabceaf39c042 tail:0x62c end:0x566
dev:<NULL>
…
skb_panic+0x48/0x4a
skb_put.cold+0x10/0x10
qed_ll2b_complete_rx_packet+0x14f/0x260 [qed]
qed_ll2_rxq_handle_completion.constprop.0+0x169/0x200 [qed]
qed_ll2_rxq_completion+0xba/0x320 [qed]
qed_int_sp_dpc+0x1a7/0x1e0 [qed]

This patch fixes this by accouting skb_shared_info and device
placement padding size bytes when allocating the buffers.

Cc: David S. Miller <davem@davemloft.net>
Fixes: 0a7fb11c23c0 ("qed: Add Light L2 support")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -87,7 +87,10 @@ static void qed_ll2b_complete_tx_packet(
 static int qed_ll2_alloc_buffer(struct qed_dev *cdev,
 				u8 **data, dma_addr_t *phys_addr)
 {
-	*data = kmalloc(cdev->ll2->rx_size, GFP_ATOMIC);
+	size_t size = cdev->ll2->rx_size + NET_SKB_PAD +
+		      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	*data = kmalloc(size, GFP_ATOMIC);
 	if (!(*data)) {
 		DP_INFO(cdev, "Failed to allocate LL2 buffer data\n");
 		return -ENOMEM;
@@ -2548,7 +2551,7 @@ static int qed_ll2_start(struct qed_dev
 	INIT_LIST_HEAD(&cdev->ll2->list);
 	spin_lock_init(&cdev->ll2->lock);
 
-	cdev->ll2->rx_size = NET_SKB_PAD + ETH_HLEN +
+	cdev->ll2->rx_size = PRM_DMA_PAD_BYTES_NUM + ETH_HLEN +
 			     L1_CACHE_BYTES + params->mtu;
 
 	/* Allocate memory for LL2.


