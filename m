Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299CE3B8BBB;
	Sat, 17 Oct 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258003; cv=none; b=qWRnf0lNGREzfyChcEPAsfXtUWle92xEZROwfwyZzApkJ6k6H/bZ1cY6yz8sl1NlmT2U53eedEEr8BzIrlxLrHX9IIC3ja1LqCp2dprIvQNVpmy+vS2C8cnVoC0IRAuPOYJ06hJ9Vga23pnprtFLpGj4IRLYqL0Aj8xcz8T2CPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258003; c=relaxed/simple;
	bh=kiZmJkZ+Z/wrC74CycG1z/LvfOjgeYlqGHzFfFT7s2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hA+dh4ytVNxhQ9vtZprvcZ9YrymXx9Hk40JQk3oFxE5zet9US8lOHAkGpA14CxHLsHAtqTZsx3yDaI6rhMbrwSACtm7Jqyt58SGAa5zMHph7hraDMMNYh6RcawoC7FXWh6ZVRFQLcwu3wAst6ehGanCx8E38kdECafHkJeEcF3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tSqxQiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tSqxQiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D361F000C5;
	Sat, 17 Oct 2026 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258002;
	bh=NIlf9Rndjrp9Dve4CkFCxetYT9B1/el1Y/RE3H8J9Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tSqxQiZYFldSrLgUFqcSHmPKvxpdIRZetMILxjmFa17y+ZgPvZtKS8kVaI2qDv8Q
	 wU/LP5/ylHkkIZrHduxTvoggOWQbsavJBkGI/zJMrsqBsOWKVKH116zRgQDvSMXuNO
	 LwqoCvNStyvdTSPCs6CwDPD8Fw6tGjXUhz4AP8ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0739/1674] um: fix time-travel syscall scheduling hack
Date: Sat, 17 Oct 2026 17:50:11 +0200
Message-ID: <20261017160450.067962706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 381d2f95c8aa575d5d42bf1fe0ea9a70c4bec0cf ]

The schedule() call there really never did anything at
least since the introduction of the EEVDF scheduler,
but now I found a case where we permanently hang in a
loop of -ERESTARTNOINTR (due to locking.) Work around
it by making any syscalls with error return take time
(and then schedule after) so we cannot hang in such a
loop forever.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 887c5c12e80c ("um: work around sched_yield not yielding in time-travel mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/skas/syscall.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index 9ee19e566da3b..b09e85279d2b8 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -12,23 +12,13 @@
 #include <sysdep/syscalls.h>
 #include <linux/time-internal.h>
 #include <asm/unistd.h>
+#include <asm/delay.h>
 
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
 	int syscall;
 
-	/*
-	 * If we have infinite CPU resources, then make every syscall also a
-	 * preemption point, since we don't have any other preemption in this
-	 * case, and kernel threads would basically never run until userspace
-	 * went to sleep, even if said userspace interacts with the kernel in
-	 * various ways.
-	 */
-	if (time_travel_mode == TT_MODE_INFCPU ||
-	    time_travel_mode == TT_MODE_EXTERNAL)
-		schedule();
-
 	/* Initialize the syscall number and default return value. */
 	UPT_SYSCALL_NR(r) = PT_SYSCALL_NR(r->gp);
 	PT_REGS_SET_SYSCALL_RETURN(regs, -ENOSYS);
@@ -41,9 +31,25 @@ void handle_syscall(struct uml_pt_regs *r)
 		goto out;
 
 	syscall = UPT_SYSCALL_NR(r);
-	if (syscall >= 0 && syscall < __NR_syscalls)
-		PT_REGS_SET_SYSCALL_RETURN(regs,
-				EXECUTE_SYSCALL(syscall, regs));
+	if (syscall >= 0 && syscall < __NR_syscalls) {
+		unsigned long ret = EXECUTE_SYSCALL(syscall, regs);
+
+		PT_REGS_SET_SYSCALL_RETURN(regs, ret);
+
+		/*
+		 * An error value here can be some form of -ERESTARTSYS
+		 * and then we'd just loop. Make any error syscalls take
+		 * some time, so that it won't just loop if something is
+		 * not ready, and hopefully other things will make some
+		 * progress.
+		 */
+		if (IS_ERR_VALUE(ret) &&
+		    (time_travel_mode == TT_MODE_INFCPU ||
+		     time_travel_mode == TT_MODE_EXTERNAL)) {
+			um_udelay(1);
+			schedule();
+		}
+	}
 
 out:
 	syscall_trace_leave(regs);
-- 
2.53.0



