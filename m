Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACCE29B771;
	Mon, 12 May 2025 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073092; cv=none; b=mhsmfr6Oi6wxhXe6hqaLMtLjwE1UnguBk6el9HVmDLThEXhNgD9I85Iu3alZbm/a63eFRyl3OgBc74BZ9tkT6Zd9/bV5/wtSBK4PdOiT6AyiLaN3QWO/14YWJ9IdbMW0aJu8cklhkFXvutDXUk5QZNiGG4Vfl079kRJ7i+eekwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073092; c=relaxed/simple;
	bh=cDVovQpZwxFVqYUJ19dKELTt2MoCccvbY2EzrCKtLWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoE5asB+d1j4axt9dsT9CWP4oyY8NYchlJM8SRAZ61T1A8vu3nzx5zJgIx/PHu8n6uctI/fWochDipfOz0DvJ7W57hT2qaaa24Qjk/eLqow+aQ1tg+O/HTNvBOA8Vq5LF6qAey0osBF+Py5x6vhN0mYAXvehlIsh8US/8S3x9hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDWmdXn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDWmdXn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B8EC4CEE7;
	Mon, 12 May 2025 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073092;
	bh=cDVovQpZwxFVqYUJ19dKELTt2MoCccvbY2EzrCKtLWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDWmdXn5imuymgcXMYel55Pue74pY79DW2bvI2b9V5CAtJzo1U0JqUwQFM58d/NYj
	 RzQRkIhBn4wy7X7jVK5BIAxktm/yhXU/wPLtgXYO0lvByNlZ/A1yljkX4HiLl4gIt7
	 DKPXG5TIVAqGHuylP8i8pspJkVgcM6suO7q2Ve/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/184] io_uring/sqpoll: Increase task_work submission batch size
Date: Mon, 12 May 2025 19:45:52 +0200
Message-ID: <20250512172047.965760945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit 92835cebab120f8a5f023a26a792a2ac3f816c4f ]

Our QA team reported a 10%-23%, throughput reduction on an io_uring
sqpoll testcase doing IO to a null_blk, that I traced back to a
reduction of the device submission queue depth utilization. It turns out
that, after commit af5d68f8892f ("io_uring/sqpoll: manage task_work
privately"), we capped the number of task_work entries that can be
completed from a single spin of sqpoll to only 8 entries, before the
sqpoll goes around to (potentially) sleep.  While this cap doesn't drive
the submission side directly, it impacts the completion behavior, which
affects the number of IO queued by fio per sqpoll cycle on the
submission side, and io_uring ends up seeing less ios per sqpoll cycle.
As a result, block layer plugging is less effective, and we see more
time spent inside the block layer in profilings charts, and increased
submission latency measured by fio.

There are other places that have increased overhead once sqpoll sleeps
more often, such as the sqpoll utilization calculation.  But, in this
microbenchmark, those were not representative enough in perf charts, and
their removal didn't yield measurable changes in throughput.  The major
overhead comes from the fact we plug less, and less often, when submitting
to the block layer.

My benchmark is:

fio --ioengine=io_uring --direct=1 --iodepth=128 --runtime=300 --bs=4k \
    --invalidate=1 --time_based  --ramp_time=10 --group_reporting=1 \
    --filename=/dev/nullb0 --name=RandomReads-direct-nullb-sqpoll-4k-1 \
    --rw=randread --numjobs=1 --sqthread_poll

In one machine, tested on top of Linux 6.15-rc1, we have the following
baseline:
  READ: bw=4994MiB/s (5236MB/s), 4994MiB/s-4994MiB/s (5236MB/s-5236MB/s), io=439GiB (471GB), run=90001-90001msec

With this patch:
  READ: bw=5762MiB/s (6042MB/s), 5762MiB/s-5762MiB/s (6042MB/s-6042MB/s), io=506GiB (544GB), run=90001-90001msec

which is a 15% improvement in measured bandwidth.  The average
submission latency is noticeably lowered too.  As measured by
fio:

Baseline:
   lat (usec): min=20, max=241, avg=99.81, stdev=3.38
Patched:
   lat (usec): min=26, max=226, avg=86.48, stdev=4.82

If we look at blktrace, we can also see the plugging behavior is
improved. In the baseline, we end up limited to plugging 8 requests in
the block layer regardless of the device queue depth size, while after
patching we can drive more io, and we manage to utilize the full device
queue.

In the baseline, after a stabilization phase, an ordinary submission
looks like:
  254,0    1    49942     0.016028795  5977  U   N [iou-sqp-5976] 7

After patching, I see consistently more requests per unplug.
  254,0    1     4996     0.001432872  3145  U   N [iou-sqp-3144] 32

Ideally, the cap size would at least be the deep enough to fill the
device queue, but we can't predict that behavior, or assume all IO goes
to a single device, and thus can't guess the ideal batch size.  We also
don't want to let the tw run unbounded, though I'm not sure it would
really be a problem.  Instead, let's just give it a more sensible value
that will allow for more efficient batching.  I've tested with different
cap values, and initially proposed to increase the cap to 1024.  Jens
argued it is too big of a bump and I observed that, with 32, I'm no
longer able to observe this bottleneck in any of my machines.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20250508181203.3785544-1-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 5bc54c6df20fd..430922c541681 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -20,7 +20,7 @@
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
-#define IORING_TW_CAP_ENTRIES_VALUE	8
+#define IORING_TW_CAP_ENTRIES_VALUE	32
 
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
-- 
2.39.5



