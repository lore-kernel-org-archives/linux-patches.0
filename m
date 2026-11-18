Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027445;
	b=kJvTlKSSjcAz4vopfW3bmr+1XTeilMLDtyfZvMCz2nZRiTv4zUTyn4gF9Ap660gPVyz+
	 4MaswjzaD6jV+Czgs3vnWD+sKfP2l2jTor8hyy23FCaL46or5DrOVBgvy3YZUXG3hAk5E
	 FnNcGkXNIzY/r6Gp4qP4wD2lSK/0EuI3zefUC8aKcHgR1N6kibm32BN+ekd3jICjX1WEA
	 P4fefcIsqQnlKEi5fLFA+JUp630R1SIb7Xr71doKyn4mhHfPeDkW8dfohhdMI/VRe9Cs/
	 lNOxoQOiImt0CzYhwSXeBsRUAOA8/Q0maXYQEu0OK6ZDYggQExMZ7VlHrSN8nMXyiMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mgm/QrgurILumos4PdyHq4iB39SMqVNWjuFYM6a21t8=;
	b=peLQ4TBoEjif7jyXKyLsU7+yR15pAte5ZdVulQCVf5C7LW1xgFxbPLEWqpUVcr/WBmP3
	 fsoecc2Lo12JYJDDcg410jZi5XExm+88WUiqqPKCMPE5IpUJjsp/GsFNP63Z50ky2DIMG
	 0xKKz4v1Qh6i7rnw2/PdSX4HPJZf3lV/L2dLFTfblvpQRH/JQBDrogl0E+q0iChxr8GPZ
	 d01MGBkh5x3SzWR/Cg6iXw+fpkpk3X59Cg+6mbEsLKYIBpKW7Q2ce3xCM1H27mRkrBbEv
	 IyVnjhTG5kq9S/ZsAJQHti+LDnfzezfaM3AX7w5m+ls5tFOt0GM56aRFog6HfZHa5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14LX196q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C81606A33E;
	Wed, 18 Nov 2026 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14LX196q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F411F000C4;
	Wed, 18 Nov 2026 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027445;
	bh=Mgm/QrgurILumos4PdyHq4iB39SMqVNWjuFYM6a21t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14LX196qsCQD0hABQyNVleErxjlmrxlLAB+6cyGx4w5I4d+HMWYuUv3/I/A6Z1i0Z
	 woxwNXlOKfLN8D7lMmSxfgB/GGJdQlrWGZnxCCqWqhuf2UWrz+VS6xHnulWzbi4Phx
	 B7qgPvkJ7aHyZRMvieKxmrhm2Hmsk6St6qx22mmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1793/2151] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 15:58:48 +0100
Message-ID: <20261118150227.130427193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



