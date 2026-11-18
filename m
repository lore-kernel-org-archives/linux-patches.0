Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049932;
	b=Kqibqhvcdg46uEndoj5e562gVRY6BXhnXSmFcsblq/ZUiG9vr2ZgMb7BJCHjPzWjUv1+
	 SUPv48xWAmRqJwNF2tc/Z2CcerfWY+09UbD95CEee263nHYH/R5gCbMA7hm592b6v9SFz
	 YAISSwGXz0AI3OaXQYG41hoSIDmbo7vbmIQUm/bbvliYIsIaQWLM0vhucyRKIiDIHN7QF
	 feq+Av9MGS/bFbNQYi9YQIkyL7tEYDXFgSvtPZYt7bj9uZaI4HSWpfrSDp5Cu/I7rmWdZ
	 2vaiGJ7MRKz/8wT6N7vh0+amZIKa+on1mCHK+TEDPzqXDZwZbG16ArTj9ildrSV0EcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0zrvJJEMVIRpwnu3/sdxMaYgQM65fQtdYRAKQwLROMM=;
	b=C+MAkIy4iqmG1TIkoH3WOSue6+S/EyPJOn43YoaL8x8MXlZRnO+dTz5vw82IMckaoHtg
	 ABOXsca0QJaiFUTjk+3xtXOO5ZcbHasGlkISME7BfgOE4usjtabkcgAGm5kX+NA4YM9Yc
	 LAmx7O26QSeo6MLQQU2AJOvZ6Ih+zKEfgeAdRndLDf9XX7ZZxO6wpKcpYtyAQAvTify30
	 KDpRmggQJPtAzIor+YH0+RAz8csQ3/4Fdzdr3XOhQmClznoGQmTQyU3woOJDD9xB2jFga
	 zgfrwQIv48haTBz0Bf5MpOJzP+OHZqEOVoOYDfiAuPfhmZLg6FyrVolab3tdpB84Zig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDgbaldn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0C606A325;
	Thu, 19 Nov 2026 00:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDgbaldn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8001F000C4;
	Thu, 19 Nov 2026 00:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049932;
	bh=0zrvJJEMVIRpwnu3/sdxMaYgQM65fQtdYRAKQwLROMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDgbaldnEeRDX2sB3hicsSe3RVlbtsdh/K3w1dqh+rI8x7pKOFwDiZqXsQ1w9xab1
	 eVe+Ra99sPU/sdMTcAr7tyYQxMuk620AjF9yzawhj/jA8GBWnk3TGV7zf69fs7z+1B
	 WEFzsN6eCATx7MSOtOl9buSMeWy6f85gQIU7ZvKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2527/2857] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150332.525452800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 55accb4a42980..be2d0f7a78741 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -467,7 +467,14 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 
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



