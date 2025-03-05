Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9246E2517BA;
	Wed,  5 Mar 2025 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198291; cv=none; b=pMvBdN2EO+26Aal7gJiUTYB64aqvKMxp5zkC9dSL+ngM6d5Tx69XTTOhpEwDhQJr2c/s52pO73kInr6qzcwDWFHeUgaJM4a3iTFJXyypJCSsYIwzSMmRiM5+tFpptb0hTCRpgw+Okt+ygEQFrfHq/R/gmyOVyxuApAGFHFQW01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198291; c=relaxed/simple;
	bh=TT16lU57wRpHr9XwyhNKJhktQrPMOiIF2qrXaYW3NLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaXV1jwNykkzIm+PFOGKmr37/cSfxR4ciKTd8cK/RfiGT8W8cSWY1SZ8Bg5iFfONgzfu/YClch3VhTXGQyAvkvhun/8POwEY8h+1PxJZE6fXC8H/DQnCl52BBw2PCMc/gVyo/rj2ocr4jvJeCQVSwJPBF6ghBu8SXPNjC0sqw4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIgAsEr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIgAsEr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1984EC4CED1;
	Wed,  5 Mar 2025 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198291;
	bh=TT16lU57wRpHr9XwyhNKJhktQrPMOiIF2qrXaYW3NLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIgAsEr8wdoD6Lz97Avt+VztbMuC/+f5czEvTTXi34CD8xzqLlZbmWNip4ESa1A7Q
	 nd5jP1OBMjlJSVYaQHfrUuqYXq/jL6NAGPnUmAQ6U2fN3O6zJYsrWIwgNU2YhBsjZi
	 yL5NheVAjWWURgsFXkYdsvWJdECAe6LxKOh5Fm7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Pat Cody <patcody@meta.com>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 6.12 129/150] sched_ext: Fix pick_task_scx() picking non-queued tasks when its called without balance()
Date: Wed,  5 Mar 2025 18:49:18 +0100
Message-ID: <20250305174508.998040345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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
@@ -3047,7 +3047,6 @@ static struct task_struct *pick_task_scx
 {
 	struct task_struct *prev = rq->curr;
 	struct task_struct *p;
-	bool prev_on_scx = prev->sched_class == &ext_sched_class;
 	bool keep_prev = rq->scx.flags & SCX_RQ_BAL_KEEP;
 	bool kick_idle = false;
 
@@ -3067,14 +3066,18 @@ static struct task_struct *pick_task_scx
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


