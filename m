Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7C2135B8;
	Tue, 26 Aug 2025 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218694; cv=none; b=CMPjQS7Uusd94lDlnJeH8ATKJHzhTd9RfGdZKWtMa5TaRf/4FQjEtnAG5ZQBr9XZFxybFq2n+E7JJAV91ewzJfB6Co/FCjhC22WWYBUcNiKWh1FjfjekBTyuaTIz/FmsFtvbFUeHMsLMjNKvApqT/3nxIg3VUmMcoeDzurUzs94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218694; c=relaxed/simple;
	bh=pFGHkjGbVWF30TV3A8KNkXMisIM6Cy9wqO4vT+H0Mps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROali9AVSzZEF6WH9bbrtEXF0ZVpi4ONKlfynAl0whdMi+02/E6PhiG06C9UcvtbwEGI2UiVnwZQbmr3HSe1fZOityd8AxcCJGeK1dI4pP3TKp2tf0ahA5OnHlVpDB6yfETWBiw2vQdPnYmpMoRHFSoYBzE1JA5L3KbkF4nDmzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrhRwiIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrhRwiIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B52C4CEF1;
	Tue, 26 Aug 2025 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218694;
	bh=pFGHkjGbVWF30TV3A8KNkXMisIM6Cy9wqO4vT+H0Mps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrhRwiILC3KgDcGvL8vuPBCW0WxNl8cqG3V+gTBD3NnUY7XLuGBKQKV7j2Hb/Ba+C
	 TVSdfcVLfP0Kte5L/c7VRr5WXvSeXnPZXY2G8uh7vXijvK+3EejnHMIHSlgywBR6Zu
	 nLoY2KPHgrbtc4st3IGCD3WkKzDd4tiX7yCq36xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/403] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 26 Aug 2025 13:07:04 +0200
Message-ID: <20250826110909.381604948@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 754fe848b3b297fc85ec24cd959bad22b6df8cb8 ]

This reverts commit 0937cb5f345c ("Revert "wifi: mac80211: Update
skb's control block key in ieee80211_tx_dequeue()"").

This commit broke TX with 802.11 encapsulation HW offloading, now that
this is fixed, reapply it.

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/66b8fc39fb0194fa06c9ca7eeb6ffe0118dcb3ec.1752765971.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 461cff7b94ad..f8d72f3e4def 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3661,6 +3661,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



