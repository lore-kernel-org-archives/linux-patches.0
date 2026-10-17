Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EC73B3C0A;
	Sat, 17 Oct 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256236; cv=none; b=eXKOi6P8O8oB7DNi2xOmxyo8uF1/nj3oMN0ColnkXD5Gje1xowKJk0wPOoa0Riyj7e6ck1grB+Q1aU0dJa6BXElkxDDIt/5N9SNZP3Zks2E0Z6JwRn9i+bchOniDMnEzIGDjBxcuf3vPdbkzoxC7rVajyrfV63OelFzl1/XIxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256236; c=relaxed/simple;
	bh=hDplKP538W2y17W1yFWwbJuynu8bH4BS4leM5PreP1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X37z2nlTrjSIUHeFShasteXvtq19QJxOp+nnpPk6MX8po2ibA4jqxSF4l+0KQieyowVbdIzGFMpoCdZ014O0axFHadONltqfxEkYdaMQvR82d34vUWbEm37TbFAyMPNq8oXwprIwZ+VsOcVcBKqmOLeGQ+Vs+0E63V9M9v/xNFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4Yxg7aM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4Yxg7aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EA01F000C4;
	Sat, 17 Oct 2026 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256235;
	bh=x+61XAzk+/Bk9kGOO3PIhiwwnQ5OZDH7atVTo008UD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4Yxg7aMEMByKhIpHt/XfnPrjM3y0mKQ2DXlI/Nb4g6bZZGXcT2zEKFriBXcRWBZI
	 ygMLI1Rvd580kZbQtxpxRP33rmvv6XMQO7eWP81Y2QbEBkYxptHcGLi0t2Zv0MDbiF
	 X0bRMs4D3Nf8OBq6AwaxFoVXJoFyJ9LoTU5iJD3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alireza Asgari <alireza@asgari.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0170/1674] net: fix checksum offsets in skb_splice_from_iter()
Date: Sat, 17 Oct 2026 17:40:42 +0200
Message-ID: <20261017160435.521224372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6919,7 +6919,8 @@ nodefer:	__kfree_skb(skb);
 }
 
 static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
-				 size_t offset, size_t len)
+				 size_t offset, size_t len,
+				 unsigned int csum_offset)
 {
 	const char *kaddr;
 	__wsum csum;
@@ -6927,7 +6928,7 @@ static void skb_splice_csum_page(struct
 	kaddr = kmap_local_page(page);
 	csum = csum_partial(kaddr + offset, len, 0);
 	kunmap_local(kaddr);
-	skb->csum = csum_block_add(skb->csum, csum, skb->len);
+	skb->csum = csum_block_add(skb->csum, csum, csum_offset);
 }
 
 /**
@@ -6988,7 +6989,8 @@ ssize_t skb_splice_from_iter(struct sk_b
 			}
 
 			if (skb->ip_summed == CHECKSUM_NONE)
-				skb_splice_csum_page(skb, page, off, part);
+				skb_splice_csum_page(skb, page, off, part,
+						     skb->len + spliced);
 
 			off = 0;
 			spliced += part;


