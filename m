Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA8332EA7;
	Sat, 30 May 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160103; cv=none; b=GDexSqMzp2CQw9SVQXuHU2HmmyL8ikAWLaAAArVaGLv2oERr2YEadeSvuLENWcvGroCDofODjprUFm5KQeqejSnJhPntjwWEfSD7VnMCDhyK3u+SIl19u4W7+cboFc3XibwEz5SiHEJ6lKYOXlFsVhIL2kNPIObsyQWYce6Y+ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160103; c=relaxed/simple;
	bh=X9plwmiq0vWH9z38CUWg4KSsvzCqFe8IzY7n5ASMiG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxpqU0YnHsqqwGFvdQo7vhSxnmo3BzznGQt/Fv7bYgJYuO4/rlkAdrStNbu2XrOrOQyMvDiiL0rWjAGYyRwoxtGEJ3JTU9pYExjJWF7Pbn5Ua3B6fVzd/WRi0/DUvg/VZc89RurwAMnDP6o6pPIq0TWXXB0aBYRjNPijTzP8Yuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n6O3Bdb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n6O3Bdb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7865E1F00893;
	Sat, 30 May 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160102;
	bh=U6je7QEcIC+tvL/Rcl/QIf1f1Y+9blPWEg/xB66E9Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6O3Bdb1KYMf3pxDwmA02X1pYKIoA28b+VJLpDG9RuK5BVJXQujiguH8zzz6yG5mX
	 Xf3uWn2OG0TZEvbCSLHHl144iArB3DPQ/nOYVRBNbAP1i8tv88n6uHiXCPpFEoJmur
	 pzPQpnHw9jjx2vwZnIx6C9ymgBDI5BGGjHA170+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Brosseau <francis@malagauche.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/969] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Sat, 30 May 2026 17:56:10 +0200
Message-ID: <20260530160307.258134013@linuxfoundation.org>
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

Backport notes for linux-6.1.y:
  - In 6.1.y the do-while masks v in the while-condition itself, so
    v can carry IO_POLL_RETRY_FLAG/IO_POLL_CANCEL_FLAG bits when we
    reach the multishot branch.  The HUP check therefore compares
    `(v & IO_POLL_REF_MASK) != 1` rather than the upstream `v != 1`.
  - io_poll_issue takes `bool *locked` here (renamed to `ts` in 6.6+).
  - 6.1.y has no IOU_REQUEUE return path; only IOU_STOP_MULTISHOT.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.1.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.1.y, verified 2026-05-01]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 367605a5878fe..cdf1f2f57b9a2 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -303,7 +303,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, locked);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
+			    (v & IO_POLL_REF_MASK) != 1)
+				v--;
+			ret = io_poll_issue(req, locked);
 			io_kbuf_recycle(req, 0);
 
 			if (ret == IOU_STOP_MULTISHOT)
-- 
2.53.0



