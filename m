Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031140;
	b=bSeOhj77QydkQ2BxY95Zwonon32lIit443cahdPY34cY/juO5NcNYfXZoyRIj/xHbVpo
	 j8S27TwT6aKHEwjFGQoeCAJuolTBAZ4KXmkyGhgbpgwd5SmK/xu6JaStDwqXKlY5RZtG8
	 EMrtIMyDl1nloEsSyXakJ+H/OOPF9NgUf0diizLfUeco6URu+lPjdJwOojDwRm05irOn+
	 k/cBNNGuOjbzni3LFjoghMRTYJr/KUUsRc2leTq6ml222NpeH5oudRvQro/7i8JqBGvcW
	 EgGC9+ynMkaIsTeb1S6HvY3OufUJD/LWFL3etSEQz24kl4XNga3SYcvDNiD4x8kvRFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J9HGhH4bBFNq1n8jLL7V7BMsEcmhMnQsDHEPzqY4uYA=;
	b=Snxb4ZgSpTqTYzggSVjJta8XVUiiM9NF6jZ/Umr9RsJBblNmDqtxe5YL2gvfJPVvZ54a
	 8y2aJZoebD5EJQ23zfY0cRsV5Ia3Yl9nawcA08gB5hoe1hgV+W2Q69S/Tjaf5BCW5bJMu
	 tBnr+Tz/skV1W3SCTC59npgMFGG8M/lJ3Jb+qLaam+EEo8Gt798Z0DrDGiau9OCRaEFLW
	 4Ul2Kh5cmb4LrhIxMZenXUj5fi1EuVuVaaX+j8HecMG1sU90bwBlk/bJu2e/yWyPUmbCa
	 jEjtfA/yLjXR+XR5bzV1sS5uwYG/9RGv+ku96De56PAYEv+E76Pr/qYDiP7btlD+2vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGWsvZ+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CEC606A32A;
	Wed, 18 Nov 2026 19:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGWsvZ+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93E91F000C5;
	Wed, 18 Nov 2026 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031140;
	bh=J9HGhH4bBFNq1n8jLL7V7BMsEcmhMnQsDHEPzqY4uYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGWsvZ+uIwZY5Vv7hcbUBAwXh7l6AVk/GsX8oJ4+3OvAyIW56XhO8mh+QXwMZOfVC
	 HL4AxsW+xmeJSF/ZLSx2l8GIYMdbX34EvjfnWJ0g8bK2ybijF75ZiLuwWCwkFVY5rv
	 e4UjrYoYaVYy1BRCYfL+zkykqyWUogdAcy9Qyaic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0952/1756] wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150047.977213246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 18eb934da570a..0160268d02740 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -645,9 +645,9 @@ static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
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



