Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036854;
	b=XLchPOCBxmEwGoCz3XdR10VnEoD3uLHqM/uoCr7NLVwHSWdCHgJtQyY5AL2dIGdDueYd
	 FgTqwVJhDdKbuB9GecpXtlN0B6w7jLMDfaA3Q+dJtKPgzXa9hjiHi+xXobU7dkFczBksb
	 AepdXM/eILD3dNa12/fDdLG79drp5TWxkH4FymaTHDJdxjOUiZ3R7twAupfxhF5Txfbcf
	 h7pr9XC3X4RR278O5tZYDlgI+mq7y7cThnI4Gr91u2C6XHoSt7SpzTPDH9Szxfz4dZC6q
	 OuB+sZ7yoFYzhWVxjw1Pbgiqirjf6x7HTYBybFERlOdZQpsK0MePGpTJ7ouM0AHcUVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxHy2OetH6vhmu4ZucqZcZ9dR+xW+XN3IZJajRdfLAs=;
	b=fp/BvrR4hObEoNcGGTjMM7GYppOQKtT8aFb21gGn7zcHXb5hVoMPqtz+wOFKx50enpa1
	 lJqTVm5K8rLOgxjlrrsFKjCp776SU7dhDfADF5Da+5fuxjsXZw4nosqIp/A3VZJza47x1
	 PZnkTywzgWND15atWMQbsgwX50teB8iiiQ/eakkcP1unRggLIuTrAY4WO+iAUcLmUJMLv
	 ZD52EbocNVYJr5MigzSQwqtEERrv+KvUiokj8eyJO9ed7LRa/sMXWdoGtK/PbO6XYUQqz
	 rX8Q3AjdxjUCN3MY1keKxnhBFtoxq7G7VsZIES5bvXJEkMSE+83Sjon8Ewh64ni/5Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9Aj63IF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC5606A320;
	Wed, 18 Nov 2026 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9Aj63IF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC10D1F000C5;
	Wed, 18 Nov 2026 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036854;
	bh=UxHy2OetH6vhmu4ZucqZcZ9dR+xW+XN3IZJajRdfLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9Aj63IFjXEIl5AAy8iIKW8coE/beHAygCR9c4c2rp8oGbVjGVHq7tuMSfZ8nBS5G
	 PXs1PWcgdhpZA5SX37RJTlpNuefdZ1fpW9t18ksg4r/FgV69BY7HR9WDsJLsOLjZR9
	 DxES6b0K/4dmlB2baUzJccgXZCUAOb6x57Zp60Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1208/3318] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path
Date: Wed, 18 Nov 2026 15:30:30 +0100
Message-ID: <20261118150356.411048967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fa730130fe154..e1312fbb69caf 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1607,8 +1607,8 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
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



