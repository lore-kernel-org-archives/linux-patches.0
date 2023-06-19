Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6511096D
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738AAC433C0;
	Mon, 19 Jun 2023 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170893;
	bh=sH9HVvYilV22jYiC/xnmtGRFRNsQRkB7+KgOuE49w9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r07aRpL81FSjmLRA3ABUq2068mrLb2/oeB4OqrEU6BQ8ELglDju+axmTsvExMxzba
	 BwLBxed7FFW/HRaUgiv/y0tb6ZmNHjD+4pmbIvqySANG7rdCwu4NSrP8TmKBmHAxkr
	 Hh+whek/P9bv0QZArLt5xAi2fufSI2bTl/BzkxX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.3 074/187] dm thin: fix issue_discard to pass GFP_NOIO to __blkdev_issue_discard
Date: Mon, 19 Jun 2023 12:28:12 +0200
Message-ID: <20230619102201.214134860@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 722d90822321497e2837cfc9000202e256e6b32f upstream.

issue_discard() passes GFP_NOWAIT to __blkdev_issue_discard() despite
its code assuming bio_alloc() always succeeds.

Commit 3dba53a958a75 ("dm thin: use __blkdev_issue_discard for async
discard support") clearly shows where things went bad:

Before commit 3dba53a958a75, dm-thin.c's open-coded
__blkdev_issue_discard_async() properly handled using GFP_NOWAIT.
Unfortunately __blkdev_issue_discard() doesn't and it was missed
during review.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -399,8 +399,7 @@ static int issue_discard(struct discard_
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOWAIT,
-				      &op->bio);
+	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)


