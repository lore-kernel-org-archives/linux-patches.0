Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22119E96D;
	Wed,  4 Feb 2026 15:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219094; cv=none; b=XmwIL+uChTzNiq0pWgr+bKbAcckmefpe7Xo6IiGXmgZn2utevAi9EKGkVdbIvEk/z6/5YxLhWNe/jU0qCD1TrLp1skUTmRNup9A1W+vHC3KE8B40sXSPlkmvJTL53Q8a+m1NzG8F6xjJGvMTnlsT73Bn3/EwnHu9T5oAfxtBVFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219094; c=relaxed/simple;
	bh=c/rGjpTeNjUHdADV+hkSZga5aYWwIfmFnVCsykUceBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF2Umb+EOEZ91ZZOzxL2U856gv/+/G1PCxXNm4rEuLReNfe5xlQW4rpx/eTuJ59IVBcMLwSANsMxd+Cc/oprStAZ6/9Zdoi2E5WOCsg0CSHgBYpGbBnRt+RQ8UOr/ejBgSJS4HiebzrkZi7UPb/YF1XySA86jYGNej5kHsQMeFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RB7Rh0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RB7Rh0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54FCC4CEF7;
	Wed,  4 Feb 2026 15:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219094;
	bh=c/rGjpTeNjUHdADV+hkSZga5aYWwIfmFnVCsykUceBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RB7Rh0Cb22crWgebC+VB0uZya4bhApjxgOFjeh0F44RFWL8yLfxbyMy5sFCSfoSU
	 Ejv7sGw2HAdC9vbZU0fKPYo44IlUpCGeEdeAHwRjREdn2NBY7Itzhn4d82JZw8F7Ck
	 Qivd3z4exsOvMT4mge9ws30TkoxwLABV7inTxFUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/122] sched/deadline: Fix stuck dl_server
Date: Wed,  4 Feb 2026 15:40:40 +0100
Message-ID: <20260204143853.943285093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 115135422562e2f791e98a6f55ec57b2da3b3a95 ]

Andrea reported the dl_server getting stuck for him. He tracked it
down to a state where dl_server_start() saw dl_defer_running==1, but
the dl_server's job is no longer valid at the time of
dl_server_start().

In the state diagram this corresponds to [4] D->A (or dl_server_stop()
due to no more runnable tasks) followed by [1], which in case of a
lapsed deadline must then be A->B.

Now our A has dl_defer_running==1, while B demands
dl_defer_running==0, therefore it must get cleared when the CBS wakeup
rules demand a replenish.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Reported-by: Andrea Righi arighi@nvidia.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Andrea Righi arighi@nvidia.com
Link: https://lkml.kernel.org/r/20260123161645.2181752-1-arighi@nvidia.com
Link: https://patch.msgid.link/20260130124100.GC1079264@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6bfffb244162f..c7a8717e837dd 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1043,6 +1043,12 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 			return;
 		}
 
+		/*
+		 * When [4] D->A is followed by [1] A->B, dl_defer_running
+		 * needs to be cleared, otherwise it will fail to properly
+		 * start the zero-laxity timer.
+		 */
+		dl_se->dl_defer_running = 0;
 		replenish_dl_new_period(dl_se, rq);
 	} else if (dl_server(dl_se) && dl_se->dl_defer) {
 		/*
@@ -1641,6 +1647,12 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  *   dl_server_active = 1;
  *   enqueue_dl_entity()
  *     update_dl_entity(WAKEUP)
+ *       if (dl_time_before() || dl_entity_overflow())
+ *         dl_defer_running = 0;
+ *         replenish_dl_new_period();
+ *           // fwd period
+ *           dl_throttled = 1;
+ *           dl_defer_armed = 1;
  *       if (!dl_defer_running)
  *         dl_defer_armed = 1;
  *         dl_throttled = 1;
-- 
2.51.0



