Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382842DFF1F;
	Tue, 17 Jun 2025 16:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178331; cv=none; b=ITkp0l1+sD4KvawDVndTwCJh4Ryt6kKFxXY55KJguzjs/6CSObrKyLw+YCVvPbIkFMXLEu9qS78vLhan8dwTGSW4o6ixBbjAR3ph/yZ2UU5SeR71xuzZKAIM4FRFrOX3aixbveflgOlS7HIqlVTZIkfPpB94lm+LgyHlurDLC4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178331; c=relaxed/simple;
	bh=fzMzonFBT480RX1CnvDrudo4pQGBuSG/GCcH67VTL6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj5INsS1cR21oncqtnl5iLC8xGJY77ksv4hpXaWyrV/Lcf36erzpyhVr9j80l+94jxEcXoa6y8500PY5AXh/o1LsrKh9H36zyCAmD/H0q4AUBvqK9/VGxcETe4AooTIJE7eRhb4t/kkGyg6NvBP0od7vKHJwbksZXH1zYpYEAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOko48U7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOko48U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93274C4CEE3;
	Tue, 17 Jun 2025 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178331;
	bh=fzMzonFBT480RX1CnvDrudo4pQGBuSG/GCcH67VTL6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOko48U7i2HKkwgav6XE3U3yeVamMCDGG152CLdxPIuhXSLXVIbi64iN+OQwIOEDT
	 X4CkjV4vuS8+/+G7UHLjzYd685awIaOJAI2xpjC4bPY840qC0OjbM9ofVs6pMfbjeP
	 4R2//A3/24VinYIuCjIyGsknebkF5/chWUkEkr/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 480/512] bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP
Date: Tue, 17 Jun 2025 17:27:26 +0200
Message-ID: <20250617152439.035437298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9e98fb87e7ef7..1289b8e487801 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -294,7 +294,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 
 	fi->folio = page_folio(bvec->bv_page);
 	fi->offset = bvec->bv_offset +
-			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
+			PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
 	fi->_seg_count = bvec->bv_len;
 	fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
 	fi->_next = folio_next(fi->folio);
-- 
2.39.5



