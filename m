Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1D81F4177;
	Mon, 18 Aug 2025 13:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523699; cv=none; b=QYHn05WHH62ki7supC5n3DrH4jaeLztcFNHTk9o+RAs6kUC/hXTI7GnQ6M9yTZ8jFVe3UbPgoBqCcDqfGrzVjE0wC5ERfEyHwDjGMZxPuIAuhnqfmLx+Qi6mbAvhNqAPkxJz6fvq77VQlMMcus+1T2/SYywX8RQbhZLOhXH6Ql4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523699; c=relaxed/simple;
	bh=OTIVHT15XlOmKUFFRrxO9sLxoJGoFdfFnN/99CUIbGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia8crUiYoLm52Qst716scnQ/WYt4I4Q26BSHQT6kxFHTE5alfJDY5PB16h50G+ARyBFOwc5PshnDnIbJXCN7RhuHyzsnNNs5XAxXzcT2DGhy/mFk0v/bcom3BEKbBAF4nP7EV018z47YSv71cKXlZCEX1syYWc7NrZdtwO9zpZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8wx0YS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8wx0YS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0799EC4CEEB;
	Mon, 18 Aug 2025 13:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523699;
	bh=OTIVHT15XlOmKUFFRrxO9sLxoJGoFdfFnN/99CUIbGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8wx0YS6u82TyE9Gzzv5UIZejMt5WPjS5+lEjdtW5aY7h3y40j3dxHak3gyaWgibY
	 ALq55JFrh5G/pP0x5woZ+MHFuDk3iiVUYRAgDwl7OR4mlebBZ5OWmaJJmWfJmLWe7d
	 pmMKnsDblQpOpBVeClc7XIdlSD5zAB5+Jzsd26jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 250/515] wifi: mt76: mt7996: Fix mlink lookup in mt7996_tx_prepare_skb
Date: Mon, 18 Aug 2025 14:43:56 +0200
Message-ID: <20250818124508.019041667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 59ea7af6f9ce218b86f9f46520819247c3a5f97b ]

Use proper link_id in mt7996_tx_prepare_skb routine for mlink lookup.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-5-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 3646806088e9..8f8c31042843 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1059,9 +1059,9 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		if (wcid->offchannel)
 			mlink = rcu_dereference(mvif->mt76.offchannel_link);
 		if (!mlink)
-			mlink = &mvif->deflink.mt76;
+			mlink = rcu_dereference(mvif->mt76.link[wcid->link_id]);
 
-		txp->fw.bss_idx = mlink->idx;
+		txp->fw.bss_idx = mlink ? mlink->idx : mvif->deflink.mt76.idx;
 	}
 
 	txp->fw.token = cpu_to_le16(id);
-- 
2.39.5



