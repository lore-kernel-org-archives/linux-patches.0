Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0DC334C3B;
	Wed, 23 Sep 2026 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173452; cv=none; b=VpblJGjm1DVajmHLB5uOcSFeMLHIXJPibMYAXaRZBIHzpXn2/jVBqVJeSdC3WMqa3CWGkEYnOP5DJChUcrYc61nB1b2F5A2M/mQuVie3Ll/2r3kkMurqthXZR7+lz/8aZ2pFqJGqzLWP4lvK2mFd7dfO67JQXkejKlG0FRzp284=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173452; c=relaxed/simple;
	bh=VfZqqwsKewm/87IlrI51tdxZxg4v5Eb8KR7hnxCnmDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdPYMfWLoDEISg9UN4mNyTdT4HReUoBKFTSmlmpCFfmtnm19lKU8ztAqg5HXCQJ8+KgaDAuSOpMkbvJwcAqYNHwMLS/ty7b9Nz8KCoof0op4apaM7KCsgl/gRtOwrmHNk3UrUG3rEYW1EpmwJiwDSN4PMUgWVOtsPQ/fGXntZ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4GoWWEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4GoWWEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B771F000FF;
	Wed, 23 Sep 2026 14:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173450;
	bh=M0AxDZEr5KdeNy0b59ewGNhCIE4EptkSFH0E5DRSaT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4GoWWEkbeNfrDji6ubDGuNbhlmtgnV7I9xFit/EwfNmGy8wvIKunBO9NJykYl3o+
	 9nbAnj6PTP9DefeTZ2da7t6wR7fRDSUYLmlCjXT1miM7saAeh0IL/nwhe3Bh9Dmb7z
	 URwruNCScrAb1NIUFROXzHkHqVmZeDsRIkHDqzv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kijo Park <red993688@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 7.2 249/438] posix-cpu-timers: Prevent freeing a timer which is queued on the expiry list
Date: Wed, 23 Sep 2026 16:04:30 +0200
Message-ID: <20260923140651.224759897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

commit c21eaa72f02fc6e85621cbe09d303d8fb8bd39cd upstream.

Kijo analyzed another race in the POSIX CPU timer code:

Commit bf635681c906 converted cpu_timer::firing from a tristate value to a
boolean. This lost the distinction between "not owned by the firing list"
and "still owned, but delivery was canceled". The resulting race is:

    expiry handler              timer_settime()        timer_delete()
    --------------              ---------------        --------------
    collect timer onto
    private firing list
    firing = true
                                observes firing = true
                                firing = false
                                return TIMER_RETRY
                                wait for handler
                                                       observes firing = false
                                                       finish deletion
                                                       unhash and free timer
    resume list traversal
    read freed elist.next
    -> UAF

The firing bit is clearly the wrong indicator since that commit.

Check whether the timer is queued on the expiry list or not instead. If it
is queued clear the firing bit to prevent signal delivery as before and
return TIMER_RETRY so the caller unlocks the timer which allows the expiry
code to make progress and remove it from the list.

Fixes: bf635681c906 ("posix-cpu-timers: Cleanup the firing logic")
Reported-by: Kijo Park <red993688@gmail.com>
Debugged-by: Kijo Park <red993688@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Kijo Park <red993688@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -408,6 +408,7 @@ static int posix_cpu_timer_create(struct
 
 	new_timer->kclock = &clock_posix_cpu;
 	timerqueue_init(&new_timer->it.cpu.node);
+	INIT_LIST_HEAD(&new_timer->it.cpu.elist);
 	new_timer->it.cpu.pid = get_pid(pid);
 	rcu_read_unlock();
 	return 0;
@@ -566,6 +567,24 @@ static struct task_struct *timer_lock_si
 }
 
 /*
+ * If the timer is queued on the expiry list, then it cannot be dequeued because
+ * the firing list is not protected by sighand->lock. The delivery path is
+ * waiting for the timer lock. So go back, unlock and retry.
+ */
+static bool posix_cpu_timer_on_expiry_list(struct k_itimer *timer)
+{
+	if (list_empty(&timer->it.cpu.elist))
+		return false;
+
+	/*
+	 * Prevent signal delivery as there is no point in delivering a signal
+	 * which is made obsolete right away.
+	 */
+	timer->it.cpu.firing = false;
+	return true;
+}
+
+/*
  * Clean up a CPU-clock timer that is about to be destroyed.
  * This is called from timer deletion with the timer already locked.
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
@@ -580,18 +599,10 @@ static int posix_cpu_timer_del(struct k_
 	p = timer_lock_sighand(timer, &flags);
 
 	if (likely(p)) {
-		if (timer->it.cpu.firing) {
-			/*
-			 * Prevent signal delivery. The timer cannot be dequeued
-			 * because it is on the firing list which is not protected
-			 * by sighand->lock. The delivery path is waiting for
-			 * the timer lock. So go back, unlock and retry.
-			 */
-			timer->it.cpu.firing = false;
+		if (posix_cpu_timer_on_expiry_list(timer))
 			ret = TIMER_RETRY;
-		} else {
+		else
 			disarm_timer(timer, p);
-		}
 		unlock_task_sighand(p, &flags);
 	}
 
@@ -731,14 +742,7 @@ static int posix_cpu_timer_set(struct k_
 	/* Retrieve the current expiry time before disarming the timer */
 	old_expires = cpu_timer_getexpires(ctmr);
 
-	if (unlikely(timer->it.cpu.firing)) {
-		/*
-		 * Prevent signal delivery. The timer cannot be dequeued
-		 * because it is on the firing list which is not protected
-		 * by sighand->lock. The delivery path is waiting for
-		 * the timer lock. So go back, unlock and retry.
-		 */
-		timer->it.cpu.firing = false;
+	if (posix_cpu_timer_on_expiry_list(timer)) {
 		ret = TIMER_RETRY;
 	} else {
 		cpu_timer_dequeue(ctmr);


