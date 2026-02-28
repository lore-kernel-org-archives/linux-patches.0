Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA8E33D6F7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301627; cv=none; b=RjhJDmGlQtHabf4ydvmDOTDXrh6R/WNLx8Fv6W5vSvf7/OsP2DORxo57xo+dRC7w+Ob0EYY5lPQIBvtWjIPLlH+Fg5CpJPXCDYFRULCnAwzzCvllDcd+0TKa/V/eTUCfHg0ETSB8e8Dascmq8kok6VvVwlfbbse3GEOAw/FukVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301627; c=relaxed/simple;
	bh=I0y4qAyFVqx0g8hXXZLxCFYwfh9DZEu+xmcP9+xzMAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRJafB/n4r7MArDwZREVov5vJYQKNyTJRHNfAXxlV6td8uYeIbOwc+d8f9dezYc3uazH6+spNwzMgzPz30U60Qu5Guu/oXKrsO2zyd+7yMyk39g8n9F64t+fFT6wpuvYrAspxNxrK4lZvGg4QN+e9NEN312geunnlHD61wZpBjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FM/RFvSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FM/RFvSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ADDC116D0;
	Sat, 28 Feb 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301627;
	bh=I0y4qAyFVqx0g8hXXZLxCFYwfh9DZEu+xmcP9+xzMAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM/RFvSN9pHZDlrwHYLc8V4DlunsH+LJMdiVGHdUDvH6j9KX6ARO9go+ION9Ihb5h
	 0SLQnuc7CCDNAA9AU0JsYAiRKjGSt0ShBay6tLdVIc6LoudejknxSGzYNC37ATKcy9
	 q3VEdT9qQ7RIKHs4IZpVdNLR4Gm3CBPvPRMRQxy14vRoWlgqT4B6PemOv7HmpXDClL
	 qWWD8Ix3cTdH4p5mJiwdsjX2yf7tVJ7iAz0SVVavAk3qliK3qb/KZg/EyJd1v91HuP
	 vIsrTDjrUydcWypHJf0bTIM+JZyM9J1NgR6sTPo/3C+EAS1v4FHOv2V/wl619rma4F
	 G31PxmjRniQqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/385] erofs: get rid of raw bi_end_io() usage
Date: Sat, 28 Feb 2026 12:54:01 -0500
Message-ID: <20260228180011.1568201-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 80d0c27a0a4af8e0678d7412781482e6f73c22c7 ]

These BIOs are actually harmless in practice, as they are all pseudo
BIOs and do not use advanced features like chaining.  Using the BIO
interface is a more friendly and unified approach for both bdev and
and file-backed I/Os (compared to awkward bvec interfaces).

Let's use bio_endio() instead.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: bc804a8d7e86 ("erofs: handle end of filesystem properly for file-backed mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c  | 2 +-
 fs/erofs/fscache.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index 990defcf93043..bc2c9fb44236e 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -35,13 +35,13 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 	if (rq->bio.bi_end_io) {
 		if (ret < 0 && !rq->bio.bi_status)
 			rq->bio.bi_status = errno_to_blk_status(ret);
-		rq->bio.bi_end_io(&rq->bio);
 	} else {
 		bio_for_each_folio_all(fi, &rq->bio) {
 			DBG_BUGON(folio_test_uptodate(fi.folio));
 			erofs_onlinefolio_end(fi.folio, ret, false);
 		}
 	}
+	bio_endio(&rq->bio);
 	bio_uninit(&rq->bio);
 	if (refcount_dec_and_test(&rq->ref))
 		kfree(rq);
diff --git a/fs/erofs/fscache.c b/fs/erofs/fscache.c
index ce3d8737df85d..20e2cb18ed1d4 100644
--- a/fs/erofs/fscache.c
+++ b/fs/erofs/fscache.c
@@ -187,7 +187,7 @@ static void erofs_fscache_bio_endio(void *priv,
 
 	if (IS_ERR_VALUE(transferred_or_error))
 		io->bio.bi_status = errno_to_blk_status(transferred_or_error);
-	io->bio.bi_end_io(&io->bio);
+	bio_endio(&io->bio);
 	BUILD_BUG_ON(offsetof(struct erofs_fscache_bio, io) != 0);
 	erofs_fscache_io_put(&io->io);
 }
@@ -218,7 +218,7 @@ void erofs_fscache_submit_bio(struct bio *bio)
 	if (!ret)
 		return;
 	bio->bi_status = errno_to_blk_status(ret);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static int erofs_fscache_meta_read_folio(struct file *data, struct folio *folio)
-- 
2.51.0

