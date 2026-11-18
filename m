Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056786;
	b=D5jeUBIB4E/BM6MABewW9Uhj08AxwuIRr+/QSbq3IRgZ4IBpy8f+LoW01DzzGDVNYbfw
	 O17Szn3mLRS01dSp6xBPQtiffYzyGsu2mx1Fv/pyNeM0LMvAXB51SPFuDvkF+iXjd7FTh
	 3GSigTpVB8G8qi4lrV5WAQTjPz5dbZ9TKjQ74Vjna2LpIV3sPZicpvdrTWOupfYnNt/3n
	 nyk+Fq1sSIbytXMur4DQ3LyLAsched/m/MuJ5B7UR+3+TNE7u8leKwQF4hYfm939RTlw/
	 7kVZlKPOflv39xMDDueODLKiSlxhUW3QZkYQ38HfVLZaD6VmQIdI0SqY/UBGqhwC9tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCqVac+3bwkFI8ZgYIsuKdF8S5g1VshIjxRioj/KTfU=;
	b=WSMe3mr22WB27k+WpgORoWMNr/SJhvpPooHk/lyLZZ1enwPT92S+y/mugUGPQGk9NbX9
	 DqsILqJbhfw6ghqrf/BXPlwOVJrlfsZ8vIC69dh2YID+rmNPfKZnGViRoD/uOPRjPDLPb
	 tulGDOWn95gji/j6Tmjr0Uo604co+av82VMW+GdHEy3RDjVkbHXiqnXD3nbhJdjVlHyhb
	 W+t25ZmjRAZcRArAbXCeijwQb77m+nQyHXnFryOueszolaIr8CQcqj8/Di+PgpgWjPtEK
	 xrKDyZsjBP7HyIkMFPaUb9GV5FLOnKaJ4v+qvHhXAWazcEx/rE1C1WAdMNBH4jSyvLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6VvElPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259EB606A31C;
	Thu, 19 Nov 2026 02:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6VvElPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7823A1F000C4;
	Thu, 19 Nov 2026 02:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056786;
	bh=SCqVac+3bwkFI8ZgYIsuKdF8S5g1VshIjxRioj/KTfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6VvElPc9HM7QZnHiCWi5pHuLFBEol6KzhfRSUX8TEQgr+nkMyBnrrLsfS73HQVyZ
	 Jlv95ZS3wEzAOsm9sALwuyIbqH/w7J84WjuBJwhEA8OX6KjLhtXAvoIxz3ezA07Alp
	 OK21+oYrtJ65S5fMieV3EgBH1BdnpFWXiSPQteIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2111/2214] net: sparx5/lan969x: do not read past skb->len when injecting a frame
Date: Wed, 18 Nov 2026 16:03:07 +0100
Message-ID: <20261118150135.064253448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c460168131c26..50bb6bdc2d79a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -157,8 +157,8 @@ static int sparx5_inject(struct sparx5 *sparx5,
 			 struct sk_buff *skb,
 			 struct net_device *ndev)
 {
+	u32 val, w, count, last;
 	int grp = INJ_QUEUE;
-	u32 val, w, count;
 	u8 *buf;
 
 	val = spx5_rd(sparx5, QS_INJ_STATUS);
@@ -177,14 +177,23 @@ static int sparx5_inject(struct sparx5 *sparx5,
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



