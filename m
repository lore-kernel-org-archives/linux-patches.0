Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024314A9E
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDC2C433C8;
	Mon, 26 Jun 2023 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804224;
	bh=MlswrwMQP56Pi/z/UhASEXmuzdhIygzlY/TiIqb6phw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTOeZD0wSkC0DK23aDSK7r/TtkrQkkeCKr+0OGlKBWRx08v5u9ddkCY8Dv92SY33m
	 5XNqrn4ERjC7Nu4xcEY/8hywGLcQOOaMTYRw3LE6S1x6XCo8MKQ+3/+go3KxFqtRp2
	 VSQu8jDqWrRm/TB/ho6Q5yAl1B5kF9RKwizXk1rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 055/170] io_uring/net: clear msg_controllen on partial sendmsg retry
Date: Mon, 26 Jun 2023 20:10:24 +0200
Message-ID: <20230626180803.042579520@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit b1dc492087db0f2e5a45f1072a743d04618dd6be upstream.

If we have cmsg attached AND we transferred partial data at least, clear
msg_controllen on retry so we don't attempt to send that again.

Cc: stable@vger.kernel.org # 5.10+
Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
Reported-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -313,6 +313,8 @@ int io_sendmsg(struct io_kiocb *req, uns
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		if (ret > 0 && io_net_retry(sock, flags)) {
+			kmsg->msg.msg_controllen = 0;
+			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);


