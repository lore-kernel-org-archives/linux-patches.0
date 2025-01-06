Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AD91C5F11;
	Mon,  6 Jan 2025 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177036; cv=none; b=lHEdMpDUAt0RFLnyBThiAugGWelYze/E7QlOzcCEiQSVRiHx5TXtO/8Lz9H0mqxZEBjSiwSlfo93hTTm8uyVmiwK6ZBXNsSYyM4Q74+Z6MuRKNvypGEK31vgflm06uS0b6BpOyhYnNsESP7p5RG9PWGjOtzwzcVO5s9+aH+eZpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177036; c=relaxed/simple;
	bh=w40AbZZRDIiNxP3G438UCyKHsgQZAMZ0MO5vsSxmft0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gr3Zua8OxmedqbjHlOhOBYm9/j2Is5+6JkMGnO8rEwj0qpjub9EP7IFqRQziy6C8RsFFOAoC05TuDgxj8YzhiGJiPOeQ7cnaSW0byo8uyVwmBBK/1VIipiBI8KBbGPbPFCeQzRId8XwMUBaOcoSPPOw3DjoH09Hx3WfM7uwfFD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeTt6AGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeTt6AGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC60C4CED2;
	Mon,  6 Jan 2025 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177036;
	bh=w40AbZZRDIiNxP3G438UCyKHsgQZAMZ0MO5vsSxmft0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeTt6AGNpytn5s0PEfPMCxq0eLotgIIUbfoO3k6DCRdOBHbzQy/zshNhkeVi/wUrY
	 2DXI/lwQpMSWCkEU9WEoz7NDOv3HkEA9QJopqXpyWPGYNB0OUmSDw53C6V2MwDqQAV
	 trbwshceJe82Gw5WLc4ZPXFzuDsGpjfdShN4EaZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/222] wifi: mac80211: export ieee80211_purge_tx_queue() for drivers
Date: Mon,  6 Jan 2025 16:13:54 +0100
Message-ID: <20250106151151.743100320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 53bc1b73b67836ac9867f93dee7a443986b4a94f ]

Drivers need to purge TX SKB when stopping. Using skb_queue_purge() can't
report TX status to mac80211, causing ieee80211_free_ack_frame() warns
"Have pending ack frames!". Export ieee80211_purge_tx_queue() for drivers
to not have to reimplement it.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240822014255.10211-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 3e5e4a801aaf ("wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h     | 13 +++++++++++++
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/status.c      |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 47ade676565d..901fe3ac139e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3039,6 +3039,19 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  */
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
 
+/**
+ * ieee80211_purge_tx_queue - purge TX skb queue
+ * @hw: the hardware
+ * @skbs: the skbs
+ *
+ * Free a set of transmit skbs. Use this function when device is going to stop
+ * but some transmit skbs without TX status are still queued.
+ * This function does not take the list lock and the caller must hold the
+ * relevant locks to use it.
+ */
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
+
 /**
  * DOC: Hardware crypto acceleration
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index daea061d0fc1..04c876d78d3b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2057,8 +2057,6 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  u32 info_flags,
 				  u32 ctrl_flags,
 				  u64 *cookie);
-void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
-			      struct sk_buff_head *skbs);
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 44d83da60aee..9676ed15efec 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1270,3 +1270,4 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 	while ((skb = __skb_dequeue(skbs)))
 		ieee80211_free_txskb(hw, skb);
 }
+EXPORT_SYMBOL(ieee80211_purge_tx_queue);
-- 
2.39.5



