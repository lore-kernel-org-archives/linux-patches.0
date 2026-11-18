Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059594;
	b=UZyAYnx0J3Vsz9K+bDHE8osCSI/Ak39GxUgdikLf1rUZL0K7IcswWaj+kBeDTee8DIBx
	 kDE5/P6gV8U2pxhtiLsi2g9aawgYg8nTnGdIdOE4daeBdEVp+xYCRYZSvG1EMcRDWngmC
	 qnLIKFG8QwLdaIRoZLbpjm72G/qzspGbor1C1uSdP/+nhwHB6ifK700H/LxKmPM7H8veF
	 cdol9zX1rOOrhY2PFyMfxL4uK7C40p7WSnLssSbEMaCWzllmppr+kG4FUllP1F9HXEJic
	 nv8xKk2IccS5QfjxRzvtHGZFzhwc3JtHIT/ipZfIhWh/MJ3oKz1VEmKRfp2b1/VRcJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbxSQ19NeilTwbZh5JtDP4B0td4WETsSxfdXZCoCAW4=;
	b=vvRuJj+a1avTfqGBkrI2goj5v4ZY95CNZ/IsEkxgHBEyIgPyVH9OpOqDs6nv6zSIV6Pe
	 R8ShVH4FUqqWJvjEVVpd8ZnewLDPIfux6LvRFTKM7+1s3WQ8SVCJ3tHutRMPiknEdLWsh
	 wZgETJ7k6RsryftqGnqfE2uvatrJTswovH0cd1a3tYWhpFi46xZnj4vr6QyvLOixztNQt
	 lbAnSDwQldnjozUexuiWRqbIhxVEn+uxmtwdzRIm1IGl7fwBrqt/UVUKkxtcQ0/XBW6CF
	 jNkjkWyFuFL1bDuP2x4CvBDqxUlQ5TTz/ewmdSSHHC0YkKv927pkIizyBJV5JCLmqTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6GTht40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECD460A2623;
	Thu, 19 Nov 2026 03:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6GTht40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C531A1F000C5;
	Thu, 19 Nov 2026 03:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059594;
	bh=CbxSQ19NeilTwbZh5JtDP4B0td4WETsSxfdXZCoCAW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6GTht402+2b5W8j1Oj1lSxCd6c1b5Aaoe3CX9wjFZAqjCYuIITGVSVI+zD8CHOkc
	 Hpl3uxAwoke1RNBrUVNVRRP2ewgWv5wt1oUJjypS4RDYre3bnl0A/Lh36LuD9NfOwG
	 Ut8Ddj6U5OJ7zqnB5wJFap/PIie61oFyRcRuvRAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0898/1848] net: skbuff: dont BUG() on a bad csum_start in skb_copy_and_csum_dev()
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118145954.323763642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 224348001368c..394eef0c7c4a1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3149,7 +3149,18 @@ void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to)
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



