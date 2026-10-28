Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216777;
	b=M25/tPT2Gu/1Eba+cKT83DpQaX1DUVsmDDbgY/+ur+oFG1afqu8aCCfnDi6/BBtGtI4u
	 j6JkWOXtV+/D4b7fMpGzn8mQL83TC0iShWqgvfuUvHzf1C6Md86UQpdstWEWVMBQy/T72
	 KL+3y/6wBFiigp+qzU4snLoyu8n3Md8o5PXSLIwPWHLdva6dFOY4FP6k9pRLsUYIMwuE7
	 CTulMMUIJ92fl0RaSqoeUigva+sJZJHLqs1XcugQ08kCTyVHse67Ii2K7/PCFfXYgrTPY
	 X+oGHvPqu1NZJRv03U3kcG9LCcDJasM/IC2TG6k3jEozSG6bfI2hUKno+LwvHZCEV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T6A1Ij73EYjZ0xoD4efrHM/TQX6IIkogsum697dQEks=;
	b=VbusTHplG2iZ/y8tDMgu6E1Kfx0EZbZM/4q4udummBucqfSg9ym/dz5dcqIQP3DbzWyC
	 HmYGK0wODyDA9geoJ93FpnfF6mEVFOP000gqkk3pdN3SDFvPEk8BbXWg35jPSjKM4DrYe
	 CHCtlfDmW8MMKwybAn+XdZMfDhjUznWFzGSpl1NZtrQBTvhn9MnxPk++8J8564Zphehel
	 DElQl7HtfON0RhsqTddM2c0+dB1Je+h0y+ymvCeBmMthkbkz4KyoVUud83eQcRzUZWNAv
	 X6jBRZQNES6fUC4EWNt2wDePyTN8MfvWdDycugGOJAFzBA+UX9rm8x1PSVu8Kt2W35w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNtGChKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63E606A31A;
	Wed, 28 Oct 2026 19:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MNtGChKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B2B1F01825;
	Wed, 28 Oct 2026 19:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216776;
	bh=T6A1Ij73EYjZ0xoD4efrHM/TQX6IIkogsum697dQEks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNtGChKSStaB3XAgXpLHN5l99B90H5y/xSe3TpGMlbsvEX14ImXmkapQGeDLkv4Su
	 NQrnyektoMPiA9umAHRlw8Z0O8frTCsCF2EhLUd/H9RmdfDBkYVhWk2WTSLAQ7fvtn
	 2Ld6d7uJdED5EarKHIgXKqKdW3Qhr+mSmuaxgc3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1674/1887] RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()
Date: Wed, 28 Oct 2026 18:02:50 +0100
Message-ID: <20261028170537.551047414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4fbc8230009f5b1bcd13cc74c5a6a43ddba141fd ]

When __rdma_counter_bind_qp() fails in alloc_and_bind(), the error path
jumps to err_mode which frees the counter without decrementing
port_counter->num_counters. The only place that decrements is
rdma_counter_free(), which is unreachable since the counter was never
successfully bound.

This leak accumulates across repeated failures, permanently preventing
the port from switching to AUTO mode (-EBUSY in __counter_set_mode())
and blocking the MANUAL→NONE auto-revert in rdma_counter_free(). When
the mode was NONE before the call, the MANUAL mode set by
__counter_set_mode() also leaks since the revert logic is never
reached.

Add an err_bind label between the num_counters increment and the
existing err_mode label. It decrements num_counters and mirrors the
MANUAL→NONE revert from rdma_counter_free(), ensuring the port state
is fully restored on bind failure.

Link: https://patch.msgid.link/r/20260520104546.1776253-2-cuitao@kylinos.cn
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 8cbca897fc531..78a76b4fa6f68 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -190,12 +190,19 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 
 	ret = __rdma_counter_bind_qp(counter, qp);
 	if (ret)
-		goto err_mode;
+		goto err_bind;
 
 	rdma_restrack_parent_name(&counter->res, &qp->res);
 	rdma_restrack_add(&counter->res);
 	return counter;
 
+err_bind:
+	mutex_lock(&port_counter->lock);
+	port_counter->num_counters--;
+	if (!port_counter->num_counters &&
+	    port_counter->mode.mode == RDMA_COUNTER_MODE_MANUAL)
+		__counter_set_mode(port_counter, RDMA_COUNTER_MODE_NONE, 0);
+	mutex_unlock(&port_counter->lock);
 err_mode:
 	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
-- 
2.53.0



