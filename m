Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36DB2D3A94;
	Tue, 12 Aug 2025 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026756; cv=none; b=CU2obotcKuGh5Y1k2PuxVdietU4+A+o2cn55sDaKMQzuOwOJfvCVPx80lafmr6iJMvSPha4MGQmLaSpllboPyWQDU6UBL4xHy4iJAjvHXhutXWdeuGAmiUO+/jaPVYihYdGiGfpqXEeXcPP93UlmwVBQHkm+LzEJrw1x6HHB51M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026756; c=relaxed/simple;
	bh=Ingi3AJcjVmyqs//y95xStnIa4RsKb7p91ZNkLLB4CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjOCp97ujedq9ukFkvBYNMEZJgQGlRLXjNtR0rV2ncoNiBPn4BpF2pALdZwRz46BUQ92taBQmW1VcgwBRzRRV06ij4eqjgMsGT5hFFC+EnL/qmk2UVFiecgveAxyFl0U47dSJlc3MnHD+cilgT3gQNNmc+SE0hElRQn5G74XlVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DycJf/h/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DycJf/h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3B9C4CEF0;
	Tue, 12 Aug 2025 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026754;
	bh=Ingi3AJcjVmyqs//y95xStnIa4RsKb7p91ZNkLLB4CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DycJf/h/v2ypUjTRRAyFmqI2OlIvohwkhbDUZeYidquT8Siv6IFxRLwSlibWCDI7N
	 WYpEgUy+bXo7xMnZ7hMgsaVbWUQKgsBmtn01jeOaLozaFMjlxO67MMwErcTrY1bXk6
	 esBp3Qgm0QROrV7oVXc0ajuEBffYPQEL813SWx4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 403/480] sunrpc: fix client side handling of tls alerts
Date: Tue, 12 Aug 2025 19:50:11 +0200
Message-ID: <20250812174414.055198715@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit cc5d59081fa26506d02de2127ab822f40d88bc5a ]

A security exploit was discovered in NFS over TLS in tls_alert_recv
due to its assumption that there is valid data in the msghdr's
iterator's kvec.

Instead, this patch proposes the rework how control messages are
setup and used by sock_recvmsg().

If no control message structure is setup, kTLS layer will read and
process TLS data record types. As soon as it encounters a TLS control
message, it would return an error. At that point, NFS can setup a kvec
backed control buffer and read in the control message such as a TLS
alert. Scott found that a msg iterator can advance the kvec pointer
as a part of the copy process thus we need to revert the iterator
before calling into the tls_alert_recv.

Fixes: dea034b963c8 ("SUNRPC: Capture CMSG metadata on client-side receive")
Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Suggested-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Link: https://lore.kernel.org/r/20250731180058.4669-3-okorniev@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 4b10ecf4c265..9b2328b727b6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -358,7 +358,7 @@ xs_alloc_sparse_pages(struct xdr_buf *buf, size_t want, gfp_t gfp)
 
 static int
 xs_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
-		     struct cmsghdr *cmsg, int ret)
+		     unsigned int *msg_flags, struct cmsghdr *cmsg, int ret)
 {
 	u8 content_type = tls_get_record_type(sock->sk, cmsg);
 	u8 level, description;
@@ -371,7 +371,7 @@ xs_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
 		 * record, even though there might be more frames
 		 * waiting to be decrypted.
 		 */
-		msg->msg_flags &= ~MSG_EOR;
+		*msg_flags &= ~MSG_EOR;
 		break;
 	case TLS_RECORD_TYPE_ALERT:
 		tls_alert_recv(sock->sk, msg, &level, &description);
@@ -386,19 +386,33 @@ xs_sock_process_cmsg(struct socket *sock, struct msghdr *msg,
 }
 
 static int
-xs_sock_recv_cmsg(struct socket *sock, struct msghdr *msg, int flags)
+xs_sock_recv_cmsg(struct socket *sock, unsigned int *msg_flags, int flags)
 {
 	union {
 		struct cmsghdr	cmsg;
 		u8		buf[CMSG_SPACE(sizeof(u8))];
 	} u;
+	u8 alert[2];
+	struct kvec alert_kvec = {
+		.iov_base = alert,
+		.iov_len = sizeof(alert),
+	};
+	struct msghdr msg = {
+		.msg_flags = *msg_flags,
+		.msg_control = &u,
+		.msg_controllen = sizeof(u),
+	};
 	int ret;
 
-	msg->msg_control = &u;
-	msg->msg_controllen = sizeof(u);
-	ret = sock_recvmsg(sock, msg, flags);
-	if (msg->msg_controllen != sizeof(u))
-		ret = xs_sock_process_cmsg(sock, msg, &u.cmsg, ret);
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &alert_kvec, 1,
+		      alert_kvec.iov_len);
+	ret = sock_recvmsg(sock, &msg, flags);
+	if (ret > 0 &&
+	    tls_get_record_type(sock->sk, &u.cmsg) == TLS_RECORD_TYPE_ALERT) {
+		iov_iter_revert(&msg.msg_iter, ret);
+		ret = xs_sock_process_cmsg(sock, &msg, msg_flags, &u.cmsg,
+					   -EAGAIN);
+	}
 	return ret;
 }
 
@@ -408,7 +422,13 @@ xs_sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags, size_t seek)
 	ssize_t ret;
 	if (seek != 0)
 		iov_iter_advance(&msg->msg_iter, seek);
-	ret = xs_sock_recv_cmsg(sock, msg, flags);
+	ret = sock_recvmsg(sock, msg, flags);
+	/* Handle TLS inband control message lazily */
+	if (msg->msg_flags & MSG_CTRUNC) {
+		msg->msg_flags &= ~(MSG_CTRUNC | MSG_EOR);
+		if (ret == 0 || ret == -EIO)
+			ret = xs_sock_recv_cmsg(sock, &msg->msg_flags, flags);
+	}
 	return ret > 0 ? ret + seek : ret;
 }
 
@@ -434,7 +454,7 @@ xs_read_discard(struct socket *sock, struct msghdr *msg, int flags,
 		size_t count)
 {
 	iov_iter_discard(&msg->msg_iter, ITER_DEST, count);
-	return xs_sock_recv_cmsg(sock, msg, flags);
+	return xs_sock_recvmsg(sock, msg, flags, 0);
 }
 
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-- 
2.39.5



