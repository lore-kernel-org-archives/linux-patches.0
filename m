Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A76432E94;
	Thu, 30 Jul 2026 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423442; cv=none; b=fVPjN1yQK3V1+dTGWKRdbNqryC/0yPromtRHY55Ub4BrZCNLdohraeNrx3ggsIa63R9q0yLWuYetM0aD822w7MR+GXGO6UNtzhXiPDlHac0Vmzg5SCOWtEcMvkevtjqtheko7P53+Xy4BJWWKWU57YEiSvWlvMUcIAJXxYl0XMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423442; c=relaxed/simple;
	bh=LjIOe5mseECKjk42GKv1f8EvHVvlzI1ZvR0ShtWAEnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGYVUrz61F2I0vdJ4PCD9iPpqXb6b+e3NdIXQ29NZy8OI9yao+4HQ3fNCZB/Z6SBx9N8zVIPrU2BWk4lp5crGFDPnYoHmJETjYO55uujgLpd2BXeqbe3R/40z5Rjl/9NzmdxeBzZnaySlPp0TqOKZyG+KfqTwr8bSTVC+GJzquU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGGmOS+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGGmOS+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EA81F00A3A;
	Thu, 30 Jul 2026 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423441;
	bh=dDwBRi1VWz/Xm5nwptsEv96DxEJLUGN3LcT7vs4asd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGGmOS+WN6yTrw033MMleHrCCSe5AU4dQEFVnXTCaVkTcuioT8QQZCYL3j5S+RPuX
	 sVbF7GALEeHaoXPH+myGMhmSGenrtquWgmERdc0f1JB9R35ZEcOWiLybF1Gbf2eLHy
	 On74ttTVxG4ecggGT+0hfZh5notzR2ly80pkAKN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/675] sched/ext: Avoid null ptr traversal when ->put_prev_task() is called with NULL next
Date: Thu, 30 Jul 2026 16:06:16 +0200
Message-ID: <20260730141446.099656918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 12b5cd99a05f7cbc2ceb88b3b9601d404ef2236a ]

Early when trying to get sched_ext and proxy-exe working together,
I kept tripping over NULL ptr in put_prev_task_scx() on the line:
  if (sched_class_above(&ext_sched_class, next->sched_class)) {

Which was due to put_prev_task() passes a NULL next, calling:
  prev->sched_class->put_prev_task(rq, prev, NULL);

put_prev_task_scx() already guards for a NULL next in the
switch_class case, but doesn't seem to have a guard for
sched_class_above() check.

I can't say I understand why this doesn't trip usually without
proxy-exec. And in newer kernels there are way fewer
put_prev_task(), and I can't easily reproduce the issue now
even with proxy-exec.

But we still have one put_prev_task() call left in core.c that
seems like it could trip this, so I wanted to send this out for
consideration.

tj: put_prev_task() can be called with NULL @next; however, when @p is
queued, that doesn't happen, so this condition shouldn't currently be
triggerable. The connection isn't straightforward or necessarily reliable,
so add the NULL check even if it can't currently be triggered.

Link: http://lkml.kernel.org/r/20251206022218.1541878-1-jstultz@google.com
Signed-off-by: John Stultz <jstultz@google.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: b7d9c359e5cf ("sched_ext: Don't warn on core-sched forced idle in put_prev_task_scx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index d8280f87443310..d399494364c0a3 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2396,7 +2396,7 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 		 * ops.enqueue() that @p is the only one available for this cpu,
 		 * which should trigger an explicit follow-up scheduling event.
 		 */
-		if (sched_class_above(&ext_sched_class, next->sched_class)) {
+		if (next && sched_class_above(&ext_sched_class, next->sched_class)) {
 			WARN_ON_ONCE(!(sch->ops.flags & SCX_OPS_ENQ_LAST));
 			do_enqueue_task(rq, p, SCX_ENQ_LAST, -1);
 		} else {
-- 
2.53.0



