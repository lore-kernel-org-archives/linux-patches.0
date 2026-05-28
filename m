Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55F2FD7C3;
	Thu, 28 May 2026 20:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998798; cv=none; b=G4iw/r8zlwVQmH+jLJTuBQfu8SRkywoZPW2EyI+sO57BgVrxr5pG7/VsVWS/mEYZ9d8vkr7V/nYNNaR6+0cZi6UIVb+ZbJDSAAmUqTRw/RFgRKV6QuSY2iwu0TthcofUCrTguzpBRMdsfk2Zz84GrhSJiZAwnsBnXVhbk82BFtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998798; c=relaxed/simple;
	bh=iGyIURfyaH9qxXj5O1v//iRch5TzoezyhDuE6aR+J0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aso1dpcHNNPgcbQzvDCw7q37THrV7uHGJCzd7k6AZSd9goqhyw9r9qTA4gs97K4vyn9b6ojvzTe/IpRuX4ru3nHB+6+IpF6BrLSlR1+MAh2ChZYeQyybNtlgCBUtbVDNcQQTzQ6kMih0lhPIPVhWL4bIxJf0NygdKT5jKnozy6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoyQO6D0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoyQO6D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD80D1F000E9;
	Thu, 28 May 2026 20:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998797;
	bh=ocqTR9qWe9KHnNCacGkBaZgDSs3MicoDHrAq7gzc6+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BoyQO6D0wzW8ItlqAZWa/bB3iPEQBR+SE3hGNzb/SNv9aWh7JOVJmMFEBzyYmSlZ/
	 fMNgesn4FXVJVlLjxK1Al8vg5Vf9T3Bj/OMFblr+kEDRB8adXmRWxIMjNyioVZ+MdE
	 xh3j8ksFBQkrHiYmIIYKJz1Nt7oWZ+7NryymY4xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 301/461] selftests: ublk: cap nthreads to kernels actual nr_hw_queues
Date: Thu, 28 May 2026 21:47:10 +0200
Message-ID: <20260528194655.954945922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 87d0740b7c4cc847be1b6f307ab6d8547cb1a726 ]

dev->nthreads is derived from the user-requested queue count before the
ADD command, but the kernel may reduce nr_hw_queues (capped to
nr_cpu_ids). When the VM has fewer CPUs than requested queues, the
daemon creates more handler threads than there are kernel queues.

In non-batch mode, the extra threads access uninitialized queues
(q_depth=0), submit zero io_uring SQEs, and block forever in
io_cqring_wait. In batch mode, the extra threads cause similar hangs
during device removal.

In both cases, the stuck threads prevent the daemon from closing the
char device, holding the last ublk_device reference and causing
ublk_ctrl_del_dev() to hang in wait_event_interruptible().

Fix by capping dev->nthreads to the kernel-returned nr_hw_queues after
the ADD command completes. per_io_tasks mode is excluded because threads
interleave across all queues, so nthreads > nr_hw_queues is valid.

Fixes: abe54c160346 ("selftests: ublk: kublk: decouple ublk_queues from ublk server threads")
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260513101941.1373998-1-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/kublk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/ublk/kublk.c b/tools/testing/selftests/ublk/kublk.c
index e1c3b3c55e565..c40aa7952b6eb 100644
--- a/tools/testing/selftests/ublk/kublk.c
+++ b/tools/testing/selftests/ublk/kublk.c
@@ -1395,6 +1395,17 @@ static int __cmd_dev_add(const struct dev_ctx *ctx)
 		goto fail;
 	}
 
+	/*
+	 * The kernel may reduce nr_hw_queues (e.g. capped to nr_cpu_ids).
+	 * Cap nthreads to the actual queue count to avoid creating extra
+	 * handler threads that will hang during device removal.
+	 *
+	 * per_io_tasks mode is excluded: threads interleave across all
+	 * queues so nthreads > nr_hw_queues is valid and intentional.
+	 */
+	if (!ctx->per_io_tasks && dev->nthreads > info->nr_hw_queues)
+		dev->nthreads = info->nr_hw_queues;
+
 	ret = ublk_start_daemon(ctx, dev);
 	ublk_dbg(UBLK_DBG_DEV, "%s: daemon exit %d\n", __func__, ret);
 	if (ret < 0)
-- 
2.53.0



