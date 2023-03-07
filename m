Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E6FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE7BC433EF;
	Tue,  7 Mar 2023 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209362;
	bh=hi2VpWytuZfHF9xBNOLtFWOO7ClSa6tJaMqoauKp9IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9Q0u5wAI23FDZI/+TWA0XVPNHTfbOyJUUnLVM5gUFAvNRfZuYyx5JU2F/zKCMbuy
	 9fROMANdsALW759xcOwu77kIMREhuceusd3r1YWh9gEwmhL03DdD5yyPS9BZOxZU2k
	 FCAoW4x8P0W2ZeEpPRwTBe6TfABmR0F6EQf5I2oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0152/1001] wifi: iwlegacy: common: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Tue,  7 Mar 2023 17:48:44 +0100
Message-Id: <20230307170028.654037250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0c1528675d7a9787cb516b64d8f6c0f6f8efcb48 ]

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. So replace dev_kfree_skb() with
dev_consume_skb_irq() under spin_lock_irqsave(). Compile tested only.

Fixes: 4bc85c1324aa ("Revert "iwlwifi: split the drivers for agn and legacy devices 3945/4965"")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207144013.70210-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 341c17fe2af4d..96002121bb8b2 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5174,7 +5174,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5293,7 +5293,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-- 
2.39.2



