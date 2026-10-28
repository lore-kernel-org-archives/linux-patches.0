Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207287;
	b=Lc/wL642OpufaJJYmmZPOO+/xMjxEaFg2Ud+pcwt+zYrPL1A5qQmhVGVF5n0NUjNvgea
	 dPaSzLi9b33I4cWP6c8EOKCrOrZDxOxR7R+WM72aZJd/g8wo3k0HpaK4wgCUeRHAt9ncj
	 p0sCB1tccjmftkK5A1mq81DegmtTBuUAeoM7lkriCgrnXqRHKA/Z+rlwK3Is4fUaPpF58
	 TAq1f3FNnnaT4zt1wiAPuBYzkzKU5HVhQAfZSf/fKHjAK1Y65HyRw/IeZPoQa2wLbJeRC
	 LUvIhHDP3twgYWkPBdRJPHgEff+srxYLRl+y8n+xZkdv8HmIOt2nmg7q7OuLK1utCuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mwCgkaQIA6R85TggSB2ISxWvYsUHx/uLFiDAAlOCfqE=;
	b=SjhYoDuJ6L2cFH2RCV1i7rsqtb478kedk0ZVj3cI1at2fj8anOJdN1GWdWOgYN3NUlgm
	 1ZqYXdgDhe8orbIn31S0TCdtYB7lW8BywuFJEUiiw2S1s4TFkfOxSU7IKt0c+c3/Tv4k7
	 UwewYeEk9zu+O5Ee/Ob+h0xtgCOQWRxduMWMQAs+OwhjGbngXibkFcVjDLhEuB9Iqsfn4
	 dTnFGrVEeRes2R4LeqZIidNrBZP1v0s0sEySjq7bK3S1p8Do1QfWnpRhjcSnIgUZlen3w
	 ZjEmH1NqoITG/YRS5rjzcIg7jkbr+NSlSMyw64rVd/TyYTVVz8lJTvm/1bV+OUunNpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRf45HD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB11E606A31C;
	Wed, 28 Oct 2026 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRf45HD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D51F01825;
	Wed, 28 Oct 2026 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207286;
	bh=mwCgkaQIA6R85TggSB2ISxWvYsUHx/uLFiDAAlOCfqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRf45HD5qPOn0oGiF1JLwGObYD7ZCTkrBTE33ORvfGV3VVHZ1RtmCLgPUsu25jXll
	 15kskiT/lEllVejwvmOfb2qDbzT7xe43q7SepgRLEXgxX01JndGXwRBQ+SLqZkqRYV
	 1NEJZLmNhVHBJDI6SIHmMv4Q4htoDycxivfeqpOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 51/88] io_uring/zcrx: fix buffer offsets in areas above 4GB
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028165943.313307771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit ab4536bf2e5617b04f2d9396f06393c7bbfb071d upstream.

io_zcrx_queue_cqe() computes the offset of the buffer in its area from
net_iov_idx(), which is an unsigned int, so the shift is done in 32 bits
and only the result is widened to the u64 that goes into the CQE. An area
can be up to 1TB in size. For every niov beyond the first 4GB the CQE
points the application at a buffer 4GB, or a multiple of that, below the
one which has the data. It reads the wrong data, and then returns a
buffer it doesn't own via the refill queue while the real one is never
given back.

Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-35-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1474,7 +1474,7 @@ static bool io_zcrx_queue_cqe(struct io_
 		cqe->flags |= IORING_CQE_F_32;
 
 	area = io_zcrx_iov_to_area(niov);
-	offset = off + (net_iov_idx(niov) << ifq->niov_shift);
+	offset = off + ((u64)net_iov_idx(niov) << ifq->niov_shift);
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
 	rcqe->__pad = 0;


