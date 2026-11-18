Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050709;
	b=TcYy1lDF83plHpRN5W6fYqJ5G6W40wNyqEcccO4k4un5Ryu5TAHGRY3WafyEms/bqpIp
	 W4CJcozgoWa1BpXNpMpIgio4PiwiFYb0D4yWPwnkqBU6BQLfmYEbJIT9o6smOsSCFvKGH
	 IMlPqx+0PTb1LeLe8EsjQ6mrFNQPBvtVzHcsuqFzL9t+2yx1rPMrXOmUQzcGClvVgdymY
	 zSUeN4RkW2Wvw/IBvz/fcKpR7pJiQ6OSnsVq5CIu18e2lzK/RPqXlk84d0lrRbcdikPd+
	 tZNFUHPT2dIaw+tC+uEipdgNmOB5iMdlaR4pboOrIj/+lE1QUcDuMInns+2GGPX6AuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXedTscR5gzAge79rn6KIrynCGzN35bytgcsGn26xwQ=;
	b=gZ39D0GXL7gHOE9oQjGd62gJma6UfMIxLGwroXGrD2MnHBUdeWrW3M4TdER7RXRoBtQX
	 R/lDSIyV2EyCjuPLCA8dibEERVEwPKl3RSDQgalTOx53y+XUGG6T1D3KMdTbDdoFYM2X+
	 aqHySMlRYs0PX33OBDNdUXBsd8tilBN5z6pD9B8ztrkpoKgNTdHbZ8e3z7S3eLQVAWMQu
	 v6dp0c5FX13triz+cv3EVlazuSUjjvo4s5lch//h57Nv32jJYNVz5lihFfFLGcNN6PUcn
	 H2N06+67visqpWmKCaTXKSoe2wHxCi8aQc5aD9OgXNtQB8LbGrFsTvh/XiEUAVmLirA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVuY3x4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C58606A31C;
	Thu, 19 Nov 2026 01:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVuY3x4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658BF1F000C4;
	Thu, 19 Nov 2026 01:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050708;
	bh=JXedTscR5gzAge79rn6KIrynCGzN35bytgcsGn26xwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVuY3x4FNpZM7pHqQslPcrbbpfJn7y0b12r/Tw9j136KyKFYxzDXGSXczOEutcHGr
	 F0gmxDE/HAxycvlJUGKUBZa+/CPFEB5mhhlxQQJsTiLKExGg0W2EF80paNBxj1tJp5
	 NG7KR2llMuK5sn03eJ8lJPcp3IkFcPjJ3ZcoMkjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2753/2857] net: lan966x: do not inject uninitialised bytes past skb->len
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150340.734970898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4a85cd5ebcce0..d0aca28eb364b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -250,9 +250,8 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
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
@@ -262,6 +261,20 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
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



