Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828122673B7;
	Tue,  8 Apr 2025 11:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110740; cv=none; b=UsAmDEURrheiLE25xyAk/IjwuBeQ0fgN9K1SViBKeijnzRCQ3Ks5MHnHfm4dPwPMOHPvFzKTXQFiXcpeWIkZxgN7+EX+Q1MVkvbVEOG+Jq33rN88PZHjmJFyBcwa9Mcokj/6/06zhYzGKyJeoYxs1TmU3RBCVtMXNOHrJ4DsgUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110740; c=relaxed/simple;
	bh=VsuGen+L6dfru7UT/v30SPWZ8pd1qhpqhFNWgebRXkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISAoyXApf6kKBpslN4Ie/7ROu1DfvuWOpLyEc4CkgTq20YN6ldZJk3dafgfjncXzGcsf2DCT+d4jWBVXx1PZy7FlsCP7MUZkWY5useUtf8YAPyO60HH0aQpQFVoWiQf0pdEMZq5vgoFNiwmXoWFpVT2aS1MjZHwWXFRaelSbYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOjJUntO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOjJUntO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFFBC4CEE5;
	Tue,  8 Apr 2025 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110740;
	bh=VsuGen+L6dfru7UT/v30SPWZ8pd1qhpqhFNWgebRXkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOjJUntOI6qYVnnYaOulk+/NrnuqJSUNC5/GbACXgGJoMXC/z2wJoPgZtHWQQvby3
	 fZtdTkfwX1d8eLzmQ/OVofRhrWPSdHN0P2fJq3lHhaNH5VpXKpDzilrE58TK4JIFHa
	 C4S+KkgUtBDX6ZgJ0JIa6uX1cUgTZgGRlAg8q5n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kundan Kumar <kundan.kumar@samsung.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 177/731] block: fix adding folio to bio
Date: Tue,  8 Apr 2025 12:41:14 +0200
Message-ID: <20250408104918.394279720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 26064d3e2b4d9a14df1072980e558c636fb023ea ]

>4GB folio is possible on some ARCHs, such as aarch64, 16GB hugepage
is supported, then 'offset' of folio can't be held in 'unsigned int',
cause warning in bio_add_folio_nofail() and IO failure.

Fix it by adjusting 'page' & trimming 'offset' so that `->bi_offset` won't
be overflow, and folio can be added to bio successfully.

Fixes: ed9832bc08db ("block: introduce folio awareness and add a bigger size from folio")
Cc: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20250312145136.2891229-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6ac5983ba51e6..6deea10b2cd3d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1026,9 +1026,10 @@ EXPORT_SYMBOL(bio_add_page);
 void bio_add_folio_nofail(struct bio *bio, struct folio *folio, size_t len,
 			  size_t off)
 {
+	unsigned long nr = off / PAGE_SIZE;
+
 	WARN_ON_ONCE(len > UINT_MAX);
-	WARN_ON_ONCE(off > UINT_MAX);
-	__bio_add_page(bio, &folio->page, len, off);
+	__bio_add_page(bio, folio_page(folio, nr), len, off % PAGE_SIZE);
 }
 EXPORT_SYMBOL_GPL(bio_add_folio_nofail);
 
@@ -1049,9 +1050,11 @@ EXPORT_SYMBOL_GPL(bio_add_folio_nofail);
 bool bio_add_folio(struct bio *bio, struct folio *folio, size_t len,
 		   size_t off)
 {
-	if (len > UINT_MAX || off > UINT_MAX)
+	unsigned long nr = off / PAGE_SIZE;
+
+	if (len > UINT_MAX)
 		return false;
-	return bio_add_page(bio, &folio->page, len, off) > 0;
+	return bio_add_page(bio, folio_page(folio, nr), len, off % PAGE_SIZE) > 0;
 }
 EXPORT_SYMBOL(bio_add_folio);
 
-- 
2.39.5



