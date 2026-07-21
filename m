Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6487B47125C;
	Tue, 21 Jul 2026 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656488; cv=none; b=pcNo80T4D0dBasYibSW1abFspueqcJeg0hZeAxaFciajpLlXWimmzc3Ruv8e04IoTlHG7HD9wFGKKPFkiW2KX8/CsTf3arW3UE54N2b3QK4Ce7jFp2UclxMHTRSI6zxr3yAghOp+MzVE5+jzdxeLNs59ASOWgPEQ6niRGV3dAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656488; c=relaxed/simple;
	bh=gglIFX05zGxDosLIKKX+KHvMDDLsc9v71gYhOV5ffGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDB7R5j/3h8TFfKRfm94gBmbTklOZp0u4nNH7qfKKqe9ZjRJ0VQnEiD1jsPsZvMFGYCT/PoNksT7+MbpRuQuwXdwF4onPUnPdsKNAAqMzHrfWamGszASW6mCJLpT+HewUuezV7X8CShXj5arSUcvhN6+k1xKdlTb1KvJkXLPebU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3ZM+/KM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3ZM+/KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7CB1F000E9;
	Tue, 21 Jul 2026 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656487;
	bh=RilGO+V3xY9YL77stfHkf4kW/kVUH7A66OHucSfLX5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3ZM+/KMqniV/GpO8FXXwXKbKmoD/YGmgMMbANHPR5ZQzcBUBzurWHqL+72sx5png
	 uTRIcCF0/1R9JckqEJgVbLwCzmtZWfUWyeA9DqnnHqtdrITQAMOk2CTOfXJPixvCFv
	 XXSy+BBhORWQNfyJlI9x9/SMGOs2mxPrdLrs9xOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0405/1611] wifi: mt76: mt792x: skip MLD header rewrite for 802.3 encap TX
Date: Tue, 21 Jul 2026 17:08:41 +0200
Message-ID: <20260721152524.352585526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit a1152244702bb31b64650e5ca8308142286c0e4a ]

mt792x_tx() rewrites addr1/addr2/addr3 by treating skb->data as
an 802.11 header for MLD traffic.

That is only valid for native 802.11 frames. Direct 802.3 TX can also
reach this path with IEEE80211_TX_CTL_HW_80211_ENCAP set, where
skb->data is not an 802.11 header.

Skip the MLD header rewrite for HW-encap packets to avoid corrupting
802.3 frame contents.

Fixes: ebb1406813c6 ("wifi: mt76: mt7925: add link handling to txwi")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260425144648.734030-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index a5bdccae92c5bd..96c50a501c1a96 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -105,7 +105,8 @@ void mt792x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		wcid = &mvif->sta.deflink.wcid;
 	}
 
-	if (vif && control->sta && ieee80211_vif_is_mld(vif)) {
+	if (vif && control->sta && ieee80211_vif_is_mld(vif) &&
+	    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 		struct ieee80211_link_sta *link_sta;
 		struct ieee80211_bss_conf *conf;
-- 
2.53.0



