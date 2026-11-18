Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041033;
	b=kyEZ8C4zPro3WYjtcgOVUfkEzK2mGdr8Yp/xoj9uz0x+MNITaockLzNRmCeXoMZVizHK
	 7MS54wc6vin9XuVJLWAKxMkYImEY5czzLpFu9Sx6wpf+NqPErwZIEpX0dPjzQgFaBFCX/
	 dXVfdwPHeIIZyn2o/lZsT4n3+9k+aAysBzxDwgDim+DzONioHFPJtLEdMemDPUD+rqsko
	 TVOrjaSTjwmvtyRloIHJTtMY8WzHdbYZXUSrD98lsOwLPUS4T8IXSGYq0f5ozMGMGA6kZ
	 giq8AH/RAsbtSWuo/kgk2CXslBBFpEgM2s5RG31egtLosxC+4wvyU10CciTz4O6MgHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0g95S29jZb0o/bk0IWEYBODfDnVhhXdw/1t3NI/oau8=;
	b=ZU+dNC+wcnmh20Cuaz8NTB1b64xjCVlpW2PG2B3rLtlZeEITCSETsgUuJReO8WCClNZm
	 hlcKkBOjijcNuPcsi5gApShj0CN2ndzsF5d7EjdE3SCANpOR7p++lr6Q/rzrGhgTfMYkT
	 zJj/ioI1Q1Xp9jwELoqdZtBf7JIIVFmDtaas8CQ/fuUWm+8hnIpDj7RafLJnDEQ9sA7yE
	 af9BwM3j6NNeoaQX6WlMG74AyDMTKoWXNuQfFDpLRfkK/HVg4LOeZjKYs0lI1MZJtNQXc
	 cTvc4yIrXvjawQ0OSlBqONLuCil6wQiA1uEpS1UCdtlMomLpLnpaQP0GfvF9RQWVyHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDBVPqIG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5C7606A320;
	Wed, 18 Nov 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDBVPqIG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B31F000C4;
	Wed, 18 Nov 2026 22:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041033;
	bh=0g95S29jZb0o/bk0IWEYBODfDnVhhXdw/1t3NI/oau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDBVPqIGJgv/EaxPECYAn3h6YmZXCIR8scEsBAf+qJ8QIWjcha9ZXJVYpKIbg9eWF
	 zhCcLzvx40+Kw9yFePF3ZK10E8EdT8etQ+b4GccOsDrH99zptUQbbDTlCS/knlaCFQ
	 jCaTlH9n53exqZNYkM3WqhzoHFzlUutSppzbrfmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2667/3318] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150441.025415974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5ee2bb6f679b..441d461e76787 100644
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



