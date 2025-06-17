Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E772CCC5;
	Tue, 17 Jun 2025 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176970; cv=none; b=eDVibeIDi/bubCQij34334QGc2j9rnvuwyH0yy3swD1upj++0/du2CLdki+JI8pN+vSbmZ4JOL3n6Ub+TTHA06b2lfuELxaR48/p5DJ3kMzo3dAbeou6Wh30P15YBkc1XVX59v0cPcFSB+zG6/pgUybF8ZJ67BQ2dDr3SZvgMeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176970; c=relaxed/simple;
	bh=ZtGO1Mj9Kl/0YWQgfZsZy20kD8m1Wih03InaQMCFVYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KizY4aA4WDpWFId1Cvu8DweQIbOEggHglPnf2MYhEmD3HFQPMlT8A+aqLL8eC35j+I6n5NBWDzE7jb4q7wZGMO6LAWw5KxEULSPRUqEeJf+tFK98Sdw1BQhh1m16YgfW9mrqLSZ2PrwJgGQ0TLoGJnd9qwMOTgnfylrXI/Ed7VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03QjBBP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03QjBBP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2A3C4CEE3;
	Tue, 17 Jun 2025 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176969;
	bh=ZtGO1Mj9Kl/0YWQgfZsZy20kD8m1Wih03InaQMCFVYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03QjBBP9alSC2mldWXnojW8x09Vh0WAK4ksC2TdcxeRl4olkj0Am0rpk9STy1bWJ0
	 vnsduDN6I3o9Qpmb39u/XRa6OQTu6oEDIx2BEZdCsgSr0a0pmIqqpznX1HKW3hZWYP
	 vC8Ghs+wLUEa4JvozsqKfamePResjWdDSSQyXqzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/356] block: Fix bvec_set_folio() for very large folios
Date: Tue, 17 Jun 2025 17:27:30 +0200
Message-ID: <20250617152351.620228811@linuxfoundation.org>
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
index bd1e361b351c5..99ab7b2bba27c 100644
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



