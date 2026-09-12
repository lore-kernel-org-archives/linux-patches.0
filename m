Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2072A3542F8;
	Sat, 12 Sep 2026 11:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212725; cv=none; b=nJuAX6P92WAajjliab5ug8Onw+L19p3NWymzKyH/+EVueSf1C2/R0UvhtY7daLq2P96dF0bkW8MNIW7E2hXPyJximOA+LZiDRzJgCqFjZvqpz25oAeym2ujUYRQeq+RxW0MsMvEZI4dlgmjL7bQKXajOCsLJNGc8z1Zj5/xNyb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212725; c=relaxed/simple;
	bh=5ypiwE+mvmio3upcKO8zvEYdzU38EGyQz/cbIe1swCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThH3tP9n9Gh8TN2LbGfIzUTfz277AeJv5n9THSYd5z84TWXnYh+rYK6aGtxaEkBDVrd8d1RUvxLszVoUi9m60Cd5FWQgY1dSp3+dS+y58/reAQ+Oy8vgyqEvdOZadh9LzfzUd2+beChjEO1yV++wlo6kao6er71Mzsump5VKhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIV+vS6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIV+vS6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303321F00893;
	Sat, 12 Sep 2026 11:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212721;
	bh=oukIghSbkyv6scElxdjmr4KWP9XUglhwygqsQ7TFyJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIV+vS6TtJ4sgXuMwrtN/h1ihvelv1DBwmkm4trfOK6XffWpQ0tH1lOmWA/XMwI2K
	 +6HHkMBVWXkj73lb5Qm1gQXjoe0EDFCHOGkeP7rFs1BK1G1iFApvW/WqXjuYBZ+CZZ
	 hnsdUrUkdM5ocawyZGT6ErZGnRcdtwwkLfEGixHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eauger@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1494/1518] block: save page offset gaps in cloned bio
Date: Sat, 12 Sep 2026 09:01:03 +0200
Message-ID: <20260912065657.358617032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 96c8ea3c5add7920b3c43840d1ea76b3354c8d2d ]

The cloned bio needs to inherit the accumulated gaps between vectors so
that we can know if this bio can subscribe to the iova coalescing
optimization.

When cloning for a split, the gap only applies to the front bio since
that's as far as has been processed. The remaining bio can reset its
gaps to 0 since it advanced past the checked vectors, and will start its
accounting from there on the next split check.

Fixes: 2f6b2565d43c ("block: accumulate memory segment gaps per bio")
Reported-by: Eric Auger <eauger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260819154937.3903312-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 5d1861dbe4c8b..63994b8cd8e1f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -834,6 +834,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
+	bio->bi_bvec_gap_bit = bio_src->bi_bvec_gap_bit;
 	bio->bi_iter = bio_src->bi_iter;
 
 	if (bio->bi_bdev) {
@@ -1717,6 +1718,14 @@ struct bio *bio_split(struct bio *bio, int sectors,
 
 	bio_advance(bio, split->bi_iter.bi_size);
 
+	/*
+	 * The gap bit is set when splitting to limits and only applies to the
+	 * front bio that was split off. The remaining bio will calcualte its
+	 * gap value when it is subsequently split to limits, so it is safe to
+	 * re-initialize the value back to 0.
+	 */
+	bio->bi_bvec_gap_bit = 0;
+
 	if (bio_flagged(bio, BIO_TRACE_COMPLETION))
 		bio_set_flag(split, BIO_TRACE_COMPLETION);
 
-- 
2.53.0



