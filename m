Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3CF3C063F;
	Tue, 16 Jun 2026 16:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628182; cv=none; b=l/4dnP0Hf0kBtwZwqjjAnS4EYxuID8TXx0k3mKYYRyBMtnhgyVEOSwDtYnvFY9d77YGU6bVPdLjZx5FPnsqaR5FsLgBBFw3yhXcIztYXU3QpOhjQeVn6L3YKefIJPZxna6hQtx5rjrxRc3Ou4s6SCr3Wn+rJGD9e604p8VSWmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628182; c=relaxed/simple;
	bh=hbeGpTEbNmpDpAA3nLRylJsi/QxJ7Utl+Mak28fI0Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/M1lQro9+26Dputxt+/XJUFmmqiBmDS5Bj+GnWpFcLbkSWcYoBwsZBBIG4qSuO1HIYIsuQTfeJ7O4wbAFrZh8T5dpY1g+VNd9ooqNLXz2je4EA8JCcjUDpU0w3tta9ipOyX4lkflNU4PbMXa87QKzV5GylJFHOx4m2iKDzjxWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdGhVNef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdGhVNef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D593D1F000E9;
	Tue, 16 Jun 2026 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628180;
	bh=RW0GbpfrIhD0kCIqkh9DFvCSo4HeTe8agFrLd66u6xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdGhVNefO9txE0k6RZ90ozON7SBmSUrlB740M/Jh6Wd2uo4oASsS6u8dJFjS/KKtM
	 5qEcVL0E8Yv+mxuSsDWlZi9Pet/edT9i9WjTwoympdHbqx1m5f6Px1v62BdGockuM7
	 mhy+YSMDhmq5fPaZLnxyvaUHXsoXsbRu2Iiao6FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Chandelkar <rc@rexion.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/452] ipv6: rpl: fix hdrlen overflow in ipv6_rpl_srh_decompress()
Date: Tue, 16 Jun 2026 20:24:26 +0530
Message-ID: <20260616145119.992905368@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Chandelkar <rc@rexion.ai>

[ Upstream commit 9d5e7a46a9f6d8f503b41bfefef70659845f1679 ]

ipv6_rpl_srh_decompress() computes:

    outhdr->hdrlen = (((n + 1) * sizeof(struct in6_addr)) >> 3);

hdrlen is __u8. For n >= 127 the result exceeds 255 and silently
truncates. With n=127 (cmpri=15, cmpre=15, pad=0, hdrlen=16):

    (128 * 16) >> 3 = 256, truncated to 0 as __u8

The caller in ipv6_rpl_srh_rcv() then places the compressed header
at buf + ((ohdr->hdrlen + 1) << 3). With hdrlen=0 this is buf + 8,
but the decompressed region occupies buf[0..2055] (8-byte header
plus 128 full addresses). The compressed header overlaps the
decompressed data, and ipv6_rpl_srh_compress() writes into this
overlap, corrupting the routing header of the forwarded packet.

The existing guard at exthdrs.c:546 checks (n + 1) > 255, which
prevents n+1 from overflowing unsigned char (the segments_left
field), but does not prevent the computed hdrlen from overflowing
__u8. n=127 passes because 128 <= 255, yet hdrlen=256 does not
fit.

Tighten the bound to (n + 1) > 127. This caps n at 126, giving
hdrlen = (127 * 16) >> 3 = 254, which fits in __u8. The compressed
header then lands at buf + ((254 + 1) << 3) = buf + 2040, exactly
past the decompressed region (buf[0..2039]). No overlap. 127
segments is well beyond any realistic RPL deployment.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
Link: https://patch.msgid.link/20260525154031.2290876-1-rc@rexion.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 54e71623aac9cc..e1d632c12cc46a 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -546,7 +546,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	 * unsigned char which is segments_left field. Should not be
 	 * higher than that.
 	 */
-	if (r || (n + 1) > 255) {
+	if (r || (n + 1) > 127) {
 		kfree_skb(skb);
 		return -1;
 	}
-- 
2.53.0



