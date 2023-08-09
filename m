Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E21171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7C5C433C8;
	Wed,  9 Aug 2023 10:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578738;
	bh=uV45xLpK5Qq4q0FfiZ+9HpKMAuYVCKcqq+Oyat4qdcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yONno9S3DKjT0Kc1z1/buRy3YP1OEyoigzN6PJjBmTyq1W1guhyUdtXwM0HpYsOl8
	 BiOdNVB6gDP2PuXuMAbCmVyVioIDazYgMEm++Lls0iiclPHheTQIJaITJ5NSnNMuZC
	 cor+0YXm7K349MyAVWVxqjUZy1OoS1LRiSvXZSsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/92] mISDN: hfcpci: Fix potential deadlock on &hc->lock
Date: Wed,  9 Aug 2023 12:40:58 +0200
Message-ID: <20230809103634.377894282@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 56c6be35fcbed54279df0a2c9e60480a61841d6f ]

As &hc->lock is acquired by both timer _hfcpci_softirq() and hardirq
hfcpci_int(), the timer should disable irq before lock acquisition
otherwise deadlock could happen if the timmer is preemtped by the hadr irq.

Possible deadlock scenario:
hfcpci_softirq() (timer)
    -> _hfcpci_softirq()
    -> spin_lock(&hc->lock);
        <irq interruption>
        -> hfcpci_int()
        -> spin_lock(&hc->lock); (deadlock here)

This flaw was found by an experimental static analysis tool I am developing
for irq-related deadlock.

The tentative patch fixes the potential deadlock by spin_lock_irq()
in timer.

Fixes: b36b654a7e82 ("mISDN: Create /sys/class/mISDN")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Link: https://lore.kernel.org/r/20230727085619.7419-1-dg573847474@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index eba58b99cd29d..d6cf01c32a33d 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -839,7 +839,7 @@ hfcpci_fill_fifo(struct bchannel *bch)
 		*z1t = cpu_to_le16(new_z1);	/* now send data */
 		if (bch->tx_idx < bch->tx_skb->len)
 			return;
-		dev_kfree_skb(bch->tx_skb);
+		dev_kfree_skb_any(bch->tx_skb);
 		if (get_next_bframe(bch))
 			goto next_t_frame;
 		return;
@@ -895,7 +895,7 @@ hfcpci_fill_fifo(struct bchannel *bch)
 	}
 	bz->za[new_f1].z1 = cpu_to_le16(new_z1);	/* for next buffer */
 	bz->f1 = new_f1;	/* next frame */
-	dev_kfree_skb(bch->tx_skb);
+	dev_kfree_skb_any(bch->tx_skb);
 	get_next_bframe(bch);
 }
 
@@ -1119,7 +1119,7 @@ tx_birq(struct bchannel *bch)
 	if (bch->tx_skb && bch->tx_idx < bch->tx_skb->len)
 		hfcpci_fill_fifo(bch);
 	else {
-		dev_kfree_skb(bch->tx_skb);
+		dev_kfree_skb_any(bch->tx_skb);
 		if (get_next_bframe(bch))
 			hfcpci_fill_fifo(bch);
 	}
@@ -2277,7 +2277,7 @@ _hfcpci_softirq(struct device *dev, void *unused)
 		return 0;
 
 	if (hc->hw.int_m2 & HFCPCI_IRQ_ENABLE) {
-		spin_lock(&hc->lock);
+		spin_lock_irq(&hc->lock);
 		bch = Sel_BCS(hc, hc->hw.bswapped ? 2 : 1);
 		if (bch && bch->state == ISDN_P_B_RAW) { /* B1 rx&tx */
 			main_rec_hfcpci(bch);
@@ -2288,7 +2288,7 @@ _hfcpci_softirq(struct device *dev, void *unused)
 			main_rec_hfcpci(bch);
 			tx_birq(bch);
 		}
-		spin_unlock(&hc->lock);
+		spin_unlock_irq(&hc->lock);
 	}
 	return 0;
 }
-- 
2.40.1



