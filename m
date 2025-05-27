Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E741AF0BB;
	Tue, 27 May 2025 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367095; cv=none; b=O8gLp23Nu8zJdwokZBtTN6IUJ2tyJwbt6jDAik6VxHNuAeMUZSKFHnjQ8BMIHgF2ryp44vIWhYDJs50adECf2dGSLUmjx+KYNKCc290URVSHivL3s2RXM6Gpqkb581U4OhCZGdyFled4vLp04qYNhTLR08TJEHh34BK9y9vNov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367095; c=relaxed/simple;
	bh=ntHaB7jbqQRAbiVok4W8AS4OcFaUWPo4LExaKDjYcjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z84fqn6F6/tf0EOORf3hfreGgFGLWAZtH1ER1jAaaVtybHR2IOivPzvhsfrzuGVhegbrHWSX8vo53OlcCh7Ej3PRzmB2WzwQQghpDVf1NuO/c3bWVw5g9UdS9/y6WtWMVgDFCDiIIOSKN0CaYYo/U68WjQDx0c6PWwzz5uepNq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xDlGz2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xDlGz2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6449C4CEE9;
	Tue, 27 May 2025 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367095;
	bh=ntHaB7jbqQRAbiVok4W8AS4OcFaUWPo4LExaKDjYcjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xDlGz2tKPrEmKBPtRoSGHw8Cz1ZicbQfhybk5fPY5quPVOLlkwp0b+HFTkxEOahZ
	 Io1MGtGlZxvvKVDscvoYkohb7aau88QJyrKPk0O+V8/rBgRgQfyoIxLFPsPemggraa
	 0HE9cjcDck+qmFEFTGYfdOSUHy4I1gOhl75UlPCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 276/783] blk-throttle: dont take carryover for prioritized processing of metadata
Date: Tue, 27 May 2025 18:21:13 +0200
Message-ID: <20250527162524.324130124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a9fc8868b350cbf4ff730a4ea9651319cc669516 ]

Commit 29390bb5661d ("blk-throttle: support prioritized processing of metadata")
takes bytes/ios carryover for prioritized processing of metadata. Turns out
we can support it by charging it directly without trimming slice, and the
result is same with carryover.

Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250305043123.3938491-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a52f0d6b40ad4..762fbbd388c87 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1623,13 +1623,6 @@ static bool tg_within_limit(struct throtl_grp *tg, struct bio *bio, bool rw)
 	return tg_may_dispatch(tg, bio, NULL);
 }
 
-static void tg_dispatch_in_debt(struct throtl_grp *tg, struct bio *bio, bool rw)
-{
-	if (!bio_flagged(bio, BIO_BPS_THROTTLED))
-		tg->carryover_bytes[rw] -= throtl_bio_data_size(bio);
-	tg->carryover_ios[rw]--;
-}
-
 bool __blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
@@ -1666,10 +1659,12 @@ bool __blk_throtl_bio(struct bio *bio)
 			/*
 			 * IOs which may cause priority inversions are
 			 * dispatched directly, even if they're over limit.
-			 * Debts are handled by carryover_bytes/ios while
-			 * calculating wait time.
+			 *
+			 * Charge and dispatch directly, and our throttle
+			 * control algorithm is adaptive, and extra IO bytes
+			 * will be throttled for paying the debt
 			 */
-			tg_dispatch_in_debt(tg, bio, rw);
+			throtl_charge_bio(tg, bio);
 		} else {
 			/* if above limits, break to queue */
 			break;
-- 
2.39.5



