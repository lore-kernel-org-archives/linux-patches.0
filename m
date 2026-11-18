Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032052;
	b=O6QcZ/uAlliuNsG8uTiSpCyqGEKutA0529DyOzzrwhWs6OD8gWta8dRwFNu62RxO9m5W
	 uZ0vVgIi/mz27SztVwBEdRWyt+GrH7pVBehcFeLA3q2VWV26UQDuiKwyK/qq/dmHjbae/
	 BOcK5amwfiBObigA4eFlykswV+QGiUaYDps+X48XihavXt95tk+1LP3DrJV07YsRMNeU1
	 IoGHNdCpTeTH4wfqFviM3bAb+a8ibbtQ0uFUnF6MnCyl8RCdkie0F1bQqjeOES+R1XntC
	 3fB0jGgeawUA/xblc4fTSFR6WfIO/CgeQL/tvzHohGrqYJMcc/KAmMVtwURVi6tci2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYI/QiYeyxFSfxvo0qhFTitHAEjMzmLehT4g2nCTZBM=;
	b=sdHfkjUT/FQ+wNfaLPIZd6AkuuIrA5kPRNmIS3ebQheInaEKJaqvKMqvy2A+Tky/DAm7
	 IRrlaZKeq47Ywqy8kJNDPJvPO4SM7/3gAiNe8pCQ/dvSl2+UyE1/BnjT4h4bF7md3t/zv
	 AA3/7yICZ4xVXqYCY3A9C5q2OcwCA+irht71T0k7QTg5Drs+A7Lrgz3OhjsT86J1w3cdf
	 WFh9yXpYklIRa7YFcmDI184DXr0md02VjmxgNyWl2V9l7EU209lktW4aRKjvLNeEKW+Dh
	 1WAfwXUHejgOzG6p8XZ3yOoXzvT65Fj7C7WaXL89jdV4xNKMD8fQ4hE9A1MCLceGsGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4d3CbdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6B160A260A;
	Wed, 18 Nov 2026 20:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4d3CbdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69131F000C4;
	Wed, 18 Nov 2026 20:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032052;
	bh=AYI/QiYeyxFSfxvo0qhFTitHAEjMzmLehT4g2nCTZBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4d3CbdW9xhssG3fUhUftbLboy8gd8Jbv/zINpvJqW2nTNR+qvv2g9iBCWgVK1pqH
	 SfaG7FypEf5jw4V7Ga+BIlbf24eMHNOjZZtutyTBGUlo12LPQCJI8770g5UQo8ns5f
	 8yu+OtlxqMBTIITCry6jH7Syi6Iy7jLPvfuV0vIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1274/1756] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Wed, 18 Nov 2026 15:56:41 +0100
Message-ID: <20261118150100.329717088@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 33afe9909f213d8bb8e80f0b93382dde0f56e2c7 ]

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152426.3259522-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 818f1693bdec7..fbb6fb31e2760 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -781,6 +781,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;
 
+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
-- 
2.53.0



