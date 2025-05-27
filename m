Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1850194A67;
	Tue, 27 May 2025 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364791; cv=none; b=HmQjGjq/E/p1YD2PLK/cUKzu4g6Kic/Vexn2WZFQRfPkL2MkZkrQnqk4ilOAihjmgX2VLC9xMoEmzbRtUjJpBLwn6kpIRMEcU0/eZiVh8+NgxVr4YtdCMIEd8Tu1n+TXap+1K1mVp2rybLInTyUGWeqND/Ii+RruzQ9IHDOx2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364791; c=relaxed/simple;
	bh=trOEykDWcdbE03KxjbAD0nAiaQIQr0VSQ51PmAMpK3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPPzbzKbVimw1yDSO+/2ow86k2odGjD2ssXkOjqsbvrsoB3L+Ej2z91G11RvW4TQso9syDoCu2Igko8QkdX5gaqipC930R0/2zL9yI+NFei1tEr4+N7q5tnX7FGW8acRxx9QM6QS43AMl8a9SA/DqetfLgRowxDEpuIwoNB3eCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXdAH5lP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXdAH5lP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101BAC4CEE9;
	Tue, 27 May 2025 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364791;
	bh=trOEykDWcdbE03KxjbAD0nAiaQIQr0VSQ51PmAMpK3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXdAH5lPjd9Nzuqklcn7wxMcD4UI+wFzui8+EC6PXDiNZk234RShL74FTYxXm1vR/
	 JSkgDim90MiI4+xwnn6iphhzOUxp4690h1nn8neWN8Nj/xyzNEjrlk5MXlmIC3dG4D
	 nP9FYuOsCHGt/wOe3mel677Wv0pjqpTEFEEascKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/626] posix-timers: Ensure that timer initialization is fully visible
Date: Tue, 27 May 2025 18:21:00 +0200
Message-ID: <20250527162451.809472563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 896ff735034ce..c5d9bfbb082b8 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -514,14 +514,21 @@ static int do_timer_create(clockid_t which_clock, struct sigevent *event,
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



