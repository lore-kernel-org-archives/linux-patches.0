Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025849;
	b=PkW41zoH4ib9R07ONlJqJOh4dvr9aPHaXn8q0fxHPpsSMjyz4bbGNbbiFlCpoZEpklu9
	 IZGsKz7vVYNEkYpR0pLN0bZDaFLQzsgfzGpv/54pNUXPvkq8LG9QiOJOyfqT6r5HTQ733
	 KQxJarSl8uoAehAKICyc8GaaI9nCt9LoPepYJaKGyMRIwrP7MT4YtiKuNUw8aNFc+tXRU
	 Td5GBChud+2txdP0ccSlFb+ZD+LXg4Ni/+MiRYQy6Xqn35yblci9srhlYyqHTq0lZzIAV
	 y6evBQRGtey5fZKnwe4qY3W3Ro/UXi18c9wXfvYSBwj2WOfTbTmdBpkJKyECJg9k3Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMtCqZVRaziqB9sIa+R5ZcTwcWrZJfcDqhg/VW+RpwU=;
	b=UdzceUZYHfxDQZfXhb/NVK+0jkz/g1jM2wK2Tk6fjM9AYiL4M+ZWCTgKjMgeIZ59VSii
	 v2DSHR0gJhxLkmqAt/2QwafSSkyW11IKdRDcKtUSdfl3h2gipZP4Ysld+DfL+GdhRORSN
	 uJkbohVdelKGdETxwwnHPcIy4JG7EksKJrjC7GvrZLEZJ7T7fmo9DY6nKF3ytEG1r5hCS
	 kGEQ9BbIxb1KcTaSQPxowVndUxommBKhBIivAhiukQz80WtQorPJG4dHX1qWV+8kF8W8+
	 oycRqo7htWdxdc7gKti/xBtS0zO5cQ+sewiB+eW+DG3Y/12gWGOz2X3sV70BQM1esag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgJhHqua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43B60A260D;
	Wed, 18 Nov 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgJhHqua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4951F000D2;
	Wed, 18 Nov 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025849;
	bh=VMtCqZVRaziqB9sIa+R5ZcTwcWrZJfcDqhg/VW+RpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgJhHqualN1rUYXqh6rYaL08AVXjmnHIUdloLNENoJc24AA6lSyLjnuls5VdrbyO4
	 Zlqws7wfgosbQ3mZsaHYII2R6PygofAPwR1Z37SgOVLcrxK/2/3suW7scvYZmXZTau
	 3dnHuVr8vNezpr/MGBb8tjEJZ9Q984wUPhTfeYzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1225/2151] wifi: mt76: abort a scan only for a link change on the scanning radio
Date: Wed, 18 Nov 2026 15:49:20 +0100
Message-ID: <20261118150206.813515541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c7a6b6a1dcc8fc0ac49ec0d7418b4603684e7d73 ]

mt76_assign_vif_chanctx() and mt76_unassign_vif_chanctx() abort the
scan whenever the scanning vif gains or loses a link, on any radio. An
AP MLD that scans on one radio for ACS while its link on another radio
comes up therefore loses the whole scan, and hostapd gets an aborted
scan. mac80211 does not continue an aborted scan with the next band.

The scan uses the link of the vif that mt76_get_vif_phy_link() returns
for the scanning radio, so it needs to stop only for a channel context
on that radio: the new link would duplicate the offchannel link, or the
removed link is the one the scan uses. Abort only in that case, as
mt76_add_chanctx() does.

Fixes: e411b8190fe7 ("wifi: mt76: add multi-radio support to scanning code")
Link: https://patch.msgid.link/20261006205936.669125-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 696b8ad3ea403..66bb75090a161 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -111,7 +111,7 @@ int mt76_assign_vif_chanctx(struct ieee80211_hw *hw,
 	bool mlink_alloc = false;
 	int ret = 0;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
@@ -160,7 +160,7 @@ void mt76_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt76_phy *phy = ctx->phy;
 	struct mt76_dev *dev = phy->dev;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
-- 
2.53.0



