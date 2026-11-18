Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049302;
	b=sD0RHNJPMGmryjx8wPFJV1eyxabarSVKGXHou7uYVtezZ6W2eZEdA3jJuPw7F0h4qI/W
	 uebyzGuHb0r7Zz30xH+vd1GbRhMi2D2j6R98+ez3+lUXE69jIYiIwLkBKJnvksh/WZWJ6
	 9ZxpeJi3aNYDcCiodYDITXVIdNRkleQ/w4phBHSVkibqHq4V84k6xgES7+BqRD7cs92pT
	 bFOmb0KOu9d/eoRqi8G4Eu6575kraAYNAJ00tF09k0Br26dKda79jBueVeH4RzRgL8HP1
	 QMSH3925OgRB1ogZbSLPeB9DtpJS3COkFID7RPNFG37g6eA0jhTFGR2W2MZ5URd5Q/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+RowjUneYe1KABP7HRkp81m/q16A1C6lN9AfgbwxSM=;
	b=moZuulYBbsMKzFtatiLhBjfY+CddNs/q0rnH3UnLRcpqcPxIemdkU2h/fNq3nsE/zNWa
	 KjIH0FGhTdwWLyYBNHMM5Avk1XhDp/BIiGuW4Hp0GBGx9AVBh4tvGO3rrJikD/nrXER4b
	 Ak9Va9AggQ4N+tyZBjCr9VQ85V+nF2FOdjwE94nFwe8XqXk1uDFTvdn5AGd9JG04Qx/bc
	 2mbMPT8FGW/1gJkRZtrhy+JaWg6Xw/VzworaO1AEB87VZRX1L24/DF6WwCt4Rihx0Wc3R
	 oMPzemH10V7SoSFaxRCEbn91XYX1Z/j3QZOcxH4dIDpPcvntsDlXvxDiidWWmGhK6gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNmSfDOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCD460A2609;
	Thu, 19 Nov 2026 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNmSfDOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7881F000C5;
	Thu, 19 Nov 2026 00:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049302;
	bh=f+RowjUneYe1KABP7HRkp81m/q16A1C6lN9AfgbwxSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNmSfDOpxbUfaKdqMItXpz2nfySmy4ji6jGOmM5mcuZ+MbYvxnscUmwX/u3eucB26
	 JRmRJKPD8GBzKIg9CGhdo+REHPIFZWhNQgcNXChhx65iks257EGO4d+ARYcx6XUGpo
	 PsyDuLVvNXyiJdtCoYSfCh8eKZ7qWUIrPik1vhc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2302/2857] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150324.369035406@linuxfoundation.org>
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
index 9f104c4ec99ea..8d5a1a4bbd428 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1313,10 +1313,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 	mt7921_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7921_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt7921_mutex_release(dev);
 
@@ -1331,10 +1331,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 	mt7921_mutex_acquire(dev);
 
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
 				     MT7921_WATCHDOG_TIME);
-- 
2.53.0



