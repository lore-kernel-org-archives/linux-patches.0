Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025748;
	b=JwY/BQnmz4alEIpPPCaNixWo2AVKk3/86mqsiMdXVeEKi+VdWm2OIwkbGDCRKgnltwJI
	 /NSJ79ctHwhRsiVKTc/CQ4Kgtw5aQLn7Yk3EZRieHXpQ5aAXJ9q552ZE/UUim0lfMmOF/
	 /fmFvkCFdqthvo1HkvrwKk2zVETXwJKM0cezrPDrZmB9nSUg+7JvZoPoy27NqK+AlpZRp
	 ETgrQ9F0FjcUP0aZjLylLGO4YvUaGByhhYih2GOAFs1xceBCPa7jAsLMtvkfEdX9mLblZ
	 QvNLOsab8KwMZtSgwEe/oPdDm5QV/y/GWgn3snmLN/uOgTcOtt7XOH7H/fhyjnNZKQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vdZ94QFtrcr15VHqKUdwFVnZbqNa2raV5aghqlX2A3s=;
	b=x5HlAsB7sNR+7Qseb2vYAO0//88c00UgMykCRtnmA95shQqXUoV7wbplMpSdoBZLl7JW
	 UJXmmKBdTWj/2Ue3xOn1G7MdFVao/mJ6R79VQ9vv5m9YDqgdDtNbuLw0B+qj2f18WYMZs
	 NT+ywzzG59+14NZlWq4K1iPrVcbcpCUhBXeGYkgmK1ePiIiX3z605IbLE4Nh9umcKPoT1
	 hOSZ36/cHIGal7EfaMNAnp9zxNeciyj6gMnY03WkDsQX8RvJRTlA1bUinCXVIehM+/xQ9
	 tKDPmNoIOTTOotB4+1AGzFxH6UQv+ezF60CstTbPtpWvX6g0Zt7jmoNZJ0eqwaXD8eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQu+IIxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CE3606A325;
	Wed, 18 Nov 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kQu+IIxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6251F000C4;
	Wed, 18 Nov 2026 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025748;
	bh=vdZ94QFtrcr15VHqKUdwFVnZbqNa2raV5aghqlX2A3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQu+IIxjaRgFWbTPKC8rwnLzYUEUGhPngmYMNzF5tQ4a+/sU0RkjLsMF7CmuHfCNA
	 lfp3/ahPZc1Q9at3/80I+GmcxBUl6t9iJMxq/l4ZB89TEm09veOZz+vzlWhltATlO1
	 yUGGtaG3A3lARNsaAFoXXsY20xUJdFN5nib8+T7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1188/2151] wifi: mt76: check the owner of a remain-on-channel request
Date: Wed, 18 Nov 2026 15:48:43 +0100
Message-ID: <20261118150205.503383436@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d6173b8b36e5cefc7cce34c31a0cc63fb3bd77f4 ]

mvif->roc_phy points to the phy of the request that started last for the
interface. That request can end, and the phy can start a request for a
different interface. The driver does not always clear the pointer.

Two callers trust the pointer:

- mt76_vif_cleanup() aborts the request on that phy when the driver removes
  the interface.
- mt76_cancel_remain_on_channel() aborts the request on that phy for the
  interface.

If the phy holds a request for a different interface, both callers abort the
wrong request. The request of the interface stays active. Its work then runs
after the driver removes the interface. The work tears the link down through
the freed bss_conf.

Compare phy->roc_vif with the interface in both callers before the abort.

Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Link: https://patch.msgid.link/20260818125825.395538-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 065e613289e02..57ef35f683187 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -421,7 +421,7 @@ int mt76_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	struct mt76_vif_data *mvif = mlink->mvif;
 	struct mt76_phy *phy = mvif->roc_phy;
 
-	if (!phy)
+	if (!phy || phy->roc_vif != vif)
 		return 0;
 
 	mt76_abort_roc(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 53c9cd0cfadb7..f44b7dd2a2e10 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -2099,7 +2099,7 @@ void mt76_vif_cleanup(struct mt76_dev *dev, struct ieee80211_vif *vif)
 
 	rcu_assign_pointer(mvif->link[0], NULL);
 	mt76_abort_scan(dev);
-	if (mvif->roc_phy)
+	if (mvif->roc_phy && mvif->roc_phy->roc_vif == vif)
 		mt76_abort_roc(mvif->roc_phy);
 }
 EXPORT_SYMBOL_GPL(mt76_vif_cleanup);
-- 
2.53.0



