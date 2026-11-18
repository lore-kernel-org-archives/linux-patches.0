Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025793;
	b=ghjK7F4ny9WkxTyw26MsufaLabHc8eAiLQlA7GTBORETJC9y4b8ZyfHQ+s8zwyiSzLsz
	 nmX9Nohehp/XkwhnpYCh43Zg1zxgjdLjOiNQckN/zjWtogh8exIbZcS3J67oLj6nHPfZ8
	 rfYHJlGxp44qVln7RmGpuQrrPSjtPDjkADWwzz+WAXSjNyAtHxNbiWLWOFDu5e8VfWsHE
	 zzqWC0TPzCq0Hym6YFD4w6ed8gZSusiqDoyO5NWG1fqyRRoWPCYGxJ4okFKRXfx+e0TMJ
	 KVUVyM068JgAisx5xy6a05nQkNfoii1rnv1Gz4AMhjtEIZRxYXwldu9ds2iuQ9zrkxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uoUgKRV+1I+33oUVSzMWWVnNWDaLtTo1QDTUgVLl0I8=;
	b=TuaJohX/WASsDx+Rik3TjnVfF92/oxgIrLhHaPPEASPyU5sXryoEwnjfNrnG1s6PMPG/
	 JdsYSPCeH4gZ3+opPdps2LB/wU1SOw8WS2eP5q2LQdpqn5r0m8CgzvOlDNFjsfHDCxNUu
	 nYgoZ0shKa8Twd0fX5gAuT+6OQnhG6riD2ZOIQZNQc4EACckDQwQCppY9j0JY3oJK4AEV
	 kBpR8tlD4RCpvO8Jq6VvQMvjPk8K2vt7VUyJJ5/WHJP4H6HFFUbb8Q7W52N72qhmvmNsU
	 Hnp63rS4ADtbSHgTs9fE+IMFDQ7JCnpRG2oxBS95/9/2F6iHGQHLEZYczf6+9kgJMQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o2qoNpin;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64192606A31C;
	Wed, 18 Nov 2026 18:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o2qoNpin
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83761F000C5;
	Wed, 18 Nov 2026 18:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025793;
	bh=uoUgKRV+1I+33oUVSzMWWVnNWDaLtTo1QDTUgVLl0I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2qoNpinq7DgrBNy4QG2UJppu6RwNHTdBL0meSPewotOFYAdjkQTj7LDVnx/0LxRi
	 fek/F6VBawGKy0g2IOpLv0FzZmkmMKSk5TlH2mfYAQmIQ636L56J+O+Tord9kOPR7S
	 /PVN4FkkeYRwHOGIGGcHD6sY7bLnXD/Jg6KcXcV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1206/2151] wifi: mt76: mt7925: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:49:01 +0100
Message-ID: <20261118150206.133851914@linuxfoundation.org>
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

[ Upstream commit a105a9fe9a07a56d1e0b5a6978a49cde2ac7e7be ]

Same as the previous patch, other driver.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260830064201.92285-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 79c72a7289d36..cd9058075a878 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1530,10 +1530,10 @@ static int mt7925_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1548,10 +1548,10 @@ static int mt7925_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.53.0



