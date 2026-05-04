Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7AE3DE43C;
	Mon,  4 May 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904793; cv=none; b=RFcFJVZCM8mJGz/D/T0E0T/RBGLrbTMIxl7YQcl00n6X9hISBRhZEF3iruCaOstCBw1yWvdYmbtrUSnZ2xgHfZoTemlj7sV9jqzinR59nm43nz1EA0nKfV8tmnIvOg4a/ZKEx1JEDLKvlITlz59FjdyKxiedLolv5P/PPBnUvk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904793; c=relaxed/simple;
	bh=r/ZhZAvVU70nWQI6sCa93kCjkg6JS2xSn3nmRwKw2wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTKlxm8o9CxKrRM36AYZE3uguzIf6nrUH511128CqfrFzspz0IbuVqvrlnu1i/3HaiRS6vN5AoRI6DGJFA31X6aQvSnqeV0w5xhO9xd/872GCbagT/vtCuPglY0N6/0ISymUroZ73CjqRXo35XPYeTWztFYZj1Az/sImMtqcJf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjnRP6cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjnRP6cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9804CC2BCB8;
	Mon,  4 May 2026 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904792;
	bh=r/ZhZAvVU70nWQI6sCa93kCjkg6JS2xSn3nmRwKw2wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjnRP6cuQwl9hIxNe0XWTbACc80up7IO672rXicOxI3UkP8SlUUV8/CLSsZFTJ1pH
	 KZRRe791rPXP60GDpG8bgBDP+o9dfhYYNbyE5btM8sLkReHCvxrK9ILiR8aodvlKfK
	 d/tnSL0xXZegqoZ2a2ymu3N4XwBwPyytHP/Gn2xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Brosseau <francis@malagauche.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/215] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Mon,  4 May 2026 15:52:33 +0200
Message-ID: <20260504135135.045257066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

Backport notes for linux-6.12.y:
  - The do-while body in 6.12.y already places `v &= IO_POLL_REF_MASK;`
    just before the while-condition; the upstream patch moves it
    earlier so that `v != 1` in the HUP check refers to the ref-count
    only.  The backport does the same.
  - io_poll_issue takes `ts` (struct io_tw_state *) here.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.12.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.12.y, verified 2026-05-01]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 63c3ce50cb83e..002f1ae830b8a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -295,6 +295,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
 				v &= ~IO_POLL_RETRY_FLAG;
 			}
+			v &= IO_POLL_REF_MASK;
 		}
 
 		/* the mask was stashed in __io_poll_execute */
@@ -327,7 +328,12 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, ts);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && v != 1)
+				v--;
+			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
@@ -343,7 +349,6 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	io_napi_add(req);
-- 
2.53.0



