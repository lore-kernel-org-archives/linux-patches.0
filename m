Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826865;
	b=0VUIF8nyaSX/zb0z6Gy+SFxtEHy0A14VD3OqhtHPJ6/n/LZ97dYWdArZrza5Ri/bpH6V
	 xNIGIBgDZ/1rZ1cUhUMQ73D4YPKgNXIBNRUq8WvKyz6/E1R9HE+NpCaGQp46HvR3GUr6u
	 yWBxaGBFuTT/294Glo7G+8r3iN/O3vdz1Bm+s4cpQ90+WX+c/Du7JwHuYZUF32foOFrGT
	 XiSTXwCUmhYqwnkNoP/3EMrDvBo3kiZ15vfsX3z1Y4XDWdzLzlt3KxaKH8fTA/NbO+z5F
	 6smNSfpbjIjWh3p7/SP7qmJ3/PxLVumuqyukVV+RDbrSfK/ypBn4CT6eZxkwUacep4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5eg4ezdJHVlmXuIt6uFV2LFfKT6SVQONdRrxoBfAOc=;
	b=YpMWtvHSmr+OzCFCSOp3HZHREs51acmY8dk/ORmqnP4zLQ+6syr9JpfCe+rdJajjSM1Q
	 B3I6cBb0Ksw1FAfFEwVPiRxOErwd1Q98+caXGmi9azv0Nt7lNQ7n/fY+2avnF60ZOgH7X
	 BTk8lRI1ZrCuGCPijjpBwawUfruMHxDlmawuUENxQiESn0fVf8zLaS+lQT2RUuIwBuqng
	 ns8DDxWM6A47+QnEbFMJcOtp3+OnsADn91gKmIsWVVu8AGOHWFPb+8R/ZMehm6fymJRAC
	 OkzIzD93QaBXi5S3M0BkQDvWAj+H75g7ayCY9J3Ntibcx8jc9UB+wLjjtPDMJI+QTeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6w25YMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112F6070434;
	Wed,  4 Nov 2026 21:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6w25YMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DBE1F00A15;
	Wed,  4 Nov 2026 21:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826865;
	bh=u5eg4ezdJHVlmXuIt6uFV2LFfKT6SVQONdRrxoBfAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6w25YMkr436sP3494XZTD08K53pYKdl01bVSgrgHNbShuRl41qFs+Y0AmGeX5fMm
	 J0NIbG3dfBD7rJkRcVcVSjnYJCjjNbw4PZl9BPSr9utqXRRih4GP7uYHNE5kNP41Qg
	 HHGJUdS28HDnlDW95XLNcnsQnj5tcBUJG62aooKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 018/547] io_uring/cmd: dont leave list poison in ->hash_node
Date: Wed,  4 Nov 2026 16:03:22 -0500
Message-ID: <20261104211038.890228285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 4c83e39f4d1944d7146fd06094f2c8053238d55c ]

io_uring_cmd_del_cancelable() uses hlist_del() to take a command off
->cancelable_uring_cmd, which leaves LIST_POISON1/2 behind in
->hash_node. Requests are recycled through the request cache without
being reinitialised, and not every user of ->hash_node sets it up before
it is used:

If a vectored futex wait is woken while futex_wait_multiple_setup() is
still queueing the futexes, io_futexv_wait() doesn't add the request to
->futex_list, and leaves the completion to the task_work queued by the
wake up. io_futexv_complete() ends in __io_futex_complete(), whose
hlist_del_init() is fine for a request that is unhashed, which is how all
other users of the node leave it. If the request was a cancelable
uring_cmd in its previous life, e.g. a ublk FETCH_REQ, it writes through
LIST_POISON2:

  Oops: general protection fault, probably for non-canonical address
  KASAN: maybe wild-memory-access in range [0xdead000000000120-...]
  RIP: 0010:io_futexv_complete+0x219/0x420
  Call Trace:
   tctx_task_work_run+0x804/0x950
   tctx_task_work+0x71/0xa0
   task_work_run+0x118/0x200

Leave the node unhashed.

Fixes: 93b8cc60c37b ("io_uring: cancelable uring_cmd")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-2-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 726a659f38c38..3baf6459c1c85 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -87,7 +87,7 @@ static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
 	io_ring_submit_lock(ctx, issue_flags);
-	hlist_del(&req->hash_node);
+	hlist_del_init(&req->hash_node);
 	io_ring_submit_unlock(ctx, issue_flags);
 }
 
-- 
2.53.0



