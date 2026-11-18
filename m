Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056388;
	b=f7l3sw46FOil2CLqhz5J4sMDCOc8BfXgRZtBtkTEqguxyq0uIV/z5amlJwQs0UNr6rKD
	 aiMuBtWlcPaOzHGnj2BL/OAJQ48E3TZGhWMe34YCIo6iih3pQAOMb/JUF2c/Aix2UOYyv
	 hSV19WrXuW8RFXFsCViac/LtnButBtlOoZKI+fWrQAF7p7dTPwFr0Y8gG+2gFZp1R1F/n
	 4iHkymjGSHY6+NRctZhpsX4u8agmFrp/1w7Fhp9Is6e0oPOmMrbggRrf3L7Bwt01hbGzN
	 q3eAVJAdxP7x0d/cKuSpvxBOGwXym/Ri8qf24LVHXJv3+882L8sIDCW8xnnyyWmTSSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/WwCdSI0nU5AwCga6f7Ki/g8za6nXWaObhfQ9WRW4s=;
	b=CIUskGKcL7xo7JudvTw3lP8gZUu2W3Oo1vwXPRnXOwmIaZGVMHjt/DHNzTJfNyRfsNFe
	 +XGd0bUE2aAwSRd1eywhtfsMQiODl3zch0M3MzlAXxOtfegwTfmXWl4p6taNqZckjixDx
	 3gE5vYTWmeZHVuNdYQp1x012+bxeG/3h36fGjORM0qop7cR8yatZukxdX/zSCY3spJgdt
	 Pge5kcAUOkMjoacEpAEpWyAUApzQTRkAkmie0L66Oq2Hy9SJosjiX1D450KqpGR24wwPX
	 oxhGgLjLOCo+BaQUvMusUxGDec9ZYw3zgZ7nwgDlZmvc63PIF/2apH1XfWdp0uMKb6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tA6tJIdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341DE606A325;
	Thu, 19 Nov 2026 02:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tA6tJIdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8337B1F000C4;
	Thu, 19 Nov 2026 02:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056388;
	bh=t/WwCdSI0nU5AwCga6f7Ki/g8za6nXWaObhfQ9WRW4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tA6tJIdvAqtCj9h6FP+7XEjoitE5+ILBhvYZNph1hfZ7lH/eyB+cPpo2RgR+b2Q9u
	 IgotgfeF3rzkpaiTvdLgym+acTExXvl0263ZJVQFYGh7kVydJdm1C9F6MC9P57zAe4
	 /0BZhcXFEDkdh2yhZjILmoy/pOk1oX1Nq+4qGWBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1970/2214] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150129.722946522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a025a60ae767..d9389f03386e9 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -454,7 +454,14 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 
 	if (pkt->mask & RXE_WRITE_OR_SEND) {
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



