Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9762E3AFF;
	Tue, 15 Jul 2025 13:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586057; cv=none; b=PLjqf8cQqSXF1BdmHgdII4bTV/bYixY8xmDZkp7X8LFXqZU8ZQQ2i2Xn0dLIfy1iYU2TScPeSghSae0Sjm3WWRV2AvvCkcJ1oF365crpmBAbo8Z8aipg103HomMg9vFVCRSxNZNcc7WxUdXlhZDVFAbn7g8T9sKSOnItF5EP6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586057; c=relaxed/simple;
	bh=3WchZIK0yDR6Li5PBrbQuvKq1FogV0ZdyUOIULy8pEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgXV/RZ/ueetmAmEIwBT+UWrCAHiV9Epd2nfpc9FTqwVx1zIkuqF87GYr3jqN/5aUq4Y/tyLFwP63ARWfy6daQdJqg70Cfj1UQ6TsPhNkO5+deLvAxEs1/4B5M86kat2NYn4EeFbJEYN7aNRnHu0QlrR7NZ6xGbxfAxnaoBQ6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcitySYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcitySYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4FAC4CEE3;
	Tue, 15 Jul 2025 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586057;
	bh=3WchZIK0yDR6Li5PBrbQuvKq1FogV0ZdyUOIULy8pEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcitySYq6W8kpwU1N7Az7/kBXIJ7PNbeXNbLb1ii3I4sdHBnG3EZKDRlK2J2+DdGn
	 WEJhbf9e/HIy+ge0wpOEO6lrceXM9GzPib+MH15acrxEkvf7Ez9BJpQTurILF4Bcaa
	 d3qP4uSJMy0zFTam9KSBkAjOq4rfWz4IZK7Zecxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/109] wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()
Date: Tue, 15 Jul 2025 15:13:34 +0200
Message-ID: <20250715130802.005419827@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5d534e15a844f..278875c02f41f 100644
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



