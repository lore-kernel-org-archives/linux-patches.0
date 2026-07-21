Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC2408039;
	Tue, 21 Jul 2026 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661857; cv=none; b=Xk4uYTVo3YWrZ9zRrWSB2sWVSCSMLpdpnjQfH4LnQLbLGZOPUoOr54sG6i5mcHbywKryCdPcPeO4BdyQqWITWIRGDrUJ/fujfmRB9W8RIRz33PBNtuZMaPWBoCdaxIB9HXz69xnL6pMvCnjnXDXeL0eR1V/uq4+KtXLdVkoMQIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661857; c=relaxed/simple;
	bh=tta5/FFYBvO51U8LnceP0gyyBqUesLgKHjIHcD5IZG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0fGZhEEGlYQdozQ2GZl03N9yejQ7nxrmJWT3beoH6kyFNI6ObZkUbHtOLqQm7t8MhOWOoVsCNMufKu1vyPKXgLY951kiJmatoSUjRNg0LWOeGrRo8TBmne6WRv683pu9UaFWhsuSFnf+TQbqLGPuMOm38J8RugyvDxJD+jzQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1MKspQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1MKspQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353CA1F000E9;
	Tue, 21 Jul 2026 19:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661855;
	bh=H7c927Twt1bx9IB7F5fJTI0k7Vw8E3qTqTFUfL+CYfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1MKspQK8lxIryOQjoJOww2nLzIueUz1d8am86nYyL9wZTJXPucljoswb0wNu1e8A
	 O7UnO6ENWcMQoI6XpIR26+Q1bGif0M33lwm67AY2R2wM6KC/p3HqlI3QfBu0zr/ybE
	 l66D7kkBT+pZsyU+zySf02Qsb8KZPu6MY36ygxU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qiaoting.Lin" <linqiaoting@xiaomi.com>,
	"Guanyou.Chen" <chenguanyou@xiaomi.com>,
	"Chunhui.Li" <chunhui.li@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0222/1276] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Tue, 21 Jul 2026 17:11:05 +0200
Message-ID: <20260721152451.057873718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanyou.Chen <chenguanyou9338@gmail.com>

[ Upstream commit 63c1a12bc0e09af7dee919c4fb4a300a719d5125 ]

Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
__setscheduler_params(). However, when an RT task with SCHED_RESET_ON_FORK
creates child threads, the children inherit timer_slack_ns=0 from the
parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
not restore timer_slack_ns, leaving the child permanently running with
zero slack.

Fix this by restoring timer_slack_ns from default_timer_slack_ns in
sched_fork() when resetting from RT/DL to NORMAL policy, matching the
existing behavior in __setscheduler_params().

Note: this fix alone requires a correct default_timer_slack_ns to be
effective. See the following patch for that fix.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260522131000.1664983-2-chenguanyou@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 49dbb52842c95d..ea106403abd86f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4705,6 +4705,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.53.0



