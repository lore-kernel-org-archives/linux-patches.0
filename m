Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324065BC5;
	Tue, 23 Jan 2024 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971680; cv=none; b=OT9DdPcN+W5hvHyuZ7GrarI9FfaDfvV2Xxn3NTRz4sOP3Nd3kcmULERqilKGKVMZgtcBLlPXQUok1KvOU3hwckXRQ7RIgV3ofdibUe67gUSOm2KcH1ZsgAx2T29WM81pBOWwxwOFnpJYlha17LNeyQ3IIqrFLSKudBevNbSHWj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971680; c=relaxed/simple;
	bh=x6Rss4do+PyJNRwa/8GeiR5bLovlaLZIn0FDj4WozRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwBniXNP3ZOZ1EZmuErPIk43wS7YLMHwQAo4dQ+wr+W9rh4/yzeLwn4X1lwvmrU0xVj6khsdJZceUM1SYiWbR/X9Jt0iPjO7iQx9uPPYkZ8KfEkkhhgXVyXW51swc9SDHQopoQM1rEHmZhJRsB8EtV9hFQFoBz2BLBFm2uQfaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xrbr1Xxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xrbr1Xxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435E3C43390;
	Tue, 23 Jan 2024 01:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971680;
	bh=x6Rss4do+PyJNRwa/8GeiR5bLovlaLZIn0FDj4WozRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xrbr1XxrqqDE2pnIw2Ap3ZYkTg2YXdjguHP6aiIetWqPuCjmg+YOmz3Mcs9UVhQUu
	 ppqxoqvb+EbeS4J2Av+H6csCjoUnlWE9hJkLRfEldNTlcWDmEBDBmo2dU4qfxJj/kv
	 JL20M9r6ixfs5/gsn5rUo8SDzQqN2FZqMH26S5ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b23309d5788a79d3eea@syzkaller.appspotmail.com,
	syzbot+004c1e0fced2b4bc3dcc@syzkaller.appspotmail.com,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 296/417] block: Fix iterating over an empty bio with bio_for_each_folio_all
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235802.083920566@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
@@ -279,6 +279,11 @@ static inline void bio_first_folio(struc
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
@@ -296,10 +301,8 @@ static inline void bio_next_folio(struct
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
 


