Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0415272605;
	Tue, 26 Aug 2025 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214414; cv=none; b=N+e7pLVlae0Is2hDXv3FD3tOvYJiio/o2ZP6OseB0nYYVmNtZA2SaPO8a/XhqLYCXaBVdDodAb1xHcbsV8fgS5+VL/JbCIJx7An/bia05RIr2TDEcIUPbvEnD0/DyUZH3Lh4coL7bVss5RTLnXY4F7niJ+O5q3IFDhU4f5R0ZTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214414; c=relaxed/simple;
	bh=7ZQFPZX3YVHebQDyXPwg+lNqcCp78naGQU76Tz2OsUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hJm3DOTviegHODJZdXhoMghQcjEGCqj/Tmfw7sFa4H1SXLDseHu4HOm1SHaYKb//2GnTER1wmkJfs5K8JzsANReFQfspiEfCyuOHjzcew3XWI1fdQK0G5p1FfA+a158iXYp0bmEvff7IeayOaPEF6VqES+2tfK4sE6m7E1einjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5IVe5WT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5IVe5WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C86FC4CEF1;
	Tue, 26 Aug 2025 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214413;
	bh=7ZQFPZX3YVHebQDyXPwg+lNqcCp78naGQU76Tz2OsUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5IVe5WTM7g2d/rSozuJJuSNEhTYAeiE+pvFZ0IG1nJEpGTlbonILlygtjkxtkO4p
	 WL1OOdE8//pePHONAIBDVbow2J7topxdLtcGn3B1pQFyc+pOph70Y3rQ/wFnhWS8J7
	 cmr3Ic4rFNuDfVFN6D5Irz6wty9e34e3IWfknBDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/482] um: Re-evaluate thread flags repeatedly
Date: Tue, 26 Aug 2025 13:06:22 +0200
Message-ID: <20250826110934.007479824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9e2f2246eb2b5617d53af7b5e4e1b8c916f26a8 ]

The thread flags may change during their processing.
For example a task_work can queue a new signal to be sent.
This signal should be delivered before returning to usespace again.

Evaluate the flags repeatedly similar to other architectures.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20250704-uml-thread_flags-v1-1-0e293fd8d627@linutronix.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/thread_info.h |  4 ++++
 arch/um/kernel/process.c          | 20 ++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index c7b4b49826a2..40d823f36c09 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -68,7 +68,11 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL | \
+				 _TIF_NOTIFY_RESUME)
+
 #endif
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index c5281ce31685..d8c274d99390 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -97,14 +97,18 @@ void *__switch_to(struct task_struct *from, struct task_struct *to)
 void interrupt_end(void)
 {
 	struct pt_regs *regs = &current->thread.regs;
-
-	if (need_resched())
-		schedule();
-	if (test_thread_flag(TIF_SIGPENDING) ||
-	    test_thread_flag(TIF_NOTIFY_SIGNAL))
-		do_signal(regs);
-	if (test_thread_flag(TIF_NOTIFY_RESUME))
-		resume_user_mode_work(regs);
+	unsigned long thread_flags;
+
+	thread_flags = read_thread_flags();
+	while (thread_flags & _TIF_WORK_MASK) {
+		if (thread_flags & _TIF_NEED_RESCHED)
+			schedule();
+		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
+			do_signal(regs);
+		if (thread_flags & _TIF_NOTIFY_RESUME)
+			resume_user_mode_work(regs);
+		thread_flags = read_thread_flags();
+	}
 }
 
 int get_current_pid(void)
-- 
2.39.5



