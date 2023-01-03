Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A8138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6C3C433EF;
	Tue,  3 Jan 2023 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733747;
	bh=lVkhJSuC3IowY6x05isk2+fmIZYOlISTPGIA+JFIPO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUMF+1uI4I/GMUYDhyB+Hngtoe3vxWxcab3114NIWjO1ReXzkoFNOziz6A29kmpbt
	 e3hX0n4IJ5qJX0uPKL5jRcX8tDDXMGF6cwMzX75k2oQZ/PmQZ9+wJWYro17iJ7lW3c
	 RxLSVxDwJRlLKRnRELdrZfCYjTVxl0Dv0GpZ2Bzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hexagon@vger.kernel.org,
	Brian Cain <bcain@codeaurora.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 30/63] hexagon: add support for TIF_NOTIFY_SIGNAL
Date: Tue,  3 Jan 2023 09:14:00 +0100
Message-Id: <20230103081310.386730622@linuxfoundation.org>
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

[ Upstream commit aeec8193578a71d0aee21218351849d38121ce90 ]

Wire up TIF_NOTIFY_SIGNAL handling for hexagon.

Cc: linux-hexagon@vger.kernel.org
Acked-by: Brian Cain <bcain@codeaurora.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/include/asm/thread_info.h |    2 ++
 arch/hexagon/kernel/process.c          |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -95,6 +95,7 @@ register struct thread_info *__current_t
 #define TIF_NEED_RESCHED        3       /* rescheduling necessary */
 #define TIF_SINGLESTEP          4       /* restore ss @ return to usr mode */
 #define TIF_RESTORE_SIGMASK     6       /* restore sig mask in do_signal() */
+#define TIF_NOTIFY_SIGNAL	7       /* signal notifications exist */
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE              17      /* OOM killer killed process */
 
@@ -103,6 +104,7 @@ register struct thread_info *__current_t
 #define _TIF_SIGPENDING         (1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED       (1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP         (1 << TIF_SINGLESTEP)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 
 /* work to do on interrupt/exception return - All but TIF_SYSCALL_TRACE */
 #define _TIF_WORK_MASK          (0x0000FFFF & ~_TIF_SYSCALL_TRACE)
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -174,7 +174,7 @@ int do_work_pending(struct pt_regs *regs
 		return 1;
 	}
 
-	if (thread_info_flags & _TIF_SIGPENDING) {
+	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
 		do_signal(regs);
 		return 1;
 	}


