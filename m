Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052817;
	b=TIVJvtBdp6VHX1vWdkMAkEyZleF7k6xxPP6IdCPPbJe/m3uYOjouo5AzIVwNs76tM1TB
	 yUvNdRe5T/cX8zEF654HpstELA3kJxAGOqjqmsY0d4+yNyil4owW9anut97YOS0uIlglC
	 4oYhF0ltP6wPo2Xp0WgPdaHBmLtpaZxvQMc2fkC5G/zo0sFPXN2cq9zea4nbjprg3VtqG
	 pofKFxOKVYaHF3zbku2d0Qq9S0HWf2SPcRELUAzC5Bj6O9mnHJCyi41sG9Lguww+rApoc
	 hnAryH+QYNZvLxu3UgbqrsLZSJQYg4N2RMWon37oCwpeiFcrSQ7CNTHnR+ihS+TWo5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sJFB35apyc0YHepiCTSbdApTjit9Osis5RK60FU9V/Y=;
	b=HXLal9xKIDRKiO7wNId4yIt+3oagyr23ljT9yiv3vWvmMxI/UZdY2J2/jI96L/irU5vz
	 50AnFVYUn0a0BZZO9L5KUF/uPtW63yI+QHfr9l84FEiUIaqXwxrr0lF10ADFCvkrsg6oq
	 BewmGrBzMeDmqs+GpIa4wN2T1ruxkS0+o6L0UPCpueYv3K/mru1HWEZyIFvdgBkgVL5tB
	 QrHVIdxvouoDs9OLcBhyWfOqdvjodC9x0cL5bwGjjPE4R7vHLadyddKu75DQxY34YFkK8
	 yTSx19k5WlZKo+FpLxpPtTMkI+nQpeJEsx4r4LPpCwSH74HnjXLW2JBfNEqReeYb8nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAHDtmuI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEC8606A320;
	Thu, 19 Nov 2026 01:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAHDtmuI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B231F000C4;
	Thu, 19 Nov 2026 01:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052817;
	bh=sJFB35apyc0YHepiCTSbdApTjit9Osis5RK60FU9V/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAHDtmuI28pv2mxYsxPNFG/FHPruqJC70KHXuee0kLY1yvJswoVbTpHU/FfmLoleo
	 U7cfjCAmKXVMsQ1XNou/H95HbXER9yoSQz8+Fea93pu7XwcF4dEkS9Y9GRqpkL64T7
	 TEG+2UC+uiVHacUtWim7DFa0l4M903MC8h4y1z0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0699/2214] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Wed, 18 Nov 2026 15:39:35 +0100
Message-ID: <20261118150039.771680205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 52deada50891a..fcf95de6fca3f 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1601,8 +1601,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



