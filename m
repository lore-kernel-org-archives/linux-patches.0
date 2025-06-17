Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8003285059;
	Tue, 17 Jun 2025 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178337; cv=none; b=NDNe5iJNY78vLcLbqYo2DWhCVS0Zq9JicMrWucYQK89WW4/GeQvHblzW6LDl57vsyp6BxxEZhNjLkABo0Ksi2wjlbGJHPq8bTeA8cRKqfS5r/CegK0QBcqkKaDTeMvZ+NGMD4vOIcM4iZDaV6eY4imJ+Tzar1CD4Rwcoxqbg6sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178337; c=relaxed/simple;
	bh=9yhE4cS1J0t9Hi6sExWsGN1JWCz8eRp28e3HNOKO2X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB5T3W2uPplza5HMDgspO6yRuaMq+Qs4A6L0xSpl8UyCZCwDopQyC0u0B6m07WaYe8W1g6A691EpmmTNqbfhX7II4WYG6gJ1nIZA2lcCRwCxSN1N8WzlxYwFW40aM6dv5S6STNKiRqOqXhU4bbc1nFv75TKl33Dtz9UHSeBJz4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuFLGUVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuFLGUVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26983C4CEE3;
	Tue, 17 Jun 2025 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178337;
	bh=9yhE4cS1J0t9Hi6sExWsGN1JWCz8eRp28e3HNOKO2X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuFLGUVeBEKMwMp0Do/ZYUHkn8GU5oKFQwOlwqKFV/YuDHiTdRvksXogl12upeIh9
	 6FYkPJRS1/wLCG2yaCjrDI4+WxbH7vfY5iho6ZYemgkVOlOUbBxpsnuIEVpZYFGAtm
	 yiWGpeLZHLnm6Q1W8EhyVh01puEuVfL+LIS3q6mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/512] block: Fix bvec_set_folio() for very large folios
Date: Tue, 17 Jun 2025 17:27:27 +0200
Message-ID: <20250617152439.077340614@linuxfoundation.org>
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

[ Upstream commit 5e223e06ee7c6d8f630041a0645ac90e39a42cc6 ]

Similarly to 26064d3e2b4d ("block: fix adding folio to bio"), if
we attempt to add a folio that is larger than 4GB, we'll silently
truncate the offset and len.  Widen the parameters to size_t, assert
that the length is less than 4GB and set the first page that contains
the interesting data rather than the first page of the folio.

Fixes: 26db5ee15851 (block: add a bvec_set_folio helper)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20250612144255.2850278-1-willy@infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bvec.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f41c7f0ef91ed..a8333b82e766d 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -57,9 +57,12 @@ static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
  * @offset:	offset into the folio
  */
 static inline void bvec_set_folio(struct bio_vec *bv, struct folio *folio,
-		unsigned int len, unsigned int offset)
+		size_t len, size_t offset)
 {
-	bvec_set_page(bv, &folio->page, len, offset);
+	unsigned long nr = offset / PAGE_SIZE;
+
+	WARN_ON_ONCE(len > UINT_MAX);
+	bvec_set_page(bv, folio_page(folio, nr), len, offset % PAGE_SIZE);
 }
 
 /**
-- 
2.39.5



