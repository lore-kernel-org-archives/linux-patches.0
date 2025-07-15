Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893052EB5A0;
	Tue, 15 Jul 2025 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587081; cv=none; b=Xtv5gmll35D9qkX44693joka3pkSVbUgc/OfNTLlvxgYWWSy2W7MbPT0+iQcrWWRChkmXmcCzFI9qiQ7gsV4uLx3ATYRkifZnltPIn27d9jBPCZCRyjnD5BTNcxCx2DP0ttJnAZxobZf6Yus+XKi7p0dD0COVEbqZl3f33K03KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587081; c=relaxed/simple;
	bh=GNQODW5LSyHMt3Rwg04jUXGI7/UdFvJMkim+H3dMUU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHpCTMpwAQ4BkTUu/4tckBUzwqqMR6WLDdDLK/yWC2QIMKPmaVY19iPttKCsuDuS8AtLFtWvboW7VvVoYvBURW/VK1O8C4BCcBP2GkUOcg9ptUwjy4HeJlMFEwPspc2sTrOxB824vpV+Jk2koWbYq83JiPMdKXchO/mebo0tabs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdR1qssV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdR1qssV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC5C4CEE3;
	Tue, 15 Jul 2025 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587081;
	bh=GNQODW5LSyHMt3Rwg04jUXGI7/UdFvJMkim+H3dMUU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdR1qssVkKDr6L4T3PIcbTCb3d3VL5s0PfnvyRH/lvvfXicDWBPa31qa8RZ6TxWuZ
	 NNk0oSPE9Bgq8SN6IsuB6tXKbmRzE5oaXVHIipi08oK/wolXUKeiCcv2Ckz21MzDTv
	 Y43CRW+NciGpT8Yj0h8lfqkeuklAtgVt30BlcJVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 128/192] wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()
Date: Tue, 15 Jul 2025 15:13:43 +0200
Message-ID: <20250715130820.035500340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 74b1ec9f5d627d2bdd5e5b6f3f81c23317657023 ]

There is a potential NULL pointer dereference in zd_mac_tx_to_dev(). For
example, the following is possible:

    	T0			    		T1
zd_mac_tx_to_dev()
  /* len == skb_queue_len(q) */
  while (len > ZD_MAC_MAX_ACK_WAITERS) {

					  filter_ack()
					    spin_lock_irqsave(&q->lock, flags);
					    /* position == skb_queue_len(q) */
					    for (i=1; i<position; i++)
				    	      skb = __skb_dequeue(q)

					    if (mac->type == NL80211_IFTYPE_AP)
					      skb = __skb_dequeue(q);
					    spin_unlock_irqrestore(&q->lock, flags);

    skb_dequeue() -> NULL

Since there is a small gap between checking skb queue length and skb being
unconditionally dequeued in zd_mac_tx_to_dev(), skb_dequeue() can return NULL.
Then the pointer is passed to zd_mac_tx_status() where it is dereferenced.

In order to avoid potential NULL pointer dereference due to situations like
above, check if skb is not NULL before passing it to zd_mac_tx_status().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 459c51ad6e1f ("zd1211rw: port to mac80211")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Link: https://patch.msgid.link/20250626114619.172631-1-d.dulov@aladdin.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index 9653dbaac3c05..781510a3ec6d5 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -583,7 +583,11 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 
 		skb_queue_tail(q, skb);
 		while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS) {
-			zd_mac_tx_status(hw, skb_dequeue(q),
+			skb = skb_dequeue(q);
+			if (!skb)
+				break;
+
+			zd_mac_tx_status(hw, skb,
 					 mac->ack_pending ? mac->ack_signal : 0,
 					 NULL);
 			mac->ack_pending = 0;
-- 
2.39.5



