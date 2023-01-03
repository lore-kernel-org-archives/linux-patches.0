Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4565C138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA23C433EF;
	Tue,  3 Jan 2023 08:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733765;
	bh=G4YkfGzwE9j8vy/+YFxtfyJXJjLzyj/9Znckcg4USSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q33vZ7PU7EysINg1VSElh0TostNyaEv6rs+kW6hnGUnTGCZt1zHR+pHSEiM/xiQHB
	 6OYlCUHWyO38VtfcNjUdfbCyzluDiSWiWpgtvkOxf98H9DbRAVsXvuqBl8+BL8dXbC
	 5B58AvvjXeHfCl0o+EEkB/YLFf/FRl3bRdWLMSlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-c6x-dev@linux-c6x.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 35/63] c6x: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:14:05 +0100
Message-Id: <20230103081310.682573691@linuxfoundation.org>
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

[ Upstream commit 6d665a4d8b4264def0fbb72da3a500d9904ffe3e ]

Wire up TIF_NOTIFY_SIGNAL handling for c6x.

Cc: linux-c6x-dev@linux-c6x.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/c6x/include/asm/thread_info.h |    1 +
 arch/c6x/kernel/asm-offsets.c      |    1 +
 arch/c6x/kernel/signal.c           |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -82,6 +82,7 @@ struct thread_info *current_thread_info(
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_NOTIFY_SIGNAL	5	/* signal notifications exist */
 
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 
--- a/arch/c6x/kernel/asm-offsets.c
+++ b/arch/c6x/kernel/asm-offsets.c
@@ -116,6 +116,7 @@ void foo(void)
 	DEFINE(_TIF_NOTIFY_RESUME, (1<<TIF_NOTIFY_RESUME));
 	DEFINE(_TIF_SIGPENDING, (1<<TIF_SIGPENDING));
 	DEFINE(_TIF_NEED_RESCHED, (1<<TIF_NEED_RESCHED));
+	DEFINE(_TIF_NOTIFY_SIGNAL, (1<<TIF_NOTIFY_SIGNAL));
 
 	DEFINE(_TIF_ALLWORK_MASK, TIF_ALLWORK_MASK);
 	DEFINE(_TIF_WORK_MASK, TIF_WORK_MASK);
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/syscalls.h>
 #include <linux/tracehook.h>
 
+#include <asm/asm-offsets.h>
 #include <asm/ucontext.h>
 #include <asm/cacheflush.h>
 
@@ -313,7 +314,7 @@ asmlinkage void do_notify_resume(struct
 				 int syscall)
 {
 	/* deal with pending signal delivery */
-	if (thread_info_flags & (1 << TIF_SIGPENDING))
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs, syscall);
 
 	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME))


