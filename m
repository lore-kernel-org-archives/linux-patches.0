Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049299;
	b=2iwMiKznGOWIj/zpuZYoiE63De5+J1FJaRUG2xjbrvRl4xWrrSal13oV5t5id3sgz1UO
	 Tl+xetevb8CFGDlFscehHifCfEQORd4ULWXpFEYYnkUB89r6kVvBZzfyNjxI8J/7oTS3l
	 YQSK8CYNkfnfVrQ7ouHe7Gr0vKNP0ZgDlYSYiEgzUoIrTsbzuvzCFWGPdmklGMEPDKTe/
	 tI4gEN3CajSCj5U5zdP2ybHi9j5yMKG5zQF3Qaa7IuJmWQ0glOTxzBvQAHQIscxvdqgsk
	 fMXjkYRa8ynLwBE5grB/yCnlZ4TUTUjEyL14fUfGvUVyIMY+B+MtlQgbpMH6bwPF3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdGG5x1L2jvigheGtLL6ZuD97nsN08gJtH546XNweuM=;
	b=aTTdAWHYJdZhU1liumIt7qjar9PLYL31rofSEsMIWcT1t1+mjU86aL4gX38GaLEOfBc4
	 nFODyn3C/4JEgAj2OSdv9YhG3B3QHAZYgmP4FMncvfzaCqNpz0RmNvenE1iS176EOAVHw
	 u3UyHtJQzsRq/UYKtR3eEf/uuwfWm7jeiP785a9JCeRRka6mWNl3ibxb4EXIaBuiA/vg6
	 XjoZGBDEe4eUXFztA0X8cL1m+AaZgrjZfE/pPAY9qBYOLQWa5XjXdSMJBAjSA+WRwGGJH
	 BwA96vGl1nuF4oE7Smb7TRhvXCN1zu3WUV2/mAlYFb55/ASrNJBZkAplZMKOJXQGN5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boCf9tOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1E606A333;
	Thu, 19 Nov 2026 00:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boCf9tOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EBE1F000C4;
	Thu, 19 Nov 2026 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049299;
	bh=jdGG5x1L2jvigheGtLL6ZuD97nsN08gJtH546XNweuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boCf9tOfGXMeb36c3BiRStMJ4yYI7XkwTkxrgmP1LUhqZjfz4xh0uMqW+PhNXZT8y
	 FpKCJ4FnGO5wOc6Cjg9DKJyVtDaTpJ1z6njBDwJqmoL+tGHs+DlQ1jlIrLfsOtnoS0
	 qEqD/sbjX4+qad4lIgAXevRaP6ekIC9yKkzmv9oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2301/2857] wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150324.333509475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2576548957096..9f104c4ec99ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -580,9 +580,9 @@ static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
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



