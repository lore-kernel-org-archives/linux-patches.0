Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CFA47A76;
	Mon,  1 Apr 2024 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986876; cv=none; b=emTKiFmJFNXdtMPt42OryGFrAor42vRkePdNswx+gm3TmbkQAa+fjYK/TJJFhdDgjxxcu8uJv5X/sWiXEsPxzTm8Ee/GlqdCrJxmOtxiLRjKThxWhZJrJwZ3QwnoA37NmQp84AhDyOrNntJbp+t+VNDX+sABv9FCv0nE2ofDf1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986876; c=relaxed/simple;
	bh=TEbMRpiQwC95rv4j1LbProKDBRnHs65KvKektsv6EEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar4ppzgM6f1zsGEnA0QuBj8/4ROFOZvbHrojBvl+AHmiHiak4cixacRHtbhPCKPSORJfjepC3bWhyzoMM9OQmVaRpAjVjEsCvjy52jIECrvRAGPGtYwpQDkwBGUOHPFoQ98/77mHY5xdVnjRx7HyQPqlN9ssyZFuD+kOl5YpAfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfo1ja+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfo1ja+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0608EC43601;
	Mon,  1 Apr 2024 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986876;
	bh=TEbMRpiQwC95rv4j1LbProKDBRnHs65KvKektsv6EEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfo1ja+z9+gNGoLre1x9b6c0/70DEpwO8lYT6EYeAjx406RoAqfjpHOxXihPEUWW8
	 fuLPpYpQ5KI+kMJaPmu3lXkw+xSF0P4okX4hFNAOp3d4IPs4T+6qe6b0Nxx/QIpx9k
	 2yGMmb+YRyKH2gajOlXmpmXoWUxBhP6VBljYkDIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	Greg Edwards <gedwards@ddn.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 114/399] block: Fix page refcounts for unaligned buffers in __bio_release_pages()
Date: Mon,  1 Apr 2024 17:41:20 +0200
Message-ID: <20240401152552.593722473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index b9642a41f286e..b52b56067e792 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1152,7 +1152,7 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
 
 	bio_for_each_folio_all(fi, bio) {
 		struct page *page;
-		size_t done = 0;
+		size_t nr_pages;
 
 		if (mark_dirty) {
 			folio_lock(fi.folio);
@@ -1160,10 +1160,11 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
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



