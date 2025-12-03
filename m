Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A6C3148D5;
	Wed,  3 Dec 2025 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776831; cv=none; b=UcgkV7y7BufcEkzHr6rEWQkfA7jBBrBpqtgrd07npZl1x72LSHywx73VxBrG1n1QrjANlviODQ5GOqWb+Mg4msEAiIr9xKjeFVLLPCOinQAbG09+Fg+fM3bv9UjiscivhjVnxjV+YO3SoBRW6Pnb5i7k9AlfXLkNdhF60YQdBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776831; c=relaxed/simple;
	bh=W2BFbYmqUGwN/RxUwEX7PHvKxfPt4HTGsetWX+C5Yk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/tbzDT+cdEO/ouI8xfolnRk1gP+tluAY2Z1KiVrjSvxiCwokgfAe4hBN/r3dZYI1xwhdwOHgECaIJWRZeEq1NamBjdKsQoJb6p5joSTTceIxungxzPkOZ8O4U80HnIi19H3oVlbABipqnLd7/HXJVAYL3ThEWOn6EosRKGndAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayf+bKU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayf+bKU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9753C4CEF5;
	Wed,  3 Dec 2025 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776831;
	bh=W2BFbYmqUGwN/RxUwEX7PHvKxfPt4HTGsetWX+C5Yk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayf+bKU2zcPRGLmxp3xMmbkb8NeQYxZhdH8m/Ptjl8NmE4hJcqUXTgMNMTPuNjt1T
	 Nwdgq9gF92yWT0lvnOVXxRtRtesDl3zWoJ30eSDUbM8fUoTgHKSeYbq4ZdIEyoxe8H
	 /7peO5xSKW8SGV4hQSmRdzU1+jiYSjEaNMPGNqbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 300/300] netfilter: nf_set_pipapo_avx2: fix initial map fill
Date: Wed,  3 Dec 2025 16:28:24 +0100
Message-ID: <20251203152411.737298627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit ea77c397bff8b6d59f6d83dae1425b08f465e8b5 upstream.

If the first field doesn't cover the entire start map, then we must zero
out the remainder, else we leak those bits into the next match round map.

The early fix was incomplete and did only fix up the generic C
implementation.

A followup patch adds a test case to nft_concat_range.sh.

Fixes: 791a615b7ad2 ("netfilter: nf_set_pipapo: fix initial map fill")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1106,6 +1106,25 @@ bool nft_pipapo_avx2_estimate(const stru
 }
 
 /**
+ * pipapo_resmap_init_avx2() - Initialise result map before first use
+ * @m:		Matching data, including mapping table
+ * @res_map:	Result map
+ *
+ * Like pipapo_resmap_init() but do not set start map bits covered by the first field.
+ */
+static inline void pipapo_resmap_init_avx2(const struct nft_pipapo_match *m, unsigned long *res_map)
+{
+	const struct nft_pipapo_field *f = m->f;
+	int i;
+
+	/* Starting map doesn't need to be set to all-ones for this implementation,
+	 * but we do need to zero the remaining bits, if any.
+	 */
+	for (i = f->bsize; i < m->bsize_max; i++)
+		res_map[i] = 0ul;
+}
+
+/**
  * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
  * @net:	Network namespace
  * @set:	nftables API set representation
@@ -1158,7 +1177,7 @@ bool nft_pipapo_avx2_lookup(const struct
 	res  = scratch->map + (map_index ? m->bsize_max : 0);
 	fill = scratch->map + (map_index ? 0 : m->bsize_max);
 
-	/* Starting map doesn't need to be set for this implementation */
+	pipapo_resmap_init_avx2(m, res);
 
 	nft_pipapo_avx2_prepare();
 


