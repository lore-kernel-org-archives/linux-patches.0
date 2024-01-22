Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F0855C09;
	Tue, 23 Jan 2024 00:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969793; cv=none; b=Mg9LSs7AjTE59AEWEd/4uSyDuAdHZ0JeKZTNVsL6i3MuGimxobXCdWyhajdcu+Jd+AfyI18lugDv9pU8lDr0rS4esM8j3sYdACMgViLw2cb4adrp6H0kwjfwHpTsErV3y4SXFH7lT4ZfZgV1F3oQBmBrbEPzuy1pMZNTaA2M6gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969793; c=relaxed/simple;
	bh=ehuUdVFZUNUzyGUhlAxSUe/btKUoehXcQm5XJX/K/5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okXpt9PkzYc2QmR6vkkzTvYjYFjRcS4abHNbtdP6YqulPE6JMTPjKGdeOijvZhOZpLds1Hh5p+jG2c2HQPuPp4qusBUp+KfoQVhx2XZvckcfR/sNSmFnwL7TARzCgOci9K/BcpbL3ebRE+9kbQrL0+5RCPZAeF4TkM8oNhZ21Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfUR3z+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfUR3z+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6371AC433F1;
	Tue, 23 Jan 2024 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969793;
	bh=ehuUdVFZUNUzyGUhlAxSUe/btKUoehXcQm5XJX/K/5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfUR3z+7sD7XHtP82/Yngt9Xhsc7IjRy/wwwI2RNcA7PcEnijcFVsIrgqCCohTjra
	 CBdqPpJiGfFbbxk92TBaFCN1M/jvfj+r9ktHy6EI95bRaQgRmTTdNUQYzymwXf8la9
	 lJnyhzGiOX87S0miNcVicbT0sM51QqebK+LDa42E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 429/641] io_uring: ensure local task_work is run on wait timeout
Date: Mon, 22 Jan 2024 15:55:33 -0800
Message-ID: <20240122235831.418091993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 6ff1407e24e6fdfa4a16ba9ba551e3d253a26391 upstream.

A previous commit added an earlier break condition here, which is fine if
we're using non-local task_work as it'll be run on return to userspace.
However, if DEFER_TASKRUN is used, then we could be leaving local
task_work that is ready to process in the ctx list until next time that
we enter the kernel to wait for events.

Move the break condition to _after_ we have run task_work.

Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2637,8 +2637,6 @@ static int io_cqring_wait(struct io_ring
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, 0);
 
-		if (ret < 0)
-			break;
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2648,6 +2646,18 @@ static int io_cqring_wait(struct io_ring
 		if (!llist_empty(&ctx->work_llist))
 			io_run_local_work(ctx);
 
+		/*
+		 * Non-local task_work will be run on exit to userspace, but
+		 * if we're using DEFER_TASKRUN, then we could have waited
+		 * with a timeout for a number of requests. If the timeout
+		 * hits, we could have some requests ready to process. Ensure
+		 * this break is _after_ we have run task_work, to avoid
+		 * deferring running potentially pending requests until the
+		 * next time we wait for events.
+		 */
+		if (ret < 0)
+			break;
+
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */


