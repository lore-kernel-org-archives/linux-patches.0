Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E172C1EFFB4;
	Mon, 18 Aug 2025 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522043; cv=none; b=pGcCOboAiKg3Mm9FW7/o73VQ2wgEaMaPmXEbcPwDrjJjlG4jJ2MOuVBDrxhomOp1V2Mh3BHmjzfvkIZwblUR9fhgQLrfQvZZjL35QbpnM6PWqJhwEl0s2Jqt2mGoMsNbbE1NDdx6RNIKpGwiQaWo+VKgBFpmcKPgZ4Rq+l1M/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522043; c=relaxed/simple;
	bh=NfaKOmXzhphGVuuYUqFpJXo1ioc2sf07y0TEUEbjaOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYMx2A0GudqwlDmbFTjP1U2sPYo26uHGFphR/kyG4czzSxUlwgagpOCMqru+I+E4Yti2A3flDvv8MbKAxydRiAkIoXsEhPndjkbmVc/LHRg2lvcx/P4/PlVLWso6PQ80SLDYFKGhjnpkF4yfToOG/0YN7fi9kfXz/yAC8x+LzSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn8IM4Ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn8IM4Ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA6FC4CEEB;
	Mon, 18 Aug 2025 13:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522042;
	bh=NfaKOmXzhphGVuuYUqFpJXo1ioc2sf07y0TEUEbjaOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn8IM4Chijhg0qRQMWWjwUTZDmR0hrHIct3mYHzv46+Mev7V87leBUA7sDPeEAXrK
	 j/QcpXKul6re5bMGT16RlRI0wAMbGgzbnkfgwG6Y2N/i4qSRH9tkkz8/XtJ/6t7ln/
	 XBt/w5VrTP1QYkd1T3JbWpX1KNMGOXoZmRVObHoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nam Cao <namcao@linutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/444] um: Re-evaluate thread flags repeatedly
Date: Mon, 18 Aug 2025 14:43:44 +0200
Message-ID: <20250818124456.289572932@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9c6cf03ed02b..eaeeedd62930 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -81,14 +81,18 @@ struct task_struct *__switch_to(struct task_struct *from, struct task_struct *to
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



