Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433E847A57;
	Mon,  1 Apr 2024 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988223; cv=none; b=g6XYAWigvJI/hQlJEer6QdO1N2iu9ZEtSooojrxyp27Z7Q5Pqr0J8PUNpv0z1EnQrWfD6sew4IFhby+7tUjTSGml8qK37LvykLjRxeTHpdu+E5Wv2R/F6vP9KesjMzsBpAfN7Hg5lDM2r7RIPey8LxOcxrVL/aaXcX+CvkqlYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988223; c=relaxed/simple;
	bh=SEiKmy30zqQ89WLj2mRjpxkCIfoorfa/ROp/VPNMkB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usRi9s+hKF2VB/XprBFSMD2VRVwYo4MmjFRPxWoZO8LWNAje0KU97sc9T/yGqOYqqTn71R1J+7mld3Yp3Wyn8IW/PFSuWgRLI6J6yQoIswp8va4SzTqK/WSIwUfDUCRTnFTEqTSie5Swp7a4xHfMh10kdcbJpEvcJq83GvGn3Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lv5h+Pm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv5h+Pm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6902BC43390;
	Mon,  1 Apr 2024 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988222;
	bh=SEiKmy30zqQ89WLj2mRjpxkCIfoorfa/ROp/VPNMkB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lv5h+Pm69/PIrq+FTHdbEoy4ATtxpZCZUOGD7aLQqpY0XxDWvjHQUG39fykm06VdI
	 fXTxPkPOya5DCgAF2zhjBYueUm8mC1aKpBmru40jIka5jDOCLGNTVk3Iw2VM6o0gRz
	 6ntwR7Uh63B9BHYhLcW36TR2zKQJROGN8OpFz504=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 120/432] io_uring: fix io_queue_proc modifying req->flags
Date: Mon,  1 Apr 2024 17:41:47 +0200
Message-ID: <20240401152556.702650135@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1a8ec63b2b6c91caec87d4e132b1f71b5df342be ]

With multiple poll entries __io_queue_proc() might be running in
parallel with poll handlers and possibly task_work, we should not be
carelessly modifying req->flags there. io_poll_double_prepare() handles
a similar case with locking but it's much easier to move it into
__io_arm_poll_handler().

Cc: stable@vger.kernel.org
Fixes: 595e52284d24a ("io_uring/poll: don't enable lazy wake for POLLEXCLUSIVE")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/455cc49e38cf32026fa1b49670be8c162c2cb583.1709834755.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 58b7556f621eb..c6f4789623cb2 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -539,14 +539,6 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 	poll->wait.private = (void *) wqe_private;
 
 	if (poll->events & EPOLLEXCLUSIVE) {
-		/*
-		 * Exclusive waits may only wake a limited amount of entries
-		 * rather than all of them, this may interfere with lazy
-		 * wake if someone does wait(events > 1). Ensure we don't do
-		 * lazy wake for those, as we need to process each one as they
-		 * come in.
-		 */
-		req->flags |= REQ_F_POLL_NO_LAZY;
 		add_wait_queue_exclusive(head, &poll->wait);
 	} else {
 		add_wait_queue(head, &poll->wait);
@@ -618,6 +610,17 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		req->flags &= ~REQ_F_HASH_LOCKED;
 
+
+	/*
+	 * Exclusive waits may only wake a limited amount of entries
+	 * rather than all of them, this may interfere with lazy
+	 * wake if someone does wait(events > 1). Ensure we don't do
+	 * lazy wake for those, as we need to process each one as they
+	 * come in.
+	 */
+	if (poll->events & EPOLLEXCLUSIVE)
+		req->flags |= REQ_F_POLL_NO_LAZY;
+
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	if (unlikely(ipt->error || !ipt->nr_entries)) {
-- 
2.43.0



