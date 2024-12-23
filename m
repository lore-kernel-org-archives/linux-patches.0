Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8978917A5A4;
	Mon, 23 Dec 2024 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969881; cv=none; b=g5GY+XJOuaa31UtkntTI9u1qvYttcL1go58q+NmBDtW3CtSz/SJGJMV8BSkw5pYYmwad8luGM5c83t+qjCqNc9RRn9jN7T8bwoNp7F0UbfF96bV9ZRcO2765J6WCfio51I1cWlLhxmjeHIywRaVFkcShhPAApl4EB3ulrhoKTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969881; c=relaxed/simple;
	bh=K0pNack9YPe0QCdhFnXLupJW/1mUIl6bmaVx/RZ/8MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOGE3kDWkF/oMFo0ztqhUIQDddLJ81A/PEtdIrQPnj5PhdNNd1Xq25yf9rIck8+gsu8Ejoo+KHpsXLr1aBhGqYJPq93fZUc4Mbn4MwKrvIz+C2CoYuz6wvFKunTctSvNEhw1OFuVOhIurTap5QV2bqn3tX4caR2ticdCIvgf5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtN4QgQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtN4QgQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC90DC4CED3;
	Mon, 23 Dec 2024 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969881;
	bh=K0pNack9YPe0QCdhFnXLupJW/1mUIl6bmaVx/RZ/8MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtN4QgQV8KS7kBUOTYW8FrUbH3osNQUF7HK1geNTOAf/71jdzjyl/7QJ7ZsKII/59
	 jr8NQo52YYoiZ0sUf8IC/12jvPk8UUbp8MrmkrnN/Q6EvVRREnpJmpz1JzAO20Jj2T
	 nhaGjgIQ9RjAl8aTyK1PolrSdeZ5FK4I6dT9eRyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/160] net: ethernet: oa_tc6: fix tx skb race condition between reference pointers
Date: Mon, 23 Dec 2024 16:57:42 +0100
Message-ID: <20241223155410.659798529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit e592b5110b3e9393881b0a019d86832bbf71a47f ]

There are two skb pointers to manage tx skb's enqueued from n/w stack.
waiting_tx_skb pointer points to the tx skb which needs to be processed
and ongoing_tx_skb pointer points to the tx skb which is being processed.

SPI thread prepares the tx data chunks from the tx skb pointed by the
ongoing_tx_skb pointer. When the tx skb pointed by the ongoing_tx_skb is
processed, the tx skb pointed by the waiting_tx_skb is assigned to
ongoing_tx_skb and the waiting_tx_skb pointer is assigned with NULL.
Whenever there is a new tx skb from n/w stack, it will be assigned to
waiting_tx_skb pointer if it is NULL. Enqueuing and processing of a tx skb
handled in two different threads.

Consider a scenario where the SPI thread processed an ongoing_tx_skb and
it moves next tx skb from waiting_tx_skb pointer to ongoing_tx_skb pointer
without doing any NULL check. At this time, if the waiting_tx_skb pointer
is NULL then ongoing_tx_skb pointer is also assigned with NULL. After
that, if a new tx skb is assigned to waiting_tx_skb pointer by the n/w
stack and there is a chance to overwrite the tx skb pointer with NULL in
the SPI thread. Finally one of the tx skb will be left as unhandled,
resulting packet missing and memory leak.

- Consider the below scenario where the TXC reported from the previous
transfer is 10 and ongoing_tx_skb holds an tx ethernet frame which can be
transported in 20 TXCs and waiting_tx_skb is still NULL.
	tx_credits = 10; /* 21 are filled in the previous transfer */
	ongoing_tx_skb = 20;
	waiting_tx_skb = NULL; /* Still NULL */
- So, (tc6->ongoing_tx_skb || tc6->waiting_tx_skb) becomes true.
- After oa_tc6_prepare_spi_tx_buf_for_tx_skbs()
	ongoing_tx_skb = 10;
	waiting_tx_skb = NULL; /* Still NULL */
- Perform SPI transfer.
- Process SPI rx buffer to get the TXC from footers.
- Now let's assume previously filled 21 TXCs are freed so we are good to
transport the next remaining 10 tx chunks from ongoing_tx_skb.
	tx_credits = 21;
	ongoing_tx_skb = 10;
	waiting_tx_skb = NULL;
- So, (tc6->ongoing_tx_skb || tc6->waiting_tx_skb) becomes true again.
- In the oa_tc6_prepare_spi_tx_buf_for_tx_skbs()
	ongoing_tx_skb = NULL;
	waiting_tx_skb = NULL;

- Now the below bad case might happen,

Thread1 (oa_tc6_start_xmit)	Thread2 (oa_tc6_spi_thread_handler)
---------------------------	-----------------------------------
- if waiting_tx_skb is NULL
				- if ongoing_tx_skb is NULL
				- ongoing_tx_skb = waiting_tx_skb
- waiting_tx_skb = skb
				- waiting_tx_skb = NULL
				...
				- ongoing_tx_skb = NULL
- if waiting_tx_skb is NULL
- waiting_tx_skb = skb

To overcome the above issue, protect the moving of tx skb reference from
waiting_tx_skb pointer to ongoing_tx_skb pointer and assigning new tx skb
to waiting_tx_skb pointer, so that the other thread can't access the
waiting_tx_skb pointer until the current thread completes moving the tx
skb reference safely.

Fixes: 53fbde8ab21e ("net: ethernet: oa_tc6: implement transmit path to transfer tx ethernet frames")
Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index 4c8b0ca922b7..db200e4ec284 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -113,6 +113,7 @@ struct oa_tc6 {
 	struct mii_bus *mdiobus;
 	struct spi_device *spi;
 	struct mutex spi_ctrl_lock; /* Protects spi control transfer */
+	spinlock_t tx_skb_lock; /* Protects tx skb handling */
 	void *spi_ctrl_tx_buf;
 	void *spi_ctrl_rx_buf;
 	void *spi_data_tx_buf;
@@ -1004,8 +1005,10 @@ static u16 oa_tc6_prepare_spi_tx_buf_for_tx_skbs(struct oa_tc6 *tc6)
 	for (used_tx_credits = 0; used_tx_credits < tc6->tx_credits;
 	     used_tx_credits++) {
 		if (!tc6->ongoing_tx_skb) {
+			spin_lock_bh(&tc6->tx_skb_lock);
 			tc6->ongoing_tx_skb = tc6->waiting_tx_skb;
 			tc6->waiting_tx_skb = NULL;
+			spin_unlock_bh(&tc6->tx_skb_lock);
 		}
 		if (!tc6->ongoing_tx_skb)
 			break;
@@ -1210,7 +1213,9 @@ netdev_tx_t oa_tc6_start_xmit(struct oa_tc6 *tc6, struct sk_buff *skb)
 		return NETDEV_TX_OK;
 	}
 
+	spin_lock_bh(&tc6->tx_skb_lock);
 	tc6->waiting_tx_skb = skb;
+	spin_unlock_bh(&tc6->tx_skb_lock);
 
 	/* Wake spi kthread to perform spi transfer */
 	wake_up_interruptible(&tc6->spi_wq);
@@ -1240,6 +1245,7 @@ struct oa_tc6 *oa_tc6_init(struct spi_device *spi, struct net_device *netdev)
 	tc6->netdev = netdev;
 	SET_NETDEV_DEV(netdev, &spi->dev);
 	mutex_init(&tc6->spi_ctrl_lock);
+	spin_lock_init(&tc6->tx_skb_lock);
 
 	/* Set the SPI controller to pump at realtime priority */
 	tc6->spi->rt = true;
-- 
2.39.5



