Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF1477980;
	Tue, 16 Jun 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627466; cv=none; b=pnv2fWUelfKq9R/dUbwe0OjHFWIVXQZRWNQf2S6AMr+YvB4aehJMsmo1cJ5NDk1nkguKH0niU1sl6YmHTQmHCyy87/jUCmFaaWKlqXqskC523r2OqaiHnW3NxI2Jf/EwkiXYG+MHxCvXbUssl3I/k7ZhWOkm2vG5JX3r7aY+kBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627466; c=relaxed/simple;
	bh=t02FDf4cGRE0UpqCNAtIXu6zQ6k7kCh6H34l2P9JK/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMVGfJUMiJhLzIh/lI8BY+kUWYUwX7+am5W2g9P1N0JrBKmth+QkrFH9TtZtLwcYkTSzKZejVVfCCAfRON1xhFgZ4KLGeqxpgHXs3hMJWZq8qJ+ucSu86vZnZi8fIrdVuZaR9znaekyHc1jRHTmYTgmiyAM+Ixpz5As9mg0Fuig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b2bd1RL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b2bd1RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC581F000E9;
	Tue, 16 Jun 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627464;
	bh=+Vo3kvA+LCyAp15OueHKYhO45qlsxrM3jnTaBQrLHO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0b2bd1RLt/jsDRct9FZrCOALC0vn918KtIdAhaoVi40eOEvycXBQrnllr271wloj9
	 j2KmYWQ+UE/pIb6gGbgAYoJkEXsH8mc304u+qz4SRQPdmsKNYKEeKbYheYw8C8Bmf/
	 OMAPbtzvfFVq6t6Ey1foqOSiVzcz+L/zM4UtmudI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 145/261] io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries
Date: Tue, 16 Jun 2026 20:29:43 +0530
Message-ID: <20260616145051.799201493@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@meta.com>

commit ed46f39c47eb5530a9c161481a2080d3a869cfaf upstream.

When a bundle recv retries inside io_recv_finish(), the merge logic OR
the saved cflags from the previous iteration with the cflags returned by
the new iteration:
  cflags = req->cqe.flags | (cflags & CQE_F_MASK);

Bits listed in CQE_F_MASK are inherited from the new iteration, and all
other bits (notably IORING_CQE_F_BUFFER and the buffer ID) come from the
saved cflags. Before this change CQE_F_MASK covered only
IORING_CQE_F_SOCK_NONEMPTY and IORING_CQE_F_MORE.

When using provided buffer rings (IOU_PBUF_RING_INC) with incremental
mode, and bundle recv, io_kbuf_inc_commit() can leave the head ring
entry partially consumed, __io_put_kbufs() then sets
IORING_CQE_F_BUF_MORE on the returned cflags so userspace knows the
buffer ID will be reused for subsequent completions.

Because IORING_CQE_F_BUF_MORE was not in CQE_F_MASK, the merge above
silently dropped it whenever the final retry iteration partially
consumed the buffer, and the subsequent req->cqe.flags = cflags &
~CQE_F_MASK save would have left a stale IORING_CQE_F_BUF_MORE in the
carried-over cflags had one been present. Userspace would then
wrongfully advance it ring head past an entry the kernel still uses.

Add IORING_CQE_F_BUF_MORE to CQE_F_MASK so it is both inherited from the
new iteration into the user-visible CQE and stripped from the saved
cflags between iterations.

Cc: stable@vger.kernel.org
Signed-off-by: Clément Léger <cleger@meta.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://patch.msgid.link/20260604160715.2482972-1-cleger@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -846,7 +846,8 @@ int io_recvmsg_prep(struct io_kiocb *req
 }
 
 /* bits to clear in old and inherit in new cflags on bundle retry */
-#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE|\
+			 IORING_CQE_F_BUF_MORE)
 
 /*
  * Finishes io_recv and io_recvmsg.


