Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4957B138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42DDC433EF;
	Tue,  3 Jan 2023 08:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733785;
	bh=sDKNwB8V+ZhVA/Dt0dwWmeDaO6wgEBnjWBIXlkDfifE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIiQh81/w7xT6iIFQicVGfNjc4LWC699vSapuMz/P7TBUWC27kH3affjgDG23la5T
	 meGuCTH0hRyraOZ84opCa46WwkxXgB1ZGODUvMpP7JzVdC4D5RZreXp0MZAF0utGTe
	 Dy8f0OfsIGtBcP1hp7Q7ESN9qwdVKudltsY7325c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ley Foon Tan <ley.foon.tan@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 21/63] nios32: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:51 +0100
Message-Id: <20230103081309.834473894@linuxfoundation.org>
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

[ Upstream commit 42020064274c235d720d9c4b7d9a678b133e59cf ]

Wire up TIF_NOTIFY_SIGNAL handling for nios32.

Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Acked-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/include/asm/thread_info.h |    2 ++
 arch/nios2/kernel/signal.c           |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/nios2/include/asm/thread_info.h
+++ b/arch/nios2/include/asm/thread_info.h
@@ -86,6 +86,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_SECCOMP		5	/* secure computing */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
+#define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling
@@ -97,6 +98,7 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 
--- a/arch/nios2/kernel/signal.c
+++ b/arch/nios2/kernel/signal.c
@@ -309,7 +309,8 @@ asmlinkage int do_notify_resume(struct p
 	if (!user_mode(regs))
 		return 0;
 
-	if (test_thread_flag(TIF_SIGPENDING)) {
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL)) {
 		int restart = do_signal(regs);
 
 		if (unlikely(restart)) {


