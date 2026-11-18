Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019015;
	b=T/UyNG9QIdog8FYpso2PHFBxa0dexMasbRMqbg/pc146PgkeFImqOwFW7bH9M9N/6w2G
	 jfEi4Ka5ocz3/Hy7Fj1ZzxYXht6V38Xlhs3sH1392P2mEx+sHzhMBCB88z6yEqRdioVfR
	 HJpRkfzwZLWhBzAgA8M92aLFvDv+z+ign5VLhNVM90jFmSTPrzXa6tHTS7MxQ3+jEB3ks
	 dbOdqsQlcr84tPlRpwSh/NFof6br09e3fVgJdiVsAMVPDpQxKWIcbwtg7t0oQnR2BiN5J
	 UHT2/Idu7LzQ9Cxfg9MB0ngzn3oNw0wtKu1Muz9hD25mrpZrZpQ+SBHVvbG5LibOQFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PIadoqDV84S7wuWequWIOEewZj8ufy6rYkCb2G4299Y=;
	b=WFO84OYqRfXMlqLxL7rK+RpYYd4pIevRyA4hZa2ncrDgTBKvnDJ3DARpDELdjJRo1e7T
	 KK9huD/a5W20KK2BE0FTjs7SJvR3pQOSbDSjfZhTUX4DOVROJw8HATV/pMxnRDNxsBwyA
	 xHj1mL18N1PiLh1NaGDDepcBtaO6SggzibcxkbLmzy7bOZrwY4sVXI34+ep0fZgOummxa
	 LnwSsRuzZvkmzuB/+fj4ACT+E7EuL9/w88gyGF60ZK1KR25xugnFUHEzd/Fsc/ZG+rqz+
	 UTZv36lGgqAulSNXq34iXIXB5lF8fDh66zjQVB+xCAy1HndGOxl0XzgtFjqyh502Pww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lF3ytgiX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B0A60A2600;
	Wed, 18 Nov 2026 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lF3ytgiX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFC91F000C6;
	Wed, 18 Nov 2026 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019015;
	bh=PIadoqDV84S7wuWequWIOEewZj8ufy6rYkCb2G4299Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lF3ytgiXXNNCN+Gyc5rzT8ZdkIeBrkdQ2guchCNtzk3xXaUKpXmFyx3HPnDOi1IPn
	 gyuajwx+2e4RZw4fAa1QZDRAqsGaWEV26KoOknTbXlxKmlXF8KtbcHtwQIjnkdV28k
	 MZ5H0vDuyU/co7J788DcQwlfQkBnQzl8lJgaXh94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1446/2651] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:44:46 +0100
Message-ID: <20261118150340.098938191@linuxfoundation.org>
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
index 231685bb62d2a..158aa356b7105 100644
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



