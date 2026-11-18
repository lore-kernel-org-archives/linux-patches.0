Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018916;
	b=qHcwuJo3Ce/U2k3lyfGmR9C15/zu/WaujEXR3Ryfv+KeZ+75F0YV64RXQgOnaKaIFJX6
	 jqYhFXtDkwCVvCn3Jbla1ML9XHztG+CVJ+mL+YDdo4XDwHIyMkGWXXIe7CgZAaprpkDDW
	 CYF/HoXtlLHnYf+6mPqzpyemnk7BgpeX4DpaM6NLaEDu8Tbd7NIOxOj1rEXT6Nfhjwcyi
	 amxBlRzGofZ5tuZEITqUkYBcPFKmuhRyTmmY7TUjEPBTiamnmJFUxWYXdRROZCKJjHdtb
	 8HVE+yF3ndI7HuPHjP+z2f42RcRXiGMPlaKRTFDEuQ38Ma1Moqiha7u+u2bdiwhn61w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvfXVrckH6zE9okvnXB+YiMzw3lV+I68CcF/RizOz1A=;
	b=oEpBoYLjecIDo4n3bz3Z1/LPRsfP+rw9Z4J4nTH1NGxw/abDdqTat1RC512r1J/KnVb/
	 c8aGeKsdCpyXTVNMZGcUwvblz4Kc3V3J+9R7n82zQ6ay9eNCziIuZTprpu/JykOMQy4x/
	 kwFyAP8ib4fYXqPLT7+rxJhjAmedlU6LmwCfMoM+ZDYmhpchQUV1GIZ+Im3xvhGhTv8tz
	 IHP8wQiOHPV+sja8fwbQIicuhmqwBTd+2EBjKt27Sg92ObDNMffXLL4FW6psZuQv/uWZg
	 i2Z9fYjXZ9pnJJESxnGZgWx+KYQCJ35PHPO0qAC1VpdeN9FLc/IDGn/P5g/pdL8Y+yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7473OHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED896606A31C;
	Wed, 18 Nov 2026 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j7473OHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB271F000C4;
	Wed, 18 Nov 2026 16:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018915;
	bh=PvfXVrckH6zE9okvnXB+YiMzw3lV+I68CcF/RizOz1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7473OHBfzawzR4ZjOmYj12m/fYev1hNrLh9dd3Be1RGxTZBaoA/yRzJJQ7P6nr/p
	 diNtlcw6JWHcxRjaxkaQAM2rHzu5gs5Pm9v/3VvJyl2fS1pTca4WODBXLT2prWm7hj
	 UmrINqfSEByNsdEo7oCp5GONxT8GovwrJJlD/ow0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1411/2651] wifi: mt76: check the owner of a remain-on-channel request
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118150338.804463393@linuxfoundation.org>
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

[ Upstream commit d6173b8b36e5cefc7cce34c31a0cc63fb3bd77f4 ]

mvif->roc_phy points to the phy of the request that started last for the
interface. That request can end, and the phy can start a request for a
different interface. The driver does not always clear the pointer.

Two callers trust the pointer:

- mt76_vif_cleanup() aborts the request on that phy when the driver removes
  the interface.
- mt76_cancel_remain_on_channel() aborts the request on that phy for the
  interface.

If the phy holds a request for a different interface, both callers abort the
wrong request. The request of the interface stays active. Its work then runs
after the driver removes the interface. The work tears the link down through
the freed bss_conf.

Compare phy->roc_vif with the interface in both callers before the abort.

Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Link: https://patch.msgid.link/20260818125825.395538-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 28ad7bcaffd45..1d2635672ac3d 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -423,7 +423,7 @@ int mt76_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	struct mt76_vif_data *mvif = mlink->mvif;
 	struct mt76_phy *phy = mvif->roc_phy;
 
-	if (!phy)
+	if (!phy || phy->roc_vif != vif)
 		return 0;
 
 	mt76_abort_roc(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3467eb6cea0b5..ab037e302dca8 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -2121,7 +2121,7 @@ void mt76_vif_cleanup(struct mt76_dev *dev, struct ieee80211_vif *vif)
 
 	rcu_assign_pointer(mvif->link[0], NULL);
 	mt76_abort_scan(dev);
-	if (mvif->roc_phy)
+	if (mvif->roc_phy && mvif->roc_phy->roc_vif == vif)
 		mt76_abort_roc(mvif->roc_phy);
 }
 EXPORT_SYMBOL_GPL(mt76_vif_cleanup);
-- 
2.53.0



