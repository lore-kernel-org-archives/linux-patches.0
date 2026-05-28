Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479AA1A3157;
	Thu, 28 May 2026 20:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998923; cv=none; b=EcA690swKgAZKfKc/D/IM3FRMinp0hFTIBu5CjDrMAEX1dBrRU4UHiwkaNFo6MwghDUhdkra2AacJYE0hk8GyvC0SoxROgbPAvazMxCN/BIlPKeDSlx/FG3ccDRUi2PpSSJOkz5gCBQZcsMbOwwCODgwd0gRBR4E9OHDW70UejE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998923; c=relaxed/simple;
	bh=Z9lxY/c8SFux1Q72WmTQvIYzu6N6yOT0JYyGuaCzsBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5C2n3Zfs+CmxjN2rBUhAWKuchuTtuIjiKWJiyOXJcsHhXp59/52aPyx0aXTBXOzFy9LY8uIb5Qkp2ZtrzqTlkGSqETqxZsUIjJazY2f0n3w1uPrHtia1kteIx4Jtm4i3GP50adbTo3BrCFHlcypmqx4ylgZ9lXGgyzg3as0RIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSUgGKmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSUgGKmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56E11F000E9;
	Thu, 28 May 2026 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998922;
	bh=g1TjX73FiwjVmrx5MH4ayqmeFNMipfQRU80q4M4RVlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSUgGKmAeXuWzJUgFlJOcMvV6WH+K4N66FRZ2m+XUb9dFlG+ZPYr/EBt/rFtG9xI2
	 LeYKGf8lggpf5QP22lAxBu7g4CXW8QlSDMwJjZ2HqNOTyEO/5Rjb/f6WOwMM3VnGhv
	 7r4fSwHs2JaE1/KbIz2GhA7fbHG4v9hliM4EDS5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 344/461] io_uring/net: punt IORING_OP_BIND async if it needs file create
Date: Thu, 28 May 2026 21:47:53 +0200
Message-ID: <20260528194657.327634278@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ccd25890f73c082fe2657ed227b497d6ac5fdc40 ]

For two reasons:

1) An opcode cannot block inside io_uring_enter() doing submissions, as
   it'll stall the submission side pipeline.

2) Ending up in sb_start_write() -> __sb_start_write() ->
   percpu_down_read_freezable() introduces a new lockdep edge, which it
   correctly complains about.

Check if the socket type is AF_UNIX and has a non-empty pathname. If it
does, mark it REQ_F_FORCE_ASYNC to punt the submission to io-wq rather
than attempt to do it inline.

Fixes: 7481fd93fa0a ("io_uring: Introduce IORING_OP_BIND")
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8885d944130a1..5bd3fa5a2b6d3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -4,6 +4,7 @@
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/net.h>
+#include <linux/un.h>
 #include <linux/compat.h>
 #include <net/compat.h>
 #include <linux/io_uring.h>
@@ -1841,11 +1842,29 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+/*
+ * Check if bind request would potentially end up with filename_create(),
+ * which in turn end up in mnt_want_write() which will grab the fs
+ * percpu start write sem. This can trigger a lockdep warning.
+ */
+static int io_bind_file_create(const struct io_async_msghdr *io, int addr_len)
+{
+	const struct sockaddr_un *sun;
+
+	if (io->addr.ss_family != AF_UNIX)
+		return 0;
+	if (addr_len <= offsetof(struct sockaddr_un, sun_path))
+		return 0;
+	sun = (const struct sockaddr_un *) &io->addr;
+	return sun->sun_path[0] != '\0';
+}
+
 int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_bind *bind = io_kiocb_to_cmd(req, struct io_bind);
 	struct sockaddr __user *uaddr;
 	struct io_async_msghdr *io;
+	int ret;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1856,7 +1875,12 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	io = io_msg_alloc_async(req);
 	if (unlikely(!io))
 		return -ENOMEM;
-	return move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+	ret = move_addr_to_kernel(uaddr, bind->addr_len, &io->addr);
+	if (unlikely(ret))
+		return ret;
+	if (io_bind_file_create(io, bind->addr_len))
+		req->flags |= REQ_F_FORCE_ASYNC;
+	return 0;
 }
 
 int io_bind(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.53.0



