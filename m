Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEEF138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9C9C433F0;
	Tue,  3 Jan 2023 08:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733750;
	bh=PNq6pVEUdxKsdZFSUDm/36i48QCfKTRg6NlQTCHtVGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clgA9Hnpo43+Lrcueb+sw2loYDbNn95slU9QR82S76CiC8gX90kxO3QFoxtjkih9j
	 VFoEtxpiQlt6jXoVloxuoiKmy93qMAxIBVEjMN/yUhNMN17qHwp+mA9pLrJUcrHUbf
	 bggjtFSxvO0s3xaJqH+J4quenqElxXWXpevJhz94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@xilinx.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 31/63] microblaze: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:14:01 +0100
Message-Id: <20230103081310.441051189@linuxfoundation.org>
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

[ Upstream commit f4ea089e429e0d366cd1a34a2cbe3c7b13d98d75 ]

Wire up TIF_NOTIFY_SIGNAL handling for microblaze.

Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/microblaze/include/asm/thread_info.h |    2 ++
 arch/microblaze/kernel/signal.c           |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -107,6 +107,7 @@ static inline struct thread_info *curren
 #define TIF_NEED_RESCHED	3 /* rescheduling necessary */
 /* restore singlestep on return to user mode */
 #define TIF_SINGLESTEP		4
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 #define TIF_MEMDIE		6	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	9       /* syscall auditing active */
 #define TIF_SECCOMP		10      /* secure computing */
@@ -119,6 +120,7 @@ static inline struct thread_info *curren
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -313,7 +313,8 @@ static void do_signal(struct pt_regs *re
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, int in_syscall)
 {
-	if (test_thread_flag(TIF_SIGPENDING))
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL))
 		do_signal(regs, in_syscall);
 
 	if (test_thread_flag(TIF_NOTIFY_RESUME))


