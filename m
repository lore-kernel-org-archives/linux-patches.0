Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFDA1DE4E0;
	Thu, 28 May 2026 20:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000968; cv=none; b=VHZ5OmWpXIQocsEhrK+j00Wwhx2XXpoEqnJPJUNGF/krzLSuOvDiS/6O3CotrxBdt+oBSOA10NPIXxkUcC32ytBTPlOi1u4EjcZ6OCHgAVR3Qzns/mQmqMc20ks270/Yjf7ZPDgOGMS467vNH/6IoYFhTaLeh0b0mH08vqpyxmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000968; c=relaxed/simple;
	bh=Sxxem8MgSQmdsDn+RZV68Zs3Bim0Vba6C6Cf/VWJm1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jfapiv5ef196+JdaCxTGi+XLDZRkS16FfAgiJnn5ImSJPq7nB1eirNj9EYXza84PrZhP95E2SYXvfIiVYtRZcl7DULeFX5GWpsJwS/jvHweLJnEkNb48B3UBDRl7l+KwyVFYfvWnzA5IUDygc1c7xk+IYn3/5QJ5RyDZ73iwqUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXLtuGQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXLtuGQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0DF1F000E9;
	Thu, 28 May 2026 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000967;
	bh=eqr8y3IVTq/AmTa+JTBDDC64bMbSNMLOmB2nRdaZ41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXLtuGQZTwz6H7WJIbuI+B6ECumPB4yWYzLP9/kEFFyTJod6uRygBwIPzAk0pH1hy
	 KUVBFn4pords84xFCsrMJpMwMMg9S5ZjPcKZx35+MadWxP3RsBzVrPhgKFAqxlunr+
	 Ftiqlr9hDS+e06D96LRxz8qUllFk4y4uogqWOLrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/272] io_uring/net: punt IORING_OP_BIND async if it needs file create
Date: Thu, 28 May 2026 21:50:07 +0200
Message-ID: <20260528194635.690543255@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0b730c3a7de46..94b6a15245afb 100644
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
@@ -1785,11 +1786,29 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
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
@@ -1800,7 +1819,12 @@ int io_bind_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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



