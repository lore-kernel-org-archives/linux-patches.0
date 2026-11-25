Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623015;
	b=M/GMWl/gmp4OpmBk1GIdRmv5oXWpQYkclN5ameDIAosPW90D/KYdDLRQfhEqe9RT4mFG
	 PNvBD6aIskriLh4tT8meEFO+tAXfchKskgAUvcZ4ACtzC0Xf8eiZQL4TMWglYT318f9Cu
	 vPc/kBOzM8eCRMWccW3SK5393ORydkO/7AhO83WQKIuzkVk8FxsqfKz9BWEXsnOO8BMGv
	 2cv3IgbMxQ+zU9QIuAkINCc213RDE9VeeZIx11WXYHr5gR1nnqiMM1xSIWpOypUcDdbBY
	 cNO14XdRn4dwJ7FhmX3b2PnhrIF7womJwpXb81HptJae9mSDVR56NOIJUejKLom+Jgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0cdmB3fd3Dlb/B+UnPe6Z3wVoCxbe5RhQpYkvM6PgYk=;
	b=UoPzrb1HAr+1ySjv+f212JHk9JQqVmSV6uSg4t9CSp3mIe6sFz3JYT3RtPwEbUGE0PLI
	 UhuyWFOALN/Y4YeeOyBvCanf8iFWdI8mpN1jHTfX1CmlYa6LmKalHU1v6yhz22X5XKw1+
	 mZrc0Nw8KyLzyIwSvP95w+aDxascWXbVFB1IOSuC1/+K7kgZ856a/Iatqzx5u0L3lAiUZ
	 5XX5knSeTjYnwDDAtt+wMly9phdmQDaZPjIUyTJcOp4wUDJkOnPRizN2mOltHlnyTEEsf
	 G1E0tzzBLCniHmDk+atT86oLVmIIZvt1Bi+BCFr8SroMw0oI3xhif3i8ltrSsv+xbCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5BG21ii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A260606A321;
	Wed, 25 Nov 2026 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5BG21ii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9C31F000C4;
	Wed, 25 Nov 2026 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623015;
	bh=0cdmB3fd3Dlb/B+UnPe6Z3wVoCxbe5RhQpYkvM6PgYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5BG21iiWEgn4quANmsKe7QL9cn8dX99buAvoKQwL95gqlIz8vULe2egdfGBxaMew
	 c+yT0C0KwdvYHQ9DZkNt9pmSO1FVQnQrARcrFcFgOJe359hK3M3RDKf6bK+LJgHcLV
	 Sb9YxLPhIrc6fEVD+FRrOXpsyxYz/faDdCyaTwho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 721/990] net: gro: avoid parsing headers from shared fragments
Date: Wed, 25 Nov 2026 15:34:48 +0100
Message-ID: <20261125143838.967448931@linuxfoundation.org>
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

commit 44818c9a826d766dc0e21179dc76f229334f1dda upstream.

When an skb has an empty linear head, skb_gro_reset_offset() can expose
the first page fragment directly to GRO header parsers. For an
SKBFL_SHARED_FRAG skb, those bytes may still be writable through a file
mapping. Headers validated during receive can therefore differ from the
headers later copied into the linear head and used during completion.

For example, changing an IPv6 destination-options length between the
short and full header fetches in ipv6_gro_pull_exthdrs() can make
ipv6_gro_complete() pass an out-of-bounds offset to udp6_gro_complete().
A userspace reproducer triggered a KASAN slab-out-of-bounds read there
on an unmodified kernel as UID 1000. The same completion path can write
the UDP checksum and length through the invalid offset. The packet has
trusted TCP GSO metadata and spliced file data, so it reaches completion
without an skb zerocopy destructor or a second GRO packet.

Disable the direct-fragment fast path for skbs with externally writable
fragments. With an empty linear head, frag0_len remains zero, so
skb_gro_header_slow() pulls each required header into the linear head
before it is inspected. Subsequent pulls preserve the validated prefix.
This covers both gro_receive_skb() and napi_gro_frags(), including other
protocols using the same helpers. Linear headers and private fragments
retain their existing fast paths.

Codex assisted with review of the supplied report, reproducer and draft
fix, related-path analysis, and this changelog. The patched
net/core/gro.o builds with W=1 using the supplied x86-64 configuration,
allyesconfig and allmodconfig. The fix was checked by code-path analysis;
the reproducer and kernel selftests have not been run on a booted
patched kernel.

The issue was found by an LLM.

Fixes: dff0b0161ad5 ("net: gro: parse ipv6 ext headers without frag0 invalidation")
Cc: stable@kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261031050752.31869-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gro.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -419,7 +419,8 @@ static inline void skb_gro_reset_offset(
 	headlen = skb_headlen(skb);
 	NAPI_GRO_CB(skb)->frag0 = skb->data;
 	NAPI_GRO_CB(skb)->frag0_len = headlen;
-	if (headlen)
+	/* Shared fragments must be pulled into the linear head before parsing. */
+	if (headlen || skb_has_shared_frag(skb))
 		return;
 
 	pinfo = skb_shinfo(skb);


