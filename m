Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7E02DFF25;
	Tue, 17 Jun 2025 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176213; cv=none; b=o94ukc4oZfnzXLfILKx+rq700SWCCy96y2rLwFm5bm/KNZvRJRz+DVt8p/wve5XWRzpQetYvAnHm3eTGmkV5R0ZPDhjp/zo5K7QDQusHC+ufVvwNf7MuHnRaAQqAF1JiZ+bqRfNk6ZWB1mKWkI7eGjovRQ5QX5YEA9j4FsV/6yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176213; c=relaxed/simple;
	bh=AupRZSqwo/9p8xkjLoH32/R7Gm1fp8+PatlfNZ54XsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjYvFof2kwOUYv2CdJwTH41S5wEm45827OvymKKaoT8u7dqLq5YQrngrc8fIVzS+97evfNJg7I0rTPLXYeyQzlHOdbNd+6HQxUpSGP93oix4NBt2tfLodlDu57tEKUft6Xpk/DsE+GF+/ZStsx/GEvejUefDd6tu0hpVv2hQdUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=climbkex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="climbkex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829B6C4CEE7;
	Tue, 17 Jun 2025 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176213;
	bh=AupRZSqwo/9p8xkjLoH32/R7Gm1fp8+PatlfNZ54XsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=climbkexRA8FyV8fkJNIjLsUDcgBXrVemGvGSZ4+OHSPnngnUu6RNV/VO/IE8pFGe
	 PHG2nv6cFJ1CCyTj6H71lY1yyoznLXq7E0zUyqbEYOVDgOSvLMmX2zZ1eYPgK0jnbv
	 4nKRPGibTG+InEwLj3i6wAg4UF/4Fxq2xdUmUFmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/780] wifi: ath12k: Fix memory corruption during MLO multicast tx
Date: Tue, 17 Jun 2025 17:17:53 +0200
Message-ID: <20250617152458.205280891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 6f8a27a584b23e9dedefd6cb110dd2587b84a6d4 ]

The struct sk_buff's control buffer is shared by mac80211's struct
ieee80211_tx_info and ath12k's struct ath12k_skb_cb. When the driver wants
to transmit an skb, it caches all the mac80211-specific information from
struct ieee80211_tx_info, then performs a memset on the control buffer
before writing the ath12k-specific information using struct ath12k_skb_cb.
However, during multicast tx, the key is being filled into the driver data,
which overwrites some crucial members like link_id and flags in struct
ath12k_skb_cb. This causes invalid information retrieval when the driver
accesses these fields during ath12k_dp_tx(). Fix this issue by removing
the key filling logic during MLO multicast tx, as it is not used anywhere
in the tx path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: 2f50de725677 ("wifi: ath12k: Add support for MLO Multicast handling in driver")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Link: https://patch.msgid.link/20250402175714.2667270-1-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index c20fd92000dfe..a1fad297ca357 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -7429,7 +7429,6 @@ static void ath12k_mac_op_tx(struct ieee80211_hw *hw,
 								info_flags);
 
 			skb_cb = ATH12K_SKB_CB(msdu_copied);
-			info = IEEE80211_SKB_CB(msdu_copied);
 			skb_cb->link_id = link_id;
 
 			/* For open mode, skip peer find logic */
@@ -7452,7 +7451,6 @@ static void ath12k_mac_op_tx(struct ieee80211_hw *hw,
 			if (key) {
 				skb_cb->cipher = key->cipher;
 				skb_cb->flags |= ATH12K_SKB_CIPHER_SET;
-				info->control.hw_key = key;
 
 				hdr = (struct ieee80211_hdr *)msdu_copied->data;
 				if (!ieee80211_has_protected(hdr->frame_control))
-- 
2.39.5



