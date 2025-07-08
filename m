Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC8C1DB127;
	Tue,  8 Jul 2025 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993736; cv=none; b=FZlSGfoqBC7jQkk5Kn/6tNP1HHeuAT38uA68SS7XVFetdix4oZaLu5p/8MjOCKgr3nMSHuTPIg8j7YCAN6v3ZM0SG59vOv1sWfvNMqHzmCWjIezpfFVNMbE1jcUzEGhtSR1e76nA2ZW+/Bh7rnxNe1du/YTLyrF8pBWX2Hl1cYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993736; c=relaxed/simple;
	bh=3co7QAW2WtA7Wt+id/ZIVs329ru+9o2JzbjWcXx/jrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka4HpEGPMrHnilCXTLJcOv1a8JPUtTiQP/wvnWSuttnP51QawVCuxMsHPVXk2q/et1CRLoEY97a4LdYTrSyjANYAT4WiU4OcJk63J5teDipmtiYvEtraxtl27bTeiqkrn8b2hDiso7HgzApZH5SnS70EuF8t/bGA5DcK8vynMus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCKOTJpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCKOTJpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8470BC4CEED;
	Tue,  8 Jul 2025 16:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993735;
	bh=3co7QAW2WtA7Wt+id/ZIVs329ru+9o2JzbjWcXx/jrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCKOTJppFmhBv2SsSiMEWl+Hl2EzBBFpVcZJw4IQUXSymNiTNUaH1vWxkRvxlYuBw
	 R2qCSQlaCHWitnz5ZJJIyAyozj1zS8PFEDed72hxJSDOAl86jfp+lWm7vbXgHbgzuz
	 vtk4eMbiVxozj9m0sprryzwayIMle1XpGkNnlCHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Sanders <jsanders.devel@gmail.com>,
	Valentin Kleibel <valentin@vrvis.at>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 135/178] aoe: defer rexmit timer downdev work to workqueue
Date: Tue,  8 Jul 2025 18:22:52 +0200
Message-ID: <20250708162240.083245458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Sanders <jsanders.devel@gmail.com>

[ Upstream commit cffc873d68ab09a0432b8212008c5613f8a70a2c ]

When aoe's rexmit_timer() notices that an aoe target fails to respond to
commands for more than aoe_deadsecs, it calls aoedev_downdev() which
cleans the outstanding aoe and block queues. This can involve sleeping,
such as in blk_mq_freeze_queue(), which should not occur in irq context.

This patch defers that aoedev_downdev() call to the aoe device's
workqueue.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212665
Signed-off-by: Justin Sanders <jsanders.devel@gmail.com>
Link: https://lore.kernel.org/r/20250610170600.869-2-jsanders.devel@gmail.com
Tested-By: Valentin Kleibel <valentin@vrvis.at>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/aoe/aoe.h    | 1 +
 drivers/block/aoe/aoecmd.c | 8 ++++++--
 drivers/block/aoe/aoedev.c | 5 ++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 749ae1246f4cf..d35caa3c69e15 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -80,6 +80,7 @@ enum {
 	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
 	DEVFL_FREEING = (1<<7),	/* set when device is being cleaned up */
 	DEVFL_FREED = (1<<8),	/* device has been cleaned up */
+	DEVFL_DEAD = (1<<9),	/* device has timed out of aoe_deadsecs */
 };
 
 enum {
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 92b06d1de4cc7..6c94cfd1c480e 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -754,7 +754,7 @@ rexmit_timer(struct timer_list *timer)
 
 	utgts = count_targets(d, NULL);
 
-	if (d->flags & DEVFL_TKILL) {
+	if (d->flags & (DEVFL_TKILL | DEVFL_DEAD)) {
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
@@ -786,7 +786,8 @@ rexmit_timer(struct timer_list *timer)
 			 * to clean up.
 			 */
 			list_splice(&flist, &d->factive[0]);
-			aoedev_downdev(d);
+			d->flags |= DEVFL_DEAD;
+			queue_work(aoe_wq, &d->work);
 			goto out;
 		}
 
@@ -898,6 +899,9 @@ aoecmd_sleepwork(struct work_struct *work)
 {
 	struct aoedev *d = container_of(work, struct aoedev, work);
 
+	if (d->flags & DEVFL_DEAD)
+		aoedev_downdev(d);
+
 	if (d->flags & DEVFL_GDALLOC)
 		aoeblk_gdalloc(d);
 
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 8c18034cb3d69..9b66f8ebce50d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -200,8 +200,11 @@ aoedev_downdev(struct aoedev *d)
 	struct list_head *head, *pos, *nx;
 	struct request *rq, *rqnext;
 	int i;
+	unsigned long flags;
 
-	d->flags &= ~DEVFL_UP;
+	spin_lock_irqsave(&d->lock, flags);
+	d->flags &= ~(DEVFL_UP | DEVFL_DEAD);
+	spin_unlock_irqrestore(&d->lock, flags);
 
 	/* clean out active and to-be-retransmitted buffers */
 	for (i = 0; i < NFACTIVE; i++) {
-- 
2.39.5



