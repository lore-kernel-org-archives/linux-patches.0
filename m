Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35316138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F8EC433EF;
	Tue,  3 Jan 2023 08:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733745;
	bh=lyrliJQSOV8XQYB1qNXDyEHxJsVSxRLvYk3RuJLbrD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ng97aOtKiUkp+RSlJI3nLUXV0oNpReLhK2E+atWIdsyVnSIMHhJc22iZ5/5FFsyGM
	 /nAxbJJ90WOA+ccvGr5sWVCbg2irM/dPCC+f18RClwCKkz94MEF1y6JJuin9efxqN5
	 fNQNiXG1WuGg9Q6US224P7L2E1YKWQtOGnwY7dJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-csky@vger.kernel.org,
	Guo Ren <guoren@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 29/63] csky: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:59 +0100
Message-Id: <20230103081310.330470070@linuxfoundation.org>
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

[ Upstream commit f3924d763c8af4c5d441b666c01f4de03ac9449e ]

Wire up TIF_NOTIFY_SIGNAL handling for csky.

Cc: linux-csky@vger.kernel.org
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/include/asm/thread_info.h |    5 ++++-
 arch/csky/kernel/signal.c           |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/csky/include/asm/thread_info.h
+++ b/arch/csky/include/asm/thread_info.h
@@ -64,6 +64,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_TRACE	4	/* syscall trace active */
 #define TIF_SYSCALL_TRACEPOINT	5       /* syscall tracepoint instrumentation */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_POLLING_NRFLAG	16	/* poll_idle() is TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18      /* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
@@ -75,6 +76,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
@@ -82,7 +84,8 @@ static inline struct thread_info *curren
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE | \
+				 _TIF_NOTIFY_SIGNAL)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP)
--- a/arch/csky/kernel/signal.c
+++ b/arch/csky/kernel/signal.c
@@ -261,7 +261,7 @@ asmlinkage void do_notify_resume(struct
 		uprobe_notify_resume(regs);
 
 	/* Handle pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {


