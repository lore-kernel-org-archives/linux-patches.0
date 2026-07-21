Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011E401497;
	Tue, 21 Jul 2026 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654783; cv=none; b=p3mGRtc1BsbpMmCknUfDS5UqC4WMFrIGUVotxJZZFgI914uOKpUdlS9GWvMy/ZVbvqg270RZvv8Kh2x8sFxuJRRCt36GwK0S5GQbxpbjC+CzQutixM20hfpZlyxD0LULHvyBcO3OPicqJ7Mf25HxSwRX6M31a5ga8r3D1wGvchE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654783; c=relaxed/simple;
	bh=uTQtjHbxJ4uFESZzREecPCUJBBTj3joRA07Djbwgvkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbWPS5Zntmr0fbtoqADBiFR92HlXKcnEVoDJYfPOkHSiBwPZHb9SSRf3F/91IeXaHAeIJwzpkmstha6AzcPDcAnlFRLbvHtDCf2/VGQyBnsla7scpsQ0EstTmifCC2TEzX+Lbd6CKUVLjuZNE4koETPWwXaMZPY9BKnyLQgojUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcYzjILl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcYzjILl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735151F00A3D;
	Tue, 21 Jul 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654781;
	bh=rDYa4RjTFLdnP40rpwIpyXjXb3Vh7tlb/djvdFwGSIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcYzjILlcQpMaygTQjGXPI0s3M1JPuYkt4q+x0X4U/7Gf9pBxLFMCkqGkr7y1VuLm
	 le5njuDSB/G9PLgfLZFdqrEWJ2btaqrxEa94e1+4hnP7Vg4LC8cnqGv3Z2tk+Q/2ik
	 dWiszLPeffI9UTyRiviOIGCFrpXfd9e10sSkbsQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woraphat Khiaodaeng <worapat.kd2@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 1834/2077] io_uring/bpf-ops: reject re-registration of an already-bound ops
Date: Tue, 21 Jul 2026 17:25:07 +0200
Message-ID: <20260721152635.997684226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Woraphat Khiaodaeng <worapat.kd2@gmail.com>

commit 3afc64c61ce906a04f073ca350b46de10e8302f9 upstream.

io_install_bpf() only rejects a second registration on the ctx side
(ctx->bpf_ops) and sets the per-map back-pointer ops->priv
unconditionally. The struct_ops link path never advances a map past
BPF_STRUCT_OPS_STATE_READY, so the same io_uring_bpf_ops map can be
registered more than once, and bpf_io_reg() re-resolves the target ring
via fget(ops->ring_fd) on every call. A caller can therefore point the
same ring_fd at a different io_ring_ctx between two BPF_LINK_CREATE
calls.

The second registration passes the ctx->bpf_ops check (the new ctx has
none) and overwrites ops->priv, orphaning the first ctx. Teardown
(io_eject_bpf()/bpf_io_unreg()) only reaches a ctx through ops->priv, so
the orphaned ctx is never torn down: its ctx->loop_step keeps pointing
into the struct_ops trampoline, which is freed once the map is gone. A
later io_uring_enter() on the orphaned ring then calls the dangling
ctx->loop_step from io_run_loop() -- a use-after-free of freed
executable memory, reachable by a task with CAP_BPF + CAP_PERFMON.

Reject registration when ops->priv is already set, as hid_bpf_reg()
does for its struct_ops.

Cc: stable@vger.kernel.org
Fixes: 98f37634b12b ("io_uring/bpf-ops: implement bpf ops registration")
Signed-off-by: Woraphat Khiaodaeng <worapat.kd2@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/20260717154537.129736-1-worapat.kd2@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/bpf-ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -165,6 +165,8 @@ static int io_install_bpf(struct io_ring
 
 	if (ctx->bpf_ops)
 		return -EBUSY;
+	if (ops->priv)
+		return -EBUSY;
 	if (WARN_ON_ONCE(!ops->loop_step))
 		return -EINVAL;
 


