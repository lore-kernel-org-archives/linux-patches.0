Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8EC2367DF;
	Fri,  9 Oct 2026 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555536; cv=none; b=VCwyjC+ihfQDf6ZcUmpqnINm/NWGX43/7/MfzWxKjfZyJmoyHo1lmiPF00yCaLIcPLs1s2gPlTV36lWqufNuqD9hO/jEKwK0OMM/roeu+qaYTmH9/3Gb37z10vr3Tpdign6X0EkqiqYVkQ2JR1gvyyIDnENjSkn1E5MONUfViYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555536; c=relaxed/simple;
	bh=X/P6VrarSfAiiBwQeZeLAn3URBYhCNtGcPbIZSLHhkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXxU6tUbp8nss39EZJWaZj+JYbrr+ILkgLClfN/uz5otRLZmdYQuT/+fjnHsoekXcmOPkvsxJWx5ncIn0rUn2JdCfScRoculWkDLew07XCXOSHEmKMlIr6VjOPSQntZEZv+6FBzmGRU83tM8naLpDOuMrn1nNb2O0hxpNrjgcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2ZLEbZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2ZLEbZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670271F00898;
	Fri,  9 Oct 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555530;
	bh=LvBXeEp0A3vAhAdmzIsSxKDHkTakl2sSYMUAgztwa28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2ZLEbZ0S2E0B4jQ72GVlRh6L29MFo+JOmnDX+r9RvqYZyi4NQcDTTKBV0rzc6+6v
	 TsqKqWoTw1sPOkPvZI8FVZ1PzYTvaN9jIuiJHUpO5npTaE5YD2mreDb9ZkTKvyTeK2
	 l/RBCdDWHa9sPgbF/Am8qIGLI5ex34cYUT6eOuFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lollipopkit <a@lolli.tech>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 024/428] io_uring/cmd_net: end TX_TIMESTAMP multishot when the CQ is full
Date: Fri,  9 Oct 2026 16:06:01 +0200
Message-ID: <20261009140946.596768074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: lollipopkit <a@lolli.tech>

commit 3a3d93070c5ec8b8049d57025987ba313420bda9 upstream.

SOCKET_URING_OP_TX_TIMESTAMP arms an EPOLLERR apoll multishot and, on
each error queue edge, posts one 32 byte aux CQE per timestamp skb. Aux
CQEs have no overflow backing, so io_uring_cmd_post_mshot_cqe32() fails
once the CQ ring is full. The loop then stops, splices the unprocessed
skbs back onto sk_error_queue and returns -EAGAIN.

-EAGAIN is IOU_RETRY, so the request goes idle until the next poll
event. io_arm_apoll() forces EPOLLET and draining the CQ does not re-run
the command, so the spliced-back timestamps stay queued until an
unrelated later timestamp produces a new edge.

End the multishot when a CQE cannot be posted, as multishot poll and
recv already do. There is no partial result to report, so complete with
-ENOBUFS: no CQ space is left for the timestamp CQEs. This command does
not use provided buffers, so the value cannot be confused with a buffer
ring running empty. The terminal CQE still reaches userspace because
request completions can go to the overflow list. The application sees a
CQE without IORING_CQE_F_MORE, which it already has to handle, and the
first issue of the re-armed request delivers the queued timestamps.

A timestamp that cannot be extracted keeps its current behaviour.

This was found with LLM assistance while reviewing io_uring multishot
handlers for the pattern behind a RECV_ZC stall reported earlier (see
Link), and confirmed with a reproducer on v7.3-rc2 and an A/B run of
this patch.

Fixes: 9e4ed359b8ef ("io_uring/netcmd: add tx timestamping cmd support")
Link: https://lore.kernel.org/all/010001a0cd914529-23df2f94-bbe0-49cd-ae5d-05922356fa12-000000@email.amazonses.com/
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-6-sol
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: lollipopkit <a@lolli.tech>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/20260927074206.65427-1-a@lolli.tech
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cmd_net.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -69,8 +69,8 @@ static inline int io_uring_cmd_setsockop
 				  optlen);
 }
 
-static bool io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
-				     struct sk_buff *skb, unsigned issue_flags)
+static int io_process_timestamp_skb(struct io_uring_cmd *cmd, struct sock *sk,
+				    struct sk_buff *skb, unsigned int issue_flags)
 {
 	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
 	struct io_uring_cqe cqe[2];
@@ -83,7 +83,7 @@ static bool io_process_timestamp_skb(str
 
 	ret = skb_get_tx_timestamp(skb, sk, &ts);
 	if (ret < 0)
-		return false;
+		return ret;
 
 	tskey = serr->ee.ee_data;
 	tstype = serr->ee.ee_info;
@@ -98,7 +98,9 @@ static bool io_process_timestamp_skb(str
 	iots = (struct io_timespec *)&cqe[1];
 	iots->tv_sec = ts.tv_sec;
 	iots->tv_nsec = ts.tv_nsec;
-	return io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe);
+	if (!io_uring_cmd_post_mshot_cqe32(cmd, issue_flags, cqe))
+		return -ENOBUFS;
+	return 0;
 }
 
 static int io_uring_cmd_timestamp(struct socket *sock,
@@ -135,7 +137,8 @@ static int io_uring_cmd_timestamp(struct
 		skb = skb_peek(&list);
 		if (!skb)
 			break;
-		if (!io_process_timestamp_skb(cmd, sk, skb, issue_flags))
+		ret = io_process_timestamp_skb(cmd, sk, skb, issue_flags);
+		if (ret)
 			break;
 		__skb_dequeue(&list);
 		consume_skb(skb);
@@ -145,6 +148,12 @@ static int io_uring_cmd_timestamp(struct
 		scoped_guard(spinlock_irqsave, &q->lock)
 			skb_queue_splice(&list, q);
 	}
+	/*
+	 * Aux CQEs cannot overflow and the poll is edge triggered, so nothing
+	 * re-runs the command once the CQ drains. End the multishot instead.
+	 */
+	if (ret == -ENOBUFS)
+		return -ENOBUFS;
 	return -EAGAIN;
 }
 


