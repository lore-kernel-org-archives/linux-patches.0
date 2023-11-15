Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC7B39FC0
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIWfF1a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D767C4E777;
	Wed, 15 Nov 2023 20:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081597;
	bh=gR7Z1+UevWg6j1qebmWtHDVVeWauOsRDvW2CysmflGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIWfF1a8VoJWyCI1EFKh2qBQZO1YytQWuzIh+OyPZJfss3gGBq8xtrlV7l4NKds0i
	 h8z2CJW+HBlYqQIqPxLkj4l4esk7uYU/GWxhp6ld9rfdzq/3tZ4KnZBjMuTuW0eFOd
	 ANl/0zmnk7RSeRpVlJV6d0sM29f83K1lS4z+h3So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/244] block: remove unneeded return value of bio_check_ro()
Date: Wed, 15 Nov 2023 15:37:01 -0500
Message-ID: <20231115203602.090374547@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit bdb7d420c6f6d2618d4c907cd7742c3195c425e2 ]

bio_check_ro() always return false now. Remove this unneeded return value
and cleanup the sole caller. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Link: https://lore.kernel.org/r/20220905102754.1942-1-linmiaohe@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 1b0a151c10a6 ("blk-core: use pr_warn_ratelimited() in bio_check_ro()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fbbd59e6d7e15..a3d5306d130d0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -693,18 +693,15 @@ static inline bool should_fail_request(struct block_device *part,
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline bool bio_check_ro(struct bio *bio)
+static inline void bio_check_ro(struct bio *bio)
 {
 	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
-			return false;
+			return;
 		pr_warn("Trying to write to read-only block-device %pg\n",
 			bio->bi_bdev);
 		/* Older lvm-tools actually trigger this */
-		return false;
 	}
-
-	return false;
 }
 
 static noinline int should_fail_bio(struct bio *bio)
@@ -810,8 +807,7 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
-	if (unlikely(bio_check_ro(bio)))
-		goto end_io;
+	bio_check_ro(bio);
 	if (!bio_flagged(bio, BIO_REMAPPED)) {
 		if (unlikely(bio_check_eod(bio)))
 			goto end_io;
-- 
2.42.0



