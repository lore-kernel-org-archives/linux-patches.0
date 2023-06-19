Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0916310974
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E135C433CB;
	Mon, 19 Jun 2023 10:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170854;
	bh=cXS0a0auy2CBTdKj72MP5unq8TDGz1A8afRYSYyLK/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIqrLPG/pmnd1U0tLFllWWeEzEJ6tgJR3Tp0N6rfmysudXDFgjFyH2+Ype85iBS+n
	 +J2fOow7AynPwPn4FdFsEAPaclRK1J6hidgrwt71BmWEHMXvhhNhar6Y5ez8nPwV8/
	 FXWeLNuuaGyK16vEyemJBdD4GQ6HXQOZACQOzcXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH 6.3 059/187] io_uring/net: save msghdr->msg_control for retries
Date: Mon, 19 Jun 2023 12:27:57 +0200
Message-ID: <20230619102200.535541331@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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

commit cac9e4418f4cbd548ccb065b3adcafe073f7f7d2 upstream.

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
 io_uring/net.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -65,6 +65,7 @@ struct io_sr_msg {
 	u16				addr_len;
 	u16				buf_group;
 	void __user			*addr;
+	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
@@ -195,11 +196,15 @@ static int io_sendmsg_copy_hdr(struct io
 			       struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int ret;
 
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->free_iov = iomsg->fast_iov;
-	return sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
 					&iomsg->free_iov);
+	/* save msg_control as sys_sendmsg() overwrites it */
+	sr->msg_control = iomsg->msg.msg_control;
+	return ret;
 }
 
 int io_send_prep_async(struct io_kiocb *req)
@@ -297,6 +302,7 @@ int io_sendmsg(struct io_kiocb *req, uns
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
+		kmsg->msg.msg_control = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)


