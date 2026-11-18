Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055895;
	b=fOnYrcLzSukQkQhYPShtalKlyrdkm33x1WYVqvMlwXrs3GDs/fGTwRSfdVlT+T1ePjwW
	 xHSiKV/zEbUFI2KQoGBXDR7i2Huyg6g8Quw9JyvXQ5bL9ieLY0p/984oJ2kK1f3NwziB6
	 LR9TrNlU0RFez2CqKF3OOCpry7hyMiNHYFnEEkPUhkSwllT5YIMUsC3+6kT9VdCt5ZZQt
	 sNQn4MQP8IBr88ZGeNtgLXu7CE4GDYZ7zps1QFrGmusDu8df+J4Y09ND7eOukeFKIHDwI
	 9kI4UzGcIFqiNZsTz48AN5+A18ljWy44QHr2rmkkGXsJbb4HiviL2eY7fg3i4g8vQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k44nMSQV7fW4iUDJsc41Cd1cjNkBqLpcqhcgEjGkFhw=;
	b=j7VJLp6E6/bd+bJFlcKOlnurS9B1Qb4vJ9e1gfoBdk3p7QFsQV4ye98+IIytaG1+du/F
	 jMYuV59S9IRclA/8HDpq+yQuuZZG2+2iby55j/HjJrX99ZW00vNi8JxRQR3FGrCggUhe9
	 WWuA5elN5u0vEZMHZu1b5nobKoIqSwW3Ae1tfHtDczXW2jHm5n/qbw7QkDtL2p4fBQ/O8
	 xRx1HFHk0CFN6GkBedqWsWx57TZRy4dDRiwm45FFzMVDr5bdZElyWAW7YluWDY6PPFZTg
	 6rJB2zghN2o0E47tMcEMsMJ3csbA0Y6klt+2+95mA45MfofPWeF/i9KJ+XT+1KfRkXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obInYQ1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F79E606A31C;
	Thu, 19 Nov 2026 02:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obInYQ1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BCA1F000C4;
	Thu, 19 Nov 2026 02:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055895;
	bh=k44nMSQV7fW4iUDJsc41Cd1cjNkBqLpcqhcgEjGkFhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obInYQ1Sh1BwWt+vIOubLjBJVP6g2zeeiBv7TKZdSf1rYfk8m7IG1yKUeU1WcV4uA
	 SIufow6Cw09kYXu4WuyLA1ZJzfX6zppXMnVzd1IlNWUhr1Nartpe3c8sQiVdRVcYEl
	 LR6A0kL9Mi0slHGNGPgzZoWfR2e+qIavLOkUn3L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1794/2214] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:57:50 +0100
Message-ID: <20261118150123.269106428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d277dc1db8ef3..6249f3b9bf109 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -818,9 +818,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
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
@@ -840,6 +844,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
+	if (pad_len + ieee80211_get_hdrlen_from_skb(skb) > skb->len)
+		return -EINVAL;
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-- 
2.53.0



