Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B9A6A024;
	Tue, 23 Jan 2024 02:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975446; cv=none; b=qDFALPHumfGB58Egg+3OkAtSVb1OhTU4RdH672e8CLi/5pO6A3oqm5/JsqZ2VzZfTAGn5aKToLf9+H32AenZYUfOa5o94WVLQFCwq9DB6S9szdGx35YIs+XOuig5esrHI9LFZoPU02qzyQm3vIAOQN4w4oMFVRoLF/y3EAqot18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975446; c=relaxed/simple;
	bh=EKTMnDVybyCKS31nQfpaKx5ddb/EGbcOyytN9/CyQVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+rpt9Wmfp4/usrMi9u2ubkONQeooz8OztFu1SuHp7hq/16tc40T1qTpq3S7c+weEweUltlMG7mQ4TgxGCrewwh5HZs/+DCKGLl9gsInYIubzYpjrOroSoz2XKqwkdYy1oPXpcv6KNle3Yg2lT6JvjNNJKpyGIc4zmz3xWbTY6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoJDVQ+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoJDVQ+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A160C43399;
	Tue, 23 Jan 2024 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975446;
	bh=EKTMnDVybyCKS31nQfpaKx5ddb/EGbcOyytN9/CyQVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoJDVQ+5RkqH/1YjvqyEPXwogw9BWnXPktamvSsPV+1lUDJlDN/eD/fJt5pM/sdiU
	 Q5i+nbybvoesSs5VC5DABz80J2mLyYvFddyVjz8kbzYPUGPGol2A96aYSZxp3oaicg
	 rliR/KxWRDww2k6UHXa4gKBXX+I8Mu8Y6ahamo3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b23309d5788a79d3eea@syzkaller.appspotmail.com,
	syzbot+004c1e0fced2b4bc3dcc@syzkaller.appspotmail.com,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 403/583] block: Fix iterating over an empty bio with bio_for_each_folio_all
Date: Mon, 22 Jan 2024 15:57:34 -0800
Message-ID: <20240122235824.315022136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


