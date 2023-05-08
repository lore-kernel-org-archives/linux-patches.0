Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63820168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EBAC433D2;
	Mon,  8 May 2023 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542392;
	bh=EsVrH5BxzEcLj+iQ8nVxglINIowhKorUFAm17R01TT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShJRq6MepFf47U0vBmWnBUOZdaq8y6fS5gW5y4NTdp15V+lrL59BIZRziqewp5+wI
	 NXbclp/rH/nGh5klb9ejadJcPOfwKGHakoNM5B8azRy6VJbSZ99qDQYlD9LXI6Qs3l
	 BQYkEy1EC6gC9WlYNPNAGn8KYGGKjUCadD2tNEy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 386/663] wifi: mt76: mt7921: fix wrong command to set STA channel
Date: Mon,  8 May 2023 11:43:32 +0200
Message-Id: <20230508094440.629422671@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit fcc51acfebb85dbc3ab1bea3ce4997d7c0a3a38d ]

Should not use AND operator to check vif type NL80211_IFTYPE_MONITOR, and
that will cause we go into sniffer command for both STA and MONITOR
mode. However, the sniffer command would set channel properly (with some
extra options), the STA mode still works even if using the wrong
command.

Fix vif type check to make sure we using the right command to update
channel.

Fixes: 914189af23b8 ("wifi: mt76: mt7921: fix channel switch fail in monitor mode")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 744382be36f8b..b2366efd74ea5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1705,7 +1705,7 @@ static void mt7921_ctx_iter(void *priv, u8 *mac,
 	if (ctx != mvif->ctx)
 		return;
 
-	if (vif->type & NL80211_IFTYPE_MONITOR)
+	if (vif->type == NL80211_IFTYPE_MONITOR)
 		mt7921_mcu_config_sniffer(mvif, ctx);
 	else
 		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->mt76, ctx);
-- 
2.39.2



