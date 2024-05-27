Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301C71667DB;
	Mon, 27 May 2024 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836465; cv=none; b=SCY1tp5rCjASWIPdIVrQt/G2bxwdlBAkdYZfybpneTUywQkbtY7Rq5zXmuJ9gIYFhjPI3IurdOqeQSk67nCE475+RJAoNWImv4ibLtNL/v2W7Bt4axqJAorS+2oSt3uESMxyx5LaJq4IrWNU4Vxs/NrU9mnULpIyIkVuhdDXIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836465; c=relaxed/simple;
	bh=pJ5gZKqeYoFzbOMXG9nmJOdX9hfraKN8jn1Sa71kxB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seE8lCRly1NljeiNjcrvr2d322QBVbrp37ndM3OtayYC5uIsaAbihCGTVQTEaTWxh+yAbujNWMwDInBsKXLvecQH4wt4fOVUHYm8LYDYvDd42PAejYAK8N5iODoRj0VyBDX+GWeVEpWd7n7+aryJLzf4PaVvVaUTvn/+DBo7R5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvxjlgF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvxjlgF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E8EC2BBFC;
	Mon, 27 May 2024 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836465;
	bh=pJ5gZKqeYoFzbOMXG9nmJOdX9hfraKN8jn1Sa71kxB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvxjlgF/GQTPpQslK6doM+FaEFcEIp7IctrEBqe6qcQWfw2dqErkjEdApGMtTF7Rd
	 5jckSuug+FOqVNMRz6o4omnyyG/c8znVHWJad3HHYTvByZnG96cBvQJtvwRocTOcPk
	 ew7BI9cK8kMjZo1TchLixbhg6uTPWZhvVcJNyRiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 064/427] io-wq: write next_work before dropping acct_lock
Date: Mon, 27 May 2024 20:51:51 +0200
Message-ID: <20240527185607.886725484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit 068c27e32e51e94e4a9eb30ae85f4097a3602980 ]

Commit 361aee450c6e ("io-wq: add intermediate work step between pending
list and active work") closed a race between a cancellation and the work
being removed from the wq for execution.  To ensure the request is
always reachable by the cancellation, we need to move it within the wq
lock, which also synchronizes the cancellation.  But commit
42abc95f05bf ("io-wq: decouple work_list protection from the big
wqe->lock") replaced the wq lock here and accidentally reintroduced the
race by releasing the acct_lock too early.

In other words:

        worker                |     cancellation
work = io_get_next_work()     |
raw_spin_unlock(&acct->lock); |
			      |
                              | io_acct_cancel_pending_work
                              | io_wq_worker_cancel()
worker->next_work = work

Using acct_lock is still enough since we synchronize on it on
io_acct_cancel_pending_work.

Fixes: 42abc95f05bf ("io-wq: decouple work_list protection from the big wqe->lock")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20240416021054.3940-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 522196dfb0ff5..318ed067dbf64 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -564,10 +564,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
 		if (work) {
-			__io_worker_busy(wq, worker);
-
 			/*
 			 * Make sure cancelation can find this, even before
 			 * it becomes the active work. That avoids a window
@@ -578,9 +575,15 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			raw_spin_lock(&worker->lock);
 			worker->next_work = work;
 			raw_spin_unlock(&worker->lock);
-		} else {
-			break;
 		}
+
+		raw_spin_unlock(&acct->lock);
+
+		if (!work)
+			break;
+
+		__io_worker_busy(wq, worker);
+
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
 
-- 
2.43.0



