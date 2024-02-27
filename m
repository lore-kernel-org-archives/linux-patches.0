Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5214600C;
	Tue, 27 Feb 2024 13:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041646; cv=none; b=a5s5LtEcxSNs9vR6lgsusABlakvyLgHUqVhO9/EUrEx117nbIgGUa71cD7F8I1tFlh91V6e4DjdGE2jYL6c2gafSgAm6/o/+rJTwWbBQ24uZUV9wYqnXKfxqcNSARcmEm9KD6i+V339sxMpyNT6VXpjWtnrpyqoIdXhm5BYyLFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041646; c=relaxed/simple;
	bh=fuBkK90EHenkr0QJ4tlM8Z8e11ctPzRD/G80zMQYM2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPkkIaNclU6skJMbsggoEVJwPm/YdZug9CE/yMfCFxKpQ4tugb0gXb/KhKIf60Fob0w4NwkiAdzSgfMsbGG7WBVzCVp0iobXvdiJ+iyh1LUKEbkApqlxszEdnr19ZTdGvUB4x48t0GgsKA9GAIs3yIYQwoVftjn11DE4CNKo8M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYdd++i7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYdd++i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DA4C43390;
	Tue, 27 Feb 2024 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041646;
	bh=fuBkK90EHenkr0QJ4tlM8Z8e11ctPzRD/G80zMQYM2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYdd++i7/pLniSyeets4pAI7NkMiyn6FCApnJ6SRyQZzpsee0E18ETmWA8+pa2UtZ
	 joQo1Idaq/iSiV47ZsXBBG8k1xCydUJy/5naSgxUwxG1WTcgJbdJX0X3Rp1Rd9+VxH
	 4zZHgqd1GhsZOZCo3vqKMVGb0Kpo2BN/gBf0y/nk=
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
Subject: [PATCH 6.6 021/299] block: Fix WARNING in _copy_from_iter
Date: Tue, 27 Feb 2024 14:22:12 +0100
Message-ID: <20240227131626.514190045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
index 8584babf3ea0c..71210cdb34426 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -205,12 +205,19 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
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



