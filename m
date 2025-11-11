Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E353431E6;
	Tue, 11 Nov 2025 01:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824652; cv=none; b=oYKvYVtorYLBfhH8Mej33TWiDZkPb+nQR6oT9/u54KQSwuvzSfJvQrymStT+dBMGHbE9xB4FIfqGy43y0/5gmjIAGpjxW6OzQl2KLS1t9MGmCZOAKlSfdK1/AKcYF4J6vyADwsAG+F71nv7XO094cJ0jJKo8wqpXGJoZqMRAOus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824652; c=relaxed/simple;
	bh=X/pBxV5DpceVL762Tafd7ON19gQ+7Eq4VTq/PAnE+cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERlpaIDANozpR+aEiOuDsIkefw3FeYHhu2nD9H5HsZQQkfG7X0EmvGIiwoNgYNaQHQH7emD8QsSEkO4u1QBJ738b1FVsHI+fapORKcI9BfRNKvfftz1mqVWPfPekCWErMmPNUjf7qH+jTN0TjCh3XIGQdvPon2S3Rbh4OiMbvfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD+Jbp19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD+Jbp19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F06C19424;
	Tue, 11 Nov 2025 01:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824652;
	bh=X/pBxV5DpceVL762Tafd7ON19gQ+7Eq4VTq/PAnE+cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD+Jbp19y2z4QayUPCK0wMS+oizImYzfXGoH5vLtvhy8wvM5i5hXSgNs310EmRXAM
	 t86Krxq2eK9EBtO9r9eKf2NfJkY7YQ+GO/Ib26e8WITPP+KpcvqmZ0gj11D/nMVnQ6
	 yAhO0aVSavTMWqOlAYkkphIPptfQCwIcouZnTLnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 544/849] wifi: mt76: mt7996: fix memory leak on mt7996_mcu_sta_key_tlv error
Date: Tue, 11 Nov 2025 09:41:54 +0900
Message-ID: <20251111004549.562383947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index aad58f7831c7b..0d688ec5a8163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2535,8 +2535,10 @@ int mt7996_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
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



