Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95351379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302068; cv=none; b=aRPaHszT09lJ8YjNjaQMMAukMF0Msq3WIP/7r326mJCzcqt7sNxJ7Ucz8pt2gNc4ADOP8FllGbQFYVAcODAUWRLe+2+/RJUqfVy1y7UtYSI6cneyRcKKyTopbGoo5/VuPNxjra1455USbuer3A+XHSE038wQGxfL5vwYHEomqv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302068; c=relaxed/simple;
	bh=eDTbKJeK9t/DTmy4ayF0F6zjHYRkQDJAcYq1jLs4/CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqVCfnMxBc4oMfFbp5PpRkj9a/MFBEiRCjvLC04ao9t1wgYROtvfpHZ03jkkBGvxayOjjWteexmWw7c6vLP0dhvGRLjm54LOTqWeD9WhyepVhBQYXdoNU7fKkaZUaK6hwzX2eDpShtHvvmsaT9lEN3unExRXQTjTrzF6b2BJFU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjIFi7nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjIFi7nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060EAC116D0;
	Sat, 28 Feb 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302068;
	bh=eDTbKJeK9t/DTmy4ayF0F6zjHYRkQDJAcYq1jLs4/CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjIFi7nHICWlgNuyCDOADb9r0alQjwWIk2B90iVRxW5DNSntvJJORI1A7kTD9+CdR
	 EUnxz/PJFC3C67xXyHgdJaIxSQNikPpZKA1u+qandwOeWzr2VMDdEy72CvZ9YYVMGL
	 yHd/R0/T1lzyvWcriAVIDCx8MZ1+AYgaXyV/vMsC5Zi4bhhU0cjSUHV77L3OE4DDea
	 JoVTP5Df0vXwKb3vaBBMSciRqjBYWbfFg2Qn7rJ/2ssF9rJPaFNzjdUnFK5htTFAdn
	 lsGLacN+FhYkFF9MC36Ulnwg/gaa+O7XArhEA7+yc6taHcVslczBhnrvlTA+alI9tN
	 izTVEM7xy/g0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/283] hrtimer: Fix trace oddity
Date: Sat, 28 Feb 2026 13:03:09 -0500
Message-ID: <20260228180709.1583486-47-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0320f49bd1f4a..03f488f93cddf 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1715,7 +1715,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0

