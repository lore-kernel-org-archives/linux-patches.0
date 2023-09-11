Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D0A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E5BC433C7;
	Mon, 11 Sep 2023 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444637;
	bh=xEcQg/SANat2oDqK17MSvNUiZtMCzUqgGty0ITivR6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaLDu3tDXc3/gNR8BvgXpUI2mnVJVd3/vT1EbzKBUHcFstKQ6EMo5TZrAeUP6QZ5g
	 cHTveWBMRvt9Zn35l48tIM4gYvbAKQHUo2DT2RO54NsD9Lm0U6mTzK7nPwrViv/zUE
	 Ldn9gW+CyY5nC0bPnARgMP23p/g+YVCVzF0vmRVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/600] wifi: mac80211: Use active_links instead of valid_links in Tx
Date: Mon, 11 Sep 2023 15:41:36 +0200
Message-ID: <20230911134635.483904282@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 7b3b9ac899b54f53f7c9fc07e1c562f56b2187fa ]

Fix few places on the Tx path where the valid_links were used instead
of active links.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230608163202.e24832691fc8.I9ac10dc246d7798a8d26b1a94933df5668df63fc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 763cefd0cc268..2f9e1abdf375d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4391,7 +4391,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
 				       struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	unsigned long links = sdata->vif.valid_links;
+	unsigned long links = sdata->vif.active_links;
 	unsigned int link;
 	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
 
@@ -5827,7 +5827,7 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 
 		if (WARN_ON_ONCE(link == ARRAY_SIZE(sdata->vif.link_conf)))
-			link = ffs(sdata->vif.valid_links) - 1;
+			link = ffs(sdata->vif.active_links) - 1;
 	}
 
 	IEEE80211_SKB_CB(skb)->control.flags |=
@@ -5863,7 +5863,7 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 		band = chanctx_conf->def.chan->band;
 	} else {
 		WARN_ON(link_id >= 0 &&
-			!(sdata->vif.valid_links & BIT(link_id)));
+			!(sdata->vif.active_links & BIT(link_id)));
 		/* MLD transmissions must not rely on the band */
 		band = 0;
 	}
-- 
2.40.1



