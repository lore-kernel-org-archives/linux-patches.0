Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1212746C4AC;
	Tue, 21 Jul 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656240; cv=none; b=lX8082TZP99BdJGWZuaGxoG3hp1SpiXnOn52nL/GaSl4HkPJYFPGmBLalk2jBQ1FuZgy3luzc+WfUPFcMOvjk5JFAkpsizHWWns9neaQYKnSsDGvnato7yIeUkY7CT1DvLGWq6gWM5/PxRdfk5QEsKzuy9SS3rz2Nty5ci///VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656240; c=relaxed/simple;
	bh=rUrxzw01EXlVN74pj4RnwYwIzQ7dJIBg2Y9fUbyMzMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvzBiwP+OXOa5MKqCZ1BDCYs8R/eX5j9G7yhaTyjiaJjGiZkGmz4AKjgwYjApV80XnbWX9i3sjdxjjGm3eEU6Kmr2HAXEvU1zOosJFKjyoSx0Fhu/AWGS/SbqCAa0ZBqqFRlGHoG/1+dHbG+Rn1eWH4MA58rOax1SQzombDbx4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBhAG9a/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBhAG9a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7746D1F000E9;
	Tue, 21 Jul 2026 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656239;
	bh=ihsM3WVBRt0SZoPiT3QdT/FOAC1O+oT6FHyQKm8yvDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cBhAG9a/sz+w0J+k7Nc6wg6w6hY0rfpfqLGD8wJ4PdMYouHzepHuq/8j/5y2vGArz
	 mWSxtMZ9MDN+WAAftn+7aSy1/l6m2E85fRkgevqzXpqvsSOonSiyTRz7h+EyJdFhfz
	 iHdYXbE1UDOKY16dSxKPiwm33XRphFvfXNmJV6eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qiaoting.Lin" <linqiaoting@xiaomi.com>,
	"Guanyou.Chen" <chenguanyou@xiaomi.com>,
	"Chunhui.Li" <chunhui.li@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0311/1611] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Tue, 21 Jul 2026 17:07:07 +0200
Message-ID: <20260721152522.071573547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d089b1f2115560..b5b5897b595b4c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4706,6 +4706,7 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.53.0



