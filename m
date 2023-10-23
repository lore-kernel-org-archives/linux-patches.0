Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5933614A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6QeqeQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7947C433C7;
	Mon, 23 Oct 2023 11:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059124;
	bh=a0w98Fuq2HnAtQAp/AIYQYmguwtnvTUHbu8GjDM/+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6QeqeQAR9aMnaz+R1Au1+ANWEOe5tC0J+0Tj0an9XnOcDQ6Eo0GOeW3BCr0lW6LU
	 dS26izyx4CzzqGDyn3p4dHh09JjDPjCketj5voYikw5cFd88c1aeyq+Jzpn42tpOAs
	 t78P+NcbMSh9Ffeo+SItnm0KRUB3xkwQegBXdqGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinas Rasheed <srasheed@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 072/241] octeon_ep: update BQL sent bytes before ringing doorbell
Date: Mon, 23 Oct 2023 12:54:18 +0200
Message-ID: <20231023104835.649539996@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shinas Rasheed <srasheed@marvell.com>

commit a0ca6b9dfef0b3cc83aa8bb485ed61a018f84982 upstream.

Sometimes Tx is completed immediately after doorbell is updated, which
causes Tx completion routing to update completion bytes before the
same packet bytes are updated in sent bytes in transmit function, hence
hitting BUG_ON() in dql_completed(). To avoid this, update BQL
sent bytes before ringing doorbell.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Link: https://lore.kernel.org/r/20231017105030.2310966-1-srasheed@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -715,20 +715,19 @@ static netdev_tx_t octep_start_xmit(stru
 		hw_desc->dptr = tx_buffer->sglist_dma;
 	}
 
-	/* Flush the hw descriptor before writing to doorbell */
-	wmb();
-
-	/* Ring Doorbell to notify the NIC there is a new packet */
-	writel(1, iq->doorbell_reg);
+	netdev_tx_sent_queue(iq->netdev_q, skb->len);
+	skb_tx_timestamp(skb);
 	atomic_inc(&iq->instr_pending);
 	wi++;
 	if (wi == iq->max_count)
 		wi = 0;
 	iq->host_write_index = wi;
+	/* Flush the hw descriptor before writing to doorbell */
+	wmb();
 
-	netdev_tx_sent_queue(iq->netdev_q, skb->len);
+	/* Ring Doorbell to notify the NIC there is a new packet */
+	writel(1, iq->doorbell_reg);
 	iq->stats.instr_posted++;
-	skb_tx_timestamp(skb);
 	return NETDEV_TX_OK;
 
 dma_map_sg_err:


