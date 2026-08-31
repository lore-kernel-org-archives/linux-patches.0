Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271A563282;
	Mon, 31 Aug 2026 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184067; cv=none; b=l25tdWm+LcX/gPx4ttUNUA8M0pUKaEgziN+urhoJ24dWxr+c6oXBtDOL6TbA3CQyMSN2TBK1yDZP58vp3hjcqVvk7LolwOQWHZAj3MDxREBqviY7KUxir3IBodmCsp6QURkJG9mVt1C7L/9cVLNkth5ljpmv4Uy7f1p6y1uhyrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184067; c=relaxed/simple;
	bh=ezTdqHPRzQ2HMvrw3Zp8zGAIRQTG+Vd+rhkCRc5IIr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuhdfmB3M4UWCuP4QiBPWjjaxGJhrrHQ6bCit9SdtIVd7sQxAlO8E7C5/7Uqwc+oh27C/dPoz8xPqMQEqJSXWQGTVEYxX/b6ch8AbSMvgJYyNH/WEWoPJSq/FUM6HSmsmIsF2Q2BxgiswUxkvPuGmytKV//lMvjARep78vPSUeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMTWq7vN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMTWq7vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03BB1F00A3E;
	Mon, 31 Aug 2026 13:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184065;
	bh=SBhvYtHLCQKIWgusEd5rxL7fpwhVE3NTpHEPl07DuHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMTWq7vN+/pN7CZK5TL2v4BorwD/A3SBziTjBMaIOT3DetYT03SZ79kSCZ8wCHkMB
	 g4nT4rSEnuqTOYQwEt8SiLBUIFCjqJ98G0tQjQXwfdTTYssr3L8dlO39h36Ek1Pmwh
	 aH7tcgP6NyX+WMfboxhdX351JwRUbfPfcg85ojLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 61/83] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Mon, 31 Aug 2026 15:34:37 +0200
Message-ID: <20260831133402.631874484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 55dd20f0f4b1be5c9c8a0275d8d763c86563eac2 upstream.

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1156,6 +1156,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(
 	struct nft_pipapo_scratch *scratch;
 	const struct nft_pipapo_field *f;
 	unsigned long *res, *fill, *map;
+	struct nft_pipapo_elem *e;
 	bool map_index;
 	int i;
 
@@ -1228,14 +1229,11 @@ struct nft_pipapo_elem *pipapo_get_avx2(
 next_match:
 		if (ret < 0) {
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return NULL;
+			e = NULL;
+			goto out;
 		}
 
 		if (last) {
-			struct nft_pipapo_elem *e;
-
 			e = f->mt[ret].e;
 			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
 				     !nft_set_elem_active(&e->ext, genmask))) {
@@ -1245,9 +1243,7 @@ next_match:
 			}
 
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return e;
+			goto out;
 		}
 
 		map_index = !map_index;
@@ -1255,9 +1251,12 @@ next_match:
 		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
+	e = NULL;
+out:
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	__local_unlock_nested_bh(&scratch->bh_lock);
-	return NULL;
+	return e;
 }
 
 /**


