Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69E03C10A7;
	Tue, 21 Jul 2026 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670280; cv=none; b=tiABk68vXsT365F9FlorZGUvXA9RV+T6G76ZWSavqRuG7GSTl8I/neqtT5z4k1sAWNw7h4GbCFR/zX2c/23TO9SoST104d9/S2youFh+u5b5+IvbDm5yc/chj0hN/n9NRebPvIPcUk9IbvrzWxFRI+NA1yFRyiLcmfO4x7SSUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670280; c=relaxed/simple;
	bh=XFlLVqt2w1gcgiwHyINrj/Ir0p8CoCclYftGjhTZRJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlI3VbZlFIeTkRHoNk5grX+AJDoSOBqHOz8Un67gs/4j/BBIbZGIZfGZv4lOn/pyJDu3Ln/UmeUS/zv+ZZ2MJ9QbmX0Qkvz6D4UrOcdT9YNeKw1M/psORW4kAztNNHBGjirFwhaEJ1sJADPkjcyuzebTQ9eMZY74Sq1AMaYU29k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9CKfiMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9CKfiMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231211F000E9;
	Tue, 21 Jul 2026 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670277;
	bh=FxH4WXB9HWig1KGYWv4Dqw9fwvmTRg0XbUNOgud6Z3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9CKfiMQ3KOhUu0kUsLP4G7gQYF+Ll9vUJRqk4a5yy8jm9FlEeXnUlE0Zt4X+U+No
	 qDQWyzrc65m+a5+jVZQG3TmYdIK4r6KifzrFBu7Cn5NO6HR0O1xfp3Gws+u6VMESH9
	 YZx+zuiJSW+eHjS4KnvjWrLWQij5xF8Uvxyvo8fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 0871/1067] posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()
Date: Tue, 21 Jul 2026 17:24:32 +0200
Message-ID: <20260721152444.018856312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit 26aff38fefb1d6cd87e22525f41cc8f1aa61b24f upstream.

update_rlimit_cpu() converts the RLIMIT_CPU value to nanoseconds with

        u64 nsecs = rlim_new * NSEC_PER_SEC;

On 32-bit kernels both rlim_new (unsigned long) and NSEC_PER_SEC
(1000000000L) are 32-bit, so the multiplication is performed in unsigned
long and truncated for rlim_new > 4 seconds before being widened to u64.

The same file already casts to u64 for the matching computation in
check_process_timers():

        u64 softns = (u64)soft * NSEC_PER_SEC;

As a result, the truncated value is installed into the CPUCLOCK_PROF
expiry cache (nextevt), causing the process CPU timer to be programmed
to fire prematurely for any RLIMIT_CPU soft limit >= 5 seconds. The
actual SIGXCPU/SIGKILL decision in check_process_timers() already casts
to u64 and is therefore correct, so limit enforcement is not broken;
only the expiry-cache programming is wrong. Apply the same cast here so
both paths convert rlim_cur identically.

64-bit kernels are unaffected.

Fixes: 858cf3a8c599 ("timers/itimer: Convert internal cputime_t units to nsec")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616112017.1681372-1-zhanxusheng@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -41,7 +41,7 @@ void posix_cputimers_group_init(struct p
  */
 int update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
-	u64 nsecs = rlim_new * NSEC_PER_SEC;
+	u64 nsecs = (u64)rlim_new * NSEC_PER_SEC;
 	unsigned long irq_fl;
 
 	if (!lock_task_sighand(task, &irq_fl))


