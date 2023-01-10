Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C604F6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1C8C433F0;
	Tue, 10 Jan 2023 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374324;
	bh=KoA8v2Anve2Hy3NsYGykVYAmzhdRQY2RqcDs1xt48xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaa65bvhQ8ozWtzmSgn1uJ/Rh3c9jf52EYJR1OFaLjaSTqHmKTeqgg+Eb9gTPG864
	 QVqOA2Q9jYROU68JiggqigvqHpPD7leE0QvM8i4dsYTvKeWNgA64qQeOAAB//ycC+M
	 /JPIVcUcDSGiHWLHbDyLbM6MlUpYgyl2VdU9EGnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 130/148] block: dont allow splitting of a REQ_NOWAIT bio
Date: Tue, 10 Jan 2023 19:03:54 +0100
Message-Id: <20230110180021.308674383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 9cea62b2cbabff8ed46f2df17778b624ad9dd25a upstream.

If we split a bio marked with REQ_NOWAIT, then we can trigger spurious
EAGAIN if constituent parts of that split bio end up failing request
allocations. Parts will complete just fine, but just a single failure
in one of the chained bios will yield an EAGAIN final result for the
parent bio.

Return EAGAIN early if we end up needing to split such a bio, which
allows for saner recovery handling.

Cc: stable@vger.kernel.org # 5.15+
Link: https://github.com/axboe/liburing/issues/766
Reported-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -300,6 +300,16 @@ static struct bio *bio_split_rw(struct b
 	*segs = nsegs;
 	return NULL;
 split:
+	/*
+	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
+	 * with EAGAIN if splitting is required and return an error pointer.
+	 */
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_status = BLK_STS_AGAIN;
+		bio_endio(bio);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	*segs = nsegs;
 
 	/*


