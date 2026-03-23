Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DE93A6B88;
	Mon, 23 Mar 2026 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273934; cv=none; b=s31V9PPmkf7FUuMnzfZgrdEqxZA4c99pwWkXiSboatdeOSmh0YqFChwD5XqoQnZBKLHDiMIW55aLKVvCwuaWP4d2g6QCp5BzGkXlUtxM+vixZBpzo/L9k9vulwz4d7bEJHqR3nC5W8Ec9bBLnTAN9s3DYxace9oC1KWPP7xfNyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273934; c=relaxed/simple;
	bh=IqNnerE6aYWui+rmuojlBpnGPdqWIyiv92jUOTeI/+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlfg2E288+EXyCIhIkB6BQysOB98LeOy9NUYhD41KKnNlQOnyz3+Ig48eu6R6PHpBnWUN0rQGqc48amCbER0tpWCJMdGA1t/UkRksaGXfY8K3ZqeymE7II/oWR15uBEoeYaOUEIVhSgE4oVSVi1/pu2Z1EjqNwGXTzgNGLbsK0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkXjJuMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkXjJuMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4876DC4CEF7;
	Mon, 23 Mar 2026 13:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273933;
	bh=IqNnerE6aYWui+rmuojlBpnGPdqWIyiv92jUOTeI/+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkXjJuMeUWyzpEWPbh1Lgbo4PnLOkOseZjulsfQ7p690kbo82l6angAAUYJ9zZ00D
	 CWbHC2f/pNV6r1PF7tce407KgW3n9enph5cQ6iianWvdYIa/9RN3JiwPCFxwteeq8h
	 i8g69N2G7UqHGM1zgfqtMUhQnnuK0Yv2lju2aCbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis Brosseau <francis@malagauche.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 055/220] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Mon, 23 Mar 2026 14:43:52 +0100
Message-ID: <20260323134506.324310380@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a68ed2df72131447d131531a08fe4dfcf4fa4653 upstream.

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

Cc: stable@vger.kernel.org
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -272,6 +272,7 @@ static int io_poll_check_events(struct i
 				atomic_andnot(IO_POLL_RETRY_FLAG, &req->poll_refs);
 				v &= ~IO_POLL_RETRY_FLAG;
 			}
+			v &= IO_POLL_REF_MASK;
 		}
 
 		/* the mask was stashed in __io_poll_execute */
@@ -304,8 +305,13 @@ static int io_poll_check_events(struct i
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, tw);
+			int ret;
 
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && v != 1)
+				v--;
+
+			ret = io_poll_issue(req, tw);
 			if (ret == IOU_COMPLETE)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
@@ -321,7 +327,6 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-		v &= IO_POLL_REF_MASK;
 	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
 
 	io_napi_add(req);


