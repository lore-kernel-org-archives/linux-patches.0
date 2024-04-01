Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8687217552;
	Mon,  1 Apr 2024 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987115; cv=none; b=VugdtCNhpWD1r9KH9hMmz/97wK0YaME78nLeSlkKHx68EMOu8IrSs+ivArTz+v6v5SWA1oK1pMpr6EWr9CIHtO59yJ5nL8mFaOc6jRjCVIhG/jJeph4hYqPslQQlB43xboUN5naI+6kR3tpQeAJMFEJQgx7Fgm6CCJTdDYzqJTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987115; c=relaxed/simple;
	bh=aM1JnHftYVKHzYovPRU7YJF9oUtzrCYbEL7SOQwmCjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bahIF+lygyGRlp/cd40tBjDT5ZODnHjxzQyaHTV09vKJNyF0tCC6uC0Ck7ysN3bf8/nv56efDNfLkJ+ty7RDXK+WKHY8PPyZrtDqPGJZt4O135Au+UkO1zWlBCvVCzdFAeCcQXGkVXT91zK88+LK8cPUSzvlwmvPLoHcV7K1XsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10NB0+sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10NB0+sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B60CC433F1;
	Mon,  1 Apr 2024 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987115;
	bh=aM1JnHftYVKHzYovPRU7YJF9oUtzrCYbEL7SOQwmCjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10NB0+sV5U2mLUH9/iJQ87mgloxrtaIoSCp8+fz4PVl+0reDcKEQyvKEWCNuGobhd
	 W8Vni8pIdlYEx1BiWBPCnVC9UCA+fH7CSE2weML6tzjof2adv+gkdioLZowApiFtjB
	 jyQNP/D/zFOmWnnNKt9c464VTpQm4gHYyntjjARo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 188/399] io_uring/waitid: always remove waitid entry for cancel all
Date: Mon,  1 Apr 2024 17:42:34 +0200
Message-ID: <20240401152554.787497010@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 2b35b8b43e07b1a6f06fdd84cf4b9eb24785896d ]

We know the request is either being removed, or already in the process of
being removed through task_work, so we can delete it from our waitid list
upfront. This is important for remove all conditions, as we otherwise
will find it multiple times and prevent cancelation progress.

Remove the dead check in cancelation as well for the hash_node being
empty or not. We already have a waitid reference check for ownership,
so we don't need to check the list too.

Cc: stable@vger.kernel.org
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6f851978606d9..77d340666cb95 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -125,12 +125,6 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	/*
-	 * Did cancel find it meanwhile?
-	 */
-	if (hlist_unhashed(&req->hash_node))
-		return;
-
 	hlist_del_init(&req->hash_node);
 
 	ret = io_waitid_finish(req, ret);
@@ -202,6 +196,7 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
+		hlist_del_init(&req->hash_node);
 		__io_waitid_cancel(ctx, req);
 		found = true;
 	}
-- 
2.43.0



