Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704216;
	b=0D940f8Gy5gUtMx1/eVRyEr9kUXC9N6DqwjHVbtl8NB2zKx+HsVXWxPpA3n+aaqaXQUf
	 8UqxRbcYaZApkkjjQj5srDsH8MnswcX5mfuNpkwIM624kOLLPdEoEmxNV7APA5n2eT9j6
	 c9DYVnFOabQdAgJtIFf66vgWg00AjlGzf2PinfEYCJPq4FUA4ovjkjZJBe1+Muzg6kLz7
	 9QSM+PXVI5vMnab8izikg3jrTMVJjfpzWZaOAbJzgBMOsGu71AwSot2Z+qWXMfxTkc1BE
	 iPQSPI1vJkCooWJ3+OggGq6zBx9WKWRIeWcewzl8np4kJP/W8Cy/pFJzEsyt/WbzjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mfh0pAm0iCB3NMWJ7Bgpbkj/uoill+a0VZemlZ7DlIw=;
	b=UUL4MciXkgeIWw3rwiQVRye7peTuZOOGV31M69FLMFJS1V+Tq70thYk54IW0g4erdaKT
	 4NncbvF8iWuFTJOs4vYcbBHBMwC/p1ACZqt1uOKMHyVHi+NmxMI5qNxRYPGghh+IRlQS3
	 lmiRtLLC8UD0X90N9aSpVhHrxn+f2ChlIuMOgksnDVdOr6et9sxhbtcNJKDKWlfEHntHF
	 7AIxiodiLyBhY9JWowJlbP0UuBeZvT8LdJ6Mr56McpfikOu28svhrryetg21TWhIWIbgX
	 Tf2iUsc7BN4w3NZMiC/gFgNnFyHw5rdrXWeYQP6jatUJ3NotrpXMuK32TTr0Lu2csvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GBkGh8/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA7E606A31C;
	Thu, 26 Nov 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBkGh8/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47751F000C4;
	Thu, 26 Nov 2026 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704216;
	bh=Mfh0pAm0iCB3NMWJ7Bgpbkj/uoill+a0VZemlZ7DlIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBkGh8/OuXBdvEjLbrcpQN24fLoxUlEd7w4COh6N+nWlx0sa2oBT/70nF+vItCRxA
	 CkPc7sXtNBxjp+SFpswK41aIkV7heo7bOtlTIj7ozpAz6u2Ksw2gSzOJ9ayJeUp4cI
	 g8eWPBUGitxbjK3LCx7sd88QTLW9SBxkji2GsqNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/265] mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()
Date: Thu, 26 Nov 2026 15:35:35 +0100
Message-ID: <20261126143605.452962649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

commit 53d1548612670aa8b5d89745116cc33d9d172863 upstream.

In mt7615_mcu_wtbl_sta_add(), an skb sskb is allocated. If the
subsequent call to mt76_connac_mcu_alloc_wtbl_req() fails, the function
returns an error without freeing sskb, leading to a memory leak.

Fix this by calling dev_kfree_skb() on sskb in the error handling path
to ensure it is properly released.

Fixes: 99c457d902cf9 ("mt76: mt7615: move mt7615_mcu_set_bmc to mt7615_mcu_ops")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251113062415.103611-1-zilin@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 6ed470050632c..4244b8488a099 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1378,8 +1378,10 @@ mt7615_mcu_wtbl_sta_add(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 
 	wtbl_hdr = mt7615_mcu_alloc_wtbl_req(dev, msta, WTBL_RESET_AND_SET,
 					     NULL, &wskb);
-	if (IS_ERR(wtbl_hdr))
+	if (IS_ERR(wtbl_hdr)) {
+		dev_kfree_skb(sskb);
 		return PTR_ERR(wtbl_hdr);
+	}
 
 	if (enable) {
 		mt7615_mcu_wtbl_generic_tlv(wskb, vif, sta, NULL, wtbl_hdr);
-- 
2.53.0



