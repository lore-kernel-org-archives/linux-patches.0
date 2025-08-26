Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F2352090;
	Tue, 26 Aug 2025 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217356; cv=none; b=J94qNE9ZhRQBZZwQjE6Zym2dvGZe6CY9MDl+wJV5Youwz6zki7yghfK1PbKJ16HaSV3RcYiLC894tlFwGWxOmNwu/yKrSoZ/N8LwGgikwkvpTBKJR3WuiC+V2EjTIOkkH/t8Uk7oo9eGxCYA0iZVxLyAu5De3QaL2R1R8ic0d5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217356; c=relaxed/simple;
	bh=F9ErLuh+RvHo9CEWM4RQWzN8Mh/Aqo3hnsW3+uDXx1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx3kaYpcsnu7uhH34mKUcB80yFG9OPpCvqzJrA8zhDjexRvbaJ2jfs8zosd05lnn1NIOIzHXKcQZXeNJ9UDW3iLOv0VHD2PdV0IWQZdS0Aq2WMNaBEuFhKfb7PR35v4lIhdB+shdDpLKX1R8B5AqZDjO4EUCqQUSF023ogt2asg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7U19bZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7U19bZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16714C16AAE;
	Tue, 26 Aug 2025 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217356;
	bh=F9ErLuh+RvHo9CEWM4RQWzN8Mh/Aqo3hnsW3+uDXx1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7U19bZy3+kTChVvZVdDorfQYJRDGl4tRkoXOcOr8mhdRSCuTtSzm7Q3M6yRn5fhy
	 Y7JifeT6MPrMfkshGSlSOs2xt/V1+jO5z0AkgfMMycr8DuWbujcPLR1sy9Cw/6iGIX
	 jnXK7IhWg7XtHivLaxb8ZfG437grp3m5GKiNpyew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/523] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 26 Aug 2025 13:05:23 +0200
Message-ID: <20250826110927.313012255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
index 509ea77dc2bb..30ad46cfcad8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3697,6 +3697,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



