Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F161419049B;
	Mon, 23 Jun 2025 21:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715509; cv=none; b=iringu8wc5v8sffjpViHCuf0c7tgSELV2oNHelNgktTL5SwfUprOsA4H3v6pf9y8XnudaTN2Y7c7WMdk/h3E6NaJlBo6aaD6vC9zFmys+6QNf02HsKladUZaw3/q9Il00v/uuBTpWsxkYV2iQpw41DByraeRqeYVgyFD+3mxTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715509; c=relaxed/simple;
	bh=XCkP4v9Vr2aRBcy6xir1RV7Nl7OBxiRL3C0aPtAQclc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rphgjf8KZCD/2oa5+qxy956DKmNGMhtv3hkMPvu7ptj+lMIXc0c1XzX/+/ig4aw51mRkeJTCCUbaiDZXuwCC4m3sJG3N9zmxXAkcaHKGXw2YW+LtXxflxdNWFBkS3pX02BV3eFrKc4EGXoAM+f+/+i13pQZiwF2A/255IGXhM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACmWF4rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACmWF4rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B73EC4CEEA;
	Mon, 23 Jun 2025 21:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715508;
	bh=XCkP4v9Vr2aRBcy6xir1RV7Nl7OBxiRL3C0aPtAQclc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACmWF4rNZ2MDArFJzNSXy9FU5vHjn4foq4TXbKS+urAglJXq5UM2OyO0DZagCnTDK
	 rcAT4iE6cV77GOsBnT3plXcBpvMiwEpVZUXOYoDbUBInil8l2iW1VAMHqzNy+Bkxh6
	 uCGqX1zGKowgJ+Q6rG2atc74PgPWlcmGYs76j/Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/508] bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP
Date: Mon, 23 Jun 2025 15:05:10 +0200
Message-ID: <20250623130651.765657415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit f826ec7966a63d48e16e0868af4e038bf9a1a3ae ]

It is possible for physically contiguous folios to have discontiguous
struct pages if SPARSEMEM is enabled and SPARSEMEM_VMEMMAP is not.
This is correctly handled by folio_page_idx(), so remove this open-coded
implementation.

Fixes: 640d1930bef4 (block: Add bio_for_each_folio_all())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20250612144126.2849931-1-willy@infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 00ab98ce1d438..6b2b06485684d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -287,7 +287,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 
 	fi->folio = page_folio(bvec->bv_page);
 	fi->offset = bvec->bv_offset +
-			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
+			PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
 	fi->_seg_count = bvec->bv_len;
 	fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
 	fi->_next = folio_next(fi->folio);
-- 
2.39.5



