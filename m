Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019051;
	b=knfXfox5bzCn/t5RG3uW9f8XYRJa+7d6CAPWwiu4y+9kh/1/QuxEHUVHyWSXo53UpZOi
	 Wo42AowAHdgv4OdrrgI4bzOgHpRUJ4mcbdcobL6zDTCUlp0JMCOzrEJFWYkIP7Lai/PgP
	 UZ0cYHUGLvH+DQMigAB5L61D2wttLrU7q3CTcpriNqRSU3evns2QtX1Jjz3wfWSCROBM2
	 jBZshdrN6HjnesHoHgWxMKb2AxHKR46DQBSYfU1evdlfxPYXW3IFSURwRF6kAhCRf9wC6
	 VA4SV0TbFhmyiUT+ejhAc297Z491NkGed3VYWi83LJJn2XzMpLaNQRWUxbhzfteb80w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=56wUsaa9DLsIkp2hi7is794Zjo2qb/cn8cPRs3y+Kkg=;
	b=Kv0qaLAGj5sqMyrgfFOoEwiHzB560aitLot1oxoSAWWpEsqHx9NHy3rSIr1VT6+PoWpb
	 bICd91mmgOUx54WzId2tUG0pRhekBL7lQ9zio3ZLSE1sHXojaDw07ld9EHGiZVlq7l+Zz
	 t66QLxYn5PAttxBTcyCq75phn2CHgfMKl1z4b2S2ygssD8dUJpisOTPrPQTGZzWgQCI5+
	 mM4+CtQaafOjX/kT7IksSm5Y2oZTBiQ8RWoJAWAWOaWH/iHvfIsRC1kY2KzARMGZSWY7w
	 P4L8bnBNuFfxRUGp+58p681rdRzlvi36rHLVCAvCOvoF1GuRtfQeiERUkaaOLFV8Y5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HttxRyk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D1606A31C;
	Wed, 18 Nov 2026 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HttxRyk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EFA1F000C4;
	Wed, 18 Nov 2026 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019051;
	bh=56wUsaa9DLsIkp2hi7is794Zjo2qb/cn8cPRs3y+Kkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HttxRyk1bAXUOZ0LoGb0+gXThCD/HGnDLJDJPqhDvEkOLyasRNZ45sdfpfJFBQqeW
	 RDy7uiCjm+Tx206iOb2eMapPpEwKdEDjAdMp4fYyE2/0+2LznpLLgyg4adtZMMwCIV
	 9qRsWXuZjAte7Km9s3Gc28TfYo1naVQ1g4aC6RVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1458/2651] wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()
Date: Wed, 18 Nov 2026 15:44:58 +0100
Message-ID: <20261118150340.524804718@linuxfoundation.org>
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

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 158c1145fe7ddd82914011a00de7cc3262616b16 ]

mt76_wcid_cleanup() releases dev->status_lock before calling
idr_destroy(&wcid->pktid) to tear down the pktid idr. Meanwhile,
mt76_tx_status_skb_add() from tx.c can concurrently insert into
that same idr during tx completion handling:

	spin_lock_bh(&dev->status_lock);

	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
			MT_PACKET_ID_MASK, GFP_ATOMIC);

Since idr_destroy() runs outside the lock, it can execute concurrently
with idr_alloc() on the same idr, corrupting its internal data
structures. Because idr nodes are freed through the generic slab
allocator, this corruption can resurface later as an unrelated-looking
crash anywhere in the kernel that happens to reuse the same freed
memory.

Fix this by calling idr_destroy() before releasing dev->status_lock,
so that the table teardown and any concurrent insertion are mutually
exclusive.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: bd1e3e7b693c ("mt76: introduce packet_id idr")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260820-mt76-pktid-idr-race-v1-1-451f176a6495@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 16b435b96d99b..9e6fab7b12229 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1758,9 +1758,8 @@ void mt76_wcid_cleanup(struct mt76_dev *dev, struct mt76_wcid *wcid)
 
 	mt76_tx_status_lock(dev, &list);
 	mt76_tx_status_skb_get(dev, wcid, -1, &list);
-	mt76_tx_status_unlock(dev, &list);
-
 	idr_destroy(&wcid->pktid);
+	mt76_tx_status_unlock(dev, &list);
 
 	/* Remove from sta_poll_list to prevent list corruption after reset.
 	 * Without this, mt76_reset_device() reinitializes sta_poll_list but
-- 
2.53.0



