Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E1344DB5;
	Wed, 20 May 2026 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294633; cv=none; b=e/moYl+HSEeIL8PAVfnfVEIrLlEmawV+SKfNSKlFVdADIkQkUKucSSPfZ6cCL2PvELTRGv3mPaNLh5UxnWisI6q8MuClE80qUxtmTHs5b/5STK0+5omNgZNfoZEGxaH/1cNQJ7g1pqfPjWpF4GSkdqeerUoObIPs31cQL8YOjlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294633; c=relaxed/simple;
	bh=BSuEOq1cUha/t4OP0xprTnBv4+njECipNQyHH4YM+w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNEzln2wU1iJV3bcVy4bM82MW7g9KftdWjjf9mKxSOQuIZH9zjFX3XByW7hD8UV/XkwMUJG6TsciUrXIO9gGi7UaevDyPVdHufMHqOLVuNeEQR4NQIXVMFV6Xr+rnNfvifA1L53uAVe88i8HW2Ks91//k6PJrEQUC5gcaYilOlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNZs9Pb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNZs9Pb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB991F000E9;
	Wed, 20 May 2026 16:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294632;
	bh=UacNv9Le+TquFdYzzX/oDfS/xD9ZNEW37iMJUpLqOaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNZs9Pb7fQ2YwqmdajMN+0VIW7NSws/cpp0OknrE3HrvbM8QVuO4c3OG9B8uPtc/+
	 QGcr9hao8q83LFWcy4JqXSBI6iEzKfOKv4qMCTMJbSOGOQR05RLQksQcz+Dra/Y4H5
	 w5Xzg+o/JlIYQZwuV0Fyy6XAe/b2cdYQS/JDbhFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0112/1146] wifi: mt76: mt7925: fix potential deadlock in mt7925_roc_abort_sync
Date: Wed, 20 May 2026 18:06:02 +0200
Message-ID: <20260520162150.872791532@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit dd08ca3f092f4185ece69ce2a835c23198b1628a ]

roc_abort_sync() can deadlock with roc_work(). roc_work() holds
dev->mt76.mutex, while cancel_work_sync() waits for roc_work()
to finish. If the caller already owns the same mutex, both
sides block and no progress is possible.

This deadlock can occur during station removal when
mt76_sta_state() -> mt76_sta_remove() ->
mt7925_mac_sta_remove_link() -> mt7925_mac_link_sta_remove() ->
mt7925_roc_abort_sync() invokes cancel_work_sync() while
roc_work() is still running and holding dev->mt76.mutex.

This avoids the mutex deadlock and preserves exactly-once
work ownership.

Fixes: 45064d19fd3a ("wifi: mt76: mt7925: fix a potential association failure upon resuming")
Co-developed-by: Quan Zhou <quan.zhou@mediatek.com>
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20251216013849.17976-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 3d622c066ac76..fec54d5f4eaf1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -457,12 +457,16 @@ void mt7925_roc_abort_sync(struct mt792x_dev *dev)
 {
 	struct mt792x_phy *phy = &dev->phy;
 
+	if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+		return;
+
 	timer_delete_sync(&phy->roc_timer);
-	cancel_work_sync(&phy->roc_work);
-	if (test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
-		ieee80211_iterate_interfaces(mt76_hw(dev),
-					     IEEE80211_IFACE_ITER_RESUME_ALL,
-					     mt7925_roc_iter, (void *)phy);
+
+	cancel_work(&phy->roc_work);
+
+	ieee80211_iterate_interfaces(mt76_hw(dev),
+				     IEEE80211_IFACE_ITER_RESUME_ALL,
+				     mt7925_roc_iter, (void *)phy);
 }
 EXPORT_SYMBOL_GPL(mt7925_roc_abort_sync);
 
-- 
2.53.0



