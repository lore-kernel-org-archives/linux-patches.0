Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041730;
	b=fViGSW+tRzbQTyEkuYsirjCoRh3+Bl8Y7UZEHK3dPOB0GllBRfqBTC1e/8GPp2d1xv89
	 gt7j925fFODKtdgF7Gb74mUrFy4U9Cc1HpEDrnddF9h7pgfjFKtQ1x2Pr1f5IH3kJ1SIh
	 MhSHJSRpgJ+XIFTetuSTicHgufhhTKPoP+q54qQR4iKPZ6SUidcuav6rDckcKN36mCVnn
	 /gdyuNVEXnR4f0E/7shrIBCwmR37LKCHItkXHPDAXW/L55mxtOPwDSE8DLSjZ6HVA8bjo
	 yh4oM+GUk7Njs6+3GyWTcZYj69VwNRBbKyR5ItNj5RJ6tysIcQRnN8InjKc7f87ruZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6mnfSlnmeAYLKvqDp0remeYLHJs/Lx8VASVUiIHViHs=;
	b=fa+wCudn903Fh1q1bJ0WYEfLxqhMTyivPYK9P4oC39ZMQsjp6FrfQJd48D6ahlC2wRPa
	 yw2i9VCuXA0NOE9b3hNkFsqnxFPhroScsQaw8xI/YRD+dr3ji6RB1DKLwnI6wociyqV3+
	 5uVann0pBb3RacRS8RCQ/smi+/Ne8Lh+oYGYPIiUd9B5n4HwiF5udnmsqD6N55BvLksRy
	 e6ErcZcgvM9UZPruWnC53sg+LGU3BrA41PGJ1DeNqY3pqO9W7CvEfoKB/CuMsUqRQ0n2+
	 yx42oKIikwuyNZqOAs48x1rcceXXJGnRHQlVONkn53qN94/eeE/Wgm8ExLvKAnbXjew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfRnoGc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57F606A31C;
	Wed, 18 Nov 2026 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfRnoGc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497C41F000C4;
	Wed, 18 Nov 2026 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041729;
	bh=6mnfSlnmeAYLKvqDp0remeYLHJs/Lx8VASVUiIHViHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfRnoGc2VLsl/o8j3Z7qS5oHsX5Pdut1wbZQIu0LwqpzFZ3lF22KVHZCEO9AcRKMn
	 /0zS3y8GLsgOryt3QBoZWgNbZs0MsKM5pgnUizM2JPgqxvIku70jONusbJcP17NF8T
	 rj6ZHWQrAPrUZdt7zTKVr6q/2IZIpjrWHZFE7MxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2918/3318] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150447.966441122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 47a9c0338f2e0d4178d77b0d2f529fe1fde84642 ]

For a user QP, rxe_post_send() takes the qp->is_user branch and
never runs init_send_wqe(), so
dma.length/resid/num_sge/cur_sge/sge_offset all come straight from
the mmap'd SQ ring. In the inline send path finish_packet() uses
sge_offset directly as an index:

	u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
	memcpy(payload_addr(pkt), tmp, payload);

inline_data is a flex array whose capacity is qp->sq.max_inline, but
sge_offset is a u32 from user space, so the source pointer is
displaced arbitrarily past the WQE and the memcpy reads out of
bounds.
commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]")
added num_sge/cur_sge checks on the send path but not sge_offset, the
third attacker-controlled index in the same struct.

Read sge_offset once with READ_ONCE() and bound it (and the payload
that follows it) by qp->sq.max_inline before indexing, so the value
that is validated is the value that is used.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261001152433.3259573-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 883ad2222baba..c7c025132bbc3 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -511,7 +511,14 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 
 	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
 		if (wqe->wr.send_flags & IB_SEND_INLINE) {
-			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
+			u32 sge_offset = READ_ONCE(wqe->dma.sge_offset);
+			u8 *tmp;
+
+			if (unlikely(sge_offset > (u32)qp->sq.max_inline ||
+				     payload > (u32)qp->sq.max_inline - sge_offset))
+				return -EINVAL;
+
+			tmp = &wqe->dma.inline_data[sge_offset];
 
 			memcpy(payload_addr(pkt), tmp, payload);
 
-- 
2.53.0



