Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041017;
	b=JOVt0Sj8fIgxS/2cFSWqQrO2la2APIj9+wBbl2QNTxTS2bi+QGrzvf9w8waYnHwrxSsS
	 2yrq0jCJJC7BcUFXrej9zeDNY59ZDOWwddOvFYnCYpbBZwhRgM8b6SWg5zYPOQUxIFADg
	 +BNGnU8vWcNuYLr/c0UY5epEFrIHj3LuBC4hGhxFm4w++nCXWLQv/dGW101le7HJn7MJ7
	 W3P+VEEjA6WQltAaQKk0Q8GYVlGE3HMakJIwKxq0je/fs06T6Jtquu2ZCuHsDbPSM764y
	 eDMLft5YlFslh0O5atbvfiT5fSVYyF8lpJuQKe/TQtSvlXPfF8DkM+H+PNnHZR6/NDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z2fuiOCFkUFh2unQ+mdn6HeU8sOjHd5p0X6qLSXsdDk=;
	b=TuMappBt0j7qGxJCmKUC5c4PFxJ7VLxrdkgYLi/ILK26I+OFnZ9kblJVwx5xNg/tnMwv
	 dSZeHvZXn2Vv1h0WQFoA2HDH+Zk69uiVqvomYKUSZ/UgsrqK7Yseu9QX5Ib5tjHBljvCO
	 fKz0VigIfwrFMAMw6dScZ9zg2Hrr/MwijIi3Ns0LCv4r1b/INvdV/OCSVytPac6f+SOGx
	 tUUTHNjObQubyFNVaGI6oQoSM3RpYXgHaB4aPacxw2zrbQ0+UmBLZZX8dbi6fzIJs3XcO
	 5Qdrf3HhMuLDKzH3nKV+ilROsV4S9NZ1YzS7zVDVvbRmjZ6+x5zB9Qu/fRZj6AaaHfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5oPewaz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC2606A335;
	Wed, 18 Nov 2026 22:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5oPewaz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E8A1F000C4;
	Wed, 18 Nov 2026 22:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041017;
	bh=z2fuiOCFkUFh2unQ+mdn6HeU8sOjHd5p0X6qLSXsdDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5oPewazH/3SNZy1NRlYg5SducXD8ItDJweYTYFFAaq2+yXf1bV7Sz5BAegpjAVY1
	 Ng5ikO61tSKI6Q2vAYGHMFIS+pVCQsigMQJ/pG5P2YSTEBGP/FL1F3l+sUweE2saDy
	 Lv69OuDgA/Z4Ed2wYITMYJ0R6R6zB2L1Ni8krPRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2662/3318] wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150440.884720037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index acf54f27332f6..e75f7230cf21f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -631,9 +631,9 @@ static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
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



