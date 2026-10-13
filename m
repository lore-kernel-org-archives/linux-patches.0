Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38BA4EB879;
	Tue, 13 Oct 2026 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894455; cv=none; b=lnsPYK/tli8dCrrLE72NluWM6v+eYZLKzpZd9zYCwL/qT/HPuFjECsyMaH1bwG+RTsS9if9UH7g0H6ueIP87VwjtwrLpoedLBKb1ZBDwwNT291YCNZ9R6p1OZdx9Yuoj6Qqc7TMaYMNbEiV5qjNZ2Cu2LzAsXuVhEn8OAQBOc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894455; c=relaxed/simple;
	bh=rnNVKZf0J2SIEg1UxvdxIzwxgAcZA6HczuHkMxvQm2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFMdGNdzgjucXYXmCTnz3B5A7bfufr+Pu/kXiCSCDGRR0zmSW9yOr+v4ZaqBzG43Ita3LLbkd5h0RKIhbs2sNkb/5FgLne3Z0skClXsn+rcyXyyAJRvLesQAw6+4174AN5XZypgY6yNxgliQJEvKQ0JJskICwgjvGo9oJC+o2kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPbIqnzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPbIqnzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040821F00893;
	Tue, 13 Oct 2026 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894454;
	bh=2VZjRzy3DBW/WDVaK2ep+gmD90GAeX2AzU433SpLUq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPbIqnzIvZ1WO+pMt7ckz7wIxYdcHD/m1SQ5P1OWuSXxGMm/VawbZiksIEjFXgeCW
	 tAo9UWN2IlbcVkA5niUbksiUSESzMBEQkI30ZdqmnV+xvnomubEZAsZTHJNYNRKvcu
	 +AVxVv0waZiWJT6nOFWXYjxw6+LetXFKN7+YLoTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/621] wifi: mt76: route nullfunc frames to PSD/ALTX queue
Date: Tue, 13 Oct 2026 13:39:20 +0200
Message-ID: <20261013112934.215660784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 331e766e75d2a64b5c1f38aadfcfcf31d264f43e ]

ieee80211_is_data() returns true for nullfunc/QoS-nullfunc frames, so
they bypass the PSD queue routing and go through the regular VO data
queue. This means firmware processes them through the normal TID queue
instead of the ALTX queue, which doesn't guarantee immediate
transmission.

Use ieee80211_is_data_present() instead, which returns false for both
management frames and nullfunc/QoS-nullfunc (no payload), routing them
to MT_TXQ_PSD. Firmware maps PSD to the ALTX queue, which transmits
immediately without PS buffering.

This only affects frames from the mt76_tx() pending path. Regular
mac80211 TXQ scheduling is unchanged.

Link: https://patch.msgid.link/20260309060730.87840-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 7c2e6b43c308 ("wifi: mt76: use ALTX queue for packets to disassociated stations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 8ed0ea3ea03d9..8af03dfd9e764 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -671,7 +671,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 
 		if ((dev->drv->drv_flags & MT_DRV_HW_MGMT_TXQ) &&
 		    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
-		    !ieee80211_is_data(hdr->frame_control) &&
+		    !ieee80211_is_data_present(hdr->frame_control) &&
 		    (!ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
 		     ieee80211_is_disassoc(hdr->frame_control) ||
-- 
2.53.0



