Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F171EF09D;
	Tue, 15 Jul 2025 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585886; cv=none; b=VPVCr70RgRTgTU3UJqxa6orGR4tt3oixTw2GeMK9gecF680y4xJUSVFKfQqFikGismbc5NigEJfxdh6kvwca4kcttfMVDm70b/a22fzSi3sY4u/I11GF/UJlczCvG7jxrLdpFXrvZEJSr68chrP8NnXFidd8ZuCh6MjoQKCnU7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585886; c=relaxed/simple;
	bh=rf3Wu7cFXRgYWy+iU30fa/71tY5W834uBQWCvuuxwQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtcqNTOOasZSyBsXoXE3NqLZRweQLmNH+HZL1FRuqV7+kGkpQzEUy6OuZZWBR1HVmSO6Y30P6jtOiyh1vl2FfLI427LCP3rjglmGwgB911rjxSXJXUqW3ezN8T2dqidkovmKweQeUV+KMhB7iwFhqc1aXynZLKKaex3QOY8pJ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT9i2YTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT9i2YTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC2AC4CEF1;
	Tue, 15 Jul 2025 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585885;
	bh=rf3Wu7cFXRgYWy+iU30fa/71tY5W834uBQWCvuuxwQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT9i2YTtCRwjWzDI9oOWPwAazcb4AegO+HePdzyabahqAkyZekLRZq3mLLFxNtXr0
	 4u0aenzYJ4U/k1Pj43rTMUgEU70xdcCt2jPPv5mqpIQIQrZ8m25PnC0Dts0aw2juhA
	 ZpVYzTHp+l0MwBpsjl7wo3/COYBAlotZcahFULYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/109] perf/core: Fix the WARN_ON_ONCE is out of lock protected region
Date: Tue, 15 Jul 2025 15:12:20 +0200
Message-ID: <20250715130759.049565376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 7b4c5a37544ba22c6ebe72c0d4ea56c953459fa5 ]

commit 3172fb986666 ("perf/core: Fix WARN in perf_cgroup_switch()") try to
fix a concurrency problem between perf_cgroup_switch and
perf_cgroup_event_disable. But it does not to move the WARN_ON_ONCE into
lock-protected region, so the warning is still be triggered.

Fixes: 3172fb986666 ("perf/core: Fix WARN in perf_cgroup_switch()")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250626135403.2454105-1-luogengkun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 873b17545717c..5c6da8bd03b10 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -873,8 +873,6 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
-	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
-
 	cgrp = perf_cgroup_from_task(task, NULL);
 	if (READ_ONCE(cpuctx->cgrp) == cgrp)
 		return;
@@ -886,6 +884,8 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == NULL)
 		return;
 
+	WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
+
 	perf_ctx_disable(&cpuctx->ctx, true);
 
 	ctx_sched_out(&cpuctx->ctx, EVENT_ALL|EVENT_CGROUP);
-- 
2.39.5



