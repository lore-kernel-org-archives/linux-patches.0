Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021118;
	b=gLARRD22KOnMc0GNYZM+yXRagK4AQ2sGX7jRFuDNZdR/YyQ+mq85IXcCkI4e7ljrTu/B
	 g5ZP5bsjwAhSA2CZE/p+dJWH8RDAC6d8Weu13bKDmJXGodeQoFFU3JhHQjPCkLMlVMXbj
	 kxbnliEWtOqCD251rEK/u7cxAAoVPyvkYrBT1j8eF63oVryFTr0ylyfxNOxNMRblxUUNI
	 iVJmKT6/vG8wB0sq208nKQglOQB/m7n27zbXzO9rM83hz/4GOIxZ7bVcTXrryjuCdTogS
	 jwwLPsxnTyGVSJBKRAfQKQi2TeH0NiQkoPPio3MKaUXcd7KVUZ3mgblJ5s0lKfBtlEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bE7RsI+ohfVjyWeK3Sd9zgnAl16wsEnmafKE04OUL1s=;
	b=f0NPF9VzMCvOlHohAbgFnamZpTyV/sJTPBal3HhSWa18FLKTWZSwKTEud1iV+TvVm++t
	 TPs2bbkNT0yfLTa7g6ORELi7QIXSwYYt0Ak2pO2wUIjE+B8CQxUOmrMpCjm5tq3Q1dgRF
	 B+OqxxuvLUXWc+pq5tZr2cgqP0iU85TVksLUbX7b5Rcxut4DtKP5F0oocgGDBwqCeAWEB
	 uk4aVsP67Rk42OVvErkXgQCCmqmYp+9/qlq3d6kEZ7zzZLbTXpQKr8Ejf8FNjrgxb8tZ9
	 rBZiN8OzaR9gYzX7tsS7e6v94qZxcVeKXE8nP7QsxHVJxhbv15eSRQaAYD3fG1jCt7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nta91Loa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8182B606A320;
	Wed, 18 Nov 2026 16:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nta91Loa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69D91F000C4;
	Wed, 18 Nov 2026 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021118;
	bh=bE7RsI+ohfVjyWeK3Sd9zgnAl16wsEnmafKE04OUL1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nta91LoaYraQnOsKITgxSRNHwVG87SOY33srquwaWXAhhM8FCnAvzJSxC+aKsQdSU
	 W4qEWcsdhFDgZ+8EOdZMD7MQjeWP6fJmGTDPsjlLnFtJ1+3cwBnKh1LDtL3j/WJzho
	 w6FC6eZTfV+MANEn6rG+BgxdqTpAA2K29T25LtAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2194/2651] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 15:57:14 +0100
Message-ID: <20261118150404.722342256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 1653b2747f5ff..6d4857d1c0640 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1315,7 +1315,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.53.0



