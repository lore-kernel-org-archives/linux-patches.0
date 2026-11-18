Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019043;
	b=030svBv4HNopSA9i7BKgsPT+u9XnEiiqLggUPkE9VMkQdxXVyHxD+wqvRp2IcQh9LLt+
	 rUe2j6H1udm+F4utONwvmG4/kW2apWad4K2z9JT8hxuVjH9f+1HB1UMJ06FQ0vchVB5K2
	 td0Xjwz7pg6vO/f2JIhdb4zpoMM/bCr1YwWtV4JYfq6dz7Ox3QAIBG1JUPDuPkE/0i/M5
	 GUuyZn2aFwuwQLEnSmME0+sIwNfI3bT8cwds15S3pwRpUXyscc55l3WD5OiJbO/I4/6b5
	 wQ1p39/1z6QnGg5kHmcC2tKEvdjOfg7IoqbNexL/ve8jOKsKl/sh32ed1lX7sto2raw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FeH9yGdBet0GCiVpx1Eb1dJxFWcOUBOZMxYLln+qaUM=;
	b=IB5UCBEW/X93FEs3S5NWqALKf+hwsaCpLr2/L5u9HqwSTCJRlWlsXfwvf7Tb7ppFDuEd
	 bWXK7ddfDXimpEX2+oSEGEV9c8cdACWZXGoBPlfSa/0YoBi1/OnLaud81Nn4IGGnmYjSN
	 evoGj9GL6P7+Pfer0UaeCWNoVTJ4e/eSdSHRuMGeZaraZOgqqjgxpPikKobQDtVrcumU1
	 UWuO7AVDTdXchqOFYTJuSWl+8RpIMFl9gLjIHT3+n4dZD0XXyPpdTnqmEy2w7nuSZ04/6
	 o6aRRtIYXNJ00pFcRnDWNGOQxXIhrbLdk8r3EoroECz7202lhc/VrX/kLLdKOHthl4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18FPOOxk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A03606A31C;
	Wed, 18 Nov 2026 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=18FPOOxk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E301F000C5;
	Wed, 18 Nov 2026 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019043;
	bh=FeH9yGdBet0GCiVpx1Eb1dJxFWcOUBOZMxYLln+qaUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18FPOOxkwBbVnOgdh5Yef6/6b7bj6uXOzLUuwGZwhocDOszhICcA+XcLHRzQuJ/x0
	 egZZyQL49oRuewPiUdIEkX7lPA+x0GdZSescU6F4FzEbsYIcodwofcAHj0udln0OZ9
	 c2+INv0WFP4cQZlY++lqsnu5ky73OGIRJjZc8VHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1438/2651] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150339.819098673@linuxfoundation.org>
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
index a905c21943f24..623ccb41a368a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1156,10 +1156,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
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
 
@@ -1174,10 +1174,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
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



