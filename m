Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025882;
	b=V/CRzDtNlRgQzCSS/xfWvE5E924R1DtI4xg8yGotbNmGTvaPG9uA8YL49N2vy5XFFHzU
	 D8lq3lfBh9ayN9oq/fvYfizEK1mLdYOSUPU1fKqcrwSWWywsBEojxkSobOBEkAbM74GtL
	 oCvyjvLxwTHyqYzdjjaFvSPDvrmBQI48Wk9e4f1mYq2rNWat2CZZ3N4dr0LaS9KW5S5gS
	 TTYZf28sC7QSW7dsOX2BJYp/jOey29nF3Ms7qVz6NF3Fr4uPkyErBNReDrUKHK8X8Taw/
	 OHZfakk0iP91dIqBAjId935WD4xXBp49Q8e3exbf7I3zTvCQwR9Nft4ZkHEnuIj4bGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=veyBZYByrmaLCKdf/3QWV7E3A/qTJNPHq/RajG51boI=;
	b=mcZKktMcY4fJkli5ZsJM/++Xget5svDM2/A4gQ5NnqlgLTOqXqEGrG/Wdm02w8GLB+kG
	 xXmhSMDksHmly8p3wgNiy1db31/+k3fRF4hU6jnrV46T7uwbJIFfkut8eSsw1Y1bKQD4o
	 12nbtb722nRE6o9QhALBXd0JYEf7XGt9FXFhRQtmsVKcLaqCW54SoEcsQ3WoMuXF9iYxm
	 ZgRtDR46O0eIRQfLwPSYI6eGNQBMbdSjsI9ViG4lnDkl9z9QpCdsiGTg0WVYygfwoF+hx
	 cOxEylViOIeoMFyT9ksReVsxvZiUEUaZ52W1GLDkM/83SoIUV3NlJg3q0EwEA/VD76A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Dp0nG7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94235606A31C;
	Wed, 18 Nov 2026 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Dp0nG7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97A81F000C4;
	Wed, 18 Nov 2026 18:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025882;
	bh=veyBZYByrmaLCKdf/3QWV7E3A/qTJNPHq/RajG51boI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Dp0nG7sdqZ9WVJVkZPYj/0Hp7iySlrRz6ppYV4L93gHgVuJzImvjRkB76VMcS4Nk
	 G2WXTeRqtsyOVZY5HeCBOTXB3yQSSR7Ay51fr3MmIDR3GE7pxV3hPnxqj3+7dCt+v6
	 arRrEvPBYB6S+Lien2VMAsnAuGyxf7X7aIxYn06g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1200/2151] wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150205.920786647@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 3dcb98c5cb51a70750ae8dc006d6d787ca09f425 ]

mt7921_config() holds dev->mutex across
ieee80211_iterate_active_interfaces(), which takes local->iflist_mtx.
mac80211 uses the opposite order: ieee80211_del_virtual_monitor() holds
iflist_mtx while calling drv_unassign_vif_chanctx(), and
mt792x_unassign_vif_chanctx() takes dev->mutex.

Deleting a monitor interface that has a channel assigned reaches the
second order and lockdep reports the cycle. The driver side of it:

  -> #1 (&local->iflist_mtx){+.+.}-{4:4}:
         __mutex_lock+0xda/0x1070
         ieee80211_iterate_interfaces+0x34/0x70 [mac80211]
         mt7921_config+0xb8/0xe0 [mt7921_common]
         drv_config+0x63/0x1d0 [mac80211]

.config is only reached through drv_config(), which asserts the wiphy
mutex, so ieee80211_iterate_active_interfaces_mtx() can be used. It walks
the same list under the wiphy mutex and never takes iflist_mtx, which
drops the driver's dev->mutex -> iflist_mtx edge.

Fixes: cbaa0a404f8d ("mt76: mt7921: fix up the monitor mode")
Link: https://lore.kernel.org/linux-wireless/20260730053916.109426-1-lucid_duck@justthetip.ca/
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260810045338.118923-2-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 26595de275bff..1bc596db5af85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -651,9 +651,9 @@ static int mt7921_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		ieee80211_iterate_active_interfaces(hw,
-						    IEEE80211_IFACE_ITER_RESUME_ALL,
-						    mt7921_sniffer_interface_iter, dev);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7921_sniffer_interface_iter, dev);
 	}
 
 out:
-- 
2.53.0



