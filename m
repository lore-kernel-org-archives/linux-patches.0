Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025810;
	b=wkfAVJSA6rchw/UxQExE2mZ8aoC74YS2AU6y4rJxQnWpTE8+muLntY3h3zgQyK7O7+Hk
	 gtVZ1/NQxjz0l1gC5+4/70Bh8+JbohUzLNZd6A9zXxRbD77rahYfPaH4NcHpIkViF7D86
	 hOPFO5OEki6xlg3nOh1aPhByL43l6vy0X4RwX3caPk2sowhyo8MYc5wZeY7v7mg7vICY9
	 DCyT7jr3Cpjx9FJf8i+EKGTLOvq5WJopwPDlSo2fDB1tzqnC+HAugSlxQ1+ip0n7U2CDw
	 ZLFZyoNREw2CtoPPzZeeh/5MlTbgwHxwgyQ8UeSMFG/JglffoOrlApisBohLrUtD86w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeP2gChliOLVhqE1+ed0Y1UKbaFNwSKZnitJfZMRHOg=;
	b=waA/mOBxD5NxPQDZEcVNCkDr6u803UJDrnMOqmMMV0nH9ojxcUFMfuovGeXwBf3TIZf9
	 iB0OzQN1cM806+trgECtZr9vvQSSxz/CKpnUro7PGZ3PJ6LmUl8q2GOGbD6pxxKGHYpQw
	 p7IAwAaOWLDwOFyHjiRydhic8X4jqi2t/e2sKC9End+fYhggIL7y4h4UWtVSzMVYXRDLD
	 teR69oRi1vyiE9yn0vxyAJS9I2bJKvixGC9hjVkMIVLyixJXbu5QHYwl1r7lVq9Sur9ya
	 20yTcc1gbp/6b612RleVPfty4xuGzlV3hn0UwjffbqCMnHvIokNlK9ziZ8J0Ke9GIvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Szl/OBXj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7473606A31C;
	Wed, 18 Nov 2026 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Szl/OBXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB191F000C4;
	Wed, 18 Nov 2026 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025809;
	bh=YeP2gChliOLVhqE1+ed0Y1UKbaFNwSKZnitJfZMRHOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Szl/OBXjMEjdPIzbv8Jb3Ic7gzOad0WY8cu7XWkfq5UuBWqdBK/YxnjvY96IM6Dnz
	 SL3vpb5bWWAJ0JHXWc2LWqhHBRh2mVhfZ2Ro/N3a8fcxsBDhF4gNWTnmKKK40whb2s
	 pN2o655g/Lz6VlYVRyKb0YHLTnLnZcF26K8qcZ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1212/2151] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:49:07 +0100
Message-ID: <20261118150206.351743018@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit baf375ca58eaa24503f9febac75c056852694c3a ]

The RX descriptor provides L2 and PN padding lengths that are used to
locate the CCMP IV and determine how many bytes to remove from the packet.
These lengths are not checked against the received skb length before the
IV is read or mt76x02_remove_hdr_pad() is called.

Reject frames whose IV does not fit within the skb or whose header padding
would extend past the end of the skb.

Fixes: 30ce7f4456ae ("mt76: validate rx CCMP PN")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925152754.2323624-1-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index eef131c05f763..c8ee5595c2a4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -816,9 +816,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
 	if (pn_len) {
-		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
-		u8 *data = skb->data + offset;
+		unsigned int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
+		u8 *data;
 
+		if (offset + 8 > skb->len)
+			return -EINVAL;
+
+		data = skb->data + offset;
 		status->iv[0] = data[7];
 		status->iv[1] = data[6];
 		status->iv[2] = data[5];
@@ -838,6 +842,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
+	if (pad_len + ieee80211_get_hdrlen_from_skb(skb) > skb->len)
+		return -EINVAL;
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-- 
2.53.0



