Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2C583AB0;
	Wed,  9 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964653; cv=none; b=eA0em6GyMDJwf2okpN7ZSDXTiErsviACipmOyOhVlE+vHuvRyEis4kDPqcVTOApDrSVBja1osv9rkv8zfGYxjP4Y6XMh6w3rNL+BfpYrHw2VcAU5AB5LCahRtAJ5udTb1vGPD+V2o/HCeLR5sgZMsrNvlql7F2B32Wnd41IQm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964653; c=relaxed/simple;
	bh=thurqkP8P6gGpOwlEQaSeAi1Xf6fu7hImbH9OviCTzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlbSiBdAEXiRc/GdA3JPxc1OfUZkqe+fB172Oyu33KBmgVaUIQtIGbY1xfRAvk6pMVB0VBxQ+W+SpzGPdwkUHBKVKcjqFbUbVGstMhMLNgjtO48BrhUDyXIJvRh5ZtOKzQbiiDEnqrzzrHrnxetdxTYoYiUzwuI14AJosqqaBi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxGxsqtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxGxsqtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584C01F00A3A;
	Wed,  9 Sep 2026 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964651;
	bh=ozMzHIvjLaj8gHXprbIzQSd37RtnPqDxg9jVWgdqxiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxGxsqtbhi/TvkPOkkEx5d8SgCTQg5/QfKviWTNvtINHr6Fo5qfGuFEJFgH1twamx
	 Wb5mIYUCYyk7HoyyLed9kt63QkHs/wcvbm6gXsWzBDvmLiVQcbYs3VOpIR1v5piiTu
	 6BqCRjlNjbAOZibvuRzgjYX/Co6zaBRwbvXw//oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fangqiurong <fangqiurong@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/583] sched_ext: Fix exit_task leak on fork failure during enable
Date: Wed,  9 Sep 2026 15:43:02 +0200
Message-ID: <20260909134254.996984932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: fangqiurong <fangqiurong@kylinos.cn>

[ Upstream commit 03506edca637a8465dba9f635c50e9884fbcaf4e ]

scx_fork() initializes tasks when scx_init_task_enabled is set, but
scx_cancel_fork() only exits them when scx_enabled() is true. A fork
that fails in the enable window (between releasing scx_fork_rwsem and
setting __scx_enabled) runs ops.init_task() but never ops.exit_task().

Gate scx_cancel_fork() on scx_init_task_enabled.

Fixes: 4269c603cc26 ("sched_ext: Enable scx_ops_init_task() separately")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: fangqiurong <fangqiurong@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ Adjusted the target file path from kernel/sched/ext/ext.c to kernel/sched/ext.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3007,7 +3007,7 @@ void scx_post_fork(struct task_struct *p
 
 void scx_cancel_fork(struct task_struct *p)
 {
-	if (scx_enabled()) {
+	if (scx_init_task_enabled) {
 		struct rq *rq;
 		struct rq_flags rf;
 


