Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DBC1419B4;
	Tue, 27 Feb 2024 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043183; cv=none; b=olkhkhC490qFSUVvsqsVd/Hiq6KxVGoxQhVsQ+nrbQ9B/yyU0ieyJ/gdpt6d63kU7WkpD6BdpSYiFtIBQ35SYRqFaWt+VftSK8782QyrPMB9NHnUkS32l2BfqJi/s/0uHRMVl2kg1lAnrejPXqh9u4mzc+r4uw5cOw2cGtOPjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043183; c=relaxed/simple;
	bh=IgvvUiiKZAx+pVk3Bxw/MnMFGpDJchQqJ78xA5M80aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiqKKS4gdrPGZvsEfl7WNzQonDcZnfQESL5g6e7hE5+Nsfl/eZ28oRzNVAHmYQfttDmi1aMNlwigezC2YIehJmKf16rllEBhpuzHVQB6wnVF5ltKsSbCpEf+kvZMFwq1XYGhBfx/ywGh8DG5MPHicwg+tUQneq/KzbMA/1f0J20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIvGZrzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIvGZrzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C15C433C7;
	Tue, 27 Feb 2024 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043183;
	bh=IgvvUiiKZAx+pVk3Bxw/MnMFGpDJchQqJ78xA5M80aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIvGZrzh3SQnlSNtGUeUuuxosYyu49oWHfyXr4LdT5vh3aFqyv5Zv9jHSwZ2KRVas
	 GjXIqOjCEjgGnxfIXMI3STHOR/cRmcEs8jzz7w3Vok5bmqyBZvsU4fwqLERUaYZQ7k
	 2eP6XgATMNRIOi5zyV8gi4HhEkWDxqQ7/kpgqc+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a532b03fdfee2c137666@syzkaller.appspotmail.com,
	syzbot+63dec323ac56c28e644f@syzkaller.appspotmail.com,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/195] block: Fix WARNING in _copy_from_iter
Date: Tue, 27 Feb 2024 14:24:39 +0100
Message-ID: <20240227131610.998055305@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 13f3956eb5681a4045a8dfdef48df5dc4d9f58a6 ]

Syzkaller reports a warning in _copy_from_iter because an
iov_iter is supposedly used in the wrong direction. The reason
is that syzcaller managed to generate a request with
a transfer direction of SG_DXFER_TO_FROM_DEV. This instructs
the kernel to copy user buffers into the kernel, read into
the copied buffers and then copy the data back to user space.

Thus the iovec is used in both directions.

Detect this situation in the block layer and construct a new
iterator with the correct direction for the copy-in.

Reported-by: syzbot+a532b03fdfee2c137666@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/0000000000009b92c10604d7a5e9@google.com/t/
Reported-by: syzbot+63dec323ac56c28e644f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/0000000000003faaa105f6e7c658@google.com/T/
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240121202634.275068-1-lk@c--e.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 66da9e2b19abf..b337ae347bfa3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -203,12 +203,19 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 	/*
 	 * success
 	 */
-	if ((iov_iter_rw(iter) == WRITE &&
-	     (!map_data || !map_data->null_mapped)) ||
-	    (map_data && map_data->from_user)) {
+	if (iov_iter_rw(iter) == WRITE &&
+	     (!map_data || !map_data->null_mapped)) {
 		ret = bio_copy_from_iter(bio, iter);
 		if (ret)
 			goto cleanup;
+	} else if (map_data && map_data->from_user) {
+		struct iov_iter iter2 = *iter;
+
+		/* This is the copy-in part of SG_DXFER_TO_FROM_DEV. */
+		iter2.data_source = ITER_SOURCE;
+		ret = bio_copy_from_iter(bio, &iter2);
+		if (ret)
+			goto cleanup;
 	} else {
 		if (bmd->is_our_pages)
 			zero_fill_bio(bio);
-- 
2.43.0



