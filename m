Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061366;
	b=T9lzDOnfVptEyfvgNU2iNC955k9LyM+8bsVw4N7HlyiVsje9AGxs+nQLZS9Nqdri+kH1
	 u1Dprat3xn7wBuWITHKQyt++3FZytzU1KmkbcY7Nu1d2eOjWLHETjupyMDzfkm19vjwe5
	 glzcFvKDs317C4GXaeC+gY7OuGWONJU2BCQJrMD7qt5+qbfH1b4MSCaKPeBj/uMOIHzXu
	 YYLiXPufqGmUIXVzhteClLkgTV/4F+pKrnrQzTvJmMnMG+iljr+XTAdfuKNN+TU5UeOcM
	 kYyD+lnP7nQIiCj2JtznuAZakCPYaxvW+mKuZolBF592B4SlUVZ/AD9VPGE4tIJtFLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOFL4pKTmRbFVsnJFQJUIqY4c8SKcxqAiAznEjW4+d0=;
	b=NmNUsWXKU2u/JZyDGWG1+zqB953VbWLjiWK/MV26bwY1CaFfKCUfQs1rl+ZruPVL6IN5
	 AHuvq/2Vxl4KVyKYnP6jH2arSPjQRrLZc5S82/2sr7nPbBXNyw5MF08f3MB5hHOkm1+LF
	 98uHqn4V1u1t5NPfFcoZpBRBld80/OqMib064icnp8T78ULXM1wFVor1N6/KVSX1m3RsG
	 X5KRhV1niQ3674NjE51CHInpi0hBDOUj6GlQ+jU+s2w0zxq99jsrdB1Qu4UGI3NC2OOZu
	 sJZg7nlhf6jjaLScr/wi+o8MPABUISLpdWXumClH2MT0bcqcCqaG89RYlBzhRmOoFjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzPExYNe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C253606A320;
	Thu, 19 Nov 2026 04:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzPExYNe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2171F000C4;
	Thu, 19 Nov 2026 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061366;
	bh=qOFL4pKTmRbFVsnJFQJUIqY4c8SKcxqAiAznEjW4+d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzPExYNeXcsJv4fCtybm7l78I13otanvmLDJ9Q6atZqkg+UeeWM3kDBGdqyI9U23g
	 mnq9A148Tg8V4nQpOgYsdVv/dfEUvrFw+u43Bvog9By2e2hHH8B/fY0pi+INYwV00p
	 y3CVnxHrS2vdJtQkqWtaLKvdqlXL81OAVahWaHYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1527/1848] wifi: mt76: mt76x02: validate RX padding before use
Date: Wed, 18 Nov 2026 15:59:25 +0100
Message-ID: <20261118150023.328301192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cf050ce03c538..15f2f4691f2aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -814,9 +814,13 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
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
@@ -836,6 +840,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
+	if (pad_len + ieee80211_get_hdrlen_from_skb(skb) > skb->len)
+		return -EINVAL;
+
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-- 
2.53.0



