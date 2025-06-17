Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD1A23771C;
	Tue, 17 Jun 2025 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176960; cv=none; b=b6Kq/ThPGm4cF94LZ4N6d+VU1zf7Oogp4Qs52/xSjpphZLjp2F3xgzIM7YsCRA0Lv1jEqTxn+f9sDS+3lR40lmFKf4ORHhscdF0cFvNnduN4yftVAp7DLUB61sVh8pkiGuwRWgx67VFj69cCRsnXv/ZcEnARAuYsI5SrZvpqFps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176960; c=relaxed/simple;
	bh=5onN8pn7bFtfz9XCQ3dfzZ0ZMtQLx5Elfs8pOQK0RZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGsHW39YxX9Bi/ZBdjbyOdjoebcZMoh67LShk9+xYB47tn5j3Ty9QUR2b8ztlRSce+ltDJBkq+POuEjMSPkj0GK6g+np0ze/9lBTBlp92bQcLPMyF4mm5CGPwemq98OTyccE1wiuTDXC9g3lPWCsaBvIn/RyocG6Et+AENDYMr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynls2JRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynls2JRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541EEC4CEE3;
	Tue, 17 Jun 2025 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176959;
	bh=5onN8pn7bFtfz9XCQ3dfzZ0ZMtQLx5Elfs8pOQK0RZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynls2JRbDlW9sOrLEimlvokNStORTlzHjdlbeZyG/lwLA2ZX06dUY9X6M9x/PUbDY
	 l3YbqmOfrz/yCEo0LHc4eN7v+BD6IYbiKOnTkYO5qlekJ+pIfj8YoKb1bjE8GdM/L7
	 DB2vtxKjFvf//JpetLo3+fux5uUtgAJE3DyQWgDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 334/356] bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP
Date: Tue, 17 Jun 2025 17:27:29 +0200
Message-ID: <20250617152351.581857651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b893418c3cc02..f193aef4fac08 100644
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



