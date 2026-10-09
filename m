Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52319439F71;
	Fri,  9 Oct 2026 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555368; cv=none; b=LPAnh1AK7VYjNWO0IvsYkBrMEMsrrK5Vq4gu6RPfWdOL1j5wmOezbrCirMAgE5GwmSN/fQoBbNM8H7iiqbGDHfTJDsGR7T7yDknEkolZMXDqBlPO0FRviTPUEjnm5vo1PhRsq2Vmi9OG9mSA95bhtBmfPgI93mQPjo16Khea2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555368; c=relaxed/simple;
	bh=btGP4xnMnNazhviCt1RoK12z/dXejZxbjE5/osvuhrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dt8H6vuiOacxE4RTbi2iaxok9VExrIG/AxaWAWDHnNsneOwLBfZioyE0z9Wvg82YVoE8c0eQmH/o0D2Hx01djDH0XlHZPs7CtYR3aVPqGG4JtE8eosL0t5+Ps8l7z8PcXVTC+ZySPTXtlLX61A8g3eyRg5Dg8CqDcvGRjMAIf4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmwEiUpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmwEiUpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC791F000FF;
	Fri,  9 Oct 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555362;
	bh=SUV8q1GH8/vxoegEUBbPNh6vcoJemLHzqBd1y7vakJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmwEiUpxMwrOaR7hmbnv0pd2R2nMmH8HOYQzyWpJ7ciWyn4hBgF/nAwM23CAHj94v
	 LowKr1CqUlp5lvDHi8Opq2fl+Wl/LvPSOPr7RnX5pU+z9LsmRJJW60n5vWqzbF6Yyj
	 FO95e/FKtBI55xzXk4IEHKPlqONT4RU1n+VPcx3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alireza Asgari <alireza@asgari.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 032/403] net: fix checksum offsets in skb_splice_from_iter()
Date: Fri,  9 Oct 2026 16:06:33 +0200
Message-ID: <20261009140952.865161966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alireza Asgari <alireza@asgari.net>

commit febec6a7076499d16b37f556724a942633a270a6 upstream.

skb_splice_from_iter() appends multiple page fragments before updating
skb->len. However, skb_splice_csum_page() uses that unchanged length as the
offset for every fragment checksum. If bytes already appended during the
call have an odd total length, a later fragment's checksum is combined
with the wrong parity.

For example, prime a UDP socket with sendto(MSG_MORE) and splice two
distinct pipe buffers containing "abc" and "DEFGH". Uncorking reports
success, but the receiver discards the packet for a bad checksum.
This also affects IPv6 and fragments beginning near a page boundary.

Pass the initial skb length plus the bytes already spliced to the checksum
helper. Keep the existing final length update and partial-progress error
handling unchanged. CHECKSUM_PARTIAL does not use this helper and remains
unaffected.

Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
Cc: stable@vger.kernel.org
Signed-off-by: Alireza Asgari <alireza@asgari.net>
Link: https://patch.msgid.link/20260924-fix-udp-splice-checksum-v1-1-fe61d65447a8@asgari.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7327,7 +7327,8 @@ nodefer:	kfree_skb_napi_cache(skb);
 }
 
 static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
-				 size_t offset, size_t len)
+				 size_t offset, size_t len,
+				 unsigned int csum_offset)
 {
 	const char *kaddr;
 	__wsum csum;
@@ -7335,7 +7336,7 @@ static void skb_splice_csum_page(struct
 	kaddr = kmap_local_page(page);
 	csum = csum_partial(kaddr + offset, len, 0);
 	kunmap_local(kaddr);
-	skb->csum = csum_block_add(skb->csum, csum, skb->len);
+	skb->csum = csum_block_add(skb->csum, csum, csum_offset);
 }
 
 /**
@@ -7395,7 +7396,8 @@ ssize_t skb_splice_from_iter(struct sk_b
 			}
 
 			if (skb->ip_summed == CHECKSUM_NONE)
-				skb_splice_csum_page(skb, page, off, part);
+				skb_splice_csum_page(skb, page, off, part,
+						     skb->len + spliced);
 
 			off = 0;
 			spliced += part;


