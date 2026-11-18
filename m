Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042512;
	b=sMkV8lxvr1HQLQejBNdBfiPovfLwG71SOKnomxMBJMolG+p85psa4bXZj4YJYcsopP44
	 +UhXQi/8Wo69sD1vKt/9dCmxix9XCpj6qIuNcmC5O29FtRp3YmnaCbaVJupQGBMOOUvim
	 EFj8yLNdMMzaZqxG2rF9OlaENMaJfIAMhM5STG1jn9XOw4g/5kIDZjMkr9MZdK55Int/Y
	 VJGgNBVx8N4Xyl8z4m7SKOP+h/FTxUVCEJcYwO3Hw5dn2r8BX1O6TLkTa9B1mP9VMCRID
	 FPBUKPK3npxx31HylsKONIWhOSXuo1wcMxng+Hhs40iBYZifnJH6XOBPzrFZF62f77Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QG/J4wkxY+XruOzkYIuDDkTWnrXbawua0MQsFsn9ddo=;
	b=sbwZtUTe2FMotsw2I0km7yBfgMUrpkbEovDI5lHGGiYAXcb171Fcrws6rjxV2XahLiOD
	 TVVDOjG40B4fsjneWxYC60O7cIzcqT38x7MwaZScQgfWLdOriyt9jl4ixosQjiFMUtvSI
	 mNtQvlmSTQRVACAmuHukFx0rT7sYXZsj5GiIp7o4Wx87i2pllhGeSihzPXp6sRRzQVAjX
	 7PclCgCZMV6rcThRMDxqTI3ukgnV4ZpqNci9fNagMcFt1G5u8C0srEEUL6t1Hk6iGjZIV
	 ZQInAVOkVItac+/sWzCueR6vwBg/tZaNHcO2LSelwaypu22eCsRX6KIlqkTmIZrll5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wb+ZNSIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44B0606A32A;
	Wed, 18 Nov 2026 22:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wb+ZNSIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AAC1F000C4;
	Wed, 18 Nov 2026 22:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042512;
	bh=QG/J4wkxY+XruOzkYIuDDkTWnrXbawua0MQsFsn9ddo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wb+ZNSIUhZUB5e7LR0LhcE0pyldx3bYGBC+y5Xd5b0uJLjvLF6LuDdoruoyjGXz5n
	 v2on8mfBwMGEK+H0sKWSbtfKX5qRvHU/qt5Thu7/KIWVqXvGvhYuLtqP64LmbLkGbx
	 DcJnClMAWJQ+fYanlI0zafAIEgB1KZk0lgtF/g+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3195/3318] net: lan966x: do not inject uninitialised bytes past skb->len
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150455.625689890@linuxfoundation.org>
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
index ce48685a50b20..99d3ecae82628 100644
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



