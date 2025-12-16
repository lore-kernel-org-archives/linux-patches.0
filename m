Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8810332862F;
	Tue, 16 Dec 2025 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883955; cv=none; b=ZS3FeaJUVLka3vxi2tTi6rWM9cxK5+8vd960Domc0uNddNwT/UchVprWr6bgyQkmYZu3ML/VC+c7OcP+A1baCVwkNCPj4R91DFrPzLmcx74ex1cDCCqNxyS3d3Igtv/VpH4ylRuKnNVoAM8hXzWfyx8or+/UCfowy3+aKcxMBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883955; c=relaxed/simple;
	bh=/zW/neIqwbJ1ZLSfB/tiQjASYBar30J5SRbPMkUBKz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiPJyvUgKeJoWh8xY6Qbc7JmhYS07rpaMjph8lMrJNHo8Rumy5QbbJr6MG6QRf6V8buhEgFpg533948/26KithltT0KxONPq21D4Tj9mBS5062Bt3kwyKuEXvo7dCgasN7j85HQR9elpwNS6x+/XbjEI5ELiU5wt02ifI+u7mOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEsdnxNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEsdnxNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A60CC4CEF1;
	Tue, 16 Dec 2025 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883955;
	bh=/zW/neIqwbJ1ZLSfB/tiQjASYBar30J5SRbPMkUBKz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEsdnxNyrkVQ9V/33UBin+GubuX3kZz2xt3kB+pJTAydUOipxIC+lSOmTFX72lrDT
	 9P1cHB+YdNWEZbAfiFcBreFiLrNH2WI/qUFAgw0DWYmUXtFzu0qrL1YvtzWV0p59Eh
	 1UN/nhdHTZgD3ms0PxPPsg9/8TkbgjZrkiM/apWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@kernel.org>,
	chengkaitao <chengkaitao@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/354] block/mq-deadline: Introduce dd_start_request()
Date: Tue, 16 Dec 2025 12:10:15 +0100
Message-ID: <20251216111322.657588344@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 93a358af59c6e8ab00b57cfdb1c437516a4948ca ]

Prepare for adding a second caller of this function. No functionality
has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai@kernel.org>
Cc: chengkaitao <chengkaitao@kylinos.cn>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d60055cf5270 ("block/mq-deadline: Switch back to a single dispatch list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 19473a9b50440..690b51587301d 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -310,6 +310,19 @@ static bool started_after(struct deadline_data *dd, struct request *rq,
 	return time_after(start_time, latest_start);
 }
 
+static struct request *dd_start_request(struct deadline_data *dd,
+					enum dd_data_dir data_dir,
+					struct request *rq)
+{
+	u8 ioprio_class = dd_rq_ioclass(rq);
+	enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
+
+	dd->per_prio[prio].latest_pos[data_dir] = blk_rq_pos(rq);
+	dd->per_prio[prio].stats.dispatched++;
+	rq->rq_flags |= RQF_STARTED;
+	return rq;
+}
+
 /*
  * deadline_dispatch_requests selects the best request according to
  * read/write expire, fifo_batch, etc and with a start time <= @latest_start.
@@ -320,8 +333,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 {
 	struct request *rq, *next_rq;
 	enum dd_data_dir data_dir;
-	enum dd_prio prio;
-	u8 ioprio_class;
 
 	lockdep_assert_held(&dd->lock);
 
@@ -415,12 +426,7 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	dd->batching++;
 	deadline_move_request(dd, per_prio, rq);
 done:
-	ioprio_class = dd_rq_ioclass(rq);
-	prio = ioprio_class_to_prio[ioprio_class];
-	dd->per_prio[prio].latest_pos[data_dir] = blk_rq_pos(rq);
-	dd->per_prio[prio].stats.dispatched++;
-	rq->rq_flags |= RQF_STARTED;
-	return rq;
+	return dd_start_request(dd, data_dir, rq);
 }
 
 /*
-- 
2.51.0



