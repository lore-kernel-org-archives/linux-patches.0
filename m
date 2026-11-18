Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058667;
	b=wvtagyg1DbD5UynAVb/KYOLGNXDctHzabbjOqm95m77WOzL7+2+JQAQjXqKoryKCwhQy
	 /f7FcWreKjlooO7bmBLXmuw7FAzJ2531BE7DaI9aSuSMnqaG9GAcLwzwIrfY03JPIGSCM
	 rcTnFchRlZPlc3GvTlfBa5qzSinsdof1WJ92YY5KX9az3dObAOBJisfZKDt0SXUF7Gwel
	 1Thbx81RwuqaDyR70Typ4YgsZdxsUFV8f9h3CrLQw1ICfYeANdHW2WX5tjeSiiJRecYi6
	 n+bNXuj6NwPXCgWP2cXB71gcGRuBoidFgFZz1QPj29eSoeagU9YFIUSubrAI9cfiYww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GOEz4nbw97vFeEwzJF0YlO7/enBxwFgjSZ6ARSuIZk=;
	b=Y5uzIIGADjc+y7/ICTxOUzjAEnhaVlzWQn913mUfzifIDxNrKXhV+8fBBOxptfCpDK+c
	 P+/KL50rpVHqcXSgWPRedmMEym1LrQkPLAdYMQeKu+Al9MzPhd4LKgkjZRb7lTB0G+16s
	 dG+qW4dgEY+k6wJoEJ1zkStH2LFcPRQ+e+nQSkdZt7KuVyaafq3gIxBgiU63V81vorLqY
	 N204E2GrYiTHwqqeJLEfDLWe3VRwEwdJ+ABR2pKa/jkbIJsj5ehjssMCNIaf52e+l8KBV
	 L3rYFB1pt99mOMYLJvU2OHI1a0aXUD0JfaBbWv/di6znzyhfC2PlVCQVmuGS8zz9TJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQrkQSIb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A7606A31C;
	Thu, 19 Nov 2026 03:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQrkQSIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061AC1F000C4;
	Thu, 19 Nov 2026 03:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058667;
	bh=/GOEz4nbw97vFeEwzJF0YlO7/enBxwFgjSZ6ARSuIZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQrkQSIbkYT+bN2lOVVg6agXCW5MWcyIWO5TXIVvYt3zEuAvKkgrQvrPow25Rci3K
	 B6PoaIkZb2ckYW8HfZz1d7A6UaUzMV954HkazfGCzhFQoE90M/PzZnRF6OD0CBMeiE
	 AZzgdZD9brmYGIBelA5w/nqKzC+k/UqJUzwvEq1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0566/1848] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Wed, 18 Nov 2026 15:43:24 +0100
Message-ID: <20261118145938.719696760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 8ccd731b63a0183ca2b0e18f3ca15864b3f37eda ]

do_cpu_nanosleep() sleeps on a temporary k_itimer whose reference on the
target's struct pid is taken by posix_cpu_timer_create() and dropped by
posix_cpu_timer_del(). When a signal ends the sleep, the timer is
disarmed with posix_cpu_timer_set(), but posix_cpu_timer_del() is only
called for a result of 0 or TIMER_RETRY. If the target thread or process
has exited in the meantime, timer_lock_sighand() finds no task,
posix_cpu_timer_set() returns -ESRCH and the pid reference is leaked.

An unprivileged user can trigger this: sleep on the CPU clock of a
thread, let that thread exit, then signal the sleeper. Each round leaks
one struct pid. Repeating it exhausts unreclaimable slab memory
within minutes:

  Out of memory: Killed process 150 (poc) total-vm:789292kB, anon-rss:484kB
  Kernel panic - not syncing: System is deadlocked on memory

Fix this by also calling posix_cpu_timer_del() on -ESRCH. With the
target gone, the deletion is safe. It finds no task either and only
drops the pid reference.

Fixes: e26d70d271ee ("posix-timers: Cleanup reaped target handling")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261012235149.66531-1-cenzhang@linux.microsoft.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-cpu-timers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 7cf6f083a5496..3fb24412618e8 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1559,8 +1559,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		 */
 		expires = cpu_timer_getexpires(&timer.it.cpu);
 		error = posix_cpu_timer_set(&timer, 0, &zero_it, &it);
-		if (!error) {
-			/* Timer is now unarmed, deletion can not fail. */
+		if (error != TIMER_RETRY) {
+			/* Unarmed or target gone (-ESRCH), deletion can not fail. */
 			posix_cpu_timer_del(&timer);
 		} else {
 			while (error == TIMER_RETRY) {
-- 
2.53.0



