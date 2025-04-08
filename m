Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369E224F6;
	Tue,  8 Apr 2025 11:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110647; cv=none; b=TJQYqy7W3v0uIpo8bXYuBCDYB1tB/Tz5IR+JGXwV01KoVaiQgvZ5xv7Yn2EvhzgPk/OQkqRrxyJzzRKIIyu7WocddAE/VfIj5VyDpoX+fTYxbWja9OXkUG17tyRnV9Lxoreow3F7IMFnO1D8GpLDbzxYuk8FHZaLj6BWiSqIARI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110647; c=relaxed/simple;
	bh=cTsd4xemuckM6G1iFyTLUzUoWtY/8jPZgZJXqrc/W1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiGkfiCt0kkwWAuxaBUcnigpNNaJpjgNXGCalIHA7I07ndkmKN5hZoGzobbTsnVtcqJIRXNWKS1J89MpLYYv4d7JBK/9QMNt/KiVu9fGIU4pw5U2deLziJv7GrsN0BdiKkDNxBNoOm7sG7SD8bIrA4MD4d+dW7QnO+4sQALSEF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIqMxdtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIqMxdtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84F9C4CEE5;
	Tue,  8 Apr 2025 11:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110647;
	bh=cTsd4xemuckM6G1iFyTLUzUoWtY/8jPZgZJXqrc/W1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIqMxdtpLN8QVzkkClwSZ6GGH61+YdNZh+G5tPeO0Y+J6ImEMzX/uKM8cGKB3tiT9
	 JB/wibaUinlO8PnZnmrNvjeXkp2g4CNnAfOSuc2cp2YhSSAv1QRTfropscIpDZTFhD
	 r3F/2T86DVnwqHGq6n277h/q4ZqWcBVGPDOdteRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 142/731] blk-throttle: fix lower bps rate by throtl_trim_slice()
Date: Tue,  8 Apr 2025 12:40:39 +0200
Message-ID: <20250408104917.578691406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 29cb955934302a5da525db6b327c795572538426 ]

The bio submission time may be a few jiffies more than the expected
waiting time, due to 'extra_bytes' can't be divided in
tg_within_bps_limit(), and also due to timer wakeup delay.
In this case, adjust slice_start to jiffies will discard the extra wait time,
causing lower rate than expected.

Current in-tree code already covers deviation by rounddown(), but turns
out it is not enough, because jiffies - slice_start can be a multiple of
throtl_slice.

For example, assume bps_limit is 1000bytes, 1 jiffes is 10ms, and
slice is 20ms(2 jiffies), expected rate is 1000 / 1000 * 20 = 20 bytes
per slice.

If user issues two 21 bytes IO, then wait time will be 30ms for the
first IO:

bytes_allowed = 20, extra_bytes = 1;
jiffy_wait = 1 + 2 = 3 jiffies

and consider
extra 1 jiffies by timer, throtl_trim_slice() will be called at:

jiffies = 40ms
slice_start = 0ms, slice_end= 40ms
bytes_disp = 21

In this case, before the patch, real rate in the first two slices is
10.5 bytes per slice, and slice will be updated to:

jiffies = 40ms
slice_start = 40ms, slice_end = 60ms,
bytes_disp = 0;

Hence the second IO will have to wait another 30ms;

With the patch, the real rate in the first slice is 20 bytes per slice,
which is the same as expected, and slice will be updated:

jiffies=40ms,
slice_start = 20ms, slice_end = 60ms,
bytes_disp = 1;

And now, there is still 19 bytes allowed in the second slice, and the
second IO will only have to wait 10ms;

This problem will cause blktests throtl/001 failure in case of
CONFIG_HZ_100=y, fix it by preserving one extra finished slice in
throtl_trim_slice().

Fixes: e43473b7f223 ("blkio: Core implementation of throttle policy")
Reported-by: Ming Lei <ming.lei@redhat.com>
Closes: https://lore.kernel.org/linux-block/20250222092823.210318-3-yukuai1@huaweicloud.com/
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250227120645.812815-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8d149aff9fd0b..a52f0d6b40ad4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -599,14 +599,23 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 	 * sooner, then we need to reduce slice_end. A high bogus slice_end
 	 * is bad because it does not allow new slice to start.
 	 */
-
 	throtl_set_slice_end(tg, rw, jiffies + tg->td->throtl_slice);
 
 	time_elapsed = rounddown(jiffies - tg->slice_start[rw],
 				 tg->td->throtl_slice);
-	if (!time_elapsed)
+	/* Don't trim slice until at least 2 slices are used */
+	if (time_elapsed < tg->td->throtl_slice * 2)
 		return;
 
+	/*
+	 * The bio submission time may be a few jiffies more than the expected
+	 * waiting time, due to 'extra_bytes' can't be divided in
+	 * tg_within_bps_limit(), and also due to timer wakeup delay. In this
+	 * case, adjust slice_start will discard the extra wait time, causing
+	 * lower rate than expected. Therefore, other than the above rounddown,
+	 * one extra slice is preserved for deviation.
+	 */
+	time_elapsed -= tg->td->throtl_slice;
 	bytes_trim = calculate_bytes_allowed(tg_bps_limit(tg, rw),
 					     time_elapsed) +
 		     tg->carryover_bytes[rw];
-- 
2.39.5



