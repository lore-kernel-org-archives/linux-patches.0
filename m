Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028025;
	b=WPeW5fBcj2sSFnbnOnJNFEv1hE0fuwDRBG9Qq9NqUWtmXMKjkuel93KvBu9qFr0kg6j8
	 kjgU2bbza9q9QYhdcIW0HymV+xDOyeyU05WzxGrki1tHEaHaqZ3XnwKe82ucz6BftsN16
	 /ZplejYOfaw35Tf8ml5+UaPK1ogOQWVppWR5a0qIoCSFx+FGjaEKK1Qj+k/0OhRIAzxFe
	 a/rxtG5ojTohMeZrBREi4bVCt/dEAaW4xPSfhWIXcgNHiz2Cj/a6dleIPPqCTTc4xPChm
	 cqWV61J5WuZ8zAq89BrOZhkHXPrniBgab7+mCndyRHPKMP1pA/orQ6GPrbdzzVdccXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSZocNDO1E/oMne/qRacpNzMCGx3vkvmu+tJic+ApIs=;
	b=nOHc14YaypkLMMhMMhrqxckkO8p6HQgwFci775a/7G2rG0UbKNbUrNicg/5t3RJQf6Eg
	 D4XXr5NytDDj7p22Glqgqgm2SEasQLoUzqt4dEuxbvJvUoOdG0zVQko6htzF9j2r3Hnpe
	 rK48QP0AtiryEcdXwJ6hTJcouRIH7cr2jyxyrDzt51FF/0JKORLnYw2vKaWnUGrB2zDyE
	 Vj86UptfrMS1TggBAXErknXH0weZ+xAdWoUM7ScGXWiAhuHfurS6vxtoK3VFTiVgsBtrF
	 ljz7cTsS63NV7GLMh8TJAyZsAmXCWCyREWpK4OIXAy1xdCjhs+6XC2BsGb2qmBvM0Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVluj41P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949B0606A320;
	Wed, 18 Nov 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVluj41P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54C81F000C4;
	Wed, 18 Nov 2026 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028025;
	bh=zSZocNDO1E/oMne/qRacpNzMCGx3vkvmu+tJic+ApIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVluj41P71ppLJho2pTbfcrzLltxWqvBf/iAN2nQ7zouC6kXAxV8iG3Rbr9eQAH4e
	 Zantv3TKLR7P7bDEY3hoISlUFpMUQB8bp5SK6QwiPRqtXjctCfZBVWCC/t+zy7BqZl
	 JadGEpNs1MkJeFq9GCqrCPCioFcIeQLA95pL6XEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1996/2151] net: lan966x: do not inject uninitialised bytes past skb->len
Date: Wed, 18 Nov 2026 16:02:11 +0100
Message-ID: <20261118150234.434163489@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit b4a7180558eb3cd8affa1e240b22171425bdfcb4 ]

lan966x_port_ifh_xmit() writes the frame to the injection FIFO one
32-bit word at a time, and pads frames shorter than 60 bytes with zero
words.

Before this patch, the last word is loaded whole even when skb->len is
not a multiple of four, so 1 to 3 bytes past the end of the frame are
read. For a frame shorter than 60 bytes those bytes are also
transmitted, as VLD_BYTES marks the whole last word valid and the
padding starts at the next word.

Write the trailing bytes from a zeroed word. The number of words written
and VLD_BYTES are unchanged.

Found by an AI code review agent. Reproduced on a lan9668 board with
register injection, by sending a
57 byte frame and capturing it on the link partner: byte 57 of the
padded frame was not zero. With the fix all padding bytes are zero.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261026-lan966x-inject-tail-bytes-v1-1-51d599a48313@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1179a6e127c52..e576bc7c6deed 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -253,9 +253,8 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 		lan_wr((__force u32)ifh[i], lan966x, QS_INJ_WR(grp));
 	}
 
-	/* Write frame */
-	count = DIV_ROUND_UP(skb->len, 4);
-	last = skb->len % 4;
+	/* Write the whole words of the frame */
+	count = skb->len / 4;
 	for (i = 0; i < count; ++i) {
 		/* Wait until the fifo is ready */
 		err = lan966x_port_inj_ready(lan966x, grp);
@@ -265,6 +264,20 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 		lan_wr(((u32 *)skb->data)[i], lan966x, QS_INJ_WR(grp));
 	}
 
+	/* Write the last 1 to 3 bytes, zero padded to a whole word */
+	last = skb->len % 4;
+	if (last) {
+		/* Wait until the fifo is ready */
+		err = lan966x_port_inj_ready(lan966x, grp);
+		if (err)
+			goto err;
+
+		val = 0;
+		memcpy(&val, skb->data + count * 4, last);
+		lan_wr(val, lan966x, QS_INJ_WR(grp));
+		++i;
+	}
+
 	/* Add padding */
 	while (i < (LAN966X_BUFFER_MIN_SZ / 4)) {
 		/* Wait until the fifo is ready */
-- 
2.53.0



