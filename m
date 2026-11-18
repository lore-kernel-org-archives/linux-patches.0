Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026982;
	b=Oe3vmtZzg47Xbsnog14pnH/7DDyx80bWeMbQj8svIrX9qgSJ5NBwb6KqHB16C6EakwSr
	 SGt58lH3++HeJmVrn3skGncu/v/DnCf/1hU7DaP4oKOSqqQP3WPVyEng2H5KmZN46+Rf+
	 EDzJmc3xGwuWodxp5lMDZbDTdUuhqRnGgn3hVD0zPJAqyWB0hmhv1iuM7kl3KRsinreEL
	 JrHAqawMMMYZInRRkVSgw1oIax6HMab4qHpSV4h3mtCugYVy/tMumlSA6NNwKaNqUUDQV
	 oW5w02ZsrSqWrrWnH+qLfNoNS4P1vRZET+3ptwhmzzgpgworuXhuCqiSLTnc/oh21nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWSmFvsLzNDNlVf6ozqZJHlkaagIXhA9KOF+EiEPMnY=;
	b=vgHZ6LhKFbmDKbnjiCsl6CuLIfbior7/+qx1dHk86T7pbjz/XNMzaXJujQvtx1xD+25u
	 h3fIZpxEQu2xUgjOUrBZG7WMK7+K0LjDwthFf+hMpl0VA2ahbwZ7AY4ED+Clt+O58J/J1
	 fj0VJIyEQXMZ6Iz7pkwJCJRD3GhmaLlmNYFgtmH7/HGTe/gQodnHLOsMnsXYOPkbiAk7v
	 5bZmwvq5m2OW0mM2ORLNVYM4BSPbI2VWWz+Cg8Zqrbb0zOv7gD3aTQjvpexSJesuczwNz
	 kaFqz3UIizpkC8C75KqFSKISfGDzEr+rgP486AibwQmwt+K6meprYHTIHS65HlfXaVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQmbgeYO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C22606A333;
	Wed, 18 Nov 2026 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UQmbgeYO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121441F000C8;
	Wed, 18 Nov 2026 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026982;
	bh=nWSmFvsLzNDNlVf6ozqZJHlkaagIXhA9KOF+EiEPMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQmbgeYOM/BD2hC7LU4BHYOWaV4HVL3GTUNfTEF/Ft2+sjThrfik8Ovau8xsReLs2
	 PbrLdYvDM/b9LJ6qZNLW6oJ16TaZen1Bs09H9GRJoLZKZo0OfHJn7GUYywNbS09aKZ
	 dxHpmfMu8m1sOL6fHuQQ/mMUd2fvZRfTF8NQn0b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1601/2151] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150220.200322775@linuxfoundation.org>
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
index 24f5c044363f7..152f02eed0ff1 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -510,7 +510,14 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 
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



