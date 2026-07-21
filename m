Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC3403E9B;
	Tue, 21 Jul 2026 18:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659098; cv=none; b=fOWbO7ndhLLJZBxE/6WRJgqMMebK3ggi9ifm65QlwJ/TYmqHXU/7a3LY8FG+FRFRdplmCRINfDt06jD36XEK0GqFHsLM8f3d60jl4OeuAMLFpPD8A2ajJx451cbTd6sQSPycmNFsG4hnwhh7Qsvp8bSOoPxlCGlKBHxslbsHRn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659098; c=relaxed/simple;
	bh=MlCCldVmMhYx9/R96xryDboWY4vIFezEIQnbrrARdwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYd2t/BBpES6N5F1Z5+3W/cErlPGnxsbgliODmIIbHggExoRd9UEM2oyKYMdnVYZOcurn2sKODqJKHjYDx7Zn+impCXUcA8Uqy3pQxfAzy+7BNJeLLgANHLx+4u3tAV5P2GYDwKg5V8EH+PKLN0pC3Hqks82nau/zLYcn7pyjl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMsy81mu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMsy81mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D921F00A3D;
	Tue, 21 Jul 2026 18:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659094;
	bh=r9jVX5QrvvjB+ovnDNdOb0P7pPf4bOHu+iEjtiuvyoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMsy81mupevrcNosLqjgp7tcYUmLX4PuZ7vpNo/UsH9m8a20XagPJ+m6T69r4p6/P
	 SJk6MZBGQ/CrPWQK87FUJi760ffUC2Wn/tGDFNBh0FJumze5kYYTuHYain5+ulv69V
	 wKeNqRMAWG9VVVtUVBUzC3UeJm2/olXgtDywep5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 1389/1611] posix-cpu-timers: Use u64 multiplication in update_rlimit_cpu()
Date: Tue, 21 Jul 2026 17:25:05 +0200
Message-ID: <20260721152546.685362562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


