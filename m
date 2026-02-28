Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA0A35AC03
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302676; cv=none; b=Qd9fCRnBS7pj2q8VMj9G5Ex+s0R3r7rdU04qtcMETYrs8rWkzb8c4g5iEUGQ9dyTnMpPutBR0yK/xb6V6ZFxmUpCTeI/Vy9ZQ0K9dKlool/cUKceZN+6W+cc0OM0JUvcuL/BoFBjq3mizXNYYlWGBM7+n0eehCz8yoagaLyspDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302676; c=relaxed/simple;
	bh=sFaOY6toGyA4gb/57p9/1ch2OdIZLwdn6HIcLsBpzMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJkBa/hjm6rICUy8vPp6xiBCN6NG0WW6R9YI/oMZ4nAdGY0N45ocDZM7ykwpKSiatzZrsZ6R6hMciWWIdrUpZJLt0/YL8MKsKxgyKxQAcNHwURkoeMnsFEVXHDMZZLMN6M5dHmmu7pxk0xmndWRSkJN3JgnxfIcRj1TB5+zIWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5vToQ//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5vToQ//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E18C19423;
	Sat, 28 Feb 2026 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302676;
	bh=sFaOY6toGyA4gb/57p9/1ch2OdIZLwdn6HIcLsBpzMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5vToQ//quoVKl+NktcUf1WaBaORD4dfQOig/e/k+6fjj5UhmpaivAKk6mL1bLAEu
	 TBwx1NSgVFjMXPV+VOBmN7pPE5N71NZm7YElJNEqoUXk69xHdjCWS0AWGdblSXrStg
	 k7DI3YshXI5T6yfuKkG91HWXfl1WaC2JkzES5XIl9cd/co+vq+5aLvuQ3w4zNJHG+R
	 6j7MgL3KXuxxw6p9KmCfPOb3o1jPzOY7YyN6wQCGJIGRvYicBZUiL1FeTFkbBq6vN3
	 s+EM+ZEDYu5MhDuGmS/geogtCnOYMbKX+eQWJe7GICeCRDg6iOOLT+L1iPIQDwWsX5
	 PO6V79qjCAR4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/147] hrtimer: Fix trace oddity
Date: Sat, 28 Feb 2026 13:15:34 -0500
Message-ID: <20260228181736.1605592-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 5d6446f409da00e5a389125ddb5ce09f5bc404c9 ]

It turns out that __run_hrtimer() will trace like:

          <idle>-0     [032] d.h2. 20705.474563: hrtimer_cancel:       hrtimer=0xff2db8f77f8226e8
          <idle>-0     [032] d.h1. 20705.474563: hrtimer_expire_entry: hrtimer=0xff2db8f77f8226e8 now=20699452001850 function=tick_nohz_handler/0x0

Which is a bit nonsensical, the timer doesn't get canceled on
expiration. The cause is the use of the incorrect debug helper.

Fixes: c6a2a1770245 ("hrtimer: Add tracepoint for hrtimers")
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260121143208.219595606@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index c202488695c46..cf928eb8f2f8d 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1553,7 +1553,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0

