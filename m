Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041164;
	b=mZenyvQk09GP/vSuVrvcrL1Z+J81fsgGR0RF3CVqGzFxgUZuOJh0SsdSC23XkczBKK8L
	 S2rIKHH8c5GELS1WbxKUfO0LrM/EJZ/+8ufvAFAtm8PwhtVbtaoPypRqoCAQVe/zI5b/U
	 mZe2RU2TpuZz2cavsSbSylZ8yRed0cRlEc10efhlIiiZeJxFFg9bQr632ub1727rOQsB3
	 Ee+S3Huwn1sDS16hJZhudlqgLCLaBVhQkXOYHkah/wTUMIaR5od+CtKtjSObWb+jLJmk+
	 o1av2/liHsOzV6kcNclKJhj5kGnlx8uhIReOm2AgeW9gdro/6ekMDYqM+kHVVvMDOYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+DN92as2GBsmBpZCjbDJfa5P9+37YeneuquCalwwAOM=;
	b=gkdZWbWulq0tvTumLOZiaAyG8SVkobDuhbLEQ4EltJj4yrF0u0zXmfrxOh2hWs67ZDHg
	 2XXrkxhN1xtPyb/0RV2bjCny3pKtuZeJ2giQY0NcMEuFqgmaQKh3hEBMWgSVgqa/F41rv
	 jOgeuheuh8GCYxkRQ0AhjPnNs6Gbe9C6dEW84Crdzia1h7m/jhkqE7LY+x4VreFEDZDtF
	 QLKOvlRwQC2YYNfBrKBfPTGJmxI6RZl31oAxlJj1LpyuM9TxeQ2xE0JdAhkzjnoNDw56s
	 w81o3mNeX8kjS+NwZOgpyKwoSVda94uA28J9Je62nh9gKikNYAOyq41RIwTnei7mHGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FY9nAdcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB224606A32A;
	Wed, 18 Nov 2026 22:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FY9nAdcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE3D1F000C4;
	Wed, 18 Nov 2026 22:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041164;
	bh=+DN92as2GBsmBpZCjbDJfa5P9+37YeneuquCalwwAOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY9nAdcSP3WHhBpJfhf0cBpBx3pGnRaU0dXPqO2UNwGPyf6fCkdnnM/wTzmh694GH
	 xl6dj6BlnFspORRpvG4BXkO82Z09gboHyPhgZxeTqxunusJmo8zMzzBtImOipTrjv7
	 LyXWuiRgXAnpYOFPaO60ppcI4dxGEu7jMZTKOhjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2675/3318] wifi: mt76: mt7996: fix PLE free page and AC queue register offsets
Date: Wed, 18 Nov 2026 15:54:57 +0100
Message-ID: <20261118150441.249494874@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c33af2e4622baafc56c565a13823f6b89d3f50db ]

The PLE register map in the MediaTek vendor driver places the free
page counter, the free page head and tail, and the HIF group page status
at 0x3a0, 0x3a4 and 0x3a8. The driver reads them at 0x380, 0x384 and
0x388, and the vendor map has the band 1 TXCMD queue empty status at
0x388. The same map has 0x100 bytes per AC for the station queue empty
bitmaps, with the MT7992 extension register at offset 0x80. The driver
uses 0x80, which cannot hold the 34 registers per AC of MT7996, so the
hw-queues file reads AC1 to AC3 of a station from the wrong register.

Use the offsets of the vendor register map.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20261006205936.669125-25-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index 97beab924517b..8d762076a29ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -53,12 +53,12 @@ enum base_rev {
 #define MT_FL_Q2_CTRL				MT_PLE(0x3e8)
 #define MT_FL_Q3_CTRL				MT_PLE(0x3ec)
 
-#define MT_PLE_FREEPG_CNT			MT_PLE(0x380)
-#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x384)
+#define MT_PLE_FREEPG_CNT			MT_PLE(0x3a0)
+#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x3a4)
 #define MT_PLE_PG_HIF_GROUP			MT_PLE(0x00c)
-#define MT_PLE_HIF_PG_INFO			MT_PLE(0x388)
+#define MT_PLE_HIF_PG_INFO			MT_PLE(0x3a8)
 
-#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 +	0x80 * (ac) + ((n) << 2))
+#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 + 0x100 * (ac) + ((n) << 2))
 #define MT_PLE_AMSDU_PACK_MSDU_CNT(n)		MT_PLE(0x10e0 + ((n) << 2))
 
 /* WF MDP TOP */
-- 
2.53.0



