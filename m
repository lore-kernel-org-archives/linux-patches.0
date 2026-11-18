Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025910;
	b=n6gUj7ux57O0nigTjKJnQf2G1t9cgTxTgeqHutCEM+URztHJf63IeDbxK6DaTKCKEud+
	 ryjQzDuti6pW0+22+woWBLDYsPATJdHqDWX7FQPYuT9BkycDLpQdrXwzaXC+XRMbyR1FX
	 e1BXoXI5esLcUoMmLs2LhU5z3Ia6CWuIY0HcRxwEbasGC17A4bhiC4VupAJzTtG/THAyN
	 LzdjRkzLEV7rCCFR3rwrEh7SSZKEWjbP7T4PjNXQeFiLo9Z6hjJrv6l5n6jP4JMHx0/7f
	 XnvDrj1htw2p/SsVrH9snKAkVu8vOHNgr7O8isHyC/L8/EWA1oJd+BhwRRCZ40jLqWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C306W9FosgdkXYmUlAW/0Zv3ClJosE6q9gN5Yjk+r8I=;
	b=ujzGygPu3BMXEtIdGo6tnikP7dAOkA+DjlhCJG64vznz0+gSimoyoMw5VXN0H2MYrn6J
	 9m7T2Zyizs5XzLH5akh2poejMLvQaguxYACyRpeloDgI5ithuuL68/O6c+yKs8FFTAjRg
	 FvvAq4vdZgOgIB0VbdUO3+C7YGRg1QaaGRrAs6DJcu23kDU73YDGS+s9PJmBUdN5a/08E
	 QCAR2M+7rYkCx07YAT10CU89H4LTDH8cK8y5PfzYXkuPInnI6luq6qZHGAAS3LkP9kEiw
	 4pxxqiHjFYxM2OvTAc6doNBpTa50a0Iq7MHLR1lBiBQzqRdc/r0bMZyObUAkxkk+cjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvHlKfKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE46E606A320;
	Wed, 18 Nov 2026 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvHlKfKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279751F000C4;
	Wed, 18 Nov 2026 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025910;
	bh=C306W9FosgdkXYmUlAW/0Zv3ClJosE6q9gN5Yjk+r8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvHlKfKjD1PiCUz5/C0Q13EhcSzpwQGwOat4DXa9gFKT/YzHWEyjkxdfstOllEUw0
	 xXP75lJkBzldv1bihDhQL0nkQMnGWxuQNaqumTfYs7pQrdlaH/NyWcDusYLuVAbbZU
	 wYxMEkKMO/KBmUphpkCRZLn7pKWn0jdNXWVB0GdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1205/2151] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:49:00 +0100
Message-ID: <20261118150206.098118984@linuxfoundation.org>
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

[ Upstream commit 0e6472108d51a42272332f5b6a95871244b64301 ]

Same inversion as the config path, same one word fix, missed the
first time. Both are called with the wiphy mutex held, so the walk
can rely on that instead of taking the list mutex.

No new splat: same class pair as the accepted fix, and lockdep
reports a pair once per boot.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Link: https://patch.msgid.link/20260810045338.118923-2-lucid_duck@justthetip.ca
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260830064201.92285-2-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 1bc596db5af85..d00ef69f06355 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1144,10 +1144,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7921_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1162,10 +1162,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt76_connac_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt76_connac_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.53.0



