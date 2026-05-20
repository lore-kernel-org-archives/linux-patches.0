Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979312DC76C;
	Wed, 20 May 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297707; cv=none; b=imGIbOEXaACAldcbugHL/wPi142BfynG+VedI/tJhZhNDOACXz0DUgLqGielrXAKdGVpfZCoX6S9PrQPrGCwHeqmahsfbtnE7WhNAXd+5cqQY49B2wA17eFsdpSofTIw38ks+LuwmBoOQOWYH7LH462cRirRyII0Y75aHsA+1zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297707; c=relaxed/simple;
	bh=VhFRxyVi84r4/N52m+Lhl7v/vvHCC1XeeThAqOvzeG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdSbgWoVDIQEXxNBJLCQmjb8PfqCl/bA48+DfixDw5AsL2ur7rHJi3y5swfZVMoqk/qTIHh1USK0TowP4cwE1SOuLqg7VyxyRzWdHOmWOe3N+37kefK0sRdY0pJLH4D94znP+64tZpqfHR0+KU8qUVwuw3iW4xpxpzZ+OqJ8P/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnP5jK/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnP5jK/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40071F000E9;
	Wed, 20 May 2026 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297706;
	bh=thbKffB+ORHdFt537hTYJZlKrtI6QyBY0fq74BjV0I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnP5jK/evMtIzKstF0HFvcNw3lUXvZl8Ksh+mzIhfB6+SFU2nkfhCWDztdlSrLir5
	 q0ezWCMQ8LVg+VKOpdOmjbx8QJQMrgkRLTNKMZHm1TzFzbOQlkriNcVL7OdJ2yMTZt
	 +49XhS3DV9bqmpk+vd+lcpr46gS4TibQRe7s9rqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/957] wifi: mt76: mt7925: fix potential deadlock in mt7925_roc_abort_sync
Date: Wed, 20 May 2026 18:09:34 +0200
Message-ID: <20260520162136.533814454@linuxfoundation.org>
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
index ebb746f4072de..00126f563dfd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -452,12 +452,16 @@ void mt7925_roc_abort_sync(struct mt792x_dev *dev)
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



