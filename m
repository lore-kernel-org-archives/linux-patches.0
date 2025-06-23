Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262A1F5820;
	Mon, 23 Jun 2025 21:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715809; cv=none; b=Ol/IGIUQZXSwbATJ2ZIOPn4D6vUTPV//Cv1LOdiGhgr9SeMCMG6eF34Q2KNrnDEZpx120G8x506dEVeU5dSQu2/nup00MqZ9OD0Vv9uAkn/SuBSEMDooPjRuvsAf5rDhUEgZzQeFSPEwBXF4vw7eNEJkMNeu+9QLF+UrHhri2bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715809; c=relaxed/simple;
	bh=r4oBdtqK7//Gdg/U3j+Pv+IvcNOF15T9Sl3K36KMIOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c76u09DlGuT2j8htvV/d2wFUU2oLXurPrn3w8RQAy7qGygwazeoXbMZ3tVP1N3O7OIhSM3FP/FOBuj88qp8z6J4ObX6+VjjcEgzsSN9SBM3cKQJSWi9wSsFOQHknRgfXUq0+/Id7cTFNqJUwtcs2gz+ufQUaQzPuERvfaiJkVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWdCDSaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWdCDSaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695A0C4CEEA;
	Mon, 23 Jun 2025 21:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715809;
	bh=r4oBdtqK7//Gdg/U3j+Pv+IvcNOF15T9Sl3K36KMIOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWdCDSaGb9Mn5rgmj4cu8pKW7KIUPPCdhLiD7kFTDaAjRLWCSck+JlCUaKxIkOh+H
	 ufdE+sCEbqSRN/iRwaFdakpZDWzx/hvPbb7cMh6AkVkAQNrXcQjo7nQ+TkqniBFIBL
	 mocZj+lg7EpGVgxfTcSeIf+8mILNa+9q/e/vflIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Sanders <jsanders.devel@gmail.com>,
	Valentin Kleibel <valentin@vrvis.at>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/355] aoe: clean device rq_list in aoedev_downdev()
Date: Mon, 23 Jun 2025 15:08:29 +0200
Message-ID: <20250623130636.036003054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Sanders <jsanders.devel@gmail.com>

[ Upstream commit 7f90d45e57cb2ef1f0adcaf925ddffdfc5e680ca ]

An aoe device's rq_list contains accepted block requests that are
waiting to be transmitted to the aoe target. This queue was added as
part of the conversion to blk_mq. However, the queue was not cleaned out
when an aoe device is downed which caused blk_mq_freeze_queue() to sleep
indefinitely waiting for those requests to complete, causing a hang. This
fix cleans out the queue before calling blk_mq_freeze_queue().

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212665
Fixes: 3582dd291788 ("aoe: convert aoeblk to blk-mq")
Signed-off-by: Justin Sanders <jsanders.devel@gmail.com>
Link: https://lore.kernel.org/r/20250610170600.869-1-jsanders.devel@gmail.com
Tested-By: Valentin Kleibel <valentin@vrvis.at>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/aoe/aoedev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e2ea2356da061..ec043f4bb1f2e 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -198,6 +198,7 @@ aoedev_downdev(struct aoedev *d)
 {
 	struct aoetgt *t, **tt, **te;
 	struct list_head *head, *pos, *nx;
+	struct request *rq, *rqnext;
 	int i;
 
 	d->flags &= ~DEVFL_UP;
@@ -223,6 +224,13 @@ aoedev_downdev(struct aoedev *d)
 	/* clean out the in-process request (if any) */
 	aoe_failip(d);
 
+	/* clean out any queued block requests */
+	list_for_each_entry_safe(rq, rqnext, &d->rq_list, queuelist) {
+		list_del_init(&rq->queuelist);
+		blk_mq_start_request(rq);
+		blk_mq_end_request(rq, BLK_STS_IOERR);
+	}
+
 	/* fast fail all pending I/O */
 	if (d->blkq) {
 		/* UP is cleared, freeze+quiesce to insure all are errored */
-- 
2.39.5



