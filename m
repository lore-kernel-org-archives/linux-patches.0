Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B51D2DE1E2;
	Tue, 12 Aug 2025 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021274; cv=none; b=rVVUgFG0wbh7O/0RB5NHeatgQ2w6BTt/7ADunRiISmAoWGmq7vHD/roCOYOx6qLA7MoiKFNZVgJHmS6PHJDyNO0Wucfw+MTMIBSxn0JNVlv/xuJ2/MT45g4sEXD/E+elCx1NWss+ejCH866SI4p/zjadWGpXcHC7Pdz3dE0pOjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021274; c=relaxed/simple;
	bh=Pzm7RRNGHuUSNDMPkgglskyQdLrIqhps1bRffFS+mz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROqbDb8zpxwan4ziDWDRLS49WcWpUpUW+EhIwM/DbK2PZ5ex+IiCD/8tsQudRJuDsveeS8bqq1dslSJvFSQGt6ehTjkYj/OE3X5P4uAL21/QiZ4Men+MHYFmv+G0ryJ//eAJ8G/jhPMRe5FqCZc28rdc2Elcj5DKTy22Yuv3RUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBB5ra/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBB5ra/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87B7C4CEF0;
	Tue, 12 Aug 2025 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021274;
	bh=Pzm7RRNGHuUSNDMPkgglskyQdLrIqhps1bRffFS+mz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBB5ra/dQR1T/PIj+h6XV4fY8MFH1idIipJCPBSMRBivvw1YcjqGHIY0dJfSd99pu
	 5XLmi2srCIbXy5jaEBjC55d2q1UsnbS3lr7knSRpX6nyAk2jYqw+cXmvE+Vj7kKFqo
	 LlIe6CftuGRupjXp7/Ii+bxwWN3lob+ASzNGtjKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/262] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 12 Aug 2025 19:27:55 +0200
Message-ID: <20250812172956.759225311@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index e4797eb9c2ba..7eddcb6f9645 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3884,6 +3884,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



