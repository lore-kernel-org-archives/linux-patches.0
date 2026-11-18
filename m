Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019074;
	b=zPd6FDYVgq9c5jk/BsWM28G1V2m/oQZn5V30hCu5plfCQfBhLdLz21U9jYmKD5+m4hpI
	 k5Qa0fTqGgWxHR/6rpDNGa2AhTGcc1nr7Dx+e9He0N4Cs3j1L3yQj7gmvao50Rx39SQoH
	 QY0ZqHM8BG7s1zmylBj2oMZfZRu4KGWCWYnGvOZ2cI4T8Vmy1tmanUCkREc/LEBuzNw6W
	 qEWLlgX5uOSgkkN3Ey39j+37uq2bhKUI1YnwqztL7j5MNtrK/rhvV7dhUAAS2rCM0Yoze
	 sdBY7Ydiwhhw6nrXsiDpL/6kEZG5qQWp0QhbfJqckL1rtb4GQlFZ0c0/6O7+/mM1w2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fR4SxUAIZK+BXu2kZv7LfPU/vCvdhCHEXwOaBec6xtw=;
	b=chFtA68gARzAxD/5y6sox+bXhBJGKXEa3/nO49369Qb+D7lQ9o0n6R66SXQCrH4LB2y/
	 klEAq8Q3gHVFmXkT225kKXMOAtb5FzjMdAVS+a4iPq4qGZlO1tii/1s8riARHHqIBCtjy
	 orYeoeGhAqbHnos8UOg4ExOBcZvtvZnvrjL7kHWgjdUFi8m1hxIOuZMmKZQ7itfZ/XJDV
	 03FHWotDwQ8ikMttHnyuGZKe20G5yfjVNZk2bRn7fOxxvsqaXIfnSdMdEuA4PH32lgoCf
	 KrHb0yrMlQIAqh8VlxEjJWKXhjj4ir9MsbnP8pIs9vaX+2grUi2MD3dAYdIS9hEKzwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHHgkP3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DF60A381B;
	Wed, 18 Nov 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHHgkP3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0541F000CB;
	Wed, 18 Nov 2026 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019074;
	bh=fR4SxUAIZK+BXu2kZv7LfPU/vCvdhCHEXwOaBec6xtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHHgkP3YrX3uwyjOqZAURclq1OIaK15L8MkjL4hOPTfeCnLkcuEN3IieHTFpkZR9H
	 pBqQnKJrlC030naTKxlBW6R0hmplVGRZQCcmb7lxILeII7tbSxapa/ynrf9ryku3O/
	 dyr6ni5BfbiPehYuY+MuRJXuFtI9x0MykG9G2i5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1439/2651] wifi: mt76: mt7925: fix the lock inversion in suspend and resume
Date: Wed, 18 Nov 2026 15:44:39 +0100
Message-ID: <20261118150339.852337281@linuxfoundation.org>
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
index 53845857bed33..4381e8c7559bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1732,10 +1732,10 @@ static int mt7925_suspend(struct ieee80211_hw *hw,
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
 
@@ -1750,10 +1750,10 @@ static int mt7925_resume(struct ieee80211_hw *hw)
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



