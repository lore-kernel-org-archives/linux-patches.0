Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B128138E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF11C433D2;
	Tue,  3 Jan 2023 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733735;
	bh=aHWCsL7Yk7DECg3q0Lq6MKlwgwnQsz0WYbGfOt60hto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBUDqulvEgPg7Fu1NCRxfQiPrPoUMG3/BcAKLmo8FKXu/HjsRS7aZyJIY3K4dwOEp
	 XAvZy7BNlTZOVYD9y/B4vyq3jNgDqlVTS2Hvm8a9gCQBofchXuM+FRXxM7s5UvkUuw
	 IUDGE8xd0m9j+6Hlla02AcjZsiUqozPgtcfGYhfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-um@lists.infradead.org,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 26/63] um: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:13:56 +0100
Message-Id: <20230103081310.149506483@linuxfoundation.org>
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

[ Upstream commit a5b3cd32ff238b87e94d47b927aff117e22d13c0 ]

Wire up TIF_NOTIFY_SIGNAL handling for um.

Cc: linux-um@lists.infradead.org
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/thread_info.h |    2 ++
 arch/um/kernel/process.c          |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -57,6 +57,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_NOTIFY_SIGNAL	3	/* signal notifications exist */
 #define TIF_RESTART_BLOCK	4
 #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	6
@@ -68,6 +69,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -99,7 +99,8 @@ void interrupt_end(void)
 
 	if (need_resched())
 		schedule();
-	if (test_thread_flag(TIF_SIGPENDING))
+	if (test_thread_flag(TIF_SIGPENDING) ||
+	    test_thread_flag(TIF_NOTIFY_SIGNAL))
 		do_signal(regs);
 	if (test_thread_flag(TIF_NOTIFY_RESUME))
 		tracehook_notify_resume(regs);


