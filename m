Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CE731B828;
	Sat, 17 Oct 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260516; cv=none; b=DNf3zi2NbxtULvDmwTf/E0C5dUpHXdrD4oDb+N5182RltlImYKWCvnbnh8WiXi5y6+H8lqoonDf7xGiQTjK5bG3e8u/ViHP6EyxHEL92/AsSjfiDArcJljTYPdaGCf5tomSpNQO3iv4vYdiYyetsYLBjcfS4GZPNV4ETSUYQlj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260516; c=relaxed/simple;
	bh=iBRhPvjbYH16OOVmoG2dUz2FXzKetMs1U2L/C2o6SiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6m2yPEGMTI177ssWKQXAy63tS0i9/MFSbXEg1hnuSdUFEQXFcV7B2oy2HvtpgevPev2MMC1KvGs/IXwPkxMZsLZmgv1W/6qo0E52J9ovui+eqTFre4N/0kG7y2FUJw0YbgoAnb6Mnnyfn4Trex4+HJD4TkPYJOSMCnROi0o+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1aX9MvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1aX9MvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685DF1F000C4;
	Sat, 17 Oct 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260515;
	bh=+oi2zQb6dLgVSrUHr18DAewPvMzBd6/J0hsBxSYKebw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1aX9MvVpRrNKaZ1ovQ8fUBirzcoDwylo/hJnGCOqo4OglKy80uEPXgwGwgexTR5h
	 WHlsWOokmiPDUxo4JPC7zZq+6IuusqyXFGLlfkHFxTubmyP7zK+fb/4M26HY2qRMaf
	 OwNm2BxLwK8hqApc9fbLUquxMYzNJ7Cb4w1x8UX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1569/1674] net/handshake: hand off the pinned file reference to accept_doit
Date: Sat, 17 Oct 2026 18:04:01 +0200
Message-ID: <20261017160511.374223993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/handshake-test.c |  8 ++++++++
 net/handshake/netlink.c        |  6 +++---
 net/handshake/request.c        | 18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
index 34fd1d9b2db86..6eeb53da6e2de 100644
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
index c4a76319e1f88..1afa7d4880381 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -92,7 +92,6 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	struct net *net = sock_net(skb->sk);
 	struct handshake_net *hn = handshake_pernet(net);
 	struct handshake_req *req = NULL;
-	struct socket *sock;
 	int class, fd, err;
 
 	err = -EOPNOTSUPP;
@@ -109,9 +108,9 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	if (!req)
 		goto out_status;
 
-	sock = req->hr_sk->sk_socket;
 	fd = get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0) {
+		fput(req->hr_file); /* drop ref from handshake_req_next() */
 		err = fd;
 		goto out_complete;
 	}
@@ -119,10 +118,11 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 	err = req->hr_proto->hp_accept(req, info, fd);
 	if (err) {
 		put_unused_fd(fd);
+		fput(req->hr_file); /* drop ref from handshake_req_next() */
 		goto out_complete;
 	}
 
-	fd_install(fd, get_file(sock->file));
+	fd_install(fd, req->hr_file);
 
 	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
 	return 0;
diff --git a/net/handshake/request.c b/net/handshake/request.c
index e5285fcf15b06..b8eb7e8e0ec48 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -182,6 +182,17 @@ static bool remove_pending(struct handshake_net *hn, struct handshake_req *req)
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
@@ -192,6 +203,13 @@ struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
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



