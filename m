Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B44F211;
	Tue, 23 Jan 2024 00:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969778; cv=none; b=GwI4Ip5okP3qJFF8pty8HKrYrB9T1zzU5haiVcS0NQgxtg+X8DlhPS2/UWBlGcwszsJaVv/rDHL6O0jJ7yZPSuGdepvt525ieo9ZgjeJ62rKh8H+kkF993jlwkt8KKQVT9Dw/KXML1vlMPurDyrdOnOys89UNVRyowMwwQGg0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969778; c=relaxed/simple;
	bh=Ox2jOULpuEVECoTLz9daIkKenRAK+Ghrl0PuxNKlzCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsWbYF/qxs0hXiOGS+92NKA8nWywHLK2u/iWft7gZg83+G5X7YnmlT9fS+rR6KgVjKdio0K7nEVeV6V7poTm3lvAcALy9eJHBWRnGZkUBT6rZVDqYETioT9j2B/XYjqzaxUSkTOTRKLYkaDbslPMv3PcKuIFcOz6GXGJ6WPuxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSuWSMmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSuWSMmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CA2C433C7;
	Tue, 23 Jan 2024 00:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969778;
	bh=Ox2jOULpuEVECoTLz9daIkKenRAK+Ghrl0PuxNKlzCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSuWSMmr0UU1+9PHEypGC06vspSh6HTb5QKkvf9OeoOkNLE3xxC8rrMzzhmRWADUZ
	 CLY+oUZCFov1BRkc4LTa1zeuPhg4tNDyjTdC/dav2VIHotNXz25OHgP9U2h2PVz5Z+
	 24ejEm5g/P0xEbtL2DddVsLJG46985T5KUB5XMt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b23309d5788a79d3eea@syzkaller.appspotmail.com,
	syzbot+004c1e0fced2b4bc3dcc@syzkaller.appspotmail.com,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 443/641] block: Fix iterating over an empty bio with bio_for_each_folio_all
Date: Mon, 22 Jan 2024 15:55:47 -0800
Message-ID: <20240122235831.883587008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 7bed6f3d08b7af27b7015da8dc3acf2b9c1f21d7 upstream.

If the bio contains no data, bio_first_folio() calls page_folio() on a
NULL pointer and oopses.  Move the test that we've reached the end of
the bio from bio_next_folio() to bio_first_folio().

Reported-by: syzbot+8b23309d5788a79d3eea@syzkaller.appspotmail.com
Reported-by: syzbot+004c1e0fced2b4bc3dcc@syzkaller.appspotmail.com
Fixes: 640d1930bef4 ("block: Add bio_for_each_folio_all()")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240116212959.3413014-1-willy@infradead.org
[axboe: add unlikely() to error case]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bio.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -286,6 +286,11 @@ static inline void bio_first_folio(struc
 {
 	struct bio_vec *bvec = bio_first_bvec_all(bio) + i;
 
+	if (unlikely(i >= bio->bi_vcnt)) {
+		fi->folio = NULL;
+		return;
+	}
+
 	fi->folio = page_folio(bvec->bv_page);
 	fi->offset = bvec->bv_offset +
 			PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
@@ -303,10 +308,8 @@ static inline void bio_next_folio(struct
 		fi->offset = 0;
 		fi->length = min(folio_size(fi->folio), fi->_seg_count);
 		fi->_next = folio_next(fi->folio);
-	} else if (fi->_i + 1 < bio->bi_vcnt) {
-		bio_first_folio(fi, bio, fi->_i + 1);
 	} else {
-		fi->folio = NULL;
+		bio_first_folio(fi, bio, fi->_i + 1);
 	}
 }
 


