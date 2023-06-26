Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D08E11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B2C433C8;
	Mon, 26 Jun 2023 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804760;
	bh=SmI0wIclrXG2Z7l2k3a/CF45iPIL4ZMsn8SNR7st0Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/yXkII/t/cErQ+D5s8JyjyTHGYCuaou4LNv8PdtOOqsMBHTXnyVxfsgIOQCCD/GU
	 7eTW0PJk9rZ1SibaBjQySKBh0TwV0h/VeIp0YYOcaW1aU1K5p3RRt0U7gbJYlp6El+
	 pxG6P1Pwmi0rNJ8LjaFR/31+FCKYbwOL/yj7iP8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH 5.15 32/96] io_uring/net: save msghdr->msg_control for retries
Date: Mon, 26 Jun 2023 20:11:47 +0200
Message-ID: <20230626180748.286611678@linuxfoundation.org>
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

Commit cac9e4418f4cbd548ccb065b3adcafe073f7f7d2 upstream.

If the application sets ->msg_control and we have to later retry this
command, or if it got queued with IOSQE_ASYNC to begin with, then we
need to retain the original msg_control value. This is due to the net
stack overwriting this field with an in-kernel pointer, to copy it
in. Hitting that path for the second time will now fail the copy from
user, as it's attempting to copy from a non-user address.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/issues/880
Reported-and-tested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -581,6 +581,7 @@ struct io_sr_msg {
 	size_t				len;
 	size_t				done_io;
 	struct io_buffer		*kbuf;
+	void __user			*msg_control;
 };
 
 struct io_open {
@@ -4864,10 +4865,16 @@ static int io_setup_async_msg(struct io_
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
+	struct io_sr_msg *sr = &req->sr_msg;
+	int ret;
+
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->free_iov = iomsg->fast_iov;
-	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
+	ret = sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
 				   req->sr_msg.msg_flags, &iomsg->free_iov);
+	/* save msg_control as sys_sendmsg() overwrites it */
+	sr->msg_control = iomsg->msg.msg_control;
+	return ret;
 }
 
 static int io_sendmsg_prep_async(struct io_kiocb *req)
@@ -4924,6 +4931,8 @@ static int io_sendmsg(struct io_kiocb *r
 		if (ret)
 			return ret;
 		kmsg = &iomsg;
+	} else {
+		kmsg->msg.msg_control = sr->msg_control;
 	}
 
 	flags = req->sr_msg.msg_flags;


