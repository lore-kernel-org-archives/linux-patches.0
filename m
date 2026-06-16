Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29B144CF44;
	Tue, 16 Jun 2026 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625805; cv=none; b=idIXbPStQ9WiXRf6+KZCCwW6XtTQ4u0/u/wx5kG/xBEBflgq3skScsLy7suikknRzc9zSKHkUsgSFalRX5BzWM3ZM2pqgotKx9nmk3HW/F2wLXxkdwCAyXNHUrZTKHAGXAmBWWIXUr9+u3IvfO/n4RITqUIHG9aEqBVPiA8HCxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625805; c=relaxed/simple;
	bh=AHv0ghWw4GCIo+Wz96v1LZOCwgD285s/CwkFI3BirhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1dCH6yC20/z2fo2GQD6iwZhW36/iq1xEeJdF4kcaIJ83u6kLNmyujbDk9CpJ32GKPJ1BTaNxSYC19x5fDfcb2xEpaN88SDeacJ2El/txFXeo7iZTq/P2ejkTEwwQw2R/xTiKnNh1yjIS1YxWKVsekx7bUbONI8+/TtOrTO1A40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzXXGKKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzXXGKKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37551F000E9;
	Tue, 16 Jun 2026 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625803;
	bh=8uI3ZYpTOXry6+dOb9LJaLV0dmUuJRtLmjKuJbkP5+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzXXGKKpR8KPbtm7Rfnn8RuB6SLZI6bm8NMCIK8X21mnilFTZeNAO4USMo3UFGwIs
	 gVX3catPAmTQNKr15WTc83A98f9W1m3yjHoZRa5zAe4hB/1x7Ilmf/NPHyzbNdaWg3
	 nlsbvny5uCgK4xm95b3Cmk7HtHLeYpaA96XRsuQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 180/325] io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries
Date: Tue, 16 Jun 2026 20:29:36 +0530
Message-ID: <20260616145106.846400018@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -839,7 +839,8 @@ int io_recvmsg_prep(struct io_kiocb *req
 }
 
 /* bits to clear in old and inherit in new cflags on bundle retry */
-#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE|\
+			 IORING_CQE_F_BUF_MORE)
 
 /*
  * Finishes io_recv and io_recvmsg.


