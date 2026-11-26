Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704536;
	b=adH7hanAFoI+iKcY6mqIjKDpY176KnnCXkmjfTu2bVD++9xcbc25r0AMEtWItjdZRXBk
	 ot5nc26wjYrMssOuBNXxbG8mQGn7qR9cFVD5EYgeZpSGTT7npWpCGVd4syEA8FQUyqaiY
	 R4bX1eNZuM4Yo+NGc5uUUBQ3cLykhKAmfSiXzgEOpZ2sb4g/agls0ea/H0no7QeiunxKD
	 IZ/x772jiVGCk8ISd8m97UjVUSeu6f3enaHovXXQwGKKSju4VJMQrJ5ENflq92+9BB/ui
	 zliI6nHtz5GNRnfeUGicnidAVAyFIDmWaO+CWY2QgnM6AJjICYRxWQI8LzKOR8vC3rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=htrJtfpqRL1TFthNEEK5WRHYLrGEhbolZSe7WNKY/Vo=;
	b=a/ZPb32cmPwRAoBCXYgvoL9ZGz2Czty4fwaXvuAek6IGZpvSY7jgJMxNCja9nAUcsgZg
	 1a6pcl+o/cv5DqKzkKFIUkVoaCUzp3n0I0ASV1kXlU9+HmFwE5eDoV+l2Ifmihc0549sz
	 ZBwAj2z7BizB6PFnkom87qWcCL/kd84ioANp1BACn6nWzlX6kvlNCWe6S63mnrm5uw9eB
	 hjHh2syaL982LGcZd0Ffj3S//gotXmR2gsyYjJWOpbfYtlwdNRsQxiZlcUxsG55VAj4ZY
	 9njkKzEQjAUjSUH+banJ3oOwlKDR6r/AoYWbmf7LCynigUdC3unS3iJVDg0Jrg6ADjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yD34il/6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497A8606A31E;
	Thu, 26 Nov 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD34il/6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EAC1F000CA;
	Thu, 26 Nov 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704535;
	bh=htrJtfpqRL1TFthNEEK5WRHYLrGEhbolZSe7WNKY/Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD34il/68gk2heggOdqfTGNbBEuBxZBpIcIHhlYqawYaOcmL20BzV9NKVS70qjbjX
	 Q363GEMJqinT9H5yK2s00CQ6AWEZieTaQFJ8OGjDSaCmc6RnoYCyhqEeJQ62OspnSP
	 N4pRS4mvEwIo2hSK+jDbeO4UHaH95hKKgfAMtPWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 159/265] ipv4: keep XFRM headers out of corked skb lengths
Date: Thu, 26 Nov 2026 15:38:09 +0100
Message-ID: <20261126143616.254496394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 0f47fce51a98d3d9f439c16861d519a7b833a176 upstream.

__ip_append_data() allocates space for dst.header_len in the first skb,
but includes that space in skb->len until __ip_make_skb() pulls it.
Fragment accounting uses an MTU that already excludes the XFRM headers.
As a result, the next skb can have a fraggap larger than its capped
datalen, and skb_copy_and_csum_bits() can overwrite its shared info.

For example, five AH tunnel states can reserve 500 bytes while leaving
an effective MTU of 348. With 40 bytes of IPv4 options, the second skb
has room for 288 bytes of fragment data but receives a 500-byte gap
copy. The overwritten shared info is subsequently consumed by the skb
release paths.

Reserve the XFRM headers together with the link-layer headroom instead.
This keeps skb->len, the gap-copy offsets and the trim lengths relative
to the IPv4 packet throughout corking. The network and transport header
addresses and the headroom available to XFRM at output are unchanged.
Both paged and linear allocations, including subsequent corked appends,
use the corrected accounting.

Fixes: 353e5c9abd90 ("ipv4: Fix IPsec slowpath fragmentation problem")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042229.74068-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_output.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1135,16 +1135,16 @@ alloc_new_skb:
 			 */
 			skb->ip_summed = csummode;
 			skb->csum = 0;
-			skb_reserve(skb, hh_len);
+			skb_reserve(skb, hh_len + exthdrlen);
 
 			/*
 			 *	Find where to start putting bytes.
 			 */
-			data = skb_put(skb, fraglen + exthdrlen - pagedlen);
-			skb_set_network_header(skb, exthdrlen);
+			data = skb_put(skb, fraglen - pagedlen);
+			skb_reset_network_header(skb);
 			skb->transport_header = (skb->network_header +
 						 fragheaderlen);
-			data += fragheaderlen + exthdrlen;
+			data += fragheaderlen;
 
 			if (fraggap) {
 				skb->csum = skb_copy_and_csum_bits(


