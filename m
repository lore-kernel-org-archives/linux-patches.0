Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDA0611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02EAC433EF;
	Sun, 28 May 2023 19:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302507;
	bh=flPL4luW8zfjelwvdH6QQgjPHY40QA2KVGn1eQdynLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDRBUa9JTcrZfDdwpdxme+PDhXH7xVwZXWuRHzt9PQVhjTFDfJQt1KV+83BU0CYeV
	 yFwFXZ7K7V2XunnJ4jv7/FhOrDaUevQooe29//iWl16XrwQtUcXxULrktg5coPInWf
	 oVn65Ypc2aX22qAshZaJoXWESzTAtYOcKuxMWSQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 6.1 030/119] xtensa: fix signal delivery to FDPIC process
Date: Sun, 28 May 2023 20:10:30 +0100
Message-Id: <20230528190836.348276158@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Filippov <jcmvbkbc@gmail.com>

commit 9c2cc74fb31ec76b8b118c97041a6a154a3ff219 upstream.

Fetch function descriptor pointed to by the signal handler pointer from
userspace on signal delivery and function pointer pointed to by the
sa_restorer on return from the signal handler.

Cc: stable@vger.kernel.org
Fixes: e3ddb8bbe0f8 ("xtensa: add FDPIC and static PIE support for noMMU")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/signal.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 876d5df157ed..5c01d7e70d90 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -343,7 +343,19 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	struct rt_sigframe *frame;
 	int err = 0, sig = ksig->sig;
 	unsigned long sp, ra, tp, ps;
+	unsigned long handler = (unsigned long)ksig->ka.sa.sa_handler;
+	unsigned long handler_fdpic_GOT = 0;
 	unsigned int base;
+	bool fdpic = IS_ENABLED(CONFIG_BINFMT_ELF_FDPIC) &&
+		(current->personality & FDPIC_FUNCPTRS);
+
+	if (fdpic) {
+		unsigned long __user *fdpic_func_desc =
+			(unsigned long __user *)handler;
+		if (__get_user(handler, &fdpic_func_desc[0]) ||
+		    __get_user(handler_fdpic_GOT, &fdpic_func_desc[1]))
+			return -EFAULT;
+	}
 
 	sp = regs->areg[1];
 
@@ -373,20 +385,26 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
-		ra = (unsigned long)ksig->ka.sa.sa_restorer;
+		if (fdpic) {
+			unsigned long __user *fdpic_func_desc =
+				(unsigned long __user *)ksig->ka.sa.sa_restorer;
+
+			err |= __get_user(ra, fdpic_func_desc);
+		} else {
+			ra = (unsigned long)ksig->ka.sa.sa_restorer;
+		}
 	} else {
 
 		/* Create sys_rt_sigreturn syscall in stack frame */
 
 		err |= gen_return_code(frame->retcode);
-
-		if (err) {
-			return -EFAULT;
-		}
 		ra = (unsigned long) frame->retcode;
 	}
 
-	/* 
+	if (err)
+		return -EFAULT;
+
+	/*
 	 * Create signal handler execution context.
 	 * Return context not modified until this point.
 	 */
@@ -394,8 +412,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	/* Set up registers for signal handler; preserve the threadptr */
 	tp = regs->threadptr;
 	ps = regs->ps;
-	start_thread(regs, (unsigned long) ksig->ka.sa.sa_handler,
-		     (unsigned long) frame);
+	start_thread(regs, handler, (unsigned long)frame);
 
 	/* Set up a stack frame for a call4 if userspace uses windowed ABI */
 	if (ps & PS_WOE_MASK) {
@@ -413,6 +430,8 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	regs->areg[base + 4] = (unsigned long) &frame->uc;
 	regs->threadptr = tp;
 	regs->ps = ps;
+	if (fdpic)
+		regs->areg[base + 11] = handler_fdpic_GOT;
 
 	pr_debug("SIG rt deliver (%s:%d): signal=%d sp=%p pc=%08lx\n",
 		 current->comm, current->pid, sig, frame, regs->pc);
-- 
2.40.1



