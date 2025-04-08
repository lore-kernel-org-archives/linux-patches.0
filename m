Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B272063FD;
	Tue,  8 Apr 2025 12:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115383; cv=none; b=eWXIKmdLqbBkVgBIoapvlNDP0U30A49C+154hgg00ViqDEFOnZBEbV8PVe5rGe8dVt/OjJ5y/quYGTCYypDsFpev4Bq0fWFwwdZT959e2HkZpWR99JVN1xzPiewQ/Ts3/KRDZkWrFHpDJFk60dkImvMXtKb/MRR7CsF73js5Xqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115383; c=relaxed/simple;
	bh=yYiA6ulvCMoUOJ0z08ALK4CD845YEodEWYj47XY3FRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk5amk1VyQwSkxJC45qOlW7+6jQAvV4cdIhGx7BJXbsr0BPEhKHpyGjfAybT1vLK3oiW8SC7dk9oFpnRLTmsTywSm/0RdvtSGYwRH0SeshAuNj1Y+0Nn9xlXq9M8eZth0Oz2y6hOrfHlj78LENLzlUzmWRJ509h/D8+oLCDuh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbL8pKTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbL8pKTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC9C4CEE7;
	Tue,  8 Apr 2025 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115383;
	bh=yYiA6ulvCMoUOJ0z08ALK4CD845YEodEWYj47XY3FRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbL8pKTf2La2ncY1xUS8Z7u3Y02c3shPTkX93Mvjea8Ak2tCe4zwoY/XFqXgQa+B6
	 d42PwdU5conPrnTSVL0U8tjgcioHR/akHTBk00JwJi8HtkOQvAvTPF0nAQvICnsYs+
	 QP2j5i3z8GtN3xdJF1fwDmTmBHEXmQFJ9sxcMSdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.13 453/499] x86/tsc: Always save/restore TSC sched_clock() on suspend/resume
Date: Tue,  8 Apr 2025 12:51:05 +0200
Message-ID: <20250408104902.530925031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit d90c9de9de2f1712df56de6e4f7d6982d358cabe upstream.

TSC could be reset in deep ACPI sleep states, even with invariant TSC.

That's the reason we have sched_clock() save/restore functions, to deal
with this situation. But what happens is that such functions are guarded
with a check for the stability of sched_clock - if not considered stable,
the save/restore routines aren't executed.

On top of that, we have a clear comment in native_sched_clock() saying
that *even* with TSC unstable, we continue using TSC for sched_clock due
to its speed.

In other words, if we have a situation of TSC getting detected as unstable,
it marks the sched_clock as unstable as well, so subsequent S3 sleep cycles
could bring bogus sched_clock values due to the lack of the save/restore
mechanism, causing warnings like this:

  [22.954918] ------------[ cut here ]------------
  [22.954923] Delta way too big! 18446743750843854390 ts=18446744072977390405 before=322133536015 after=322133536015 write stamp=18446744072977390405
  [22.954923] If you just came from a suspend/resume,
  [22.954923] please switch to the trace global clock:
  [22.954923]   echo global > /sys/kernel/tracing/trace_clock
  [22.954923] or add trace_clock=global to the kernel command line
  [22.954937] WARNING: CPU: 2 PID: 5728 at kernel/trace/ring_buffer.c:2890 rb_add_timestamp+0x193/0x1c0

Notice that the above was reproduced even with "trace_clock=global".

The fix for that is to _always_ save/restore the sched_clock on suspend
cycle _if TSC is used_ as sched_clock - only if we fallback to jiffies
the sched_clock_stable() check becomes relevant to save/restore the
sched_clock.

Debugged-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250215210314.351480-1-gpiccoli@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/tsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -957,7 +957,7 @@ static unsigned long long cyc2ns_suspend
 
 void tsc_save_sched_clock_state(void)
 {
-	if (!sched_clock_stable())
+	if (!static_branch_likely(&__use_tsc) && !sched_clock_stable())
 		return;
 
 	cyc2ns_suspend = sched_clock();
@@ -977,7 +977,7 @@ void tsc_restore_sched_clock_state(void)
 	unsigned long flags;
 	int cpu;
 
-	if (!sched_clock_stable())
+	if (!static_branch_likely(&__use_tsc) && !sched_clock_stable())
 		return;
 
 	local_irq_save(flags);


