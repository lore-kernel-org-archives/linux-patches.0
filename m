Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5B225291D;
	Wed,  5 Mar 2025 18:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198749; cv=none; b=NJiCwH8G5v9dogvTDT2AUgG+Oui5rxM0Bp4ItNhz5uF6wpHkIaorMwdMlik97hLJfJ43eoLSYAodpkQNOdWKfTxtDlIXos0/PynLB2sKi/FJzCbJKhdQqmpotayyZPxQ7jrlKHdZt1bSfoBOt53WnDitHsWobz4BVIYZPYrqm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198749; c=relaxed/simple;
	bh=qXj1sffat3Ap7MxOSlkLv4lVdp8ZcunNNLDADmIXoXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE3UFiNYe8rPpYjmhKwYopvN769/GoQV/kwhQI2A5W1XejzkQukqjOgf/kbwHPmPLYGjWeRLG5uTCSltcoVxJ2yefyEoLJFFuYpcusMtJeMuE/Y85ECpU/hHsrL2nv9OSobsIp2oZGbNYCM7KTtJVq4cWGu879i7dKhJSa49Tjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bypj4O+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bypj4O+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739ABC4CED1;
	Wed,  5 Mar 2025 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198748;
	bh=qXj1sffat3Ap7MxOSlkLv4lVdp8ZcunNNLDADmIXoXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bypj4O+N0QfuBGKW3RA1ZU+81/P9hkN4tG+eIHwp5384VDTcJZjRGa+GOriigSuTi
	 4fW9uHy7o1toAIjs8UBFY/EKi9ycMZjzD13qe8VfM6cTvDYo1BD0/egwmXHJ2bvT5n
	 naT+sMoZOVEtB+upRjZ2eRqtdihuk3oCiJc+BiRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Pat Cody <patcody@meta.com>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 6.13 135/157] sched_ext: Fix pick_task_scx() picking non-queued tasks when its called without balance()
Date: Wed,  5 Mar 2025 18:49:31 +0100
Message-ID: <20250305174510.726972843@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 8fef0a3b17bb258130a4fcbcb5addf94b25e9ec5 upstream.

a6250aa251ea ("sched_ext: Handle cases where pick_task_scx() is called
without preceding balance_scx()") added a workaround to handle the cases
where pick_task_scx() is called without prececing balance_scx() which is due
to a fair class bug where pick_taks_fair() may return NULL after a true
return from balance_fair().

The workaround detects when pick_task_scx() is called without preceding
balance_scx() and emulates SCX_RQ_BAL_KEEP and triggers kicking to avoid
stalling. Unfortunately, the workaround code was testing whether @prev was
on SCX to decide whether to keep the task running. This is incorrect as the
task may be on SCX but no longer runnable.

This could lead to a non-runnable task to be returned from pick_task_scx()
which cause interesting confusions and failures. e.g. A common failure mode
is the task ending up with (!on_rq && on_cpu) state which can cause
potential wakers to busy loop, which can easily lead to deadlocks.

Fix it by testing whether @prev has SCX_TASK_QUEUED set. This makes
@prev_on_scx only used in one place. Open code the usage and improve the
comment while at it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Pat Cody <patcody@meta.com>
Fixes: a6250aa251ea ("sched_ext: Handle cases where pick_task_scx() is called without preceding balance_scx()")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3097,7 +3097,6 @@ static struct task_struct *pick_task_scx
 {
 	struct task_struct *prev = rq->curr;
 	struct task_struct *p;
-	bool prev_on_scx = prev->sched_class == &ext_sched_class;
 	bool keep_prev = rq->scx.flags & SCX_RQ_BAL_KEEP;
 	bool kick_idle = false;
 
@@ -3117,14 +3116,18 @@ static struct task_struct *pick_task_scx
 	 * if pick_task_scx() is called without preceding balance_scx().
 	 */
 	if (unlikely(rq->scx.flags & SCX_RQ_BAL_PENDING)) {
-		if (prev_on_scx) {
+		if (prev->scx.flags & SCX_TASK_QUEUED) {
 			keep_prev = true;
 		} else {
 			keep_prev = false;
 			kick_idle = true;
 		}
-	} else if (unlikely(keep_prev && !prev_on_scx)) {
-		/* only allowed during transitions */
+	} else if (unlikely(keep_prev &&
+			    prev->sched_class != &ext_sched_class)) {
+		/*
+		 * Can happen while enabling as SCX_RQ_BAL_PENDING assertion is
+		 * conditional on scx_enabled() and may have been skipped.
+		 */
 		WARN_ON_ONCE(scx_ops_enable_state() == SCX_OPS_ENABLED);
 		keep_prev = false;
 	}


