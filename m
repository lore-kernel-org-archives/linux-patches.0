Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DC11A2FA1;
	Thu,  6 Jun 2024 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683211; cv=none; b=cBRS5gztm+L6FbCH+UpQP5cLcO9F2wYVYLU4K9rvZ5d/6KOhTAJlWR0975lsHJqJ6TCb+1exQcT+Kj2+qW8q/5tBbFBRZWBk++vucqkMa1whVM2TPMFF3Z+dubHO75PNmxlmkacnopJ3LEuynhonZnrKPd9vQUT2+p7SzjKzD7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683211; c=relaxed/simple;
	bh=px5O5FzFgfF6kbFfrBUyKiHHXU5Hy3ge66X7SCtfBOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvadmaCg2dMxX44G7NVpH07Yv6AHJP5IEDLbT3Djj8zoJy/102tTc56iMoGyaEyI5A08FTSKmUjM6crLRNZpj22j1EjZ5FzT9ZQFXdK6nn7tMkZk73Vu62LSxBTKlLiJQsNpRknoVHwY5kyW8HwpTXcA/ZM5jy6m+3LlMjnJfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdSa1ByP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdSa1ByP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF86C2BD10;
	Thu,  6 Jun 2024 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683211;
	bh=px5O5FzFgfF6kbFfrBUyKiHHXU5Hy3ge66X7SCtfBOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdSa1ByPfu3aevvBxJ7hszLQ1zcVEV+kWtyJZ9xttAfXSlHRGpXOnoHCAFK0aij3v
	 6ExS+oEta4AADglYXa1p4M5Fkc0j0qqQ7TKlP6pWK6a5xyP8IIVzFOh1dMx9yMhUDR
	 35YRzyYtco+VbO6JyAiAv0fP2TD6gIFtwvkBUrKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/473] block: open code __blk_account_io_done()
Date: Thu,  6 Jun 2024 16:00:17 +0200
Message-ID: <20240606131702.815071799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 06965037ce942500c1ce3aa29ca217093a9c5720 ]

There is only one caller for __blk_account_io_done(), the function
is small enough to fit in its caller blk_account_io_done().

Remove the function and opencode in the its caller
blk_account_io_done().

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20230327073427.4403-2-kch@nvidia.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 99dc422335d8 ("block: support to account io_ticks precisely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 33ac49dc775d7..355c4c52065b8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -971,17 +971,6 @@ bool blk_update_request(struct request *req, blk_status_t error,
 }
 EXPORT_SYMBOL_GPL(blk_update_request);
 
-static void __blk_account_io_done(struct request *req, u64 now)
-{
-	const int sgrp = op_stat_group(req_op(req));
-
-	part_stat_lock();
-	update_io_ticks(req->part, jiffies, true);
-	part_stat_inc(req->part, ios[sgrp]);
-	part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
-	part_stat_unlock();
-}
-
 static inline void blk_account_io_done(struct request *req, u64 now)
 {
 	/*
@@ -990,8 +979,15 @@ static inline void blk_account_io_done(struct request *req, u64 now)
 	 * containing request is enough.
 	 */
 	if (blk_do_io_stat(req) && req->part &&
-	    !(req->rq_flags & RQF_FLUSH_SEQ))
-		__blk_account_io_done(req, now);
+	    !(req->rq_flags & RQF_FLUSH_SEQ)) {
+		const int sgrp = op_stat_group(req_op(req));
+
+		part_stat_lock();
+		update_io_ticks(req->part, jiffies, true);
+		part_stat_inc(req->part, ios[sgrp]);
+		part_stat_add(req->part, nsecs[sgrp], now - req->start_time_ns);
+		part_stat_unlock();
+	}
 }
 
 static inline void blk_account_io_start(struct request *req)
-- 
2.43.0



