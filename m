Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD4C11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1763FC433C8;
	Mon, 26 Jun 2023 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804763;
	bh=KsTkjRpki8yvZFzxeket3X1M1VPFhJTi5rpxfCfB86E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZVVNWbDlRzuZEO0a8axSdOS5STMuKTqhvji/l3aS7XWyzz2tEuOt3OhAGvy8LlIV
	 HahBhK2aAsgt2rHaAWgNt5vUBIpqSbc0+gTNrPUHFqFGI94i8zITglFZ1rOGEZwva+
	 K1L3JJoCrSNO5kc7en4GR7oqYJm63bt6v6Knm4Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 33/96] io_uring/net: clear msg_controllen on partial sendmsg retry
Date: Mon, 26 Jun 2023 20:11:48 +0200
Message-ID: <20230626180748.327422235@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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

Commit b1dc492087db0f2e5a45f1072a743d04618dd6be upstream.

If we have cmsg attached AND we transferred partial data at least, clear
msg_controllen on retry so we don't attempt to send that again.

Cc: stable@vger.kernel.org # 5.10+
Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
Reported-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4949,6 +4949,8 @@ static int io_sendmsg(struct io_kiocb *r
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
+			kmsg->msg.msg_controllen = 0;
+			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);


