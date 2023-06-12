Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E319531
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92224C4339B;
	Mon, 12 Jun 2023 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565973;
	bh=+/WoZ4SinCuwwv4QgeKRaZBwViT40csYoj4zG0zEIxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXnL9rJOkx1J9ZH9hnh/2PtNrN6ZoPRMHaiUthOZObnbu/mN2SxU20BN81Ssbu0rl
	 sv4DfwnkAbXgJ392huw8mTXJT4Zg+VjW99WFjQ67pYTsmaqgr3oq0wuGrwBg/QZ2vc
	 RQv5+d7AdaUqVvkESeBCJeQ51KkGRsTYYmmXepdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 03/68] sfc (gcc13): synchronize ef100_enqueue_skb()s return type
Date: Mon, 12 Jun 2023 12:25:55 +0200
Message-ID: <20230612101658.582584612@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 3319dbb3e755398f254c3daa04b9030197137efe upstream.

ef100_enqueue_skb() generates a valid warning with gcc-13:
  drivers/net/ethernet/sfc/ef100_tx.c:370:5: error: conflicting types for 'ef100_enqueue_skb' due to enum/integer mismatch; have 'int(struct efx_tx_queue *, struct sk_buff *)'
  drivers/net/ethernet/sfc/ef100_tx.h:25:13: note: previous declaration of 'ef100_enqueue_skb' with type 'netdev_tx_t(struct efx_tx_queue *, struct sk_buff *)'

I.e. the type of the ef100_enqueue_skb()'s return value in the declaration is
int, while the definition spells enum netdev_tx_t. Synchronize them to the
latter.

Cc: Martin Liska <mliska@suse.cz>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114440.10461-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ef100_tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -333,7 +333,8 @@ void ef100_ev_tx(struct efx_channel *cha
  * Returns 0 on success, error code otherwise. In case of an error this
  * function will free the SKB.
  */
-int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue,
+			      struct sk_buff *skb)
 {
 	unsigned int old_insert_count = tx_queue->insert_count;
 	struct efx_nic *efx = tx_queue->efx;


