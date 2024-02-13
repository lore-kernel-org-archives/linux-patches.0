Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4A35FF04;
	Tue, 13 Feb 2024 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845580; cv=none; b=u2luSgYSEc8ZVVDuhMmbhHV73avR/kaY2/OUfdtpJVtpWp0qoj7Mr8fQEGak2zh9Ey/62b6YhF4aTk4cFp1PZHVB/IAnLI83Fu1lTnp5ZKnEsDkVyikkgPZoGjliZYPZTeeE4Fk9fq3H6vwsd2VmhBzkwZd3btmnVYxTS2oy9Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845580; c=relaxed/simple;
	bh=68kODWO5pCInrNMn7qcYvAvb/zymbaBZjEsVavyWf0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWmninMsWRmIILFTIE3DFDKvf+vs08WmlK5PFfKsssQTHEH0txQh4Dv+jQNERDr43d2QMmqaiFSVKo37ArtK+LnDaYHviuAv0++g4hShhSk78RZTx0Ew8zGFtkfjBSELEWr5Ppg5A7ZyEIQ2JDDqRfwQeYMivWFALWbOKGIGPxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgQKsznj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgQKsznj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36904C433C7;
	Tue, 13 Feb 2024 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845580;
	bh=68kODWO5pCInrNMn7qcYvAvb/zymbaBZjEsVavyWf0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgQKsznjgRyp/IH/FqNP8nMTGeT/oygyvuPzMcXdkUVJ5Z3KrvgYNi6O1De96kLp/
	 dgRhwCIpg/haC0s+cFUX6cn+KX98/EiMMLpvwUg5euJC4mX+JYCt+8Yfo3eDPW5HdT
	 oJ0rQcnhpEXpDACgXochdMGjFFi0QU+imlRkBCmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 121/121] io_uring/net: limit inline multishot retries
Date: Tue, 13 Feb 2024 18:22:10 +0100
Message-ID: <20240213171856.517414389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 76b367a2d83163cf19173d5cb0b562acbabc8eac upstream.

If we have multiple clients and some/all are flooding the receives to
such an extent that we can retry a LOT handling multishot receives, then
we can be starving some clients and hence serving traffic in an
imbalanced fashion.

Limit multishot retry attempts to some arbitrary value, whose only
purpose serves to ensure that we don't keep serving a single connection
for way too long. We default to 32 retries, which should be more than
enough to provide fairness, yet not so small that we'll spend too much
time requeuing rather than handling traffic.

Cc: stable@vger.kernel.org
Depends-on: 704ea888d646 ("io_uring/poll: add requeue return code from poll multishot handling")
Depends-on: 1e5d765a82f ("io_uring/net: un-indent mshot retry path in io_recv_finish()")
Depends-on: e84b01a880f6 ("io_uring/poll: move poll execution helpers higher up")
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Link: https://github.com/axboe/liburing/issues/1043
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -60,6 +60,7 @@ struct io_sr_msg {
 	unsigned			len;
 	unsigned			done_io;
 	unsigned			msg_flags;
+	unsigned			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
@@ -70,6 +71,13 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+/*
+ * Number of times we'll try and do receives if there's more data. If we
+ * exceed this limit, then add us to the back of the queue and retry from
+ * there. This helps fairness between flooding clients.
+ */
+#define MULTISHOT_MAX_RETRY	32
+
 static inline bool io_check_multishot(struct io_kiocb *req,
 				      unsigned int issue_flags)
 {
@@ -611,6 +619,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 	sr->done_io = 0;
+	sr->nr_multishot_loops = 0;
 	return 0;
 }
 
@@ -654,12 +663,20 @@ static inline bool io_recv_finish(struct
 	 */
 	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
 				*ret, cflags | IORING_CQE_F_MORE)) {
+		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
+
 		io_recv_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1)
-			return false;
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
+			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
+				return false;
+			/* mshot retries exceeded, force a requeue */
+			sr->nr_multishot_loops = 0;
+			mshot_retry_ret = IOU_REQUEUE;
+		}
 		if (issue_flags & IO_URING_F_MULTISHOT)
-			*ret = IOU_ISSUE_SKIP_COMPLETE;
+			*ret = mshot_retry_ret;
 		else
 			*ret = -EAGAIN;
 		return true;


