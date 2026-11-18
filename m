Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032057;
	b=XuiRieJdYuSbz3ebndx87AH6mfDStcWI+fLpzsoEe8bSIa/1tf+x/FBakfeAapGXRdd0
	 XHcNkYPMD9XjTo4RmI5t6Ofd1aCufhITqsWoeJ+UvzaZZebtrdHGUZFWO5PevY9JbuAJ0
	 j9XhEv1OwaUpnFt9D2613fZB+U5ohb7hpoazM1jfuSMuxMUopb2x2a6lWG5RKKoxMhwx9
	 qTrdsyxYAmvpnleCFTJ16utONHIuS3muKw+hA4McImPuJNmxPB9BBwL8AiOZOmyO5UUsW
	 NICKQX+qIzauBmWQlO0m+yZZUeFhwR1Id5LDa4s3pp8t24HkVWP0PFVsZEgxTYoS2xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SOMJOsUAygcuyL4ex03DNVNTp4vNbf3UtA5PLN0TiVM=;
	b=ue+vuxHVweefWZ5AHDe4QqnfIJtPBjMB6XeTglckXCxGNxSVJnEFZhIXGeAZDsCXGTP4
	 ikLpBmxbxnJczBM1p/8udktAKy+lZuvmAKBw84QEgifGhFbDIqTTwNRHz3H19vmX0sMKM
	 GVI/j/EGuKxV9tqi6oObPY3IYHsl0Tk1zTrgvjCZUlffVRSP1OSkLjlCWn8GEc2AeXUZf
	 C0r1KILzo30nvzmMOEEkaNtPVFrvljHvlhSQa0+0aoE6dDbuAOd/DFyYaOeQwtjQ9b+38
	 Vjip1D7M38ouoE9yKaqY4du+XpJgtJM1i3CL7b0b+c8+oxqgI0sELGc/Cpz7ChAfzJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyJuRwrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9006606A32A;
	Wed, 18 Nov 2026 20:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YyJuRwrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8561F000C4;
	Wed, 18 Nov 2026 20:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032057;
	bh=SOMJOsUAygcuyL4ex03DNVNTp4vNbf3UtA5PLN0TiVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyJuRwrBlpHD9/o9D6wUpKdZ76/6DtG8qn0d3B7T3OXtV++DATTH6q6e5hKt2BgwK
	 mVA9x1Wzj5CxBj62Rme91XFB2YjrPJ+YRvAhx3ZPpxNHvQTQWGVbALpmReYtX6vlcv
	 nHcLW4pEf8EKsdrqKnuMskaJqhYBFFPvlYnserd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1275/1756] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150100.361308731@linuxfoundation.org>
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
index 3a4fa0ca36a77..ae552181b6846 100644
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



