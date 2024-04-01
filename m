Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268DB38DE5;
	Mon,  1 Apr 2024 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991216; cv=none; b=Ae1i0mQXUy2brSLHqK8SIWpmlZ7ocb6Nkiizp5VZs6ZqJIPvpVqcotLJ+HJgSrVJEVPHWAMmS5ZxFI7EFoO6tMSk8gy6Zchk8/kRbKFhRtGmakM/kqZZsb9G/DuEFPJmgLEEzauSKpAqi8jaLwAv37wQW2fxlj0GN++fICmTy7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991216; c=relaxed/simple;
	bh=W9HKN0ve170sj9I8vC1bD5k+OGtu2E0m7Seej9T9fyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA6RSqkHxYT0jxIYJC2kYIS3TyekgvlHOrIA+ncaL1SUTJxxQiBVYp1XLTsMzu+ss7l/CjUNbKEGWreYxBAPqbThfM1QMHOO1wOmtUN4/0FY8P+lk8UQr3hg8HUbJWBoOURhXagfNG4QkDfSRqZhewqJiOkoUgFMzgtVDNMgH4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMfgDf1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMfgDf1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D5AC433F1;
	Mon,  1 Apr 2024 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991215;
	bh=W9HKN0ve170sj9I8vC1bD5k+OGtu2E0m7Seej9T9fyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMfgDf1TH0Yur6ErNZelfvf+LrSEXhfSxrDgrcAafL35DCARwu7hG5t/v+oHWMpU2
	 IyRJSkpadcrb5QXBDqAS7jg2QmBvYMAhdbpFB/eklL0itrEQGzzgAmkHt4XFgVYVmZ
	 3TrgJ3QdJmOfDoisDEeLVvP5IBo8Xv+fJW7auFuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Greg Edwards <gedwards@ddn.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 197/272] block: Fix page refcounts for unaligned buffers in __bio_release_pages()
Date: Mon,  1 Apr 2024 17:46:27 +0200
Message-ID: <20240401152537.042085411@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

commit 38b43539d64b2fa020b3b9a752a986769f87f7a6 upstream.

Fix an incorrect number of pages being released for buffers that do not
start at the beginning of a page.

Fixes: 1b151e2435fc ("block: Remove special-casing of compound pages")
Cc: stable@vger.kernel.org
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Tested-by: Greg Edwards <gedwards@ddn.com>
Link: https://lore.kernel.org/r/86e592a9-98d4-4cff-a646-0c0084328356@cybernetics.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Tony: backport to v6.1 by replacing bio_release_page() loop with
  folio_put_refs() as commits fd363244e883 and e4cc64657bec are not
  present. ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1112,19 +1112,16 @@ void __bio_release_pages(struct bio *bio
 	struct folio_iter fi;
 
 	bio_for_each_folio_all(fi, bio) {
-		struct page *page;
-		size_t done = 0;
+		size_t nr_pages;
 
 		if (mark_dirty) {
 			folio_lock(fi.folio);
 			folio_mark_dirty(fi.folio);
 			folio_unlock(fi.folio);
 		}
-		page = folio_page(fi.folio, fi.offset / PAGE_SIZE);
-		do {
-			folio_put(fi.folio);
-			done += PAGE_SIZE;
-		} while (done < fi.length);
+		nr_pages = (fi.offset + fi.length - 1) / PAGE_SIZE -
+			   fi.offset / PAGE_SIZE + 1;
+		folio_put_refs(fi.folio, nr_pages);
 	}
 }
 EXPORT_SYMBOL_GPL(__bio_release_pages);


