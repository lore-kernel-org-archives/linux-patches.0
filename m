Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C346D556;
	Tue, 21 Jul 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649072; cv=none; b=FhPlsSoZ7vOSZbNTmKDL1mLLpL6vYZRzQNF8R7bTOly8DaZF2k6FIv4ENoGMg9NIS7EYPnRQvm2IUM2DIKv+QOUaA8Y0nBYLytCRHFkUDwlID0+JKgUyDKaBZ49uVHMw9mI4tMf0T0cJff9i6T4Ni/uSma96FRILxc528f5aOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649072; c=relaxed/simple;
	bh=vXFK4TeNaSMtRcnN2QBPOULz3Q7uqnrj+i19vGlouvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8cLWMRHkB1ccKxNUTnDhekZOdznRrtEo++KlJemPVUGelXY/o4VCgpOpau/V6Lck1AZVvHfQi3biplw/g/xpkQtoMFFf4vvl3jEOoAxn9x3G6KawEJUPUxIKBHt8zpg/3k43JN7QZDVgWnDMhCRP/4gtvGRlqJnga9I/yt2CDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAxdC2pr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAxdC2pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6103A1F00A3A;
	Tue, 21 Jul 2026 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649070;
	bh=ZhXCc9frQGKLhlZg0sSO+nMvCXG0x6R4MyHuL+rAnzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAxdC2przjfuoBRM2OMUpW097k6gdonwXpTvpe61MlorFHLviqXe5Xcf261V7y7qL
	 uyerbatZLTHw6ltiR8QB0EStz3i4oTz3pcjw9JH16gxb76OquHRpvEm62kzSgIAR1M
	 eeQutoXuyl9YFTbkQdVQW/nwE7ReAXTzIl8fmfpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qiaoting.Lin" <linqiaoting@xiaomi.com>,
	"Guanyou.Chen" <chenguanyou@xiaomi.com>,
	"Chunhui.Li" <chunhui.li@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0438/2077] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Tue, 21 Jul 2026 17:01:51 +0200
Message-ID: <20260721152603.088884296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 091ee8d2b17a89..69c2aa8c624663 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4710,6 +4710,7 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.53.0



