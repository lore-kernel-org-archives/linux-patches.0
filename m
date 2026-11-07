Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065280;
	b=4EDCYuleFt1Y4MyihzZlNsVmHo/pfY6v5+q6xzDYdRXK1G6o8bYK/kIKErMd/ckkgr2L
	 N1gkOFY7uQuc7eJNFZvYoxHnuRvsqukm5AlT5EYXq70i9hVAokzepwd9pJvB5zeNYuGQ4
	 gblRLO14A1hjPuivkOJPsdYzJ6mJYW3QHy/bsu9yvu0uUIhn1Dy3uILRG/ss1dgPJ8/A6
	 jn+5wlwKr/b+M3vRJKwcIGqhjj1EpnOjtiREm7pW9sXRIPTkhkZPJquAaM0yFQsCXQD+L
	 mKihQvoko4J8IF5cPR+8PfSgZBP8Gu3egFZUvCtqc+wCK4dSreXuuDz3qaHTEgc/pfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uodxvcuAI96auqYC9IiN3ID+/mOmM426EKo57OSW/ig=;
	b=IMFrnYxDGqWMD2b+uYxNxqfnV88GY6xAzONVLwstkYrQbQOVkYbKuWo9oiBx5yOaoHpU
	 30+YDSW4zLzBxDPyuV2qUERJNlykLmdjAYAJUDG5hGkkgDJj/MuqCdWLbd1UU6Z85uVEz
	 Hv6YwFkixyGTSSZtT8dLI3T023QIR0TMXxkJuLWxBegaHnxjnh0e+JhtYAP2gsTZpoXL5
	 bS28h42maB93pKv3LYErnDfjkt82NafunNekfVWC3ydhfs+oxpEZtDowLhI2DVe2iFxAl
	 WyX7ddrD3Ww1n0t7S06Zrpb5V4ViK7A/H4cHTxJ6XUi78l5tChLGQCSsm0oqorXAACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgyh7WGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D2E606A331;
	Sat,  7 Nov 2026 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jgyh7WGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3535E1F008A6;
	Sat,  7 Nov 2026 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065279;
	bh=uodxvcuAI96auqYC9IiN3ID+/mOmM426EKo57OSW/ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgyh7WGX0AjlVChh04IzlMTKXdM9pGJI701DeNBPLZeO4TSEkTO7TmpskkfJkQR0A
	 Ta4Gl7L1gt2cyD6b+vLlrL4GTNQDFkzvQnoT7PPhZRSq94KrgOl0M5h4GCGEalv5vY
	 1YGXtyF1Nw5F+vGVSpVLMhAlep+cVLhr3EhvpDKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1041/1257] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Sat,  7 Nov 2026 08:55:37 -0500
Message-ID: <20261107135008.065869390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0bf4fcd969c87..65cc612046d18 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1600,8 +1600,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



