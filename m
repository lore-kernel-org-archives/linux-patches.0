Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042368;
	b=JKbWoxOwXzfGWcjJK89YD07UdSyN46Aq39JGIRIrCEAVcZbqwSCdjyz6M3oM4FbPuQfG
	 O2oHIMCPAU7iE2L9GdylcV4LDAPzu6hjE5SmV/7OWlOaav+47fUeD3IkAL/EXZwErwzvu
	 85dl4RGzi6uwDAWstoB95d1ZRL4cro6G0dTLua/5WZEg5aW8XgreOrtLRIfOxIvjZNIrH
	 OU+R0h2TtsBQbZYail6dXLdXqktEWdYxJDbTBpmKTOnqz9Yd8Xj/7BmnDliRHd0FvBi7+
	 MGBNDd2Dt+04NWXLR8OkK8JV0gGA64MyRRPzA495N9Ex60Vls/05VKNI+HhNe/dNnWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=amVNYcJmO5uYUy/Z5dmQ/17OA9dE5FbGU/DiVjgQlSk=;
	b=e9oUh2xoUvwuVmIqdcf3hi5J54MWbBRqnwxC5ZowYmT9hkU/eGq3J7nFko8AMDViFCjk
	 zxH10AfaT12JnI0i5JSxa/NA6Tj+9X3GIRux3+xRfpIANrE3p4ITRCzEFQZjlSs73lpbA
	 6DOuQIBY+5m0mYzszcSDdMSyUaxS4kqbznRUnlAdEFmwrtvG5ACJ8QhXG5kmHsujnsg9I
	 BTL5VeOkRG7BO9Pp2GCaFlHgUiUl7emzPguyxwiyPznk3YQ/g9vA1ivUNBMA6fl0mnpyR
	 2zmBTRX6Hj6VgI/gUSdK8dAf0VOdOzJPX08vgZTTFF3m2qi2mHhPaALAUbfgm6zxvQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT6NFH2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB829606A320;
	Wed, 18 Nov 2026 22:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tT6NFH2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216451F000C4;
	Wed, 18 Nov 2026 22:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042368;
	bh=amVNYcJmO5uYUy/Z5dmQ/17OA9dE5FbGU/DiVjgQlSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tT6NFH2uf/ZnBClkfPynsKRWtkZWHrxachNuR8uj2JlcGR2AwLkSCG8fToczS9LGa
	 x9yD1CGYb62KsSSWofnZi92C90KCP0W8fbNZcZFMdxCGOCCR5acFdTAgipCabtGCIW
	 vjB0ZZ2BVJ8Hom4P+t/YWgMVOPYSXOw3iNqSq95c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3145/3318] net: sparx5/lan969x: do not read past skb->len when injecting a frame
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150454.220898387@linuxfoundation.org>
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

[ Upstream commit 9642ce6cb51ebd596d0a02074ba9b2a387e974b0 ]

sparx5_inject() writes the frame to the injection FIFO one 32-bit word
at a time, and pads frames shorter than 60 bytes with zero words.

Before this patch, the last word is loaded whole even when skb->len is
not a multiple of four, so 1 to 3 bytes past the end of the frame are
read. For a frame shorter than 60 bytes those bytes are also
transmitted, as VLD_BYTES marks the whole last word valid and the
padding starts at the next word.

Write the trailing bytes from a zeroed word. The number of words written
and VLD_BYTES are unchanged.

Found by an AI code review agent, and reproduced on lan969x and sparx5
with register injection: bytes 57 to 59 of a 57 byte frame were not
zero. With the fix they are zero, and traffic still passes on both
chips.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021-sparx5-inject-tail-bytes-v1-1-7dcc035c8ddf@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/sparx5/sparx5_packet.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dcf2e342fc14a..806983f002301 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -168,8 +168,8 @@ static int sparx5_inject(struct sparx5 *sparx5,
 			 struct sk_buff *skb,
 			 struct net_device *ndev)
 {
+	u32 val, w, count, last;
 	int grp = INJ_QUEUE;
-	u32 val, w, count;
 	u8 *buf;
 
 	val = spx5_rd(sparx5, QS_INJ_STATUS);
@@ -188,14 +188,23 @@ static int sparx5_inject(struct sparx5 *sparx5,
 	for (w = 0; w < IFH_LEN; w++)
 		spx5_wr(ifh[w], sparx5, QS_INJ_WR(grp));
 
-	/* Write words, round up */
-	count = DIV_ROUND_UP(skb->len, 4);
+	/* Write the whole words of the frame */
+	count = skb->len / 4;
 	buf = skb->data;
 	for (w = 0; w < count; w++, buf += 4) {
 		val = get_unaligned((const u32 *)buf);
 		spx5_wr(val, sparx5, QS_INJ_WR(grp));
 	}
 
+	/* Write the last 1 to 3 bytes, zero padded to a whole word */
+	last = skb->len % 4;
+	if (last) {
+		val = 0;
+		memcpy(&val, buf, last);
+		spx5_wr(val, sparx5, QS_INJ_WR(grp));
+		w++;
+	}
+
 	/* Add padding */
 	while (w < (60 / 4)) {
 		spx5_wr(0, sparx5, QS_INJ_WR(grp));
-- 
2.53.0



