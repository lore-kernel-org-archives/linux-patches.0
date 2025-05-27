Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEB1CD0C;
	Tue, 27 May 2025 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366851; cv=none; b=oLwEylnlGG3KRVW+hyvWxxOP1gYWTSPgd3rQ30VknU1AhrPVCXpes8NLgaXh9n2/YGxkanAsIHvTx1WaP7FsYOizN8c1P3Uvc8As5baVrjhTTLErU9isu+sIH0ggOfhF3v0s5fqNyWgk7EUJ7LeQ99gL1URA1/j09o0Kl/xIyGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366851; c=relaxed/simple;
	bh=OkVeUWgh7f5qXpPMHUAz6rubvWDRlNOb6PdRy6pKBoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTQFTWgfYjljYLdwwthYUgjIyUWIhUWcQj0J2ArY++yw3epYP6iIcfkt+cSaRr1p0Jc9uLL8NzWjMOsMq+DySViB9zh9ZyTe0+6paAs4sI8af2OHjrPKimbFdvcxuQje2Bxy6hsL0vBFabTbrVE5+RHJ1zY3fnogUmusLeiyKWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgLFkrlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgLFkrlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48683C4CEE9;
	Tue, 27 May 2025 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366851;
	bh=OkVeUWgh7f5qXpPMHUAz6rubvWDRlNOb6PdRy6pKBoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgLFkrlxkiwqEoWi5ndvm5WZps5uOT+i3MmKiffKMwt58IAgPSmhuKLRT/TeyiTrm
	 0FZoguKsPZeZO2PX8zWyDN9Y3sl+O2LA7WxOcs5baj8MS5MihTqiwUs58pkavDVBRb
	 8jTttgcBKRgVF9tjZPhhPmzjYvPe8uCP6xZ7lqGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 198/783] posix-timers: Ensure that timer initialization is fully visible
Date: Tue, 27 May 2025 18:19:55 +0200
Message-ID: <20250527162521.213887685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2389c6efd3ad8edb3bcce0019b4edcc7d9c7de19 ]

Frederic pointed out that the memory operations to initialize the timer are
not guaranteed to be visible, when __lock_timer() observes timer::it_signal
valid under timer::it_lock:

  T0                                      T1
  ---------                               -----------
  do_timer_create()
      // A
      new_timer->.... = ....
      spin_lock(current->sighand)
      // B
      WRITE_ONCE(new_timer->it_signal, current->signal)
      spin_unlock(current->sighand)
					sys_timer_*()
					   t =  __lock_timer()
						  spin_lock(&timr->it_lock)
						  // observes B
						  if (timr->it_signal == current->signal)
						    return timr;
			                   if (!t)
					       return;
					// Is not guaranteed to observe A

Protect the write of timer::it_signal, which makes the timer valid, with
timer::it_lock as well. This guarantees that T1 must observe the
initialization A completely, when it observes the valid signal pointer
under timer::it_lock. sighand::siglock must still be taken to protect the
signal::posix_timers list.

Reported-by: Frederic Weisbecker <frederic@kernel.org>
Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20250308155623.507944489@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 7f8644e047558..15ed343693101 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -463,14 +463,21 @@ static int do_timer_create(clockid_t which_clock, struct sigevent *event,
 	if (error)
 		goto out;
 
-	spin_lock_irq(&current->sighand->siglock);
-	/* This makes the timer valid in the hash table */
-	WRITE_ONCE(new_timer->it_signal, current->signal);
-	hlist_add_head(&new_timer->list, &current->signal->posix_timers);
-	spin_unlock_irq(&current->sighand->siglock);
 	/*
-	 * After unlocking sighand::siglock @new_timer is subject to
-	 * concurrent removal and cannot be touched anymore
+	 * timer::it_lock ensures that __lock_timer() observes a fully
+	 * initialized timer when it observes a valid timer::it_signal.
+	 *
+	 * sighand::siglock is required to protect signal::posix_timers.
+	 */
+	scoped_guard (spinlock_irq, &new_timer->it_lock) {
+		guard(spinlock)(&current->sighand->siglock);
+		/* This makes the timer valid in the hash table */
+		WRITE_ONCE(new_timer->it_signal, current->signal);
+		hlist_add_head(&new_timer->list, &current->signal->posix_timers);
+	}
+	/*
+	 * After unlocking @new_timer is subject to concurrent removal and
+	 * cannot be touched anymore
 	 */
 	return 0;
 out:
-- 
2.39.5



