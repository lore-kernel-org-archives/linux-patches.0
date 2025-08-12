Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AF16BB5B;
	Tue, 12 Aug 2025 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024047; cv=none; b=hrOCn9Qnntxh44g63XVYyPXOT5eJ/fuQjgztCKHYH7hgz4wBPmwnpGE3F9hxZiguIG6WSANwT63NtpXoUVMlRrTwX19hekiXLHe9O6gKpQxQ2pRYdGI061sndMoxX/bM+g3bDwRayzoiaWuQI1ZrL5BcGWnGunk6jOcrr120sO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024047; c=relaxed/simple;
	bh=q6hUYXmFUffVKa1Def1xkf2qPjL5lQ6L8fl1Ptqyk6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUAsg3i6InFpP9bOQqiA2Hio43PGtepVUV222fjJEKYQzx5h69CQ6W0N5VBZeg+jI8+NreWfbohg4GexMYYLW7o/mdqFmsBP/RsR4bbpOVO70tuCbcCyLuJ4USyJxvv5QbhuHmslSWQxqeeExmZQU22vgiU89uB2QQetp7FTAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhAWJeha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhAWJeha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74DAC4CEF1;
	Tue, 12 Aug 2025 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024047;
	bh=q6hUYXmFUffVKa1Def1xkf2qPjL5lQ6L8fl1Ptqyk6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhAWJehaprbqmlluNS5lgPvswFDIfXl9rUU3gwwbebIViAQZ+qirNrfJ6lXpm3FSB
	 xK/iVCjvsMROvhXkHfUboxGEBa/dXZURt+9h3uxfhkPAufl0r2xhLJsB8wPVw2PtVB
	 2FNAWqXV11FrgSOnUy1Rx8AlNALtfwUThS2HFEWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 240/627] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 12 Aug 2025 19:28:55 +0200
Message-ID: <20250812173428.431074029@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 73304a5cf6fc..8aaa59a27bc4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3883,6 +3883,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



