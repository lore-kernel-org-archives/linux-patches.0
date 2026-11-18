Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021626;
	b=bX7+Z7bEOzgbtswPgJdaOPJFdsF5rxbAbZ2I2AbALmz0bhI4799ySgHpQJNh+OneqtYn
	 17dVExNunJKJtlB+wQH1pxfeVshBcYGJEwe3tlgfnFdEEXAbH2POzmPSL7u5I+QxHGnUG
	 uHP/Qv/1D/C51IhLAkZoKmrl4ZGAg3CbAKlm+7Gg1LQ3UNyVhFbDsBtgnlUDTIY3i/CY5
	 QxMAl0Sh9XAkOHQ5qpF1ZRzOz7aS9UhzKmz8J32pbx0NO0t4jJfKKj9AsHfIGFgWCsMv8
	 4cDVTvjNwkKvzzrKalJ7wLSTP1tiybVSUxjbJ+DKIu9EYArNZQ4PmWoXqkLkwT7UudQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZCnuTRTUaJOVnUwKKZoMmXTmkUBQ7VUbl2fBqU7qO0=;
	b=UpiBKuyzfC5dmByG6N1KpMctl7d14j4M6FiscGQq7NA0HeBRrbWMdpVBHtvAu0RAAP85
	 Snn5gRKbSmwt7lWgYL2dzQ/J/1fOc8642bPnAfJhsSHERz9ElsECjMTrJDkU3qR5/2dUx
	 yt5P3rt9ERtefY9sHOUwxaNO82ZHuytyfMWDv9+ohk2CNkULgNo3IpzXCOQN66LXTebAz
	 rTR8E/YEPipeA6geGIFHb+B3DeiMaYqZ84Qh3Lu1S5dnKC+q7AR5DhUXJP26FEgcQLckw
	 nDbs4BWAsRsoVctPhD2iIcjWpDqvjWQgaavi67hS1sNHEuUQ2Zj1W53YZQT7HanOQNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F01GmdBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7488606A31C;
	Wed, 18 Nov 2026 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F01GmdBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9BE1F000C4;
	Wed, 18 Nov 2026 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021625;
	bh=BZCnuTRTUaJOVnUwKKZoMmXTmkUBQ7VUbl2fBqU7qO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F01GmdBqaP4H8pEbmOZxkLL/bsG/moD4UbAirhhhf7UDcztdYcm7isQMRKzl+t0Ri
	 vwOW9AKVRCtbndJJUIizigz9kEdKzWYKgLS9/CXE8zTgKRgJapLSXFAFeiquTzVClG
	 rVNRf9ucYvJaiInbHc+yJv89cD6g2rQnpiMe5+xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2375/2651] net: sparx5/lan969x: do not read past skb->len when injecting a frame
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150410.992680783@linuxfoundation.org>
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
index f713656f1fae1..14c9ae673e354 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -169,8 +169,8 @@ static int sparx5_inject(struct sparx5 *sparx5,
 			 struct sk_buff *skb,
 			 struct net_device *ndev)
 {
+	u32 val, w, count, last;
 	int grp = INJ_QUEUE;
-	u32 val, w, count;
 	u8 *buf;
 
 	val = spx5_rd(sparx5, QS_INJ_STATUS);
@@ -189,14 +189,23 @@ static int sparx5_inject(struct sparx5 *sparx5,
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



