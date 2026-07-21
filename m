Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9A44AB7F;
	Tue, 21 Jul 2026 21:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668959; cv=none; b=tTAg+JsQ+4Ofw2rAgdd8vfjWB603s0BGjJf3kNmcpAk+Osn8amAzZixJA2DGgYE5xThI1ii7W602G4zrGva/Eu41KK1fvAkVBRSxJNpC5FxHCx3B1NhglVSDKEiEQnUip6+NInawyxVxtFXd0vcgM1pY/snLhzjkkkAcQcESsqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668959; c=relaxed/simple;
	bh=I5pSNlGCZZVietkKj2UNtHv27+0GShbKtQexpbRQfTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/lDzq7xWKAWPgPOpL8WFzn6wHBZhWaJ2awSF7yGNsFtjkjpMs+avnmIyGa6uRp4NspGMKYuqNTkPmJuDZqfDoEvr+3UATXldfxdTzF223uPIEx6vvvIuwZMxrN7UqGQebhBeBG3pwD+nO5vrPw3nwTxb/bulfnGhnBP6nfJofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjIY0uJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjIY0uJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F90A1F00A3A;
	Tue, 21 Jul 2026 21:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668958;
	bh=loKSF/qhfwx10UKe2BZpamfjMpbB+2Rfo/YoSnpeSgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjIY0uJDLhS5yNuSOImqz3gQUSkRdH0xNFcNLPI/XxzqFjnYlQlCQb84ot218oaVE
	 WmH/2hmSWEu6ysSIhSmeoVYpNFqyn5n+qoZQdzCGReKQAJRh7JstIYNC0DCteQ7HWk
	 HdZv7GH7rRsBZB80bKXKHomJXUGOoI5mV6R9j7rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qiaoting.Lin" <linqiaoting@xiaomi.com>,
	"Guanyou.Chen" <chenguanyou@xiaomi.com>,
	"Chunhui.Li" <chunhui.li@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0371/1067] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Tue, 21 Jul 2026 17:16:12 +0200
Message-ID: <20260721152432.919926591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56111b42da2a9e..fa9008e5d8bd6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4620,6 +4620,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.53.0



