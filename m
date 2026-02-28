Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC11C2DFA3A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302517; cv=none; b=Q1s1I6uHCg+/mllAZvE0SPxf3It6U/Q/EBrB0mcn5cJPI9y2plPr4W0fKcocp2bfK4u+Qo3zM7PI3X40Ervjn4Gsbl16kKpxmxjwg9YdTwm2l4FhBh3BhY8lHqrorPVupr907rt4MC2/YNt2L5CkNbK7DC+B835+WkaTUJiWnn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302517; c=relaxed/simple;
	bh=KvxMqHY0tUezFSEJGncjZ2GT87hdFPjHaiK2RdIi4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWFPWmixVkylmBH+XyfikK8JOvMYYcnIFk3CVkrLVjxsk6LE+auekkfZ1dxqz54njsxrCNp1jIzHDdPfFC+4zorC3zdezzsoLlNlFc+EmVuzHnBbdKX6x433lWGy+S8/osFRMHfDHsgMwTSNe9/d9DiMjScSfujc5X2JbKZhRg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5XqUcUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5XqUcUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F25C116D0;
	Sat, 28 Feb 2026 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302517;
	bh=KvxMqHY0tUezFSEJGncjZ2GT87hdFPjHaiK2RdIi4PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5XqUcUNjtY01pZVNROs1ftnDza2v2qeU/DB/G/f837GyD6e5wetipidbtQNxBb0E
	 TG6Uz2+1a7PCuQr8ZKunhOhnp254xVfGK3EpRTHtOUVvvi8yKTrVypIXAV4Foyabiz
	 ht8FZfjRWQoikNA2mo8/uhjjo5qpMxbXJYk1Jpzu5zXxCL+Ij1akFOqutRL003YjlY
	 4b3LkBLSrIWAQEeBShveHzVUiUnBSjYURaHfCa/M5XQycZG5gVb5LFB2g86AtZqqrJ
	 sGaPREbWRO/yD4r9vByzIuTpXo0P+OKK2dh3ZWmEYjpV0Q0AzOSB0JfGX5xRJ9N4XN
	 Jm7qpIRgBsqlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/164] iomap: fix submission side handling of completion side errors
Date: Sat, 28 Feb 2026 13:12:33 -0500
Message-ID: <20260228181505.1600663-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4ad357e39b2ecd5da7bcc7e840ee24d179593cd5 ]

The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
more bios when a completion already return an error.  Commit cfe057f7db1f
("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
"copied", which is very wrong given that we've already consumed that
range and submitted a bio for it.

Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4ee7790f7b2ea..f5b36732b89b3 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -303,9 +303,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS);
 	do {
 		size_t n;
-		if (dio->error) {
-			iov_iter_revert(dio->submit.iter, copied);
-			copied = ret = 0;
+
+		/*
+		 * If completions already occurred and reported errors, give up now and
+		 * don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(dio->error))) {
+			ret = 0;
 			goto out;
 		}
 
-- 
2.51.0

