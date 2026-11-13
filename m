Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590753;
	b=awzW91cOCgKJq4GHglm4hI/C/SkViAL8VuB1uMv4ljxO2CZQW5/qqHZ8JeV3V4ecW9Ft
	 ih0NF4QghlOrx9yovHtasYi4FlvMIyOfwNLlJih8hCTvvhEJKkYBp25FZi3HwfrBi66yN
	 ZCM8o4q7wXdcbKadRk7Wat13z3gSvOWTr4/707cvv5qud/J+brHeOf7GBEwEWIuglEqov
	 i8dpSmX2tRca4qbY5U+JBUAxaxaw34I1wlyNBjjgjpvqssY2WR/X/ywSGvwF8bluhcsvo
	 Uje2MAN9C/zN2/VRPmXQGnt+ekA1pB9/qPTLLxiuuRUa/3NeHPLCJlChT7iRrYxBYMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEOsFL0sp7hrG3hdoayqTlq+Ba3a28iAi9xfUeOSn/k=;
	b=1hi+SSNRdtKTGIDePypNNruh+AAiqupUCMn/EfrnO0w7tCCeBdYFaOZzSoaBkv6z5Fun
	 G5fnJiK77Rn9TfMXcYViMjjyHIJ0pqGHM5Q0SiXDgNg5aQhXGIDTwX70GdzNl6fk7DTXu
	 fjYLkh5Vg/xqSzvsv7Xp4wjMDCyXvMWKoWzBL5Pq58BXoI5WmA4+3N/++s4+ZuE4VQEOR
	 o1mvOlGrsCBPJ4tBmaBg0cUybod/7C8oalarVLGHR8wWfY/eUDDH47l4HBSPM1cwj6MIL
	 +Wa+POplwCco/2iN31q41uGGtQgBw0SHssJYhrpF0JFrpMJN+7fDvfl8PcEKcj4isNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S75U6uzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D45607C341;
	Fri, 13 Nov 2026 17:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S75U6uzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722211F000C9;
	Fri, 13 Nov 2026 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590753;
	bh=mEOsFL0sp7hrG3hdoayqTlq+Ba3a28iAi9xfUeOSn/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S75U6uzrRFdmR9oSf+k6VjqifdnDHt3yH3EOLc6yWrf0uQASBV9SE9ii671AKjBUj
	 ujRtxn0FHZQhqVq+Kac/Bh9epO5CxOj0TaWtrinYj0kpH4tGUQyCb3nH92OjihXGKE
	 JJOJ5qXV/3kLqHRVe0WP2paPpGGsipOBUTIEQvJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 655/686] posix-timers: Handle the timer_[re]arm() return value
Date: Fri, 13 Nov 2026 10:53:08 -0500
Message-ID: <20261113153843.939505378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit cfb7fe3fdd4ca1d37da1ed15a1897d4a27c47a8a ]

The [re]arm callbacks will return true when the timer was queued and false
if it was already expired at enqueue time.

In both cases the call sites can trivially queue the signal right there,
when the timer was already expired. That avoids a full round trip through
the hrtimer interrupt.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260408114952.198028466@kernel.org
Stable-dep-of: 141a27750ec3 ("posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 3082129d836c2..3d39f77423afb 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -306,6 +306,8 @@ static bool common_hrtimer_rearm(struct k_itimer *timr)
 
 static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_itimer *timr)
 {
+	bool queued;
+
 	guard(spinlock)(&timr->it_lock);
 
 	/*
@@ -319,12 +321,18 @@ static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_it
 	if (!timr->it_interval || WARN_ON_ONCE(timr->it_status != POSIX_TIMER_REQUEUE_PENDING))
 		return true;
 
-	timr->kclock->timer_rearm(timr);
-	timr->it_status = POSIX_TIMER_ARMED;
+	/* timer_rearm() updates timr::it_overrun */
+	queued = timr->kclock->timer_rearm(timr);
+
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1LL;
 	++timr->it_signal_seq;
 	info->si_overrun = timer_overrun_to_int(timr);
+
+	if (queued)
+		timr->it_status = POSIX_TIMER_ARMED;
+	else
+		posix_timer_queue_signal(timr);
 	return true;
 }
 
@@ -912,9 +920,13 @@ int common_timer_set(struct k_itimer *timr, int flags,
 		expires = timens_ktime_to_host(timr->it_clock, expires);
 	sigev_none = timr->it_sigev_notify == SIGEV_NONE;
 
-	kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none);
-	if (!sigev_none)
-		timr->it_status = POSIX_TIMER_ARMED;
+	if (kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none)) {
+		if (!sigev_none)
+			timr->it_status = POSIX_TIMER_ARMED;
+	} else {
+		/* Timer was already expired, queue the signal */
+		posix_timer_queue_signal(timr);
+	}
 	return 0;
 }
 
-- 
2.53.0



