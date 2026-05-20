Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBE36A352;
	Wed, 20 May 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297567; cv=none; b=TGUZbcUCN6uBlNZuTPvbApiNFbSMBB8oSyazrkDRbF7IenZ5S1L4dIUdZEqeiUnR43B+KGcSvcY0XBOs/9mHrJeSN74eM1cvtHl1s5PSbHZ9lHkkStgGQdYNOrFSdwIMIXyVw0HJlB510gfXN8t4vZoC6dJ10kaV+4zXuhdHyP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297567; c=relaxed/simple;
	bh=XCMn7Zg2pLcU9KzZsNPBsK4K9cVBqIr7uCtIqa6G/A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOrSdDfzWhCSXdQ+haD7KN4SYNybF4ukXxUocZJS0ZpwhnXp/LFPoH30fZFADhKEgC1Cn1u2zRmz5JXgHMfrOpDjq+skTOvzHZTM8IcX0/g8EkkUk/up1hD6tYws9reXG9BDLxqLXHGf0kY6cnFPanJ0zsq/yjmSqsQZjqGcKMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tV5ephii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tV5ephii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5201F00893;
	Wed, 20 May 2026 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297566;
	bh=ijyqarZVSJ53DnxgW2rMWagGDelJPevMewQEYF9VkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tV5ephiiXgtaB2J+SHVb/BvHPlIDWHkN2EbGXqr9w+t3U6wDghUUhwtQTd/N92rBr
	 bVqMfPnzXWGcWQ8zwk0r2GhlcF05wH2Dbqn4lXLPDs7mXhz+09wiX8FsilUNGD5NfH
	 OHJs1XoeQ1GOCGEtDwfOuCtXQVj8TRhmgux3NuRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/957] wifi: mt76: mt7996: Clear wcid pointer in mt7996_mac_sta_deinit_link()
Date: Wed, 20 May 2026 18:09:21 +0200
Message-ID: <20260520162136.254607060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 88973240dc7c976dd320b36a9e6d925c9be083ae ]

Clear WCID pointer removing the sta link in mt7996_mac_sta_deinit_link
routine.

Fixes: dd82a9e02c054 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251205-mt76-txq-wicd-fix-v2-4-f19ba48af7c1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 5d4b1d8f3335b..589b228a4eb0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1032,6 +1032,7 @@ void mt7996_mac_sta_deinit_link(struct mt7996_dev *dev,
 		list_del_init(&msta_link->rc_list);
 	spin_unlock_bh(&dev->mt76.sta_poll_lock);
 
+	rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx], NULL);
 	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
 	mt76_wcid_mask_clear(dev->mt76.wcid_mask, msta_link->wcid.idx);
 }
-- 
2.53.0



