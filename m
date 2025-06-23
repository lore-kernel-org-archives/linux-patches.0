Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF18223DDE;
	Mon, 23 Jun 2025 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713710; cv=none; b=kZXDrZ594h7ucGjcjTY+L4CJ6yA+fDvnLwsU5QA1hvcIl/ud2+sHGw5zy5RcxZZifoPgwvFfDPOY63GSmxZLjx+hv3TfMJpGQYFvonI/eHNYqlfv+qAsy9ftWfWBLScyXdDxiriphT1YDZwi61E/pL5BaUdJSgdqJUOd+PBDVZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713710; c=relaxed/simple;
	bh=zHnCxQkPIAl1RP6qoy5DUyNbGKTEVADHOJmuM3FNFSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clCjqmanR5y+FwyhDkPC6at7cA56obgNmoug8S9QaJiWJ375bhhww5RUvrbnfJZxSUF7z1IKXEkBVeoiX/kOXLPY+d1zRR6e+ioQspm+3YjA4fXjNm8M+yrPuTUkitiDxB+6rZ5fa/SI1eLtxN9DWDqfyRIKr9703cR3BzcnXe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBwm4+vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBwm4+vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DC0C4CEF0;
	Mon, 23 Jun 2025 21:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713709;
	bh=zHnCxQkPIAl1RP6qoy5DUyNbGKTEVADHOJmuM3FNFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBwm4+vnkqzelkB2vk+YR+v1FcWI1gF3ORffptT6wPO/ifu0gKcB/WJxZ65dXtS5B
	 ISOcSfZW77IddGq0vs3W/HxtAfEea9Csd8zYOKDRSkc0ltiVzeB0JX8u+YWW1b7QC+
	 g9tLHGZR3l0LWUOH4AOVzfxZrOQkvdHYF9Nv/Yng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Sanders <jsanders.devel@gmail.com>,
	Valentin Kleibel <valentin@vrvis.at>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/222] aoe: clean device rq_list in aoedev_downdev()
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130618.282377274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



