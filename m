Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F4138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6A0C433EF;
	Tue,  3 Jan 2023 08:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733776;
	bh=vil6BYasED75jkWjAbJEHnhmMUqKl6TcRjI4ZiApwMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiDSU32rKc1XBuc+PTG4wRyz2OcdsWNFlICQYrrE6wEIXWUwYRoTFrxlxFT4hwsi0
	 FEhAN5Y/gat2ZpBAmjnDkGhwFOVgW1P0uReCpK8SwnZmFXVLb2qUIjXFQ6AzDFYff+
	 qj9s/2KRQ0/2B1gEFVoiVBEC0sFVTfppHyW2dZd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-snps-arc@lists.infradead.org,
	Vineet Gupta <vgupta@synopsys.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 18/63] arc: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:48 +0100
Message-Id: <20230103081309.660230284@linuxfoundation.org>
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

[ Upstream commit 53855e12588743ea128ee31f913d1c6e2f1d32c8 ]

Wire up TIF_NOTIFY_SIGNAL handling for arc.

Cc: linux-snps-arc@lists.infradead.org
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/include/asm/thread_info.h |    4 +++-
 arch/arc/kernel/entry.S            |    3 ++-
 arch/arc/kernel/signal.c           |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -79,6 +79,7 @@ static inline __attribute_const__ struct
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -89,11 +90,12 @@ static inline __attribute_const__ struct
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME)
+				 _TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL)
 
 /*
  * _TIF_ALLWORK_MASK includes SYSCALL_TRACE, but we don't need it.
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -308,7 +308,8 @@ resume_user_mode_begin:
 	mov r0, sp	; pt_regs for arg to do_signal()/do_notify_resume()
 
 	GET_CURR_THR_INFO_FLAGS   r9
-	bbit0  r9, TIF_SIGPENDING, .Lchk_notify_resume
+	and.f  0,  r9, TIF_SIGPENDING|TIF_NOTIFY_SIGNAL
+	bz .Lchk_notify_resume
 
 	; Normal Trap/IRQ entry only saves Scratch (caller-saved) regs
 	; in pt_reg since the "C" ABI (kernel code) will automatically
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -405,7 +405,7 @@ void do_signal(struct pt_regs *regs)
 
 	restart_scall = in_syscall(regs) && syscall_restartable(regs);
 
-	if (get_signal(&ksig)) {
+	if (test_thread_flag(TIF_SIGPENDING) && get_signal(&ksig)) {
 		if (restart_scall) {
 			arc_restart_syscall(&ksig.ka, regs);
 			syscall_wont_restart(regs);	/* No more restarts */


