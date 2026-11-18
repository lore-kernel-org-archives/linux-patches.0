Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053872;
	b=ZlVmnNdVfF3zZ4+SYF2M+KZgZ3WHjZl1cs4pV/8/sK8XsnZ6+nT0dwhNTRfb4dwpbRq1
	 pKBH1bxV4hr3lo2ifSgyPEOLGEvtHhpAMNKEyKbbZ8TaUrTN57Lz5y3n2ZdlOwgTZKKDt
	 eiIonZx5Uqph3skNecoCBrXkkPwvCxezlP3/8NwkdW1yQLV2sxxtN53elwXzyXFF4C90r
	 iE5oPutV7aLlPWgfDmX0LkcNLNGGE0lOqA6ldy0uY/LkUQpubYq8zJ8XhbKG6Yj9Bs/aZ
	 B49JTPb7DqEaEoBaicxlbUtlJG9i/Pl2/YDGr++VjT7sV2mj8exfOMjHeRfJALKPrSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EUqHv7so39t+3lJ3gSBGQs18EcgpGs3VWjG6qAe4Wz8=;
	b=csn63Ls8dgHxKpHc+/KIBbtlJIezZIPW/Xu3eJxqMiuuH5lr2IhwB1wVrmnGJ+mpvVMo
	 UfbilWsoNhs9vEhJJE1BT/BaPC1/ct5lTpqeYgHn1cxdp25jO1xFGx9/PzCML6sfhulXk
	 g0hUKtp5zoAok2jQhZlP63yoExHCJrD1H0E3Z7TdLcFNPemD/ezXz7Psm2P+me7TUjKgZ
	 iSVcPH3KVhlsFi/rm2GR4zR8if+GkP+ki0Ve1/2E0h4DhBtzwAVcXL0Ioi98G3YSBGULr
	 Di3KBmwBnQ/QlrcrpvYrAu9DX9xQeH8oBNGIhBOWfTAAkg9gWzfZVkKQWhsyz82wz7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS07+w9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0A606A32C;
	Thu, 19 Nov 2026 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS07+w9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6451C1F000C5;
	Thu, 19 Nov 2026 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053871;
	bh=EUqHv7so39t+3lJ3gSBGQs18EcgpGs3VWjG6qAe4Wz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kS07+w9Hk0UyWHd6+cyb63fuZkyu12u6lV7evvq+KjkWUDb1Nalu380lciyil+1gm
	 37qNo9wNeIbX/+KxOh1bdwvyOWaW75TQ/4aqUNoHXVUuHLJ52A++fHi3X+gQ6tNGbX
	 GfUYdZm2xFZCH1bAfl8CV4jpDNBT+/fV2IHVNoh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1066/2214] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150054.930131410@linuxfoundation.org>
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
[ sashal: Replaced unavailable DEBUG_NET_WARN_ON_ONCE(1) with WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_NET)). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2a1aaed462645..5867fcac3f05b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3257,7 +3257,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
 	else
 		csstart = skb_headlen(skb);
 
-	BUG_ON(csstart > skb_headlen(skb));
+	if (unlikely(csstart < 0 || csstart > skb_headlen(skb) ||
+		     (skb->ip_summed == CHECKSUM_PARTIAL &&
+		      csstart + skb->csum_offset + sizeof(__sum16) >
+		      skb->len))) {
+		WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_NET));
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



