Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38440254B1F;
	Thu, 28 May 2026 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000125; cv=none; b=qkXBmKsPYh2kXNCQxhn7EoSBKJ/orseBiiWFz7gnnwGp36IMBlKUWipAXbXLb7tuMMRldq79CpHgULiy7d+/k3HHDWmOo9aS40TY7e5+h92yaxXNkWTngBs7xmGJcs5HfdPeg/QtLCHx9WSMK3aW0i377tkjwn91xrNBHsrpRpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000125; c=relaxed/simple;
	bh=SnVakQ08kA7MEUL/6+0MDf1BU2b1PqRRB87IxJViz38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YscQ8zHa4olwpK7Le5EVM/Q5VajqBmGO4V712fF4bHlx2R69HdsTlQ68GvpK1ARzeG+TNVB/xJm3ujXG/U8PimGAaUDkiHAzn35BKVfS1vwYIt+pv9v/lG2w3WoHcs6l8gA7VALI6LJDH5mdqT4xfA9/QJWnD4K5NfePdtoKC/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGCrm00t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGCrm00t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961221F000E9;
	Thu, 28 May 2026 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000124;
	bh=PFlOWsvl5H62kExhZk2clfFv00ZXccw3Lpcjo7hBc+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGCrm00tRfm4I9pNzdkIcqUXHqBl3tpg9SGPom0RYyNwlHcHdNsadSh+xn9qbfV9u
	 VOa8hwseawXJGT4Hz8Vwg8QvDwsZrbfBQBUS+qo4l7X6PnvtQ0gSEfj+6h6lTcLx4B
	 Ib9d7zlq/Ht1K9wCwgpmHwRWKKUXAAj1p3l/S73c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/377] selftests: ublk: cap nthreads to kernels actual nr_hw_queues
Date: Thu, 28 May 2026 21:48:32 +0200
Message-ID: <20260528194646.297363756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cbd23444c8a98..ac47979349a4b 100644
--- a/tools/testing/selftests/ublk/kublk.c
+++ b/tools/testing/selftests/ublk/kublk.c
@@ -1220,6 +1220,17 @@ static int __cmd_dev_add(const struct dev_ctx *ctx)
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



