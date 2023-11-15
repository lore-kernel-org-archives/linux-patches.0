Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED513C461
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkzZx4PQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29F5C433C9;
	Wed, 15 Nov 2023 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077104;
	bh=RV7gg5LYEZGjYqrTPVNX6TE72oeElcdHqlxiFFzW5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkzZx4PQWR1eS/rpqekM5P1mVP6/5ok11xlDJfKTumHdWyFNdr/pKqNhd50I+oktn
	 VxwM4wIN/iIMOlmv/eeAjdLYQh2G6iMdvt7f1mJAe754GpKsI6LKlfr8dzTjTZJOqt
	 94XUkjJrn+fiCmcHg/ogHbj5IdzMUd082nsyPK9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/603] r8152: break the loop when the budget is exhausted
Date: Wed, 15 Nov 2023 14:10:54 -0500
Message-ID: <20231115191620.756367454@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 2cf51f931797d9a47e75d999d0993a68cbd2a560 ]

A bulk transfer of the USB may contain many packets. And, the total
number of the packets in the bulk transfer may be more than budget.

Originally, only budget packets would be handled by napi_gro_receive(),
and the other packets would be queued in the driver for next schedule.

This patch would break the loop about getting next bulk transfer, when
the budget is exhausted. That is, only the current bulk transfer would
be handled, and the other bulk transfers would be queued for next
schedule. Besides, the packets which are more than the budget in the
current bulk trasnfer would be still queued in the driver, as the
original method.

In addition, a bulk transfer wouldn't contain more than 400 packets, so
the check of queue length is unnecessary. Therefore, I replace it with
WARN_ON_ONCE().

Fixes: cf74eb5a5bc8 ("eth: r8152: try to use a normal budget")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Link: https://lore.kernel.org/r/20230926111714.9448-433-nic_swsd@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index afb20c0ed688d..be18d72cefcce 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2543,7 +2543,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		}
 	}
 
-	if (list_empty(&tp->rx_done))
+	if (list_empty(&tp->rx_done) || work_done >= budget)
 		goto out1;
 
 	clear_bit(RX_EPROTO, &tp->flags);
@@ -2559,6 +2559,15 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		struct urb *urb;
 		u8 *rx_data;
 
+		/* A bulk transfer of USB may contain may packets, so the
+		 * total packets may more than the budget. Deal with all
+		 * packets in current bulk transfer, and stop to handle the
+		 * next bulk transfer until next schedule, if budget is
+		 * exhausted.
+		 */
+		if (work_done >= budget)
+			break;
+
 		list_del_init(cursor);
 
 		agg = list_entry(cursor, struct rx_agg, list);
@@ -2578,9 +2587,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			unsigned int pkt_len, rx_frag_head_sz;
 			struct sk_buff *skb;
 
-			/* limit the skb numbers for rx_queue */
-			if (unlikely(skb_queue_len(&tp->rx_queue) >= 1000))
-				break;
+			WARN_ON_ONCE(skb_queue_len(&tp->rx_queue) >= 1000);
 
 			pkt_len = le32_to_cpu(rx_desc->opts1) & RX_LEN_MASK;
 			if (pkt_len < ETH_ZLEN)
@@ -2658,9 +2665,10 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		}
 	}
 
+	/* Splice the remained list back to rx_done for next schedule */
 	if (!list_empty(&rx_queue)) {
 		spin_lock_irqsave(&tp->rx_lock, flags);
-		list_splice_tail(&rx_queue, &tp->rx_done);
+		list_splice(&rx_queue, &tp->rx_done);
 		spin_unlock_irqrestore(&tp->rx_lock, flags);
 	}
 
-- 
2.42.0



