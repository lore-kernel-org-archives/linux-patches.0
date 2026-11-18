Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041022;
	b=Hgcjptrx4GaGvfg8AagCjjTHF7yIS3SeGUKDcpupuvEyEwOLIe9vHrOy7DfL/Cx2cT0Z
	 ZQJCodvlCIMXZiXDkR2xtyhOFXRuCtFRRd9hsTkjPhvLhMG/Ai7mFQsuLUFTTGHr9PNmu
	 KN3bQNVfV/OIJJrs/DWmFEgxsx2RjZU2aolHY5QIYcCQw7ltdGqAU/YJ8pF8DHtsi6Kde
	 9XaUnUSXigBDUSqyBpsQGJpm+8vdGbjpLOWl4H2Nf7rsEHla+iOGaOOqAeLfSoMZCOu1x
	 TDDGnx2BG6tu54oaAAKNHBURJ/qkJEWHvZ/ALCbq1VMu/TfkzvbLFO8OUV4SvT6t05w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOskwQvyq4Lfzh/wWCtlAk6vE7k6mzqKXBdCWH9cDd8=;
	b=MQAcJ931Y8COgwSZB/1JNV+2G5A8BQxVofSzRwwYfwvGf3H/bNrt+KcruWgWr8TRUFlf
	 VRlnnUpnRDKPPIufJzRehiFPnq++LiE2M5+IBOqBNTQ6tVFm5WijALZqHo6QUNSBsKXKD
	 B5z/Ezsptj/ObCmP7QWCIaaJlwXKM7LeAlIKtFwRJDL7D1P29gXzkloeRaM2GZ8xM0dnJ
	 Ppj1LQy8B/fDI0yNTjji29KQHH2Up3LFzbGGfNf8PIKIEImX7L/OcyC70QNv/j4YUQvYc
	 kI5x7Pi/LsG4byv5sAckRUbw1FAAYD+POQEc/vhXUJnRVmOMOVJ4c3dG7LyxLgD+JAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K53OTqPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91A606A32C;
	Wed, 18 Nov 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K53OTqPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E9A1F000C4;
	Wed, 18 Nov 2026 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041022;
	bh=vOskwQvyq4Lfzh/wWCtlAk6vE7k6mzqKXBdCWH9cDd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K53OTqPE8d/vDu/QE4Q/lPU+KuXSihRtGtzEFY5YED6N3v6pDp2CN6k7wpQzqsPP/
	 gFsh6r04hLcF05zbsVKhGu+ghSyiqlGKIbPP/MPNo0/LgEAoHf6391fMzN6a2WkFv1
	 7lk94+SkRYrkH5+2itNcBBCFoS+SZ7f3Z+iK6YHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2664/3318] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150440.940076551@linuxfoundation.org>
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
index e75f7230cf21f..aa112371c07ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1042,10 +1042,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
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
 
@@ -1060,10 +1060,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
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



