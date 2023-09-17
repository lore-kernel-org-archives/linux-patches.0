Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688A7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDBAC433CC;
	Sun, 17 Sep 2023 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980828;
	bh=UXQWC612usyKwqkTcUFixSpA781GQ+Kga2CuGi+N5pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON02YKa+6/78TLPOyJpoRe8FpfmSGc5s6O8Bsnjq34gVwQ5DS+r8IqAVhJHcrdS/k
	 jpqVEUqlgoKqP+3j2o2/ag9EgQ0cwtZfTnOBseUlZ8VHWiSGe++CU7ic6z8SOteBU6
	 LRfycxNo/99W+fU916lo04k5O4dg32cXKNOhUgqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 004/219] io_uring: always lock in io_apoll_task_func
Date: Sun, 17 Sep 2023 21:12:11 +0200
Message-ID: <20230917191041.121272755@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

From: Dylan Yudaken <dylany@meta.com>

[ upstream commit c06c6c5d276707e04cedbcc55625e984922118aa ]

This is required for the failure case (io_req_complete_failed) and is
missing.

The alternative would be to only lock in the failure path, however all of
the non-error paths in io_poll_check_events that do not do not return
IOU_POLL_NO_ACTION end up locking anyway. The only extraneous lock would
be for the multishot poll overflowing the CQE ring, however multishot poll
would probably benefit from being locked as it will allow completions to
be batched.

So it seems reasonable to lock always.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20221124093559.3780686-3-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -360,11 +360,12 @@ static void io_apoll_task_func(struct io
 	if (ret == IOU_POLL_NO_ACTION)
 		return;
 
+	io_tw_lock(req->ctx, locked);
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, locked);
 
 	if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-		io_req_complete_post(req);
+		io_req_task_complete(req, locked);
 	else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 		io_req_task_submit(req, locked);
 	else


