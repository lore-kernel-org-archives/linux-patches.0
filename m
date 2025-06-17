Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5AC2DF3C9;
	Tue, 17 Jun 2025 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174874; cv=none; b=ZVWQSfJHuCKiN7GVGQxOdudn2NIfsKaDcIk+EiFDtgTCzhEIyvRBGaICuXAMnJIV22bGgcOpFbVxL1hnR7V0XapqiF1oKsk3jsgk7Pr9aSgdr0bmh/TVCFxqF23Izlzd6fIuVhDYYVqfvFozIMMiCAvBPIcuDQISX3SvVZmd/54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174874; c=relaxed/simple;
	bh=ZQeCBo96ryQbRInQ9axv96PX170iV7JjpyIO8YrdtU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAGUivROJawoT4m+gSsMlhgH8mcjhRdtD/2OAuz+sSopPcuXmyHYHD1wmiYashD7zmrf/dK99BZcIrbe11xy0zUXWkRQbSV5trrPiQFMrShEmtybNekOQGBKH7dm/CO+ek4kFtXSOiELyYXO94a1Em2rCY6qY8ZMsjgvGAWUxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0i9z6o7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0i9z6o7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288CEC4CEE7;
	Tue, 17 Jun 2025 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174874;
	bh=ZQeCBo96ryQbRInQ9axv96PX170iV7JjpyIO8YrdtU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0i9z6o7kRv4V3V3cPYYbIDIN6TbavWtG5oxex+ntg9uPHXqIZFxqvrrHtqmaB10II
	 8t6qMPCsDi1FVWDkCAqnHDiRnyq9uSUtjKOM26PwGRFriDTL0BxRlLrDrcttIEkvK6
	 656AgCDEfZM2AsSqnP93feF7CPLOJcP3463udRuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 029/780] blk-throttle: Fix wrong tg->[bytes/io]_disp update in __tg_update_carryover()
Date: Tue, 17 Jun 2025 17:15:37 +0200
Message-ID: <20250617152452.689954820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f66cf69eb8765341bbeff0e92a7d0d2027f62452 ]

In commit 6cc477c36875 ("blk-throttle: carry over directly"), the carryover
bytes/ios was be carried to [bytes/io]_disp. However, its update mechanism
has some issues.

In __tg_update_carryover(), we calculate "bytes" and "ios" to represent the
carryover, but the computation when updating [bytes/io]_disp is incorrect.
And if the sq->nr_queued is empty, we may not update tg->[bytes/io]_disp to
0 in tg_update_carryover(). We should set it to 0 in non carryover case.
This patch fixes the issue.

Fixes: 6cc477c36875 ("blk-throttle: carry over directly")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250417132054.2866409-2-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d6dd2e0478749..7437de947120e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -644,6 +644,18 @@ static void __tg_update_carryover(struct throtl_grp *tg, bool rw,
 	u64 bps_limit = tg_bps_limit(tg, rw);
 	u32 iops_limit = tg_iops_limit(tg, rw);
 
+	/*
+	 * If the queue is empty, carryover handling is not needed. In such cases,
+	 * tg->[bytes/io]_disp should be reset to 0 to avoid impacting the dispatch
+	 * of subsequent bios. The same handling applies when the previous BPS/IOPS
+	 * limit was set to max.
+	 */
+	if (tg->service_queue.nr_queued[rw] == 0) {
+		tg->bytes_disp[rw] = 0;
+		tg->io_disp[rw] = 0;
+		return;
+	}
+
 	/*
 	 * If config is updated while bios are still throttled, calculate and
 	 * accumulate how many bytes/ios are waited across changes. And
@@ -656,8 +668,8 @@ static void __tg_update_carryover(struct throtl_grp *tg, bool rw,
 	if (iops_limit != UINT_MAX)
 		*ios = calculate_io_allowed(iops_limit, jiffy_elapsed) -
 			tg->io_disp[rw];
-	tg->bytes_disp[rw] -= *bytes;
-	tg->io_disp[rw] -= *ios;
+	tg->bytes_disp[rw] = -*bytes;
+	tg->io_disp[rw] = -*ios;
 }
 
 static void tg_update_carryover(struct throtl_grp *tg)
@@ -665,10 +677,8 @@ static void tg_update_carryover(struct throtl_grp *tg)
 	long long bytes[2] = {0};
 	int ios[2] = {0};
 
-	if (tg->service_queue.nr_queued[READ])
-		__tg_update_carryover(tg, READ, &bytes[READ], &ios[READ]);
-	if (tg->service_queue.nr_queued[WRITE])
-		__tg_update_carryover(tg, WRITE, &bytes[WRITE], &ios[WRITE]);
+	__tg_update_carryover(tg, READ, &bytes[READ], &ios[READ]);
+	__tg_update_carryover(tg, WRITE, &bytes[WRITE], &ios[WRITE]);
 
 	/* see comments in struct throtl_grp for meaning of these fields. */
 	throtl_log(&tg->service_queue, "%s: %lld %lld %d %d\n", __func__,
-- 
2.39.5



