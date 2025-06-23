Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143C3FB1B;
	Mon, 23 Jun 2025 22:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716262; cv=none; b=p3W71C+h1ncEYmpPpMc7e+WPVx6E70bPya448tj6bxY8WiDMKd6SqnxvH/4gw4JdI2f21BaCK2+UeJ9Po9TkvnUk81iNSRDgm3RVDkIaJGqxt67/T7PV3WTCarlrI/X2VyfVkaNMwNxNaQGUylEoC69taLbOavpCTDZb+s5Twkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716262; c=relaxed/simple;
	bh=kq34PNUrTriCGL1nlW9fe+F8uo+DjzFndo/w7v33ZlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpTD9nGoiNrwEC6Q9N/7Ipru04DFZWA5RpLuFGOsKB5PiobST+zMK/sv7bynGRIMlJVw5B/aNbvkI19dSTv1f4HcVTQ5d/QsKqlVEJ4HzVZ2sveXc8rs/sMqiIs/9dp6/jXcjTckglOYHUguzINauwczsH5PnqrTN3QUdXocwns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFCatz9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFCatz9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290FFC4CEEA;
	Mon, 23 Jun 2025 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716262;
	bh=kq34PNUrTriCGL1nlW9fe+F8uo+DjzFndo/w7v33ZlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFCatz9MTkHqh0/pyEb+jxEFAxXr6kY370yN5f13aKQ7k6xnGAXsROtWaSxu2NzIf
	 KVabnS7Eeag9ibo15/D6p5NJBxAuHQzzCuUO1ab45Q7OohExARV/2BooIUrvfa45bn
	 8y8DbB2dNcfzB/Hfm7cnvCqhTsAlHqT+dqi5w788=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Sanders <jsanders.devel@gmail.com>,
	Valentin Kleibel <valentin@vrvis.at>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/290] aoe: clean device rq_list in aoedev_downdev()
Date: Mon, 23 Jun 2025 15:08:33 +0200
Message-ID: <20250623130634.506194409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3523dd82d7a00..280679bde3a50 100644
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



