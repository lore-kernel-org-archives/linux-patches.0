Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853D229D291;
	Tue, 26 Aug 2025 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215876; cv=none; b=AJgHXELsCv+xNdDjMZBcBC2IR62mtYvEHST7xrNvLdA/3uYnMsOZ+FsuK5lA7n78vvwXD1/DiRV+cHj5/XQUhRuFFyTivxTKsnjW6mGwE6fmYZBcqttHrGrO7TzqYY3PJNL35GtB6sQFDsM5fkmqtCon2nGNwdMLYYCgDQtvLiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215876; c=relaxed/simple;
	bh=wIu1A+KeBCKM/12UgldH4b2nOOfACVINeUI/vYvmSj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYi15ycjugLzqZOPGRScqE0K6ZPOBLceSLkbNEBzCrRint6Cns+ZMeiFVxOCfqXPr5fQKBdpFTBZ0Gy98ygCeLepBlj6rVTafWHg05Bpc094mJuwM3EkTZXu0+/HmA7AZNpmpBb+tEu/v0WUAKjIkTNvNcz5E5l7YCjruKSZegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FI1Fh0ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FI1Fh0ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20F2C4CEF1;
	Tue, 26 Aug 2025 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215876;
	bh=wIu1A+KeBCKM/12UgldH4b2nOOfACVINeUI/vYvmSj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FI1Fh0eiS6agrsQBPjpQ4xZH4s7Ji7GzdHuKlKGibO+6Q46p4OVfvgTPi2v0YJUDc
	 0IJzYS7+WxFMCcidWRo0enco9YYtiyD0FtO2D09cv2md0HgR4fwhU2uix+Ml2vVv6i
	 hc+VnXDeGwi5vdoK30TEIzoiDim0RUG5Fa033b7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/644] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 26 Aug 2025 13:04:09 +0200
Message-ID: <20250826110950.391754632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4ab891c8416d..a5be5fe5c6b4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3711,6 +3711,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



