Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8574E36CA;
	Fri,  9 Oct 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555615; cv=none; b=UPVSwtnE//Dwpsl0NNpBXg6ErzERvv7S2eBv+6JDdoI6o18goveJc/01axzTb2I0HpHaKG6uTAvgku+/2qNahRCEOX72CSkROHxyZDJyCyeHWjmULywgX5RO1tAtJyZzzmismkvJsf4pj0Q824fZB++aWrvDQ1XOruXFj1ORchI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555615; c=relaxed/simple;
	bh=b78LrvWBhkFPe+wgk0TQaqSXxM3oBQAZ9fwibenUnWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bImP1wap/UDyfFv2mjsivZk55ZPRuvYdp+mwriiajn+fS3X3wCKWVBN7bT1V27dhKX0Wu3FyJaHawR/m3HScIQYuHaV7HnAc377jJmZNIqlo06eKVDcG2OQSml1TslbjMT3BTEYzfYLUW1gbXgyYT9HQk3yoKWwyAR00S4OqLh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjnPgZTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjnPgZTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA3F1F000FF;
	Fri,  9 Oct 2026 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555606;
	bh=rpYM8srOo2w1SKKWftdDl4sAhUzogywZn7laTjG8Dwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjnPgZTViZtdlwFI9n4t/cu7vgjDNWpxhfOByBF7WeLAz9ksMZuqAvcpt3KJr4RWc
	 hVvHbF3rqOwix4ERtYyyJ1UrfQNLylnMNwf6j6QukrV/4xq9mcY1K2xidNhk3xNOJh
	 RTFH6+iYOWn3qrfnYlXXvh+pIyqdQjxS1Dn2gn5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alireza Asgari <alireza@asgari.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 036/428] net: fix checksum offsets in skb_splice_from_iter()
Date: Fri,  9 Oct 2026 16:06:13 +0200
Message-ID: <20261009140946.881525929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7397,7 +7397,8 @@ nodefer:	kfree_skb_napi_cache(skb);
 }
 
 static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
-				 size_t offset, size_t len)
+				 size_t offset, size_t len,
+				 unsigned int csum_offset)
 {
 	const char *kaddr;
 	__wsum csum;
@@ -7405,7 +7406,7 @@ static void skb_splice_csum_page(struct
 	kaddr = kmap_local_page(page);
 	csum = csum_partial(kaddr + offset, len, 0);
 	kunmap_local(kaddr);
-	skb->csum = csum_block_add(skb->csum, csum, skb->len);
+	skb->csum = csum_block_add(skb->csum, csum, csum_offset);
 }
 
 /**
@@ -7465,7 +7466,8 @@ ssize_t skb_splice_from_iter(struct sk_b
 			}
 
 			if (skb->ip_summed == CHECKSUM_NONE)
-				skb_splice_csum_page(skb, page, off, part);
+				skb_splice_csum_page(skb, page, off, part,
+						     skb->len + spliced);
 
 			off = 0;
 			spliced += part;


