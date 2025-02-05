Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174608634E;
	Wed,  5 Feb 2025 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765508; cv=none; b=JxGmu7ygDLj//9eCkB4WQzIM4zbZuE6BTJEuwfFoQqoDGM/iLCFWWhLhFJm59X+6q9+zDORKrwfLbgG5mC/+Znxtq74MRARETmNK7fjijjaf3soHOkc6W0I5kNDfovfNgEG1Urcdpa5yADyRr5zo8t4JcjJlsNhh5uaKtXBN030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765508; c=relaxed/simple;
	bh=ygEuqCIW8OKKmFBEHJkvTsuCxdMU+Q2Mh2gOB5q8ygM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcEG2vCm/g3o+mrqXKpgF1nkN3ZYqu4Pigx4RrjRlsEoVRebddCgbqIVX/082ut+XRclElaUAyeAs7pm9MTnDgGVFmKvWEWMmhnWej5aHgPVSBgtInZFYFUHV6VPB+7dZi7hPvVJgsezv+VxLeSj2LxOcSJZoEskzeBqRmq0A50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vushmXYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vushmXYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A563C4CED1;
	Wed,  5 Feb 2025 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765508;
	bh=ygEuqCIW8OKKmFBEHJkvTsuCxdMU+Q2Mh2gOB5q8ygM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vushmXYT2QZLa2YC3tTXgBoddI0iPXF/C0RidaHsMuxPzqzKX/S7G6PFaZOKNRs8f
	 y2ZFtb5lAdHGs141g7knUNjJhmB0csTJu0TDqdMsFURHUPbapzzorSb/TaEHrAtaIV
	 LutT6oh79ny4r4iEw46M3XV5cMHnzqxUR8Jvyreo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 184/623] wifi: mt76: mt7925: fix the invalid ip address for arp offload
Date: Wed,  5 Feb 2025 14:38:46 +0100
Message-ID: <20250205134503.276120322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 113d469e7e23579a64b0fbb2eadf9228763092be ]

The wrong ieee80211_vif will lead to get invalid ip address and
the correct ieee80211_vif can be obtained from ieee80211_bss_conf.

Fixes: 147324292979 ("wifi: mt76: mt7925: add link handling in the BSS_CHANGED_ARP_FILTER handler")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20241107053005.10558-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index b43617dbd5fde..123a585098e3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -123,10 +123,8 @@ EXPORT_SYMBOL_GPL(mt7925_mcu_regval);
 int mt7925_mcu_update_arp_filter(struct mt76_dev *dev,
 				 struct ieee80211_bss_conf *link_conf)
 {
-	struct ieee80211_vif *mvif = container_of((void *)link_conf->vif,
-						  struct ieee80211_vif,
-						  drv_priv);
 	struct mt792x_bss_conf *mconf = mt792x_link_conf_to_mconf(link_conf);
+	struct ieee80211_vif *mvif = link_conf->vif;
 	struct sk_buff *skb;
 	int i, len = min_t(int, mvif->cfg.arp_addr_cnt,
 			   IEEE80211_BSS_ARP_ADDR_LIST_LEN);
-- 
2.39.5



