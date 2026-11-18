Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018921;
	b=06r4cMhbmLqJMToOuPdYIsAoZ4A+VifdiW0D6wsobB0cppHkReA8xeJa3S1joLYJHiUr
	 sOKsxo4ftG6qz+9ZBEdoRSoFWi1R+bkJUP9tnF5LW2lyHQrHUd1FqoW/6HIqrl3ViSzMw
	 qEI5aJO5HeuOX/1AldlOvuuj695GsufqJya5cJRLbd10uU8Za+tmtDqJGUZ8AS/u1nGSn
	 SPtcJPEK90wNxAYGEe+onf36B3NPbPn9WCuCOlDRnbvhhL+G3MoO3i2FHMvZJzcmz4w0b
	 VP8c4QFODN0YU2ywT+AbABheDDB+Z/+0r2ZMP4lFkahUFO0p8RuZ5l4qkm+Jd+YnD4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TBGsmDG/zlg4vdoa0F6NKed9jrcqOftBQxUxptSBbZo=;
	b=nxN4PiCWqYWkCwlEuLb1/ej3NwlaChzGO70y7N6UOSNT1rdB7ivwxJgeHhnnp39CyGZu
	 qgMr7La4p6V+caOf8uc9rud+Yv/sKTFbTtWPY41DURBXOsGvqig4olki0QdVAWjfQZJPt
	 mTR5SdKUKnQDK6sVKscUHOxbVmOnAFjwZKJqq4ef+wpB2ghfYjagT5FvHQBozFOdPb3RR
	 kDnhlOJfss5EXPCuPTvXOWjH9CfjjujtsqstSZRPP7WbM5gR52EuOlrXwtZpYPEQijU0o
	 S/BSzVtOXOYJHy5bQI5rXfSOrgs0kzRoPLNAKMWvpCFLY36vq+uxZnqZIn67LuOnuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm62ah4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1C3606A330;
	Wed, 18 Nov 2026 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gm62ah4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DDF1F000C6;
	Wed, 18 Nov 2026 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018921;
	bh=TBGsmDG/zlg4vdoa0F6NKed9jrcqOftBQxUxptSBbZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gm62ah4VBO7EdZQaIaR3y1cl8W4sZcip6MWqo3EcdFh5YxUJFwBe4TGO5HlZWYsWb
	 RbVKnJ0G0tinhMUz5H8TEiuBYeo5Ook6gz5BVK0BR08HZ5Z9N6usMGSwhPIR67viwe
	 0+r30ExjNEifReRseroaK2zcTIA7tZWXzIBdIUak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1412/2651] wifi: mt76: clear offchannel state if a scan has no channel to restore
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150338.837253017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3aaa4871006d2abb3a597028c45042311acbc640 ]

mt76_scan_complete() restores the operating channel only if the phy has one.
__mt76_set_channel() is the only function that clears phy->offchannel.
A phy can run a scan while it has no operating channel. A 6 GHz radio with
no configured interface is one example. After such a scan, the flag stays
set.

mt76_txq_schedule_list() skips each TXQ whose wcid points to a phy in this
state. All traffic for the stations on that band stops. The frames stay in
the mac80211 queues. They do not reach the hardware, and no counter shows
them. Only an unrelated channel set clears the flag.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Link: https://patch.msgid.link/20260818125825.395538-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 ++
 drivers/net/wireless/mediatek/mt76/scan.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 1d2635672ac3d..903f3a420e4ca 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -330,6 +330,8 @@ void mt76_roc_complete(struct mt76_phy *phy)
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 		mt76_offchannel_notify(phy, false);
+	} else {
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 3594b599662d6..c8c4d096c809d 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -29,6 +29,13 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 		__mt76_set_channel(phy, &phy->main_chandef, false);
 		if (offchannel)
 			mt76_offchannel_notify(phy, false);
+	} else {
+		/* A phy that has no operating channel has nothing to restore,
+		 * but the flag also gates the TX queues of every station whose
+		 * wcid points at this band, so leaving it set stalls them until
+		 * something else happens to set a channel.
+		 */
+		phy->offchannel = false;
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
-- 
2.53.0



