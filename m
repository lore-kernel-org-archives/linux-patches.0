Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4CA6FCF
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47331C433EF;
	Tue, 10 Jan 2023 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374847;
	bh=+zJF0Zy2PAnDM+h3YOj5IHxJQygTkz4FiCB3DGO2e1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8SnAbNCsp7iCYbjbvDgClPafA50fLX6wf4yVh5aazyXmOOHCaPgYi9Jngr+sEzZo
	 5xVnrLQwh7f4Gd+VU0nqcAEhNjgkiqbgvl3+sMleTpjYPqLtM6C4aPDjXjmswrRC4g
	 zwYSVq1+cZxhhGSkWfGxwI2sxinwE4sAcY6oq3vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 153/159] ksmbd: fix infinite loop in ksmbd_conn_handler_loop()
Date: Tue, 10 Jan 2023 19:05:01 +0100
Message-Id: <20230110180023.397196697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 83dcedd5540d4ac61376ddff5362f7d9f866a6ec upstream.

If kernel_recvmsg() return -EAGAIN in ksmbd_tcp_readv() and go round
again, It will cause infinite loop issue. And all threads from next
connections would be doing that. This patch add max retry count(2) to
avoid it. kernel_recvmsg() will wait during 7sec timeout and try to
retry two time if -EAGAIN is returned. And add flags of kvmalloc to
__GFP_NOWARN and __GFP_NORETRY to disconnect immediately without
retrying on memory alloation failure.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18259
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c    |    7 +++++--
 fs/ksmbd/transport_tcp.c |    5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -316,9 +316,12 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size, GFP_KERNEL);
+		conn->request_buf = kvmalloc(size,
+					     GFP_KERNEL |
+					     __GFP_NOWARN |
+					     __GFP_NORETRY);
 		if (!conn->request_buf)
-			continue;
+			break;
 
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 		if (!ksmbd_smb_request(conn))
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -295,6 +295,7 @@ static int ksmbd_tcp_readv(struct tcp_tr
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
+	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -321,9 +322,11 @@ static int ksmbd_tcp_readv(struct tcp_tr
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
+			   max_retry) {
 			usleep_range(1000, 2000);
 			length = 0;
+			max_retry--;
 			continue;
 		} else if (length <= 0) {
 			total_read = -EAGAIN;


