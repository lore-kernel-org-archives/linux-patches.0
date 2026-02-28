Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580B37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302570; cv=none; b=Smu92lSSzAna5jp5JjB5ONF7k25IoR5hDz+rTok1nBERCt+K2nOIDnaD5M9ec4zbspd28XpeVvDKz9YaofS7c9QCu5yor3+KNhiLAOSZg2eUkM8N/yZ84mdlUIfVs61i3052+lofr21KJUKYII9xVHJPvKo7gpl9/u/DqDSg41w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302570; c=relaxed/simple;
	bh=kqMOzlgv4f03iB9EIThQeGf/zHL00240YTtg/G0FEXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoHQgL/jOTwy7SiAyFFTpPy46Ou2weqnzgRGY9CSIs4nVxtXiJI9+99E6QqOk1FMkC+hL1F/98ju08272VvZen/2GSgtwNGxDo5kZSr6eELm13HEukdyIm/H+OxGQyPGs77KZj5ZIhcG2paKLHCjYC9vimnpV/rhdpEXZHjxr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhdALclx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhdALclx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547A5C19423;
	Sat, 28 Feb 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302569;
	bh=kqMOzlgv4f03iB9EIThQeGf/zHL00240YTtg/G0FEXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhdALclx/NpWczSXI2PIp4uZzf1vfdWWjJW1L7mAgadaYvRkL8LD/aIv+0DjSyijS
	 YE0UeUBINvBTnXcyQ95epQxzkDN8apTQ5QIn4zXGq6XssI8cCguBH+jLrQqYlL8EIx
	 h6PHEPHbYPOP0DSa43UN5Hsm26zAbL1zhn8HTS6QKyc5tWdc9tkFmZXbiQ5bq8gd0a
	 38URmqk602pw/L8Jg0qCYAmPZIQvFGtfQNR/3qB0py4B06cFn5oM1kipe429uQTqQw
	 ivONNSbQoILaeFvC9MsnuuTtrGY05zKtD7/7Ntmj0L5Uwd/Z2frukqtuf2GtrNjJ1f
	 RR2HZ9DPsJppw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: ye xingchen <ye.xingchen@zte.com.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/164] timers: Replace in_irq() with in_hardirq()
Date: Sat, 28 Feb 2026 13:13:35 -0500
Message-ID: <20260228181505.1600663-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit 8be3f96ceddb911539a53d87a66da84a04502366 ]

Replace the obsolete and ambiguous macro in_irq() with new
macro in_hardirq().

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/r/20221012012629.334966-1-ye.xingchen@zte.com.cn
Stable-dep-of: c9efde1e537b ("nfc: hci: shdlc: Stop timers and work before freeing context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index ab4709be7a59a..827d2ec268678 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1508,7 +1508,7 @@ static int __timer_delete_sync(struct timer_list *timer, bool shutdown)
 	 * don't use it in hardirq context, because it
 	 * could lead to deadlock.
 	 */
-	WARN_ON(in_irq() && !(timer->flags & TIMER_IRQSAFE));
+	WARN_ON(in_hardirq() && !(timer->flags & TIMER_IRQSAFE));
 
 	/*
 	 * Must be able to sleep on PREEMPT_RT because of the slowpath in
-- 
2.51.0

