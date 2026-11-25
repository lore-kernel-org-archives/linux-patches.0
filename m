Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625688;
	b=OYwZd2D/5GEdt574L3n3VPKlR6U5oNtHfvZmHe3hHZLLxIjR6F1o1cq3s0HVB95eLCbD
	 3i+VjyBovxXUGOy+ZtWA3bITefHGJD3AI5/0Yt/XIq6pg6JKRxxiR0W94kh5DCE83z4tB
	 SV+kLJMj6X4Cl9PZbl+mhwrCAzAQS8iThIrQidjYcqw0OEPecEQOrZEGNq2lsu/OKL7F0
	 IdhkYugNaq9HYsWMrsBk8m4nzjGxEFb/oTZoRPNsIZ3xH4ltFxMJWAwrwKq/VYb+3u7R8
	 3bX8fwMhTU5Ly9M87LMrdOKzm9NJcxd2H1h1Xx7u8ynWkB/BVio1D4Zo3PRej9BJvdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgbK9CPOWSn2HrmB6leYscIcfWSxTDc3vsVtM92cuhg=;
	b=o+GwJ9V40diML97MCVgQmRorarfzOsfRKNUubq7UPEDkRYXo5JrlErrxrzW2Yt55FpxK
	 8dx9A7JgmSaI/M11P3O3P6BcXyzTLOFOJ11o3xQNLOEi/AplmVIY49SweaTOAYCNuqRjX
	 o0gu6r9q6DDOoBaFbRwh+/rCksxCUowSZHK+HeW5reooJp0HGF0KqlFgubEwX1eHw3BVB
	 bDyX6l26I+lP0P09pYRHdXkrsrjNZ3/HZPhXODFd0e7XRrbqhFUKCZp/DIOeNKxGzMtJg
	 FyZQqbvVKSBUBu/Mebg+hm3/aeX5ehrCCAeAQ6qYEboZX4pJvv0V6o8Y3bGUsioqDLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oA5NvB6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D1A606A321;
	Wed, 25 Nov 2026 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oA5NvB6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130C61F000C4;
	Wed, 25 Nov 2026 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625688;
	bh=sgbK9CPOWSn2HrmB6leYscIcfWSxTDc3vsVtM92cuhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA5NvB6gCxuJJXzgeA6YA1Gj4Zz0JSpjZvdpy9lYDG9aC2kTPg30NAFHeTL3u8ExS
	 rGxehdeo524gONGeQxI6F/uqjxaPVNMcz6HOzwRyjk8h9C9+pNWaEZ3jL6FsEK9M75
	 D7C0TgKhGrEByb8B0Gm5i9sCsLYG6SaE5qVtHOYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 598/816] net: gro: avoid parsing headers from shared fragments
Date: Wed, 25 Nov 2026 15:35:46 +0100
Message-ID: <20261125143903.019925732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -418,7 +418,8 @@ static inline void skb_gro_reset_offset(
 	headlen = skb_headlen(skb);
 	NAPI_GRO_CB(skb)->frag0 = skb->data;
 	NAPI_GRO_CB(skb)->frag0_len = headlen;
-	if (headlen)
+	/* Shared fragments must be pulled into the linear head before parsing. */
+	if (headlen || skb_has_shared_frag(skb))
 		return;
 
 	pinfo = skb_shinfo(skb);


