Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD992DC765;
	Fri,  7 Aug 2026 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115683; cv=none; b=GiodcLcu0V62VtXfnuRr8fu82I/oGAshYdPkx/90yQrEMP6h0/n8cnZLriI4+Tgl7BA6QqvYdBtgYwSwJSOSo1TyNe8uY6RL7igDO2WcmrARRGoS8mgRr0B5CvcfsO+bZ08QNNpEBBgHfeYW0pOnTboL7UWi9pfR/8AosT/b0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115683; c=relaxed/simple;
	bh=DxvVR+dqWvOvKswneqCBnUzpryFbGw2OMjb6+o8mxa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0GjzVMDFm5uqmpBQ6MExIxniAky29urWQaGljwq3EaBoRvYhFnSNQLA3ABEQT/nKmvRHK72VF32IvzUu0oKbvejyMAlf2rPrD9IbhgZNOSgwSvmLOzDm4JB7Myujny7M4apgB0heWH441OEa06Bve4jV/RmXTC6KhBFOz/QEyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXg2THPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXg2THPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3C41F000E9;
	Fri,  7 Aug 2026 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115681;
	bh=vRD5hlOBWGlffF/tdfj+HSkfsUACG+O3IyKuJ5HvwQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXg2THPgYRvdSsVAbAQCjkiZcWClYZ72q++jXyzMhoYYzDeccDLa1wYX5aEfy5Lc4
	 01BgepbiH9tcS2xhH5ep0J/VGDCSq/XkxbXYz5yGlxiRj6bmiwRKZch6KJ0MFPJvUX
	 2uXlN/649VhJ7mktL4itCHWwiO7zn2SO9IwIZSB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/396] net/handshake: hand off the pinned file reference to accept_doit
Date: Fri,  7 Aug 2026 16:38:41 +0200
Message-ID: <20260807143432.071078216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f4251190e58b209999c1ba9e6d2976136a1be055 ]

handshake_req_next() removes the request from the per-net
pending list and drops hn_lock before handshake_nl_accept_doit()
reads req->hr_sk->sk_socket and dereferences sock->file (once in
FD_PREPARE() and again in get_file()).  In that window a
consumer running tls_handshake_cancel() followed by sockfd_put()
(svc_sock_free) or __fput_sync() (xs_reset_transport) releases
sock->file.  sock_release() then runs sock_orphan(), zeroing
sk_socket, and frees the struct socket.  The accept-side code
either reads NULL through sk_socket or chases freed memory.

The submit-side sock_hold() does not prevent this.  sk_refcnt
protects struct sock, but struct socket and sock->file are
independently refcounted via the file descriptor the consumer
owns.  Pinning sk leaves sock and sock->file unprotected.

Retarget the accept-side dereferences at req->hr_file, which was
pinned at submit time, instead of req->hr_sk->sk_socket->file.
Pinning on its own is not sufficient: a consumer that cancels
between handshake_req_next() returning and accept_doit reaching
FD_PREPARE() takes the !remove_pending() branch in
handshake_req_cancel() and drops hr_file before the accept side
takes its own reference.  Hand off an additional file reference
inside handshake_req_next(), under hn_lock, so the accept side
operates on a reference that no concurrent handshake_req_cancel()
can revoke.  FD_PREPARE() consumes that handed-off reference,
either by transferring it to the new fd in fd_publish() or by
dropping it in the cleanup destructor on error; the explicit
get_file() that previously balanced FD_PREPARE() is therefore
redundant and goes away.

Update handshake_req_cancel_test2 and _test3 to simulate the
FD_PREPARE() consumption with an fput() so the kunit file-count
assertions stay balanced.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-5-66c616906ead@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
(cherry picked from commit f4251190e58b209999c1ba9e6d2976136a1be055)
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/handshake-test.c |  8 ++++++++
 net/handshake/netlink.c        |  7 ++-----
 net/handshake/request.c        | 18 ++++++++++++++++++
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
index df3948e807a0f..9cc7a95f41207 100644
--- a/net/handshake/handshake-test.c
+++ b/net/handshake/handshake-test.c
@@ -375,6 +375,10 @@ static void handshake_req_cancel_test2(struct kunit *test)
 	/* Pretend to accept this request */
 	next = handshake_req_next(hn, HANDSHAKE_HANDLER_CLASS_TLSHD);
 	KUNIT_ASSERT_PTR_EQ(test, req, next);
+	/* Simulate FD_PREPARE() consuming the file reference handed
+	 * off by handshake_req_next(); see handshake_nl_accept_doit().
+	 */
+	fput(filp);
 
 	/* Act */
 	result = handshake_req_cancel(sock->sk);
@@ -417,6 +421,10 @@ static void handshake_req_cancel_test3(struct kunit *test)
 	/* Pretend to accept this request */
 	next = handshake_req_next(hn, HANDSHAKE_HANDLER_CLASS_TLSHD);
 	KUNIT_ASSERT_PTR_EQ(test, req, next);
+	/* Simulate FD_PREPARE() consuming the file reference handed
+	 * off by handshake_req_next(); see handshake_nl_accept_doit().
+	 */
+	fput(filp);
 
 	/* Pretend to complete this request */
 	handshake_complete(next, -ETIMEDOUT, NULL);
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 1a5821eb71847..21d6cbd52fcdb 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -92,7 +92,6 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	struct net *net = sock_net(skb->sk);
 	struct handshake_net *hn = handshake_pernet(net);
 	struct handshake_req *req = NULL;
-	struct socket *sock;
 	int class, err;
 
 	err = -EOPNOTSUPP;
@@ -107,15 +106,13 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	err = -EAGAIN;
 	req = handshake_req_next(hn, class);
 	if (req) {
-		sock = req->hr_sk->sk_socket;
-
-		FD_PREPARE(fdf, O_CLOEXEC, sock->file);
+		FD_PREPARE(fdf, O_CLOEXEC, req->hr_file);
 		if (fdf.err) {
+			fput(req->hr_file); /* drop ref from handshake_req_next() */
 			err = fdf.err;
 			goto out_complete;
 		}
 
-		get_file(sock->file); /* FD_PREPARE() consumes a reference. */
 		err = req->hr_proto->hp_accept(req, info, fd_prepare_fd(fdf));
 		if (err)
 			goto out_complete; /* Automatic cleanup handles fput */
diff --git a/net/handshake/request.c b/net/handshake/request.c
index 35bc6290e1203..4bf98793491aa 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -178,6 +178,17 @@ static bool remove_pending(struct handshake_net *hn, struct handshake_req *req)
 	return ret;
 }
 
+/**
+ * handshake_req_next - Return the next queued handshake request
+ * @hn: per-net handshake state
+ * @class: handler class to match
+ *
+ * On a non-NULL return, the caller owns an extra reference
+ * on @req->hr_file.  FD_PREPARE() consumes it on success; on
+ * the FD_PREPARE() failure path the caller must fput() it.
+ *
+ * Return: pointer to a removed handshake_req, or NULL.
+ */
 struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
 {
 	struct handshake_req *req, *pos;
@@ -188,6 +199,13 @@ struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
 		if (pos->hr_proto->hp_handler_class != class)
 			continue;
 		__remove_pending_locked(hn, pos);
+		/* Hand off a file reference to the accept side under
+		 * hn_lock.  A concurrent handshake_req_cancel() can drop
+		 * hr_file before accept reaches FD_PREPARE(); this extra
+		 * reference keeps the file alive until FD_PREPARE() takes
+		 * ownership.
+		 */
+		get_file(pos->hr_file);
 		req = pos;
 		break;
 	}
-- 
2.53.0



