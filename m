Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062535;
	b=NDwi7Dd82Sg+hcY41NLc51p2g7g7QhRqxTb1YtQTIQ1zxswWntovY1N1NWr9JQoYMNM5
	 +/aHJBU5Gznj3JcxpwxjOXzeg1CbQGNKRiYMXkBTPyHEQSiYP/Ung6BkjoM0XCOXJKMdb
	 OF7dlaiNuql5PSVgzJC1NnW6YIbLbwzKo2sWC0zFFQxVpm91gs7rSJrAN1XCRU8zL8YWS
	 oKRN4lWKwu08kHUg/eNiKtnmwFclhEiMtgM3Jsa9bhlJmihShsti4D70PEAZfGNMXIxnI
	 oW0DCNN7dW1iGsG4kNnhPTil1UfQV6gywANiRizpew1EJCo8G5sZti0MnZt9PUIUMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1uXPQPGf14EO+Ii6gVkZHGcCdXopS9daMgTfL/hnlRc=;
	b=xX+5s3plgRkHcuuri74RKsHqVBlfi+aYDZb2vkhpMRGpWJVvIUL9RG49NHMqwea4PNK3
	 Dp7hj6N8H7FDa+B1FulSGbNBP0/TFB6dr6XKfjogMQ/1w903uIAnj/vJpOEsiZUtC0Yt0
	 pcm50CGVQNq5lowxAYAtMNgSJ7A8UVsZVdhwlIzpidd9YIh1P2zCDN9y+cgqd21n/TGNI
	 9yUzM13RTKkceFmek+GXAwUNrtzJUGOF3yWS0/J9+rzYF9Ac4o4i0kmkE/xWg1IRxGaDe
	 bnWqtWlYHX/coEcSRE9Lc+TD/f0i/ImYr6Jyjgr5S2kTCEwBZl3FtQzaYeLtou0WT0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKgAK7t+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C480606EE96;
	Sat,  7 Nov 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKgAK7t+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054C31F008A2;
	Sat,  7 Nov 2026 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062535;
	bh=1uXPQPGf14EO+Ii6gVkZHGcCdXopS9daMgTfL/hnlRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKgAK7t+95tE4HVLYpzHV7ZCmyycHduDeSejBusGDPoYZSuWdhEjpY8SIKIBD237R
	 biBkIOOVwOlCpyufzZKvR3lK0fBTOw/1EQ581mmvdJs0FZJvXOJi8tEIQdBH5MhY6f
	 ZOa4s+45v46gj0vEQxeqD4gI5uM7vm+E1DYs9vPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1426/1536] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Sat,  7 Nov 2026 08:57:22 -0500
Message-ID: <20261107135037.882949855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0471fbe87288..33211c78d02a5 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1584,8 +1584,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



