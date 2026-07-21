Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FD449B2A;
	Tue, 21 Jul 2026 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655059; cv=none; b=I/c5BPxhhct8r8ZlOnKDIaHrKxjG72kjGYWZ5ubSimepvPgX6t65pkPwlN/zsO/k6NiKhbRG5OhWX3tcgf2qTQZwFtQTCi/oB5OJWnFEHhYHeKt+nu9K3pMvgCnprjl9ysjnNzYhhMo6THO0AbDLMdXywbUD3H9MYwfJEuYD0mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655059; c=relaxed/simple;
	bh=2ExcJxQAKf8GOQ0h6uzu1n8Ncwu5KqhjDDGhtfgtDW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdq+7Xkxji+SDpqEOQLwYSGoreT2ud4ThjcIFZQGoRDLE3vlOptl/w72LnszMtYPUei384DYLArx/9F5f/cyyCfG7Pw75sEPIqMdytq/v7llpx8+Kkv91H1fRG2BkFRSCu3rbTO9zR6cHK7Ywkp6en5Qo5EJKjwyKC14dK5r/bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t65/kdhd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t65/kdhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7701F000E9;
	Tue, 21 Jul 2026 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655058;
	bh=sf6gFpZP43BpPJwpaC5wLlhNFv02Gmx6GgfMqnBU+9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t65/kdhdIiW+3QWKGvXvuCGfNgu/qhhPME6Omlr1KyASAXMCWszt1ES/JEY+N7NFe
	 /IhONGNUKl1xbb22l4i7sc1qLB0F7JtsicW7Wjib3+QkE1pz65V6tbvMhpGTDAs0hN
	 JHlfGM+t5Zh6HoTJF7lcdIGKck+N3OtWOEeKOCdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 1897/2077] posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()
Date: Tue, 21 Jul 2026 17:26:10 +0200
Message-ID: <20260721152637.463679221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


