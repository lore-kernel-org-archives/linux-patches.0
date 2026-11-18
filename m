Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021978;
	b=elHkEwWQ3jyx4nYTk3tmVmsw10RAlO9JNjHkPuxgwcIpXGhWa6QcQQdwl1mBIjDzftOe
	 tOBFWVNi1znBULsaCWp/+R8JUpOw8b4nzgD54I7zVbVk7DsW59f5dIXCVTK85BZf8/4mz
	 mHZOvAhQDqGvuzBVwrVb2kTGXiPfdintIVw5XuVdNajwZeRmQXWl+Ha9eUL1aPIkzvtg/
	 CH+3IpDnKS/bkIWtpJAmwXdJXR/zOAXV/MRMMRdUud3M3oKGtY+YBlsqDuUzoG0hhPOwG
	 B/qZtTxxaFsJUFI7Pouv6Zpv8T7zXf5UlJWJo4nHkNDE/f4qbpDD4pIOj/WF0+7jYLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YawsY+GP6rTHBc3s3+E8uVAexdpXoyBugsD8lmKjjHU=;
	b=1FZmduqMFEtwBw62rtX9gjMrR74NlsesepET6ZLW+ll4luSkvcQ00KRC/o/c79G3hs6V
	 VvVwat80xkrFUEFVtgBspAo3CMDU1Gd+U6AoYoMj4txbipOkbDvjZZT4x+eEnTCNFalYS
	 f6zS3qmASPus8pmtU1gTV2s5S2YLxM4K0mEAN6wTcvTioSZd4y2yFMr/p0igd1ZcZ9e02
	 9IIFueaONfVwmWm/5tlLQ1LXsNM23c7rYIXGZ5UdlFs210/jVSN5DEoS8F/kEWaCJCnnW
	 r9XWtqMjEBSMv5TlDj6umD5DvyHyN4QlGjQooyLbKDwVGksVorDpoE2bcg8xrWmDh3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2Uuv+jw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B500606A320;
	Wed, 18 Nov 2026 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2Uuv+jw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5511F000C5;
	Wed, 18 Nov 2026 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021978;
	bh=YawsY+GP6rTHBc3s3+E8uVAexdpXoyBugsD8lmKjjHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2Uuv+jw6OAbaFMfwmAx73YyAQaCts7gXKKfDNjx1ZKmsz4RDIlfA/38ydczTpkem
	 58QFYciIfMKEt36pCvLwsMgbS6U759GSG5ACEncLMdl6VuIATBEU8Y+6riS2ntr6z7
	 LhoA6QSe7Qd68LZwnDfx2enr/IeW10ZkjnKxRC4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2492/2651] sched_ext: Fix a lone IMMED task waiting behind a kept prev
Date: Wed, 18 Nov 2026 16:02:12 +0100
Message-ID: <20261118150414.566523606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5173b2965834ad71d8c9035048354dce7c391125 ]

While dispatch is in progress, rq_is_open() returns true and dsq_inc_nr()
schedules no reenqueue for an IMMED task inserted on an empty local DSQ. The
check at the end of dispatch_one() schedules the reenqueue only when more
than one task is queued, so a dispatch that keeps prev leaves a lone IMMED
task behind:

 1. a parent's ops.dispatch() sub-dispatches into a child, which consumes a
    task with SCX_ENQ_IMMED onto the empty local DSQ
 2. the parent extends prev's slice and dispatch keeps prev
 3. the local DSQ holds one task, so no reenqueue is scheduled

The IMMED task waits on the local DSQ behind prev.

Schedule the reenqueue when dispatch keeps prev and an IMMED task is queued,
as even a lone IMMED task can't run right away behind prev.

v2: The description and dispatch_one()'s comment are reworded.

Fixes: 98d709cba319 ("sched_ext: Implement SCX_ENQ_IMMED")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 14088c64b9962..d1a4603a66f13 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3059,8 +3059,12 @@ static enum scx_dsp_verdict dispatch_one(struct rq *rq, struct task_struct *prev
 	 *
 	 * - A non-IMMED HEAD task can get queued in front of an IMMED task
 	 *   between the IMMED queueing and the subsequent scheduling event.
+	 *
+	 * - When dispatch keeps @prev, even a lone IMMED task queued during the
+	 *   dispatch can't run right away.
 	 */
-	if (unlikely(rq->scx.local_dsq.nr > 1 && rq->scx.nr_immed))
+	if (unlikely((rq->scx.local_dsq.nr > 1 || verdict == SCX_DSP_PREV) &&
+		     rq->scx.nr_immed))
 		scx_schedule_reenq_local(rq, 0);
 
 	rq->scx.flags &= ~SCX_RQ_IN_DISPATCH;
-- 
2.53.0



