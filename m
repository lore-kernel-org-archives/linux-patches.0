Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063493;
	b=kMeu2sz8U9s87utEMfMCOGwCyWhUMs3MT8Pq6NkONz/hezyyQ05/DkcK1fm5y4ujggkh
	 aNzC6a2T5wcDv9zJaLNmXTC6/E57vrQOkO3cWQM0iAN/Ognk9AOWihaeSw2EkMnIS2I5l
	 MdVwgBxvuddEr6edrXJXtnP9j5nB5i/Q6mc/5CnxtNYhIZ2dMWQ/zrUvQGf3bCEXYbkwA
	 jUocmCUusDVvxsytm/xbxuuyJ5DWxBO7JKwijsIIqK67hJartctczHlTIaKfju7aljEOV
	 jG+SIXOu2LqORLvNShdkFWZ1ViVZ0uLZ+UyL0ouIHgcGFLLrKZeaADyZCy0upm6amzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLDJK2QP7lgP1FTABZkZg8z7mOPcwMqIMrBfYmFf3dU=;
	b=c4zBCilgzDiJCogFZRgiU0gquNWCavD7VScgwouPUmFQNlQb88XrKx5/DqL08Y1tYy4c
	 PfO/d4vGkB2qLrkUU5+2AMjO1xK/YLVlXpV/jIEk6Kky+THOkFTxcg8UkXTBwtx7q683w
	 hKhvLgFlvbb9XV9PFwbGECAI1MNwSZy3A/bB2CM1/yGziw9dUwd0wnrw+/fTAfCAnA9re
	 tT7XaSxcsmUYbT126CTiueofLsMfKLdqU4eGoLGL2IUOgdknPx1csdUv2ItHqP3qOCnZb
	 oCsjO6rONotVExz7EzNgcO+wQLI0ctiQF+AXcfiZTGfZOx3zYpsQ98NcobnB4e7jIYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RflxIv8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFC7606A33A;
	Sat,  7 Nov 2026 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RflxIv8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFCE1F008A2;
	Sat,  7 Nov 2026 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063493;
	bh=FLDJK2QP7lgP1FTABZkZg8z7mOPcwMqIMrBfYmFf3dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RflxIv8PloxsNaIDsJr1dYG/d8FLwi96TKklr7S1Pqr8lbAg4pm0LSob2UD7vYqxs
	 bRYstI9f2mcaXJHrRpJJGkk3f1BtCF97NumcevWyLnznE3fOMh5ObxqM0WEFcyqwFk
	 9QgjrTKh2Sp+FAb6vVNfPgooFdorCNjBgMLKKRr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 602/869] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Sat,  7 Nov 2026 08:54:44 -0500
Message-ID: <20261107134913.459829108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 56453199d28f0072a8196fba14b2d702632e2219 ]

skb_copy_and_csum_dev() copies everything up to the checksum start out
of the linear area, and BUG()s if the checksum start is past the end of
the linear area.  It misses the other direction: a CHECKSUM_PARTIAL skb
that has been pulled past its csum_start gives a negative offset, which
gets past the check and becomes a ~4GB copy.  It also trusts
csum_offset when it stores the folded checksum.  So far
skb_copy_and_csum_bits() BUG()ing on a short skb has covered for that,
but once it returns instead, a bad csum_offset would write past the end
of the caller's buffer.

The function returns void and its callers are drivers copying a frame
into a bounce buffer just before handing it to the hardware.  There's
nothing for them to back out of, so check both ends of csum_start and
that the checksum field fits in the frame, and if not, copy the whole
frame with skb_copy_bits() without filling in the checksum, with a
DEBUG_NET_WARN_ON_ONCE() for debug kernels.  The frame
goes out with a bad checksum and is dropped by the receiver.  If even
that copy fails, zero the buffer so the driver doesn't send stale bytes.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Cc: stable? The trailers only have Assisted-by: and Signed-off-by:. No
Link: https://patch.msgid.link/20261007-b4-skbuff-bug-on-v2-5-b9a5f732895b@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1808bed195af1..227c889fba578 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3899,7 +3899,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
 	else
 		csstart = skb_headlen(skb);
 
-	BUG_ON(csstart > skb_headlen(skb));
+	if (unlikely(csstart < 0 || csstart > skb_headlen(skb) ||
+		     (skb->ip_summed == CHECKSUM_PARTIAL &&
+		      csstart + skb->csum_offset + sizeof(__sum16) >
+		      skb->len))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		/* Send the frame without the checksum filled in, or send
+		 * zeroes if we can't even copy it.
+		 */
+		if (skb_copy_bits(skb, 0, to, skb->len))
+			memset(to, 0, skb->len);
+		return;
+	}
 
 	skb_copy_from_linear_data(skb, to, csstart);
 
-- 
2.53.0



