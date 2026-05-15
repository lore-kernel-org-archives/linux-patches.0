Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F413C0A13;
	Fri, 15 May 2026 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861004; cv=none; b=OpEfCFzlAvoGjIRXLjtuQVyzuDSPCFQWwEuHWV5CiRT1ZWyfUX/2S2Gb7klCKipiw6QMcF4CMFfgCxoz9M/ZiWALjuorgo1Ov8wPKTDgIkR9Gsf0HTPxNDn2qWIt8pXWNN7CjaWLGj0gGJpx9GBz+r5lVGnmM8HBVRecT/uVOLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861004; c=relaxed/simple;
	bh=C62e9avq40rRAJm9iSEi6Ix1b4G8/yEa4cAZeRMM664=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuGNpQUmL74ItjJEb5FpxnkrZn+Ysrf3YYEbz26z9NuyRuDcPdQ/Lg5WEzF0H15xw3QGfes/qro5QbBMxS72lQCsw/y7XR2ZU2MGesioPu3kZvOQcSQ3XuiX+avnmYuiXINPM0rsItNBtIzK1ByGhH7149zz9iGBdiRr8jMw+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tW42XMQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tW42XMQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18301C2BCB0;
	Fri, 15 May 2026 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861004;
	bh=C62e9avq40rRAJm9iSEi6Ix1b4G8/yEa4cAZeRMM664=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tW42XMQjlPUzVYKauD0AJaOf4NFe3LmN430L4eJvwGeP6HwmQUl3RuBxEskFTWYvc
	 xfOYR6Eucxfr882WPo1IPU8sjyG7VLsXm4dbJUzSrDPZ08Jv1g0wlci9jLqLpYPDUI
	 o1XcvFL4YDfT8y0ePoZQBarIgawVxTGt6yRVxdEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Brosseau <francis@malagauche.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/474] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Fri, 15 May 2026 17:43:39 +0200
Message-ID: <20260515154717.416833895@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a68ed2df72131447d131531a08fe4dfcf4fa4653 ]

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Backport notes for linux-6.6.y:
  - In 6.6.y the do-while masks v in the while-condition itself
    (`atomic_sub_return(v & IO_POLL_REF_MASK, ...) & IO_POLL_REF_MASK`),
    so v can carry IO_POLL_RETRY_FLAG / IO_POLL_CANCEL_FLAG bits when
    we reach the multishot branch.  The HUP check therefore compares
    `(v & IO_POLL_REF_MASK) != 1` rather than the upstream
    `v != 1`, to avoid reacting to flag bits.
  - io_poll_issue takes `ts` (struct io_tw_state *) here.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.6.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.6.y, verified 2026-05-01]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index a154df4d16204..66a0a9b9950b4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -321,7 +321,13 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, ts);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
+			    (v & IO_POLL_REF_MASK) != 1)
+				v--;
+			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
-- 
2.53.0



