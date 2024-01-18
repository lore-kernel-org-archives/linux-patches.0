Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383F422F1B;
	Thu, 18 Jan 2024 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575527; cv=none; b=WBxl8vWh22SP7CsB9QckIrMvcagg4nE48j60zqFVTIypRJv9pvteGRVoILVvtmV6YIKqTsnbujWTk+yjy1g7KfT5SSbZ/i9P54sC0cPgkXJQdU30ZV9LHj1ZhBpaYFoFGyRg2optd4J6/E8c4mVsuvwR3hOPP+N8LAmzxlCed0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575527; c=relaxed/simple;
	bh=enLLsixOyGkckTu/x8QKKOryh6YWtCSYozsu9PY7Us4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=tgJIxI16W2yKV6zG3mit9fPxIHOIlBoEkH4KosLzzKieMAzZgyiVM27AtYRsowEZEaGWKZdLwouNBnICQP8AH8NLEwktDj61N28CFwOiiQ8dUAj421+ZDibBRkPrASyz4zxY9zcr2+eVLKswkYMR5kAthx2GUM3vRssnAX8gBl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JbIipys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JbIipys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF94AC433F1;
	Thu, 18 Jan 2024 10:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575527;
	bh=enLLsixOyGkckTu/x8QKKOryh6YWtCSYozsu9PY7Us4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JbIipyszjbUWc3HSCIprqR/4wvUyKL/UiFySxurCiVYAHdCjP/dNVLAH0/d/TGKm
	 ghgSk/wRRk87mPLjeFpWn6yta5bKV5II3UsaffJm6/WBMJde5JUfGLx89JBSSNj8BI
	 NkLP1axcHZQ871bVhpQJhHljSF4X8ilhkJcPGeiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	David Jeffery <djeffery@redhat.com>,
	John Pittman <jpittman@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/100] blk-mq: dont count completed flush data request as inflight in case of quiesce
Date: Thu, 18 Jan 2024 11:48:22 +0100
Message-ID: <20240118104311.511678352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 0e4237ae8d159e3d28f3cd83146a46f576ffb586 ]

Request queue quiesce may interrupt flush sequence, and the original request
may have been marked as COMPLETE, but can't get finished because of
queue quiesce.

This way is fine from driver viewpoint, because flush sequence is block
layer concept, and it isn't related with driver.

However, driver(such as dm-rq) can call blk_mq_queue_inflight() to count &
drain inflight requests, then the wait & drain never gets done because
the completed & not-finished flush request is counted as inflight.

Fix this issue by not counting completed flush data request as inflight in
case of quiesce.

Cc: Mike Snitzer <snitzer@kernel.org>
Cc: David Jeffery <djeffery@redhat.com>
Cc: John Pittman <jpittman@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20231201085605.577730-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383d94615e50..368f1947c895 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1500,14 +1500,26 @@ void blk_mq_delay_kick_requeue_list(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
 
+static bool blk_is_flush_data_rq(struct request *rq)
+{
+	return (rq->rq_flags & RQF_FLUSH_SEQ) && !is_flush_rq(rq);
+}
+
 static bool blk_mq_rq_inflight(struct request *rq, void *priv)
 {
 	/*
 	 * If we find a request that isn't idle we know the queue is busy
 	 * as it's checked in the iter.
 	 * Return false to stop the iteration.
+	 *
+	 * In case of queue quiesce, if one flush data request is completed,
+	 * don't count it as inflight given the flush sequence is suspended,
+	 * and the original flush data request is invisible to driver, just
+	 * like other pending requests because of quiesce
 	 */
-	if (blk_mq_request_started(rq)) {
+	if (blk_mq_request_started(rq) && !(blk_queue_quiesced(rq->q) &&
+				blk_is_flush_data_rq(rq) &&
+				blk_mq_request_completed(rq))) {
 		bool *busy = priv;
 
 		*busy = true;
-- 
2.43.0



