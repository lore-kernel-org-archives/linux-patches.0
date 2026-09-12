Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068103749E3;
	Sat, 12 Sep 2026 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232897; cv=none; b=AhCKEmgUcpwUxDYSTAcAXCmVI1VMNTbveBkzeenyJ43QrYuyQ/toRGChAbCxX5wQlL/i0HMJSwgFQ1zfGXjIKEfAmOLsOPNe3xR1yaag3AOiM/JTam+A5CVWTkN7cRWQe7haKLL5+1Jr1ltQs5nrVR6tciE961K7pz9xxmP+prc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232897; c=relaxed/simple;
	bh=HZvzYYMKC+hPHFG8zXXjuN7e2tkxKWFTq3foP3vEXV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhDRG027BbT3aA7i8DzX5/bnoPMYqHiHhqh+C4OijPqZI7A5yXYLWncRXa0BpNXBNPhOPYLV8aRvOqwNOYpKf3uf7Jeb6HRNnd7ra17JCtyoBS7FmjlovpcW/BTpMo0pYQ35IZz8Murq3LLNijSkCqiKVA6QXpJl7F7MdTyrUEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xF0+90+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xF0+90+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48211F000FF;
	Sat, 12 Sep 2026 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232895;
	bh=x+QAWJe2W3kgyv49kTVFOoluhb9CFcXpzryHz+L2dMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xF0+90+tmglneSPBWuDs6xYE5aI6mY4pSvU1Dyw51Oqnnou5dLnM4xnWMCGKlaZOK
	 mtdiW9w63FGfOuHirMEmmfBBx+1ICNXffupWeSTADOJAJhofX8r0qEjMEDEeskYABr
	 Abe7Okzgz3xu8a0oxv8mJfX5utIczma3UT2jeFyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 104/935] mpls: reload header after pskb_may_pull()
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065529.205743351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

commit 29e63b8d9fc150cc191b1c6eb7e16e1247e1b650 upstream.

mpls_select_multipath() calls mpls_multipath_hash() to choose a nexthop
when an MPLS route has multiple nexthops.  While walking the MPLS label
stack, the hash routine caches hdr for the current label.  After finding
the bottom-of-stack label, it calls pskb_may_pull() before reading the
inner IP header.

If an skb is constructed with the inner IP header in nonlinear data and
insufficient tailroom in the linear head, pskb_may_pull() calls
pskb_expand_head() to replace the skb head and free the old one.  This
leaves hdr pointing to freed memory.  The IPv6 path can invalidate hdr
again when it performs a second pull for the larger header.

The issue was found through static analysis.  A reproducer sending a legal
Geneve packet through a bareudp/MPLS multipath setup triggered the same
KASAN report in 2 of 2 unpatched runs:

  BUG: KASAN: slab-use-after-free in mpls_select_multipath
  Read of size 1 at addr ffff88800ecc6e20 by task ksoftirqd/1/23

  Call Trace:
   mpls_select_multipath
   mpls_forward
   __netif_receive_skb_list_core
   netif_receive_skb_list_internal
   napi_complete_done
   gro_cell_poll
   __napi_poll
   net_rx_action

  Freed by task 23:
   kfree
   pskb_expand_head
   __pskb_pull_tail
   mpls_select_multipath

Reload hdr from the current skb head after each successful pull before
deriving the inner IPv4 or IPv6 header pointer.

Fixes: 9f427a0e474a ("net: mpls: Fix multipath selection for LSR use case")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260814095404.7205-1-a0yami@mailbox.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mpls/af_mpls.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -197,6 +197,7 @@ static u32 mpls_multipath_hash(struct mp
 		if (pskb_may_pull(skb, mpls_hdr_len + sizeof(struct iphdr))) {
 			const struct iphdr *v4hdr;
 
+			hdr = mpls_hdr(skb) + label_index;
 			v4hdr = (const struct iphdr *)(hdr + 1);
 			if (v4hdr->version == 4) {
 				hash = jhash_3words(ntohl(v4hdr->saddr),
@@ -207,6 +208,7 @@ static u32 mpls_multipath_hash(struct mp
 						 sizeof(struct ipv6hdr))) {
 				const struct ipv6hdr *v6hdr;
 
+				hdr = mpls_hdr(skb) + label_index;
 				v6hdr = (const struct ipv6hdr *)(hdr + 1);
 				hash = __ipv6_addr_jhash(&v6hdr->saddr, hash);
 				hash = __ipv6_addr_jhash(&v6hdr->daddr, hash);


