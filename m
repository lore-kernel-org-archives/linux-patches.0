Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F013B42EF;
	Tue, 21 Jul 2026 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672990; cv=none; b=bs0lN0lrHnY25rg7N0gTmUumk5dpbvai4TAjsgYrBsqRnH5B9YuVEMXeNkBRI84YvIZHek3BbiPD4+zm10p4pM3ydDl5e4aj7bWAUpWoNVU1MthnBBZq+Cq/mNMzhGYvInslSbaZodSgjxk/oOOzwLnVCVB7PpeAXlt4T0RJ9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672990; c=relaxed/simple;
	bh=HY/Ft//5dK979sBcYNdx4pBipkNZRj7ojdzVxtsV0DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBKBk6tHtFBrwOozv0K7R7vOJ1JIoALmydNduJvC43jal1xPjLRKdUasUzfkFcF+hvXM/XZem7Gt3h+fIbxnT9KYPSzMmq02VmP+LsjHUJT/QRE7Mnzm/N3WNCd+99ytX8ozZoSIlM7ho3VbWeTJmKNXgORkqgQjbd850O9KYXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5Bp4Msb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5Bp4Msb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA41F00A3A;
	Tue, 21 Jul 2026 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672989;
	bh=VhaC4j/QP13D8AfcNGSf8PBkSbqadGLWxn/IHXm7Wf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5Bp4Msb80S6kBDuYf3v1Z080mqqm3rNqOXNxbpH1KgtiyNfwpM6fue2s7hEpGmCI
	 X0fBC9HVtUUYePnjS5b9GiawvBGNzeS/0szvKONLfqwOTakrpFJAVu1rRBVLWbkrLi
	 iGniL1leiPiTFJJwFs/pPWGIBiSM5YMh85Vzn9B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 834/843] posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()
Date: Tue, 21 Jul 2026 17:27:49 +0200
Message-ID: <20260721152424.841932526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,7 +37,7 @@ void posix_cputimers_group_init(struct p
  */
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
-	u64 nsecs = rlim_new * NSEC_PER_SEC;
+	u64 nsecs = (u64)rlim_new * NSEC_PER_SEC;
 
 	spin_lock_irq(&task->sighand->siglock);
 	set_process_cpu_timer(task, CPUCLOCK_PROF, &nsecs, NULL);


