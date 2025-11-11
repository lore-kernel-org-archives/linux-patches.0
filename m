Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51266337BAE;
	Tue, 11 Nov 2025 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823968; cv=none; b=VNW0scgYRaW11QNePbRALAByc/J9WAxuaiXjYHogyxdtGXTVUFhgibL4msYySNieQRG32pLx8SOcAbNkxf+zlCzSiqs4VnO82SZW4pdWw8X4ekw9LC4XhSg87HtJ9dBS7JyoQmYHcuRl4Kk77lWzLvsnAAEcTJ6I7G6757yu+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823968; c=relaxed/simple;
	bh=0fb2+hXRUm+CfSCZXhTLlFsLc4iAHS/Ps0UShTU+KUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtprq7zB+gKv3G0hP2WgJ7NatoPP/Xsx7h87bRnt4g0FaBzBHgvf724LRKa0UzJrHQ4qu4iOfxZ4sjjMTUeHwNVxDBUmmC41HiwQzlc1gD4Fb+//KILRw9BBjDjvRAqSjJ97wYSiegj8eNtQvkedyTSFsm7UTxxG/rXAGuGxXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dl4Cv9Y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dl4Cv9Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D735AC16AAE;
	Tue, 11 Nov 2025 01:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823968;
	bh=0fb2+hXRUm+CfSCZXhTLlFsLc4iAHS/Ps0UShTU+KUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl4Cv9Y/jv8QsPiKR54dXep9K2QbAZ1SzSMAwEKSDlOdfiGARHFrERlqbca29XJFj
	 Z+PymkkLA+ydM7RD7Giq01G1IQoWxd7Ne8YQLl7Jz9tlY5p8UUMzu6Y0CxgKOul5Cv
	 VmYo0/d8c2ATAyfFSAyukA4GTM5bA5QjwzAutMAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/565] wifi: mt76: mt7996: fix memory leak on mt7996_mcu_sta_key_tlv error
Date: Tue, 11 Nov 2025 09:43:35 +0900
Message-ID: <20251111004534.944333527@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7c0f63fe37a5da2c13fc35c89053b31be8ead895 ]

Free the allocated skb on error

Link: https://patch.msgid.link/20250915075910.47558-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 5f5544b6214cd..8738e4b645420 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2283,8 +2283,10 @@ int mt7996_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		return PTR_ERR(skb);
 
 	ret = mt7996_mcu_sta_key_tlv(wcid, skb, key, cmd);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
-- 
2.51.0



