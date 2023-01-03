Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C2A138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830E7C433D2;
	Tue,  3 Jan 2023 08:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733724;
	bh=54lcWpF+12GAxUbD5FhfBUU9aVVa6z40nDeaFbT44MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+bmZF9/MRW8k9uXOCDoRSp6Jz1vJE8HDky+1bc8rwnH3RH01ItTzbY57iOsNYL2V
	 ZibYhm5kGJdUXPx4gYEucOX1kjNWGU8rMIiF6Jv5K2ejVJF61sgA7Ek/VbKbIzq8Sp
	 kA/oH5LcdZTuBeXITxA/zZ3iAbQDGaD48hk8Ipf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-parisc@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 22/63] parisc: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:52 +0100
Message-Id: <20230103081309.895547605@linuxfoundation.org>
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

[ Upstream commit 18cb3281285d2190c0605d2e53543802319bd1a1 ]

Wire up TIF_NOTIFY_SIGNAL handling for parisc.

Cc: linux-parisc@vger.kernel.org
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/thread_info.h |    4 +++-
 arch/parisc/kernel/signal.c           |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -52,6 +52,7 @@ struct thread_info {
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
+#define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 #define TIF_SINGLESTEP		9	/* single stepping? */
@@ -61,6 +62,7 @@ struct thread_info {
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
@@ -72,7 +74,7 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | \
-                                 _TIF_NEED_RESCHED)
+                                 _TIF_NEED_RESCHED | _TIF_NOTIFY_SIGNAL)
 #define _TIF_SYSCALL_TRACE_MASK (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP |	\
 				 _TIF_BLOCKSTEP | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT)
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -609,7 +609,8 @@ do_signal(struct pt_regs *regs, long in_
 
 void do_notify_resume(struct pt_regs *regs, long in_syscall)
 {
-	if (test_thread_flag(TIF_SIGPENDING))
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL))
 		do_signal(regs, in_syscall);
 
 	if (test_thread_flag(TIF_NOTIFY_RESUME))


