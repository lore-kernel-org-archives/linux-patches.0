Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686BB29D288;
	Thu, 25 Jun 2026 13:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392741; cv=none; b=susJUA0c4AfNfp6pmoeExBvyWLaa2HSd3wvKELB8V1Fawo9d0J9OznE62PcTWL9lafzUjhFOK3TMLVDTTSL7OoKFVy+uekaBiNFDh4tU/GiLgGedQwdHKNFU1z8F3XA+lKhN5+WVDBag0Hd6EwplDG0ULdzPVlstlRMGHdQRAas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392741; c=relaxed/simple;
	bh=aQ7i8iig58P9wfz1SmOgljh4BjCbeRWljtfDNDqv+uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idAj//SLIQN0q0q/TKYVDxU8ygeu2QBSdh35wgCURXwy7s6IWsWNzOkqWmn2N5mqGlCNlfuOZFeeWPZvwig/y3ZaqrZ4THIGL/QZtkG8qTSrOL8ZRnhu4XDPoJ5EuvIA2aB6pYE10rYAU5Sc5V0Uv45kwwFuQXaCdiecgYhqTk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/XoCZvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/XoCZvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C2A1F000E9;
	Thu, 25 Jun 2026 13:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392740;
	bh=iiUlYfdnBy1O+C3WsEuiQVojm1XmFtzn6XL/V16bnOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/XoCZvNMOFP2eBOfY82WquHauo+ojokEQq2cZebq6vJgNcq26gEanOPAKOEUXKbC
	 U5gJEfSv9JzCc1AsTlTNYyJ2IYjKsr5zbFTXo/xCXP7CLIaQtAU7PDVwSFiA51IgH1
	 3I41XHFGauRSwg5qvQ1BbRV5a/eeCAcFXC0QauXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 01/60] io_uring/net: Avoid msghdr on op_connect/op_bind async data
Date: Thu, 25 Jun 2026 14:02:46 +0100
Message-ID: <20260625125645.735836213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit 3979840cd858f30f43ea9f4e7f7f1f56de82d698 ]
This fixes a memory leak due to the lack of the cleanup hook for the
iovec.  The stable backport differs from upstream by dropping the
io_connect_bpf_populate hunk, which didn't exist at the time and by
fixing the merge conflict due to the introduction of
io_bind_file_create.

Both IORING_OP_CONNECT and IORING_OP_BIND reuse the msghdr object just
to store the sockaddr. Beyond allocating a much larger object than
needed, msghdr can also wrap an iovec, which will be recycled
unnecessarily. This uses the sockaddr directly.

Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260602215327.1885109-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c   | 36 ++++++++++++++++++------------------
 io_uring/opdef.c |  4 ++--
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a46c7e81704024..3ab2bfca1bd5dd 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1771,7 +1771,7 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io;
+	struct sockaddr_storage *addr;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1780,17 +1780,17 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	conn->addr_len =  READ_ONCE(sqe->addr2);
 	conn->in_progress = conn->seen_econnaborted = false;
 
-	io = io_msg_alloc_async(req);
-	if (unlikely(!io))
+	addr = io_uring_alloc_async_data(NULL, req);
+	if (unlikely(!addr))
 		return -ENOMEM;
 
-	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->addr);
+	return move_addr_to_kernel(conn->addr, conn->addr_len, addr);
 }
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_msghdr *io = req->async_data;
+	struct sockaddr_storage *addr = req->async_data;
 	unsigned file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -1804,8 +1804,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
-	ret = __sys_connect_file(req->file, &io->addr, connect->addr_len,
-				 file_flags);
+	ret = __sys_connect_file(req->file, addr, connect->addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
 	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
@@ -1834,7 +1833,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
 }
@@ -1844,15 +1842,15 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
  * which in turn end up in mnt_want_write() which will grab the fs
  * percpu start write sem. This can trigger a lockdep warning.
  */
-static int io_bind_file_create(const struct io_async_msghdr *io, int addr_len)
+static int io_bind_file_create(const struct sockaddr_storage *addr, int addr_len)
 {
 	const struct sockaddr_un *sun;
 
-	if (io->addr.ss_family != AF_UNIX)
+	if (addr->ss_family != AF_UNIX)
 		return 0;
 	if (addr_len <= offsetof(struct sockaddr_un, sun_path))
 		return 0;
-	sun = (const struct sockaddr_un *) &io->addr;
+	sun = (const struct sockaddr_un *) addr;
 	return sun->sun_path[0] != '\0';
 }
 
@@ -1860,7 +1858,7 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
 	struct sockaddr __user *uaddr;
-	struct io_async_msghdr *io;
+	struct sockaddr_storage *addr;
 	int ret;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
@@ -1869,21 +1867,23 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	bind->addr_len =  READ_ONCE(sqe->addr2);
 
-	io = io_msg_alloc_async(req);
-	if (unlikely(!io))
+	addr = io_uring_alloc_async_data(NULL, req);
+	if (unlikely(!addr))
 		return -ENOMEM;
-	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+
+	ret = move_addr_to_kernel(uaddr, bind->addr_len, addr);
 	if (unlikely(ret))
 		return ret;
-	if (io_bind_file_create(io, bind->addr_len))
+	if (io_bind_file_create(addr, bind->addr_len))
 		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
+
 int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
-	struct io_async_msghdr *io = req->async_data;
+	struct sockaddr_storage *addr = req->async_data;
 	struct socket *sock;
 	int ret;
 
@@ -1891,7 +1891,7 @@ int io_bind(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = __sys_bind_socket(sock, &io->addr, bind->addr_len);
+	ret = __sys_bind_socket(sock, addr, bind->addr_len);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 932319633eac20..a57c820567f772 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -207,7 +207,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct sockaddr_storage),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
 #else
@@ -504,7 +504,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.prep			= io_bind_prep,
 		.issue			= io_bind,
-		.async_size		= sizeof(struct io_async_msghdr),
+		.async_size		= sizeof(struct sockaddr_storage),
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.53.0



