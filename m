Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E9447A6A;
	Mon,  1 Apr 2024 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988187; cv=none; b=CdMp8deaKgnPTUlNpolqBzaZFt2ZCirByea2uwW6TyPz0KSPAEK07TuT3m3TzeLskNACTSSyutuYWohtHCyCOABL9/1QFOAtu6QtRAK8T17R6HXhaOzFDjHFSlj0FyWVPURlYH4VdkRhQb5Le0tUrvGi7D5i2iDjlpse6Ror7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988187; c=relaxed/simple;
	bh=lx86JM82je5ThMJ+nGsNy9rzbmXb2x+BFJxn+B9ZZCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDxSZ9cRBH8TBqvtsf1hbQm+fyoYEOQ2iRai9YoCXuJrLUKqNvQsmAZg8Txy75PWck45n7jKq2GAF2TutNP8H8fcIi+AIDHP6G/FZVXK3F9FtGzQwO8EUXkd/tHLpY+ST3eQrSuuZkYhmcf05gWYL1vYnjlkDy8SDBHYXvcU630=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4F+KnpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4F+KnpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0001C433C7;
	Mon,  1 Apr 2024 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988186;
	bh=lx86JM82je5ThMJ+nGsNy9rzbmXb2x+BFJxn+B9ZZCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4F+KnpDKKYwGET7IkZ2y+1RpSHHkPBCh7fekmULe2BX0uuE8WkCZNlkWH+HT42wc
	 7U4hcRcDOe1n11OTqmtsilJ8c8oVRP0dgWDpkra68ps8bLr+Q32h0kG2oOjmAHu+Xe
	 DvsyhEZdgcauCoYlysL4YdvX5EkpuKoC/65tDIgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Greg Edwards <gedwards@ddn.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 110/432] block: Fix page refcounts for unaligned buffers in __bio_release_pages()
Date: Mon,  1 Apr 2024 17:41:37 +0200
Message-ID: <20240401152556.410754737@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 38b43539d64b2fa020b3b9a752a986769f87f7a6 ]

Fix an incorrect number of pages being released for buffers that do not
start at the beginning of a page.

Fixes: 1b151e2435fc ("block: Remove special-casing of compound pages")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Tested-by: Greg Edwards <gedwards@ddn.com>
Link: https://lore.kernel.org/r/86e592a9-98d4-4cff-a646-0c0084328356@cybernetics.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 270f6b99926ea..62419aa09d731 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1149,7 +1149,7 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
 
 	bio_for_each_folio_all(fi, bio) {
 		struct page *page;
-		size_t done = 0;
+		size_t nr_pages;
 
 		if (mark_dirty) {
 			folio_lock(fi.folio);
@@ -1157,10 +1157,11 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
 			folio_unlock(fi.folio);
 		}
 		page = folio_page(fi.folio, fi.offset / PAGE_SIZE);
+		nr_pages = (fi.offset + fi.length - 1) / PAGE_SIZE -
+			   fi.offset / PAGE_SIZE + 1;
 		do {
 			bio_release_page(bio, page++);
-			done += PAGE_SIZE;
-		} while (done < fi.length);
+		} while (--nr_pages != 0);
 	}
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);
-- 
2.43.0



