Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EE443D504;
	Tue, 16 Jun 2026 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623860; cv=none; b=jjtUPlN65LHmpCYVwIt/FQS+loYgudUrphVdJfkTrBuBpO4zFR7kpyFS788hosNrSnMhdeTc3grCc1MiEKyqi63Yh3ALjlTHadKdirVCb2yhJsh8diPKf/5b9rZzcT7zwyle3cp2W6QhsSfgK3ofKVOM1ZkcHa1q7ZYs7g8DAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623860; c=relaxed/simple;
	bh=MYxyCFKfwjPeP5M5WfUFM+IEnU+UrRKjJmd6d59vtPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WOs6WS/1okd5NmjmKRsyPZuMH//E3y1Bzo9AUMMtLR2Ww2DNKDAChNaqScoZNBjgXqa4F+YUkq/ec+6we3tV1zmHxdjOx0rFturZpEa5JtqX86vKuyc11Vw7YzGdwLTpTEt4Qq0FJ8bOOMWmmuSDneS0Ym9QuT5qfU/9qEevKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsdwAKib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsdwAKib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7B51F000E9;
	Tue, 16 Jun 2026 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623859;
	bh=kiM+mOE/zcE0fm++HUR0TUNCJbVeQX+Kux64e7lU8II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsdwAKibKcYfaKjvGgoDCMxp2fuZCdJHCBesKjrxGOMOaCjJPvCVqnj7+WaEk612U
	 WK94x0fohiu3Anj3eDqmlsPM4IPJvrRAa1vdQxoNnOF4HizPKNaKVMQ0sdLRqe1t2Q
	 sKFAO4umhYfYLjkicCRI8QmQJqAT+JwMg/ZI+k8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 215/378] io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries
Date: Tue, 16 Jun 2026 20:27:26 +0530
Message-ID: <20260616145121.656894506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -838,7 +838,8 @@ int io_recvmsg_prep(struct io_kiocb *req
 }
 
 /* bits to clear in old and inherit in new cflags on bundle retry */
-#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE|\
+			 IORING_CQE_F_BUF_MORE)
 
 /*
  * Finishes io_recv and io_recvmsg.


