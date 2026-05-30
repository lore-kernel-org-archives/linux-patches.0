Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73BE2690D5;
	Sat, 30 May 2026 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160604; cv=none; b=Vj9bIAwEz/WwqhmLZTFfC3N9JxyzETdz8t+k2K8idkFn8HpKvX11BOHilxqlTPg4z+kKHs4hdYePxFlkDG+Ucu3LnuSMlXSxLE7MZZXn7+2ZahbL4vcPbeJlPmCaUPtCyn1XGdMAcxzLS41p2ns4t4Yb0LY2QbfQnvpXC0dlUz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160604; c=relaxed/simple;
	bh=5smW3AUTriTzxkQr8QWB5pVi47Z//lt1MvCd5pwxcqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfR1y+r652UvbL58P+gTIwcG+YOK+arOMj3gGML2QJL51hJSBqEFhu3inzhikfvjV3+pAYqMYuy0hh+6hKZoSn4Gci9ZbAZMt0VQEL//KLyva7a+v7o8zd6q1jomdB+zD5TijQyu4f9ajUTSfRsU4DCE98LZHCUdR91TFZ8y5G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onL5xS3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onL5xS3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322081F00898;
	Sat, 30 May 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160603;
	bh=AWepjDBwCRfskCTDOJTXRpsziBSJZsxzj9hvhqWNC/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onL5xS3suxweIyWoDRttTaQNJYUY/3jHbym3uwGkX2lcoMOb9DyHqlGOC+uJPYuo1
	 m0xGlgFBhbopwsSVo8kSrwq94S3QO4j8PT0tctNHtQl/hzMl61o44vV80Dxd+HPSEX
	 iP3cOa77Xde5WtFjqiEvYG4M3aFlSnnklPou5j7Y=
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
Subject: [PATCH 6.1 383/969] exit: Sleep at TASK_IDLE when waiting for application core dump
Date: Sat, 30 May 2026 17:58:27 +0200
Message-ID: <20260530160310.874631722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -426,7 +426,7 @@ static void coredump_task_exit(struct ta
 			complete(&core_state->startup);
 
 		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE|TASK_FREEZABLE);
+			set_current_state(TASK_IDLE|TASK_FREEZABLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
 			schedule();


