Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AEB1A76B2;
	Tue, 30 Jul 2024 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360198; cv=none; b=YGAR/JETCHyGoHsX86o3+i0/T33eLO8k9IxryDwV3tP6+kpblS7+78Wvnpla1wPSe7d6vZyx0YJTppNlvJ5UmbxCAJGdQyz0kstZYvzyj8kbX5v+yLizEa34rKJEdjAM88udZGVg4hBk4dr7I82sYSYzXQzrd2+FVn4HQB/I0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360198; c=relaxed/simple;
	bh=nsILxJorgQ3A8juMOUSMswkmmlrga2tbe31jKX1lJ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT5K2Fojh8XVXX/rZsQh1Y2LlngTUOWfl/GXlAMPPrqhjXsCxWyi2b3hXDqA8X9QXD3qSBG+u4+fcA9OoQjImvwrOCuDCAjrlJm0uYf2E6tgJ7NeSBh4f2cjl+ZaAznrZTkGjbC46YJ3kLZErA4qm7Iq7v6evHjD22z1XztF5CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I9qnZrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I9qnZrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9017EC4AF0C;
	Tue, 30 Jul 2024 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360198;
	bh=nsILxJorgQ3A8juMOUSMswkmmlrga2tbe31jKX1lJ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I9qnZrj7iUQYFWCf7z7p1kabzRaayrIP228HaCua/fn3wkGySRCPGHbYPctrgMw7
	 uEGJor3vln3FpVKi7+HuEjTz3B3n32gGGAuGhn3ZiFcNx++slSBWyPRyAK4GbZi8oa
	 IzA3XHbO7D4oqumpxtatD9B9j7lYInP1nJQSuq0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 595/809] io_uring: tighten task exit cancellations
Date: Tue, 30 Jul 2024 17:47:51 +0200
Message-ID: <20240730151748.331319504@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f8b632e89a101dae349a7b212c1771d7925f441b upstream.

io_uring_cancel_generic() should retry if any state changes like a
request is completed, however in case of a task exit it only goes for
another loop and avoids schedule() if any tracked (i.e. REQ_F_INFLIGHT)
request got completed.

Let's assume we have a non-tracked request executing in iowq and a
tracked request linked to it. Let's also assume
io_uring_cancel_generic() fails to find and cancel the request, i.e.
via io_run_local_work(), which may happen as io-wq has gaps.
Next, the request logically completes, io-wq still hold a ref but queues
it for completion via tw, which happens in
io_uring_try_cancel_requests(). After, right before prepare_to_wait()
io-wq puts the request, grabs the linked one and tries executes it, e.g.
arms polling. Finally the cancellation loop calls prepare_to_wait(),
there are no tw to run, no tracked request was completed, so the
tctx_inflight() check passes and the task is put to indefinite sleep.

Cc: stable@vger.kernel.org
Fixes: 3f48cf18f886c ("io_uring: unify files and task cancel")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/acac7311f4e02ce3c43293f8f1fda9c705d158f1.1721819383.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3071,8 +3071,11 @@ __cold void io_uring_cancel_generic(bool
 		bool loop = false;
 
 		io_uring_drop_tctx_refs(current);
+		if (!tctx_inflight(tctx, !cancel_all))
+			break;
+
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !cancel_all);
+		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
 


