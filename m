Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063647;
	b=DUR+o/oOmPVexLYrmf1bLX6Zn8YFW9AlZHkNNJqZhrvPj8Wvd/R4OAfUtYNVYVJZWcKc
	 ZhUk2XL4N/oQB1ez9bfQjCx5MMTZYchpNPLLxV/XrI1ei6qvYSazvup6TQXe9sYiUsRK4
	 O+dhK+igxoGn3k/96lueQ6zqnj8csILKHoiqaymjAEtJxTLMD+o2maJeKTZURTaFMmgGp
	 x1EAqf5LQLY8SMHICgAhGnaf7g9oXlcQpAj35W3yaTaiBJIMySg8szp65/S328/4AfB4M
	 lpjKO5L+WKMbnp4maJBL0H54MzNRpoEsM9hjqD+wqZ1RV6QmpCkWyasXyZqaW1N9YwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8bPzx6U2ZOnOiQx1Uum16cuxkLoK7Vp9L7WNpXANYUg=;
	b=sk7vXYDs6/NFF/Q8yJ2jymWQswwRJQ5oHvqe6lBCfocgDB1uCezZFKdEdmk2vV3TdmBg
	 3pHS5mJCqsXnCCvFacehxs4UQgrldBRbs19ens+KU8YD9iyawIV3+deYI/JTBzBY3mxUA
	 gZEoLsc8rC03C+rPEcSCag06fmhWa8at/VJEL+FX5V+ymHmsN+FaWKWAnQjGnk4t1IiXQ
	 cnMzUCxXXKwSnAoqgjdrCgNGreREhWk+57FBZUaxMbnZtxagmmULtvfOSm25XahELdY+P
	 2uGaJTXEVTAY7mCjXekypN8Sr1xbWEs95faWzTbREydCDgJ1DgmoWwrsMzQsHKk4EcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGfueAVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BDA60A6F43;
	Sat,  7 Nov 2026 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pGfueAVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1165B1F008A6;
	Sat,  7 Nov 2026 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063647;
	bh=8bPzx6U2ZOnOiQx1Uum16cuxkLoK7Vp9L7WNpXANYUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGfueAVCQdCuOEPGrZL/2IRlU1fhHDVodUe54wgh/SNXUHkIl1syfmtRNbMYfpZO1
	 wyt7Qvgoec9ydd4kgVk1Fj7aA+byVb5n6pe3wFCWoQ/Gt2SGilqhszbh2KCzQHwNNE
	 QTFFRaXjL6IZl9iUHJHYgK1C1pzKICXxP5g6ok04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 725/869] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Sat,  7 Nov 2026 08:56:47 -0500
Message-ID: <20261107134917.387110667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index b3d4bae9ee3e0..fcb98cbb1219b 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1597,8 +1597,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



