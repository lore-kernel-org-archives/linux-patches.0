Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C87E138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E73AC433EF;
	Tue,  3 Jan 2023 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733729;
	bh=J5e7O0O8iPEmHTzAk8tMEyAl6ywNl1X69dM6nO2IGHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq3HU+lYmJklsIUNFgck/YL4t7LDH9H2spcUJwu1aNANn/+w6xWJQsRr7srJumgbP
	 YQOAuC9hTjDwS4lGSCeDTFlaUjBAlWrNINKvzkwtWncAltO/cZ5RvOE57UD+9k6j1r
	 NPtObH6O9hz0hZwZJ504GRJarQAky81IlIRS0xXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-mips@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 24/63] mips: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:54 +0100
Message-Id: <20230103081310.018548519@linuxfoundation.org>
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

[ Upstream commit f45c184bce15f4a314c0210519bc3b4aab408838 ]

Wire up TIF_NOTIFY_SIGNAL handling for mips.

Cc: linux-mips@vger.kernel.org
Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/thread_info.h |    4 +++-
 arch/mips/kernel/signal.c           |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -115,6 +115,7 @@ static inline struct thread_info *curren
 #define TIF_SECCOMP		4	/* secure computing */
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_UPROBE		6	/* breakpointed or singlestepping */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -139,6 +140,7 @@ static inline struct thread_info *curren
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_UPROBE		(1<<TIF_UPROBE)
+#define _TIF_NOTIFY_SIGNAL	(1<<TIF_NOTIFY_SIGNAL)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_NOHZ		(1<<TIF_NOHZ)
 #define _TIF_FIXADE		(1<<TIF_FIXADE)
@@ -164,7 +166,7 @@ static inline struct thread_info *curren
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		\
 	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | _TIF_NOTIFY_RESUME |	\
-	 _TIF_UPROBE)
+	 _TIF_UPROBE | _TIF_NOTIFY_SIGNAL)
 /* work to do on any return to u-space */
 #define _TIF_ALLWORK_MASK	(_TIF_NOHZ | _TIF_WORK_MASK |		\
 				 _TIF_WORK_SYSCALL_EXIT |		\
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -903,7 +903,7 @@ asmlinkage void do_notify_resume(struct
 		uprobe_notify_resume(regs);
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {


