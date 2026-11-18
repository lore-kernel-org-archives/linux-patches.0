Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036661;
	b=E4hJ+XuGJuYi/2lBBxw7VRgbm7bDTfM7gmQrEQY6+CzIhwZuP3R87vce73DvfBGeRnKI
	 pTEKhmBiIhRppDk7WyHVdNrRonr7uwvkx2k38zAENweArTSMPbMKY/h8Zkmr6sGjAtl8h
	 zdJGOuNsOAqC9n20U/Sywi/JZESDTNSh0mQ3KJWanjxVOFHmrFNI0h8z8a+xOGR50jup2
	 l9k4JyyyHh4rZPWwGKba/LIDSwQzrwVwvUKghm9UvJ7I0hSb3HY0ymR6rWlj65kRKXM54
	 5SGoBg4CFQrSPeKorv53RH9GPvazaBfL1dtscehsIfX2yb3STW3BqzswYHbtjVkt/zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrDYu2lwbEs+bxVbtrm3NN8rdTH15P9jZhVjibIYMTE=;
	b=Q8IL9qxGBxa7LVd3azHK8ESaQHa1QaSi1e0y7+cbasKx1HeMgP9hz44SOaW5aPnH/un2
	 xjqkbmw9LeSaco+kpoys5zhkxkfb1XKYSglEZFhX0ijvk1B1HdW6WGz+sg1tQC7hJV3Gq
	 dtW1yDjt3nGHbLbluXdWshD7uOuhJH+LP/E/aZqV/LU39xNvud6JTYosNkD+bAPmo++1c
	 FvYcenowE/Gt/RsGFL802e9YcrmcD8jT4bYLrBwoorC9wru1KISJZmyWOdvzgqkA3/DOp
	 yreAfYAKed+CgDupfXFwOF/Ylldfft562u+eqBBx40NlhJcB3lJGudACY8LJ5EY9pcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Hqm3W8c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E703F606A325;
	Wed, 18 Nov 2026 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Hqm3W8c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D4D1F000C4;
	Wed, 18 Nov 2026 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036660;
	bh=rrDYu2lwbEs+bxVbtrm3NN8rdTH15P9jZhVjibIYMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Hqm3W8cMiBWm0+Wt3UNLMLs+3IcNKF1Kh5HSES1sUsmgOEac64G3kLGNoPtBrJqp
	 4xzA7Gfh2mAXJRW87cNngptpvz7AYw+fcL3UJIPIDHjEAkjbJPhYrgeo+4zvHIMFtH
	 hKqaKWzstf6y08zsBfwT6o+QtVa4tkRtTyGis5nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1138/3318] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Wed, 18 Nov 2026 15:29:20 +0100
Message-ID: <20261118150354.196235753@linuxfoundation.org>
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
index 5a14f2331217b..e0f31155c8007 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3665,7 +3665,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
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



