Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2D32AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68D6C433C9;
	Wed, 20 Sep 2023 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211182;
	bh=40U12+fto3gwOH/AouhAN4Q+kGqMviCGCGwCa+Xd4Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeM2EG6ctLS5vZ8dB7fkiYU2YeSF1Wn70S1+MXF9/oehaputmoz+oB9rfmklC9VZt
	 EoIZlFOvtgrDv7dNTH/IJX+tEUw087WHBcFHq2sWSkKY8nguiIxjIE2KOGxsOHPSes
	 kSHv6iAswSG4fLBEDGNAR0Bk/aAfsbLMnI/5sz44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 113/139] io_uring/net: fix iter retargeting for selected buf
Date: Wed, 20 Sep 2023 13:30:47 +0200
Message-ID: <20230920112839.775377148@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

commit c21a8027ad8a68c340d0d58bf1cc61dcb0bc4d2f upstream.

When using selected buffer feature, io_uring delays data iter setup
until later. If io_setup_async_msg() is called before that it might see
not correctly setup iterator. Pre-init nr_segs and judge from its state
whether we repointing.

Cc: stable@vger.kernel.org
Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
Fixes: 0455d4ccec548 ("io_uring: add POLL_FIRST support for send/sendmsg and recv/recvmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0000000000002770be06053c7757@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -170,6 +170,10 @@ static int io_setup_async_msg(struct io_
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
+
+	if ((req->flags & REQ_F_BUFFER_SELECT) && !async_msg->msg.msg_iter.nr_segs)
+		return -EAGAIN;
+
 	/* if were using fast_iov, set it to the new one */
 	if (!kmsg->free_iov) {
 		size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
@@ -529,6 +533,7 @@ static int io_recvmsg_copy_hdr(struct io
 			       struct io_async_msghdr *iomsg)
 {
 	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)


