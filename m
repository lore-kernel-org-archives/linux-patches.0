Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308FB3B19A3;
	Wed,  8 Apr 2026 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673650; cv=none; b=B/vmREfuJ5YtAesBjWAq424wF7Za3bHVfH/XEwgknhPg2bw8MYDRGIK/3vs2ZcgfUUwCCizdoh7VDgqfGQBbaKxehqT4BCbdQ+75r+f4k7GWpx3uMS2s3aEQeaR+0Duz4hK0AVKLHwXhBPXypgbFyJyJhZRDZCJ1pzaWZgVlx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673650; c=relaxed/simple;
	bh=NfuHaBqN+p/Bi2jvX/EG70neYfkjI0pHC/JJbR7iRVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boP56WwkueRnBJNN/wJtJAnNHS/Z1Z/ldsfpWO+kmDjnu6u7wvd7Mdv4Ct0fK3briWKjy4Qfu0RBa/YyfcVjaMooAfiUZcyeuG/A8S8QDjMx0sSkwXboH1kMS3/RJPRYr57UO73+7YSs2Z1jo06pdFECNzvTv8dZ30qI7Hy6bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IV/BPkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IV/BPkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEAAC19421;
	Wed,  8 Apr 2026 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673650;
	bh=NfuHaBqN+p/Bi2jvX/EG70neYfkjI0pHC/JJbR7iRVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IV/BPkEPfc6x1F7edSl4/feJ0j5PgUkk4p4q6nRhiY2FX8zvHORHBRY45VV9nuqv
	 NqEgrbs1eB3kBZ5YJ2BS1u3apQmIhJS8WAxaVGD41xMPjkFjSJzhZKvoN8w0LtzQ5a
	 TeRha857s00PXUe6oW3OTF9/sqjniRHSPWMk78AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 005/242] io_uring/kbuf: open code __io_put_kbuf()
Date: Wed,  8 Apr 2026 20:00:45 +0200
Message-ID: <20260408175927.273495258@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit e150e70fce425e1cdfc227974893cad9fb90a0d3 upstream.

__io_put_kbuf() is a trivial wrapper, open code it into
__io_put_kbufs().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9dc17380272b48d56c95992c6f9eaacd5546e1d3.1738724373.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 -----
 io_uring/kbuf.h |    4 +---
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -76,11 +76,6 @@ bool io_kbuf_recycle_legacy(struct io_ki
 	return true;
 }
 
-void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
-{
-	__io_put_kbuf_list(req, len);
-}
-
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl)
 {
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -81,8 +81,6 @@ int io_register_pbuf_ring(struct io_ring
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
-
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
 void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
@@ -205,7 +203,7 @@ static inline unsigned int __io_put_kbuf
 		if (!__io_put_kbuf_ring(req, len, nbufs))
 			ret |= IORING_CQE_F_BUF_MORE;
 	} else {
-		__io_put_kbuf(req, len, issue_flags);
+		__io_put_kbuf_list(req, len);
 	}
 	return ret;
 }


