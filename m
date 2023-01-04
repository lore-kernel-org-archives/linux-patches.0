Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF213AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472CEC433D2;
	Wed,  4 Jan 2023 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849243;
	bh=PvaCj3owL+92YPNXzW/5fYNFlyDOCueZa/eCuRjmF14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQtmRLpj/Z+M7DKKUoTRTOmeELDDOjVdla90IUAAVOfuBM0V/DzTy/fk0hq2snlzx
	 rIxyqq8vcrXDAIRMuIWsNCegTA3qIcA2dPkQb9tWGEwBUO6Mxffyv5xHw4Q6Xcz+k/
	 O1GZ6SEKO+17Vb2ni14fc6hG3vR2uZ5vuHAF/yeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 088/177] block: mq-deadline: Fix dd_finish_request() for zoned devices
Date: Wed,  4 Jan 2023 17:06:19 +0100
Message-Id: <20230104160510.310365867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 2820e5d0820ac4daedff1272616a53d9c7682fd2 upstream.

dd_finish_request() tests if the per prio fifo_list is not empty to
determine if request dispatching must be restarted for handling blocked
write requests to zoned devices with a call to
blk_mq_sched_mark_restart_hctx(). While simple, this implementation has
2 problems:

1) Only the priority level of the completed request is considered.
   However, writes to a zone may be blocked due to other writes to the
   same zone using a different priority level. While this is unlikely to
   happen in practice, as writing a zone with different IO priorirites
   does not make sense, nothing in the code prevents this from
   happening.
2) The use of list_empty() is dangerous as dd_finish_request() does not
   take dd->lock and may run concurrently with the insert and dispatch
   code.

Fix these 2 problems by testing the write fifo list of all priority
levels using the new helper dd_has_write_work(), and by testing each
fifo list using list_empty_careful().

Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20221124021208.242541-2-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -789,6 +789,18 @@ static void dd_prepare_request(struct re
 	rq->elv.priv[0] = NULL;
 }
 
+static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
+{
+	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
+	enum dd_prio p;
+
+	for (p = 0; p <= DD_PRIO_MAX; p++)
+		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
+			return true;
+
+	return false;
+}
+
 /*
  * Callback from inside blk_mq_free_request().
  *
@@ -828,9 +840,10 @@ static void dd_finish_request(struct req
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
-		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+		if (dd_has_write_work(rq->mq_hctx))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 	}
 }
 


