Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938C92F271B;
	Tue, 15 Jul 2025 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587907; cv=none; b=W6fETzxGVnJiCWorgYbScTtEyBdW/Uj5AjljibGboWU5YeEVq/D+snOFtlPsfpCZPWAQ6PDcR4liE1g+qdCOSaEX4oVbVVO7oXYt0LuZO9zTibCh7ZwnyytAvNdGgBO7cUkI/zdNC/8l5SWKW2jYQ5ECQtA6cviTZa0lKHvYnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587907; c=relaxed/simple;
	bh=1f1mpv7G6W4vUTTCfYCszmp42UJXV4lnlyAbBuub4U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwzNkPq0bEwoasd2DyICB7ZU3t9Llneop0j6sdgCxaG7YchM6feLaCYuXZKLBZ9/8FVsm5xYOjw12D5f/ptnZcSEJuhDibIUkzNE4xh16TNrcIsu1jR7AjUbUkswHLdjLeEyBF0mWPKGVFrnlMc6Z51XQbjU6kPIOuGVB3mo2rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ATMtzHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ATMtzHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264C9C4CEF1;
	Tue, 15 Jul 2025 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587907;
	bh=1f1mpv7G6W4vUTTCfYCszmp42UJXV4lnlyAbBuub4U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ATMtzHU+R6uFnm6Nut67eHhJ+m94Elnb3QmcE5lODZPceLLZhxozsXBCnxfyQ4D+
	 BOl2L3yJ6w+87M6ikpH7hPvc6uh/QFVCRiSAVNunZagGOtHZEM2PIpLVhDxFlyMXf5
	 4fv4WWhNanwAB0UiHaHbOHSnauuRLziRijAUXXPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/208] wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()
Date: Tue, 15 Jul 2025 15:14:56 +0200
Message-ID: <20250715130818.444090210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3ef8533205f91..0a7f368f0d99c 100644
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



