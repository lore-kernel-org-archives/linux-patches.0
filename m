Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622985;
	b=dH5yIyXWUHJ5Bu7dpZjRZEVrl4nb69hVCoJTaUkXRy/qBsujnfwKXIApN2yFxpFMBr0C
	 h58DkvisMLcNc90nfMTMwWHWjfn7KLnnJ6ogfciwBfKaYvlXJth4x+drwfjKlRoQVpG34
	 H5Y0uvjbvwBvJjD7Mi0usLHDG+iOmdjFYUmM6EFWiS+JWmTc5Qd1p8Fcvgr++aeaROeCb
	 GLSKB9/lpVsjRmnbzozxD350MyVIz3m/tS9MR8j5bkUF38yvGx2+QfBIGXHDla2dHXVna
	 NSdqT8qYYX0loV7Bx5AQLdQyEt2Xtyn55UWLFq9J92tbAh9lBzTmABUZSARqhYuZIzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1fqJNutSZeeOC5GCex+IQAy6rHQk6Su76iIzf64d94=;
	b=Sj8r5f5IhK8UhST2NIldLw7V1+vleu5UTAitswGgt91PdHh2e6lh2f9cn999BPm+Jwrv
	 /VP1HjffSFmI6o3EefF3W9Na8+OlPi+jZv6GiG17LfwAH0WFeF4KMSEKh42c/XWwN3k51
	 RvvqR+nxFKeez7qBjnV6Byq1CPlRf0x//VXJ25oxLQt8u/FnjlY7bJ+Twu7qGpq8+1ue6
	 5QVXaPVscH9/ccnywV7KkUc9JH0WTx2FKaLjGuk6jK+B+7q0wkiEyUgnS4eDMwEcEfD5q
	 AK5Z/+9Xg/h6EomA4G5G+ehYEasE/jYRc0PKhlsVz+viPeDiIgR0NEDlHFpZNilsLuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCG8nJXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5CB606A326;
	Wed, 25 Nov 2026 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCG8nJXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94711F000C6;
	Wed, 25 Nov 2026 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622984;
	bh=r1fqJNutSZeeOC5GCex+IQAy6rHQk6Su76iIzf64d94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCG8nJXzhLzMtI1qP/iYQMBkwf6iTBY8ha1OOCYfvO9ALxOKdmtFFnAKOzUDqxUKI
	 t3iTOZky7d7R7VGdYl/0Z4CermlRCBdYqd/Gxz17DsJ84xLYrjyXZ7BqMgp8I1qYwg
	 8IigLoiznLv+eQJppBHB63yUoYOb252bWopJQSrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 712/990] ipv4: keep XFRM headers out of corked skb lengths
Date: Wed, 25 Nov 2026 15:34:39 +0100
Message-ID: <20261125143838.761777138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -1151,16 +1151,16 @@ alloc_new_skb:
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


