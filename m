Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323E20E4
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8DDC433F0;
	Tue,  3 Jan 2023 08:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733842;
	bh=NSeTGuu9jxbF8jrNYEFoO8mXqWTUINIqDZm/DcWDZh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c0I3ASKGQrdJxl5qkRmFEkHAjkSpQcUD35TXr5NShzcqc7Q6QS0dr9WZJhWtsD2S
	 ak1ao9t8+0nSPORBNrbmh0AoyknkVTP7rnsoTJkShOkK68diqU3bS53nhB+AQ3P7ho
	 HFUWZ2o630kGZRHa4q3xB6AEJL7KFfQXdVP5ks/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sparclinux@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 40/63] sparc: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:14:10 +0100
Message-Id: <20230103081310.985156291@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f50a7052f5e70ee7a6a5e2ed08660994dc3df2a5 ]

Wire up TIF_NOTIFY_SIGNAL handling for sparc.

Cc: sparclinux@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/thread_info_32.h |    4 +++-
 arch/sparc/include/asm/thread_info_64.h |    6 ++++--
 arch/sparc/kernel/signal_32.c           |    2 +-
 arch/sparc/kernel/signal_64.c           |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -104,6 +104,7 @@ register struct thread_info *current_thr
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
@@ -115,11 +116,12 @@ register struct thread_info *current_thr
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
-					 _TIF_SIGPENDING)
+					 _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)
 
 #define is_32bit_task()	(1)
 
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -180,7 +180,7 @@ extern struct thread_info *current_threa
 #define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-/* flag bit 4 is available */
+#define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
 #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
 #define TIF_UPROBE		6	/* breakpointed or singlestepped */
 #define TIF_32BIT		7	/* 32-bit binary */
@@ -200,6 +200,7 @@ extern struct thread_info *current_threa
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_UPROBE		(1<<TIF_UPROBE)
 #define _TIF_32BIT		(1<<TIF_32BIT)
@@ -213,7 +214,8 @@ extern struct thread_info *current_threa
 				 _TIF_DO_NOTIFY_RESUME_MASK | \
 				 _TIF_NEED_RESCHED)
 #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
-					 _TIF_SIGPENDING | _TIF_UPROBE)
+					 _TIF_SIGPENDING | _TIF_UPROBE | \
+					 _TIF_NOTIFY_SIGNAL)
 
 #define is_32bit_task()	(test_thread_flag(TIF_32BIT))
 
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -521,7 +521,7 @@ static void do_signal(struct pt_regs *re
 void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0,
 		      unsigned long thread_info_flags)
 {
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs, orig_i0);
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -549,7 +549,7 @@ void do_notify_resume(struct pt_regs *re
 	user_exit();
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs, orig_i0);
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);


