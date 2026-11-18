Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021256;
	b=pE9PTr5gWuMSjaPr8HaVoObmbGN4YmcXPlhAYtsiHTu0WDAZcSSSS2V/fC9JtOq6/cnr
	 +mSCy65fAQDiuhyU+qYnn+lXLzJGoXYuD6HPnCNB9ai70GSPx6MtyGZf0ZYKM04+89E9F
	 je3HpIaxI5hUQsqRuMdzpNwBo1rdd/Y3ZLalkJXb1PJv9gXvK7AmgkvVdjlXGtIxvmyrR
	 KGbHKsFP+ck7pUpmyttvK3Mjajtp5BBgzBNHV1QeChKi0znYx5rKObEQsQIMEEg8xvyXY
	 deDhuiS+dTUHhqLh8HQSK9DhW4x1kXwfdAZ86xX1NWL5XwOfgs1BF8HeMs2k3TplJgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=45TVSooXwRkYYFJIyquh3pmnR5WfKhyeczlXd0qIuzU=;
	b=Nedj3MKPZNg8CmPR5zOgFdvqXno2r44YS4DS9A5OzUkVCRLI2H8Ft5FjjEbO2FaA9HEs
	 p41FvRjBNsx61elXL/dT7BulaXdBk+V6FB7mGoxjdiYkHYh7mfPlP+VV2AgAfKJytRokI
	 oZx8IT8x4f+MW205KZrCzGqdmHETcdERrkzjZfSSokH4Eg/OT5bXG+QYjsIzDX4qUg8PY
	 DQS55A5cPM+QlO0KZ2/nElAxz2m99DGuqLipVPYRX6blssGrC7xB+IfwhSIfxyp4Gwc8l
	 yhkkNbkajqkcXnveWfOmoSNLDg5pk2UN2BkCz+tAzWQuZbUEBuX3JXEDVRl7h97HzxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGXv8tJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC163606A32C;
	Wed, 18 Nov 2026 17:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGXv8tJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7D71F000C4;
	Wed, 18 Nov 2026 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021255;
	bh=45TVSooXwRkYYFJIyquh3pmnR5WfKhyeczlXd0qIuzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGXv8tJ90E1RFLyr9ZMgIcUJpMRVLkZLk+u1wn0A5L+RjgjGYSyJ8pO5vtCwbUd6D
	 kaudks9gAkVmAbrQRLXGUsNuXqlNH2wLl+VIXtxDO/CkmCAdm1q417IT/ypEiwEMQj
	 9EZrEyjSgZ1nOuIYtP/RtEJ1k4pv9qVyFhduSubE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2243/2651] sched_ext: Use irq_work for deferred actions with proxy execution
Date: Wed, 18 Nov 2026 15:58:03 +0100
Message-ID: <20261118150406.224473023@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 9b5ce4345bf4d01dbf9ae5f6f6b1fb9cfdfc7b48 ]

maybe_queue_balance_callback() clears SCX_RQ_BAL_CB_PENDING when it
queues the deferred callback. Proxy resolution can then zap the callback
without running it, leaving the deferred actions unscheduled until a
later wakeup or deferred request.

Use the existing irq_work fallback for dispatch-time deferred requests
when proxy execution is enabled. This keeps the work scheduled even if
proxy resolution retries the pick or falls back to idle, without relying
on another SCX dispatch to restore a discarded callback.

Fixes: a8ad873113d3 ("sched_ext: defer queue_balance_callback() until after ops.dispatch")
Reported-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/08cac02c604dd73ef96fc92eb29d692b@kernel.org
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 30198a4db2b9d..b1c28516ff2cb 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -1059,9 +1059,10 @@ static void schedule_deferred_locked(struct rq *rq)
 		return;
 
 	/*
-	 * If in dispatch, the balance callbacks will be called before rq lock
-	 * is released. Schedule one.
-	 *
+	 * If in dispatch without proxy execution, the balance callbacks will
+	 * be called before rq lock is released. Schedule one. With proxy
+	 * execution, proxy resolution can zap the callbacks without another
+	 * SCX dispatch to requeue them, so use irq_work instead.
 	 *
 	 * We can't directly insert the callback into the
 	 * rq's list: The call can drop its lock and make the pending balance
@@ -1069,7 +1070,7 @@ static void schedule_deferred_locked(struct rq *rq)
 	 *
 	 * Just let dispatch_one() know that it must do it itself.
 	 */
-	if (rq->scx.flags & SCX_RQ_IN_DISPATCH) {
+	if ((rq->scx.flags & SCX_RQ_IN_DISPATCH) && !sched_proxy_exec()) {
 		rq->scx.flags |= SCX_RQ_BAL_CB_PENDING;
 		return;
 	}
-- 
2.53.0



