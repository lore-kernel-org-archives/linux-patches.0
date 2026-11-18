Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033080;
	b=ZSP124qlew/2zpesmiY3jkjRczQ/MdTKYq4EtKPdKPqXzVqEUcb/VpzeRVCIFq7c+LtX
	 1oP7w97cnrDFkYgJHyPt2chay2crm8BmetuGX2LsENp6C6XKmf20wEb4qXlQWLh+PTFZ2
	 oNovED1TnyA0SN9PQ3CygjM0XfFhU69NegvfJcOIoORUeYcmFUSSzn3A0hb5a3z5E6G3g
	 4cTKt5EYE0Mit4+1VnmTv3jWLX9xq6UGCIXPCUtqx8dJABKsKoVLurLxIrMGd3bOn0x7a
	 lsiSaGatABl//JwTFeOwpc3W4fovfuYJF8Bdw2z28vx7hBQXqGBtJry91Esivi4qbOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dizcLDebJqTp1e5WcMQ2vpuzdSLWeGQdnUrWItaWTUs=;
	b=y675vXv1daXZN/KjbY85D6jS1j6ruU0k7S1oDw53fUbPM8cdNhZfan6psPfboMimHBgx
	 j/GbzcVMNcxk4iOTzajoDLID9fY5clq34Cn+pcZSwKSjiy0PZZrLjoV5yHjTWAUiXNXoK
	 ahA+kR8X/REh28O33qBnkp604OV4XNcB5CbQol15Iws5303BWo5JmBmr3HulREW7blXz+
	 F48reiwAseZa/9eip989CkVxvs3rwUt0okzy7zNHuWvym2BTyVnyzGmLDjAf+Wg+38jlu
	 /ZrRatxjpfLSIkH4TJUOKOhrjBPL2isLwwr4r6AckehRjeSVORkq0OImhd7jfqGJ0ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+LUXOWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897AA606A320;
	Wed, 18 Nov 2026 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+LUXOWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E296E1F000C4;
	Wed, 18 Nov 2026 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033080;
	bh=dizcLDebJqTp1e5WcMQ2vpuzdSLWeGQdnUrWItaWTUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+LUXOWSD7Bd6FV6aqJ7u64APi4N+WLajXs2ojyW6b1SrlIdU5u2+YuYu8uFbQoTI
	 crx9JMktA+irN6JDA0hpQtQvQwifWON9VV+Uov0twaQbfJnLApxVp+5/joIoqxWHfA
	 twfulmU+IAQkzy0CXe7ZXs3ym9bcUkCGeuVluNVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1603/1756] net: lan966x: do not inject uninitialised bytes past skb->len
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150113.704132554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9acba25a30586..300f0751c707a 100644
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



