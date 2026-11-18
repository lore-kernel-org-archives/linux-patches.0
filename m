Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032469;
	b=ngP0OOSl/fYKX7tiEyqxlCZPeXIjRnXTGBewl5KZvh2PyirVILjF0N96ATAZowtxPkT9
	 r3tOHXpvdS/grDkG7E3Ypo48RB/rDy27FZzRw1RlwV5yUh91dPQ+d5vqIkVFnzThPHyDo
	 AIBg5kxZep9l/yqQ7mK1RX6TXKfHlch+c3CqHIElk08VEwa9hP0KBIGmQ0wo7YCUucUAH
	 xFgvKHwobNwcdImgds/6dYtcwwLU2FB17Fa+66ZR9ZKNCtEjzz8PVDuFuXSJKZfzWQ8cL
	 dFxgTF4en6WkfeV774UY5scVQ73Sl8nvrBpY1H4oHYcmOrO8pTfK+ALfSg6001P5oVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxZcM3pOQyC5+ao2+7N5zrXRkE292uQppRqgtnhlXe8=;
	b=1RPbf7zkq2VZBfr976cxengMVP8aeIO0k15LqZkKhm3erqLxdta4lAO3ijsNr/R5ecWw
	 g5q29RrbgzGw15gktei4bmy8NjeFYFsfQElM2VZFx9YsjsLNmp0rjn0QRo3IS0vSKvuBw
	 y9jERgMHYHpOVt3GTpcYxtslEdQrCzsDlbu/pRsjO7apzsrl2Z3A/vp3CedJZtGFCHs9z
	 qca748zn9zvRFXkHc4pm7XaNw1qwdpo5IAsqEdifRzgZjhs8gKju01BXdGq/Oe0co8z6u
	 kiPo0goWNcAxKFoEn4bYDHNursp+DPipLMfYAf3RxiEftBjfsBGZpLbmWkTwJrWmiLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvWJXQn2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF58E606A33B;
	Wed, 18 Nov 2026 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvWJXQn2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B99F1F000C4;
	Wed, 18 Nov 2026 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032469;
	bh=oxZcM3pOQyC5+ao2+7N5zrXRkE292uQppRqgtnhlXe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvWJXQn2X6A/HYgfd1729R279uCJT0ZLwkyYI7hKgoK4b9Z4OBlGBViHiD0Nq9OWO
	 fzw0j+PqLzGGSkrMfDXi3hXKWzzY36mEmTqxfFz4OZiLJWoqm/Ldr4A1GR9y2c7EtQ
	 dAQUG418Et06WavhBcXekIQEsjP10qoBlBk0+wRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1424/1756] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 15:59:11 +0100
Message-ID: <20261118150105.851443050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0fe31052d948a3a993bb2f58cd5886f7ec279ea7 ]

In copy_resize_cqes, the destination CQE index is computed as
(i + 1) & cq->resize_buf->nent, but resize_buf->nent is produced by
roundup_pow_of_two(), so it is a power of two with exactly one bit set.
Masking with a single-bit value can only yield 0 or nent itself. The
buffer has nent entries, so valid indices are 0 .. nent - 1 and nent is
one past the last slot; whenever the masked result is nent the following
memcpy writes one entry out of bounds.

Use (nent - 1) as the wrap mask instead. For a power-of-two nent,
(i + 1) & (nent - 1) is the correct modulo-nent reduction, keeping the
index within [0, nent - 1]. This matches get_sw_cqe(), which addresses
the CQ buffer via n & cq->ibcq.cqe, where cq->ibcq.cqe == entries - 1 is
exactly the nent - 1 wrap mask.

Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20261019050503.2313-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 4f25aa8c72fd6..8e8983e6099bd 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1262,7 +1262,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.53.0



