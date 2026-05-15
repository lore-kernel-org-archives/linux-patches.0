Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA123B4EAF;
	Fri, 15 May 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861463; cv=none; b=NbVUZ1knsXtM4AHK91xdtSZHWKpNyQH3EgDC0cuGcsM64F6km6N/z9+Hl4qa2XwgiU+WpH3JDVibtCTrWqRdr6GEbdmzFx8aZEoi/8UqIRejmM3FkzCRTxCFFVYf/y0FdHM50PuuhgoGSf9Z/FsKQBwG3piGqeGPY3iIXtAqW2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861463; c=relaxed/simple;
	bh=AbQNFx/HTaXhQknYSam5IIFsnVZvcTza13Ul4VHuTPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7/B8NRYW0sov8a43o2tYR9i5FXsT0GuNHpWSSOO1ol63OpV1uNdR2HfyNO+jcIOKHERjFV7vSschWSIE7HQGMkPZq+equqzMANFofOGIpCh5h/cOkG5qmcdCj5y4/yBKBxWvPcS5xyl+tFXyPIWvNl0m+ml7mLTk/+WFYIKTtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABfJXjAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABfJXjAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C7C2BCB0;
	Fri, 15 May 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861462;
	bh=AbQNFx/HTaXhQknYSam5IIFsnVZvcTza13Ul4VHuTPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABfJXjAzLhUkh3W8HTrcWcc6LnchWdYeI9dzdUN5tz6AUCOPbys1K254F6UG/kW10
	 c06JUjD6E4GhV9gKe76g90NUG+LAnWqsOF+uc8ry0k5bbmT8DfzDQzLfJPJaj/voWw
	 edyxH/GeWOAccm8eD13n+r4mZushaWeez2ngijPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anhad Jai Singh <ffledgling@meta.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chris Mason <clm@fb.com>,
	Rik van Riel <riel@surriel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 6.6 296/474] exit: Sleep at TASK_IDLE when waiting for application core dump
Date: Fri, 15 May 2026 17:46:45 +0200
Message-ID: <20260515154721.405634602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit b8e753128ed074fcb48e9ceded940752f6b1c19f upstream.

Currently, the coredump_task_exit() function sets the task state
to TASK_UNINTERRUPTIBLE|TASK_FREEZABLE, which usually works well.
But a combination of large memory and slow (and/or highly contended)
mass storage can cause application core dumps to take more than
two minutes, which can cause check_hung_task(), which is invoked by
check_hung_uninterruptible_tasks(), to produce task-blocked splats.
There does not seem to be any reasonable benefit to getting these splats.

Furthermore, as Oleg Nesterov points out, TASK_UNINTERRUPTIBLE could
be misleading because the task sleeping in coredump_task_exit() really
is killable, albeit indirectly.  See the check of signal->core_state
in prepare_signal() and the check of fatal_signal_pending()
in dump_interrupted(), which bypass the normal unkillability of
TASK_UNINTERRUPTIBLE, resulting in coredump_finish() invoking
wake_up_process() on any threads sleeping in coredump_task_exit().

Therefore, change that TASK_UNINTERRUPTIBLE to TASK_IDLE.

Reported-by: Anhad Jai Singh <ffledgling@meta.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -430,7 +430,7 @@ static void coredump_task_exit(struct ta
 			complete(&core_state->startup);
 
 		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE|TASK_FREEZABLE);
+			set_current_state(TASK_IDLE|TASK_FREEZABLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
 			schedule();


