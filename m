Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E383C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB5CC433C0;
	Mon, 26 Jun 2023 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805025;
	bh=wtGs4uhsKJik0lGMw9Jhb9SVPn98NiSJvhHi2x/iA3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBoF1sYMZ/pbXoKRbSZ/XAN+W2bqLCa7vfizszzDWt3HUv5i7ppPVuBraYX37x50A
	 rTNxeuIKeCKoziBQDDs+MFjOuF6ozowlG27xrTsk4nEU+pjdrQPZhzP8HbLM6HZYY+
	 ezJW1DHKFGy0gnqV3SyJIASo3/Vp9rUDpH93Arko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 24/81] io_uring/net: clear msg_controllen on partial sendmsg retry
Date: Mon, 26 Jun 2023 20:12:06 +0200
Message-ID: <20230626180745.479465640@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
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
@@ -5064,6 +5064,8 @@ static int io_recvmsg(struct io_kiocb *r
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
+			kmsg->msg.msg_controllen = 0;
+			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);


