Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5503338654F;
	Sat, 17 Oct 2026 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254045; cv=none; b=jY2ItfqlLv5o7ewk5sw/gY9P4H2qUW2jhbYxDMG97tFDQGfcZF32XgzG7fxX9cBJKQblhkDEGGLBFrVTZWoyqR3dLCsW00PmV7Hf23ab5inK+okHozbrczya2d6JQSf1d5v9D11dDCN+0lma0yvTQTEvm7kd66W+hCspakjxXYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254045; c=relaxed/simple;
	bh=UNUB10t0Gz+zk8RjQzeRTJuvpQJeQiv/li6/LSJJZdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+nmIOpGMqRjIzhTiIgfnopViplnQGj7ZO1lKejTKV/QBgFd9ql4e+NSyF+3GbIx8fvYNgUK7V/HrilEMobZ24U23aGczAOT/pc1C7rAF4M1ttbxy8E35K08zALMZDFRUyoxU1tuBmPxdGe37O/6pa5aZRZhD9OdsSPEpKaSv10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6TLSgW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6TLSgW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB63E1F000C4;
	Sat, 17 Oct 2026 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254044;
	bh=YlHaHynXDogTjuoY+UHTHtM+jnZGpSc5sd/KBGyclN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6TLSgW34AoZG8/S2SiU8fl2hciV/2GNk/pCwOdwa3Ceuf7Lk58XWSV2+jHHrk78t
	 CV8YpkKmyAA7rnciX6uUcjF264D3/TWlWM4qOxR29650qzLiCgux/y+8uJCangdLGM
	 5Fg/aKx2Mx0uM7HIFEvwMNL43ggTSCPN9ZufagYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/869] wifi: mt76: mt7925: fix potential deadlock in mt7925_roc_abort_sync
Date: Sat, 17 Oct 2026 17:52:37 +0200
Message-ID: <20261017160045.176499045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index deb226cf5413b..9a52607dc5a8f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -473,12 +473,16 @@ void mt7925_roc_abort_sync(struct mt792x_dev *dev)
 {
 	struct mt792x_phy *phy = &dev->phy;
 
+	if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+		return;
+
 	del_timer_sync(&phy->roc_timer);
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



