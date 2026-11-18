Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045815;
	b=aua0HR5Qb6YXxz355sL+T85tajsKIg/+ht3cXhi0DRWKq8EFURZOTOXf0VkfgmYp+VBq
	 +YYwv+PwmngrN5y+MBLYrfSPeLfOP7+ViI4pS0/WudNGDgs9YLS0wluArQy9C0Oq9J46v
	 HzBFGyeJze2hJI6/XBvsVeQAyPUMj1U8GyvbGGI3MKxBUSbrkFibMoLEdYwl5fM80RVLI
	 kMTzGAN1sUsxUDN1ocxVWRcdW80P/iNNRgycrC15G0WR3llTNTPdkqtYmccFfQKmLVm+X
	 wnU1Yr6HFoHq6POeEUZ22QS0ndqvAe8+MflYVm45YiVPGZuyepsawuKw9A1nboKjkGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KhX6zarQnYXawveLlDgH2BQmTiBR+q02uqKy28UwCUc=;
	b=1lUJiRKIGkxdzgwEwNeKjRUu4BPcGih33D2janjH/NJ1j/h6hf2TJapVTmz2M2n8rvzQ
	 IRsqVjXzpW80LegvB3V73graccs1VOi2F2P2rkL8pFzjOWd3WYzKeyOqWxEKaNMR5UELa
	 0n9AGVLj4PSMTM/fRKpHVH6CXYOYlZR47qhr6b+zBFkX32YVGzBQl4f/ak1eX/HG49Vph
	 5y8a5AxN//bsV4gk04beWBiKfCSMCKsXmbFsmsoWVFkDY3GdtZrtTYn060qm7ktnOPw8J
	 9VEIue13iIcz62AfYqF/fgtnbG2M647PMrVvgSxt4jFO8riWaanwCOw094zx+KEXFfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvlhl6v1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9781606A320;
	Wed, 18 Nov 2026 23:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvlhl6v1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BBC1F000C4;
	Wed, 18 Nov 2026 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045815;
	bh=KhX6zarQnYXawveLlDgH2BQmTiBR+q02uqKy28UwCUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvlhl6v15V3b5zLIaltQjMOSlF7osrNzof2NmRXAdwNaowyVlcmSwWStMjBNSzM+o
	 Q8Rd7LSXsYAbHliZhqVB2N+LCXbwlS4WFthJKsSvyroUtltRMY7h/6xIuZm/v6v9cR
	 EMWLXx6BNsdfrY9WZdzU9Fe5pmgJbcNhg5aDPCj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1031/2857] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Wed, 18 Nov 2026 15:34:25 +0100
Message-ID: <20261118150238.718679368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5f7ca683e7eb..6fd06bf6c0d1e 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1608,8 +1608,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



