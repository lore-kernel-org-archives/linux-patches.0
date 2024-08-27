Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FAC1C7B62;
	Tue, 27 Aug 2024 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770260; cv=none; b=lbBrl3kGXVWOOPZX6b8vTJdV1raS31FtmEjy83SORjt41l6bMiJPPsksbF1QVun3zjPwwBUUY5JI9Wm1A3MzgMEsuOsagpRhvfgQ7Jw8lp+QV1yN3n2y9qY/R52EWWtq8s6Z/wDOOezDsE19TgR955hNE6QgtvqIYqLw4FX4dw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770260; c=relaxed/simple;
	bh=mIGBsvgPRE55uQsyjeymZUGC5ducbcKJQbeOvrLE8xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQiuTKkrJNkyH6nLouOo9l8ChRk9XWUrWE4e6G7qNZqNvTEef0MGBAqI+VjVHgxN6ZW54vWNXMZFC2+haO1INuhXRaSL9bAlaiRecuYXH3/OG+qlUUi69g1wCT/wbcye05M+EaojSb9ytOTzlBiJw3PRyg/qRLD+1g0tOBHFvLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9+F08+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9+F08+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424B6C4DE02;
	Tue, 27 Aug 2024 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770257;
	bh=mIGBsvgPRE55uQsyjeymZUGC5ducbcKJQbeOvrLE8xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9+F08+U/r/BfLYG0wVV+PlPs0XSZ4GZzrFADqUIYSCO/WbUfIRIp6/NIdzXdzclk
	 qom2JnsHq7hA6PTqKIakspqW3vRrn0f1NyUjNboRN5tqwCAe98WwIDFMJCSSFI2GDT
	 c6b+CBpJ640O+F0yAdnLzKr3u2frYAcdI0Is51es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/341] tick: Move got_idle_tick away from common flags
Date: Tue, 27 Aug 2024 16:36:45 +0200
Message-ID: <20240827143850.036033079@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 3ce74f1a8566dbbc9774f85fb0ce781fe290fd32 ]

tick_nohz_idle_got_tick() is called by cpuidle_reflect() within the idle
loop with interrupts enabled. This function modifies the struct
tick_sched's bitfield "got_idle_tick". However this bitfield is stored
within the same mask as other bitfields that can be modified from
interrupts.

Fortunately so far it looks like the only race that can happen is while
writing ->got_idle_tick to 0, an interrupt fires and writes the
->idle_active field to 0. It's then possible that the interrupted write
to ->got_idle_tick writes back the old value of ->idle_active back to 1.

However if that happens, the worst possible outcome is that the time
spent between that interrupt and the upcoming call to
tick_nohz_idle_exit() is accounted as idle, which is negligible quantity.

Still all the bitfield writes within this struct tick_sched's shadow
mask should be IRQ-safe. Therefore move this bitfield out to its own
storage to avoid further suprises.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240225225508.11587-12-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.h b/kernel/time/tick-sched.h
index 5ed5a9d41d5a7..03a586e12cf89 100644
--- a/kernel/time/tick-sched.h
+++ b/kernel/time/tick-sched.h
@@ -61,7 +61,6 @@ struct tick_sched {
 	unsigned int			tick_stopped	: 1;
 	unsigned int			idle_active	: 1;
 	unsigned int			do_timer_last	: 1;
-	unsigned int			got_idle_tick	: 1;
 
 	/* Tick handling: jiffies stall check */
 	unsigned int			stalled_jiffies;
@@ -73,6 +72,7 @@ struct tick_sched {
 	ktime_t				next_tick;
 	unsigned long			idle_jiffies;
 	ktime_t				idle_waketime;
+	unsigned int			got_idle_tick;
 
 	/* Idle entry */
 	seqcount_t			idle_sleeptime_seq;
-- 
2.43.0



