Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE1915C158;
	Sun,  7 Sep 2025 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277098; cv=none; b=Bbi5tNOYKEfNElS2zbIhtYn8iIkrfXiBltwikToXffXeflPKvz8Amdhsf53JcMbXydEjxBTdK495F1iMMs9rfueX+pjAxfmUuICWHSr+TgEY0xfDNvrxnvVCDG5PRIkmCCKkibSNBenKksFMsg0nsNiW1BG9kQmKm5cLiDBPsMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277098; c=relaxed/simple;
	bh=3xYJJxHmY9HFOwBgbVIbxcAsRHqblrU5MvhAEzYrWnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neZcOy6V36ggtyUMAdiK0t+pO44BsdOF1qETQmvL4/WoiEl80MqZEprtCxJS1d2WjS2gPjBA2iTfovvW8XjSuTihdqzTDhO+/WdDJvaPKULqmHR83S0YVjQRZkCUuGmGmrhR7blzz/aCHg3bx9TTma2f/jisr/Xl0uctqky07iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt55ZSWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt55ZSWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA47C4CEF9;
	Sun,  7 Sep 2025 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277098;
	bh=3xYJJxHmY9HFOwBgbVIbxcAsRHqblrU5MvhAEzYrWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt55ZSWmD2qGjo7Z7QV2KumhcT9NfeyvGn/Y0Y7woiAH/abfACZyXtWleA0chj6tZ
	 2lG+xyQ89r+VsPDmieVuTIScqbnPNKdHRuLPEHpA0GlRQ2LTnKEyGtzLSePicW04ro
	 u1UeDs/75s1ZsW1Bfl+aXd100yFnolHAZXo3dhb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/175] wifi: mt76: fix linked list corruption
Date: Sun,  7 Sep 2025 21:57:13 +0200
Message-ID: <20250907195615.758484277@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 49fba87205bec14a0f6bd997635bf3968408161e ]

Never leave scheduled wcid entries on the temporary on-stack list

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Link: https://patch.msgid.link/20250827085352.51636-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5e081972bf445..634b6dacd1e0d 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -645,6 +645,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 {
 	LIST_HEAD(tx_list);
+	int ret = 0;
 
 	if (list_empty(&phy->tx_list))
 		return;
@@ -656,13 +657,13 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 	list_splice_init(&phy->tx_list, &tx_list);
 	while (!list_empty(&tx_list)) {
 		struct mt76_wcid *wcid;
-		int ret;
 
 		wcid = list_first_entry(&tx_list, struct mt76_wcid, tx_list);
 		list_del_init(&wcid->tx_list);
 
 		spin_unlock(&phy->tx_lock);
-		ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_offchannel);
+		if (ret >= 0)
+			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_offchannel);
 		if (ret >= 0 && !phy->offchannel)
 			ret = mt76_txq_schedule_pending_wcid(phy, wcid, &wcid->tx_pending);
 		spin_lock(&phy->tx_lock);
@@ -671,9 +672,6 @@ static void mt76_txq_schedule_pending(struct mt76_phy *phy)
 		    !skb_queue_empty(&wcid->tx_offchannel) &&
 		    list_empty(&wcid->tx_list))
 			list_add_tail(&wcid->tx_list, &phy->tx_list);
-
-		if (ret < 0)
-			break;
 	}
 	spin_unlock(&phy->tx_lock);
 
-- 
2.50.1



