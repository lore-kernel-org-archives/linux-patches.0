Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE9D21C187;
	Tue, 12 Aug 2025 19:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025912; cv=none; b=iN3l6mvj9YJR7e0uWxq3L5kNGkwHzvsuErl9YPIBHLx4FG0FYkM64t4d4EpF0ehUeY1hD/KzNBtD01ME2yG9bhrzLVeN2PQ9Js0OP5lulXP3FC2+Zn174EsIkzBiGzXz/3Hzezl6J/M/AYcR2LaETt98sMFKBs2B/AQXSGUe6Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025912; c=relaxed/simple;
	bh=xqlo4eIwb6dxN6e/LZ93WIGssKR5JBmALB7xOF/nw1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW6SVhq2aDSbu26EwxXbmzcz3rSMiD07i/rHliGPZ3gcZBzEfPIfYQ1XdOrr9qFFwmxYWtbcUIHQwyEWuXo4o+S3dC7Kl69AYme8MSAE+1AYtvIvTkqammgPCXtYLxDjuXxRPtybIZYYELq2Hm2/Jm3pgwTtQORTFFQUtn00pcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0FseHeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0FseHeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C747C4CEF0;
	Tue, 12 Aug 2025 19:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025911;
	bh=xqlo4eIwb6dxN6e/LZ93WIGssKR5JBmALB7xOF/nw1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0FseHeJtvI18aMsow30AkbzYWoNs/fwKhwtDQF45BiGa8rQZTun94Sv70zOpWpjx
	 jycfAChx/dN8R2sJ1rHADfAC3AFANBzj97Q1YrWO8FPT0m8tituq96gSs3tgdxeOId
	 C9yvSgX+Cfex3z8jhGhDbU8uj/5NWAlyCt92EgDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 180/480] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 12 Aug 2025 19:46:28 +0200
Message-ID: <20250812174404.933838445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 7799455b0403..506523803cc0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3894,6 +3894,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



