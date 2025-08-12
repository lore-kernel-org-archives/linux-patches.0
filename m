Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540722FD1CE;
	Tue, 12 Aug 2025 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020600; cv=none; b=D9GKtXLw3oCbRE6wvohFTH0g59h/+l2lgDW/vX7vEYJxh4TtgS26VzqI27pyjZUGF1mmI+3dVx3ZK1ukWzbq7wsh0df69MffsGkXc1ed5VbULkoegv/kWPLLK3cuj631Cns2z58xoX4K6wCUMWiZO4l5eFzdxdidSC+61wQ48z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020600; c=relaxed/simple;
	bh=t0EuXFfEHT2n9N+LXtDP+7nNg1XSxUMTihMeJ0hn1zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo+Ml3Vv6a2uSReqPAOfZC7sKytpiMkP42yYZPQLzkAq0cKDBUCrjWgN7WYrcpMONBNa01TebNY/j65LG8X6goCXVbnELQjImXPNs8BbjY7u6IsiLvYX7+rFNq8B0n4fADJCep5ZNI2jBuTBHN7I8/hW75DZ3jMIv5iRh/giFbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgTRVuu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgTRVuu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E03C4CEF0;
	Tue, 12 Aug 2025 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020600;
	bh=t0EuXFfEHT2n9N+LXtDP+7nNg1XSxUMTihMeJ0hn1zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgTRVuu7wzzeMHHqMBz/eH0ZMkvXYwzY9TGMCWQxLZf+oVxJVRhWMlJybetbbu8MO
	 nYjMFwhbHfV6UfXd+1cLNfcCYRYsVzMnxLAwxRMn0j2tofLQ1rSbgLpywRJwy9sJ2v
	 uJ1DNSRg8siEI8pIs4w24dYUj4GKPn/X05KRKYPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/253] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 12 Aug 2025 19:28:34 +0200
Message-ID: <20250812172954.059719890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e35a755b353b..e6cf5ab928a6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3807,6 +3807,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



