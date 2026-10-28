Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208645;
	b=ChS1MrsRROfBCp5ujpgzPcDv/4tlKJFE3Yan2StgK7CZwbmPTED1Rp3rZkFzGn07dxiM
	 oTvjcIJy5+ItTp8N4tHd6YYFFhUS9bJFuStKzPoiiCcy6RA1weNc4D3drVBrn+dd70iih
	 kb+sq6ygdrM/OL3Ag8xAa+GOmYtWCUq1118qixg0FdWao9KOo7VsBPxM7Gan0I0yx4Vsa
	 EBZwcrNIIAbm0z2aAZaj9ir4lag8EpSkLFlNCa+TKlRV/8xff2P4u5//tXQfznpoBP8nO
	 ZyXZYLzstngpOZIRjWdpQroaU7cEBNaz+UkIMWQAF9z6lnLZU9UwBwwFsTwOIrpYcXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2pY+lDuPmhghb34j90Gvwk2/XaobvpKQOOiu6rpC9ho=;
	b=bkP3MSNcNI7SveoPayA4dXsAEcuLdQroR+JKvdUA++wV0czI08doD5DBrZAqQ3rH4NgV
	 xDgCYKWiGm5cz8oNyrU1MV4vdCDDYf10LcKXeNLV+vMrWdTsIMdH9hNf9IzOMlR38+dwh
	 7l73TyS8LTTKcqAphSxBS2XorPmXCXhDjQnBAWXwiUHqya7wJ2rGDcpLdg9VsUAmmQUwY
	 tzDLmBBZo/P0U4JwjiVsbDepvS+J+meTP3NeguDWx7yiXF8aDU8H6IjoAMx/v18hAqxu4
	 qhd2MbFysrI8VTRXnWLVGx525xte+Dec+HbJphMtP/86YoLEA/OZI0YqIhg+GonKyqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y68PsHzh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B7606A31A;
	Wed, 28 Oct 2026 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y68PsHzh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF361F01825;
	Wed, 28 Oct 2026 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208644;
	bh=2pY+lDuPmhghb34j90Gvwk2/XaobvpKQOOiu6rpC9ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y68PsHzhbkBd89LZfap01iT7XQsK5h0UtnlGkBKsVb9rQjSExyoXD5DF8GMDFSfa3
	 ORvl+X3UJLqvHBd0rPrUjzK3xe9LiwTrkTeoOkqInvTmLu84jfp+BSUQ3jJ7unWrOA
	 /qg6m6dc/hlq2GWKyWzlEOS+mzqKW667fGhsDicQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/516] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 28 Oct 2026 17:55:01 +0100
Message-ID: <20261028170007.037323937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 481506a756dcd828ef42391cb08f38d8d96d38fc ]

vxlan_na_create() samples LL_RESERVED_SPACE() to size the reply skb and then
samples it again to reserve headroom. A concurrent vxlan_changelink() can
update needed_headroom between the two reads, creating a TOCTOU race. The
second value can exceed the allocation and make the Ethernet header write out
of bounds.

The race is reproducible on the unpatched kernel. It occurred when
vxlan_na_create() generated a neighbour reply while vxlan_changelink() changed
the link headroom. KASAN caught a four-byte write two bytes beyond a 704-byte
skbuff_small_head allocation.

Snapshot the headroom once and use that value for both allocation and
reservation.

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Link: https://patch.msgid.link/20260918032842.502409-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a2955729998cd..ac45cf9eea836 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2085,13 +2085,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	struct ipv6hdr *pip6;
 	u8 *daddr;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	int i, len;
 
 	if (dev == NULL || !pskb_may_pull(request, request->len))
 		return NULL;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 	reply = alloc_skb(len, GFP_ATOMIC);
 	if (reply == NULL)
@@ -2099,7 +2101,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



