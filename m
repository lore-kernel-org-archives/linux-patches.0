Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60A31C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A5C433C1;
	Wed, 23 Nov 2022 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197317;
	bh=lejnm8TqQXBQTMKiPPIqZ1GH9/2rkExeSV5QCBmCHjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHKRwH8gZ1sbcMhfUbh05NWnZmxadldNlP2DKVrfUuSyeJbDIw4fqsYJUmzdzBSgL
	 THRNTEARupUme4OhcN1n7lxRdj3wCoX6enX8sGm4YGyS5VI4OvQqwNpQNWk4JQ3kLY
	 Npaw8XaLUPhjDhib5Ei2ufJ85VQv5fAdmh0DC2R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 259/314] io_uring: fix multishot recv request leaks
Date: Wed, 23 Nov 2022 09:51:44 +0100
Message-Id: <20221123084637.257517848@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 100d6b17c06ee4c2b42fdddf0fe4ab77c86eb77e upstream.

Having REQ_F_POLLED set doesn't guarantee that the request is
executed as a multishot from the polling path. Fortunately for us, if
the code thinks it's multishot issue when it's not, it can only ask to
skip completion so leaking the request. Use issue_flags to mark
multipoll issues.

Cc: stable@vger.kernel.org
Fixes: 1300ebb20286b ("io_uring: multishot recv")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/37762040ba9c52b81b92a2f5ebfd4ee484088951.1668710222.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -66,8 +66,6 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
-#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -558,7 +556,8 @@ static inline void io_recv_prep_retry(st
  * again (for multishot).
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  unsigned int cflags, bool mshot_finished)
+				  unsigned int cflags, bool mshot_finished,
+				  unsigned issue_flags)
 {
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
@@ -581,7 +580,7 @@ static inline bool io_recv_finish(struct
 
 	io_req_set_res(req, *ret, cflags);
 
-	if (req->flags & REQ_F_POLLED)
+	if (issue_flags & IO_URING_F_MULTISHOT)
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
@@ -740,8 +739,7 @@ retry_multishot:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			ret = io_setup_async_msg(req, kmsg, issue_flags);
-			if (ret == -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) ==
-					       IO_APOLL_MULTI_POLLED) {
+			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -770,7 +768,7 @@ retry_multishot:
 	if (kmsg->msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished))
+	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished) {
@@ -836,7 +834,7 @@ retry_multishot:
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -869,7 +867,7 @@ out_free:
 	if (msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0))
+	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
 		goto retry_multishot;
 
 	return ret;


