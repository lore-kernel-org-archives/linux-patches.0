Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D6A2E62C9;
	Tue, 15 Jul 2025 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587026; cv=none; b=ssnj4uadegGWYhZtCFNcIVO7xwwdkYM6Inwqwpig6NdaT6AWCX/XU0e0QDxKD3iIXae0LPzhyLxbsyZFwDoUnlSh/Oy7SIqy13wZcDBOQb6tfnK3AqU+4SwmZg7Yn0Cw5mJ7c1idtv151CH3yf/s9caDmR6rmFyI3T+zyg/j6xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587026; c=relaxed/simple;
	bh=VIR0fUFezDzQrILquHMZWWUbW3CC5mmbEUfJ7suHiG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d562bQtZmFv5TSioGd3A5DCuxTmP9rbhENPw62W+Vs10v2NrdeYF6Mv4zJy5ajxtmhHxdkv9nO1F3wqQJC885lsWEkmbQIsVLxoZRhZdKUHZUBzhuxH4cti3sqIgqYZI56xe1G2eZWUdo5h8Jlr1NEFGGITRMjCVn9Q+vuGOPUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RflJP/bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RflJP/bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB788C4CEE3;
	Tue, 15 Jul 2025 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587026;
	bh=VIR0fUFezDzQrILquHMZWWUbW3CC5mmbEUfJ7suHiG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RflJP/bftck+/payGmgw+oB3I0yKs7tq/gY3saiQzHv1gZakcTyKky5nLiZCYAt2n
	 AV7LLOZwPU6tdYgomaBxQ2xqHn4uD28dGu7zQIJkJira2iVt+OJvA5No9YmBwfU267
	 IAWC6ravLZLPq1UJZ0czzNXCoe3xFtlOk0wuPp28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 139/192] wifi: mt76: Assume __mt76_connac_mcu_alloc_sta_req runs in atomic context
Date: Tue, 15 Jul 2025 15:13:54 +0200
Message-ID: <20250715130820.481129128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

[ Upstream commit a0c5eac9181025b6d65ff25c203a7f10274f80c1 ]

Rely on GFP_ATOMIC flag in __mt76_connac_mcu_alloc_sta_req since it can
run in atomic context. This is a preliminary patch to fix a 'sleep while
atomic' issue in mt7996_mac_sta_rc_work().

Fixes: 0762bdd30279 ("wifi: mt76: mt7996: rework mt7996_mac_sta_rc_work to support MLO")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250605-mt7996-sleep-while-atomic-v1-1-d46d15f9203c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 963970b8d1310..407df42f0f9b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -288,7 +288,7 @@ __mt76_connac_mcu_alloc_sta_req(struct mt76_dev *dev, struct mt76_vif_link *mvif
 
 	mt76_connac_mcu_get_wlan_idx(dev, wcid, &hdr.wlan_idx_lo,
 				     &hdr.wlan_idx_hi);
-	skb = mt76_mcu_msg_alloc(dev, NULL, len);
+	skb = __mt76_mcu_msg_alloc(dev, NULL, len, len, GFP_ATOMIC);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.39.5



