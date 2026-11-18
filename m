Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056365;
	b=SnK//XSTVVNrzpU0WrC4dVMkLrkwB5jnunA1mP0GoO1KaEcknFoMgjQWWV0UfmU0Vzwn
	 1RjZTnOrCHIQzHdV+1W17ONuVC2MSOSE+CQiu37IkXQFTLD9NTaMRebnGks6c0Lbic1s0
	 ytiUWLWG7p9Cy9MgT0F+flo+Znv0SRA4Ghf7DuFOrr3P21W6n5WsIqo/1uBryORaOqnTF
	 eydD1QLQOM29aQZ1xMqSB1KOAnXGPGt37nKPPFaoJ+J8YKbfMclYGI4QLdgc/gm0dzbd6
	 dNspyiMf4PC5RwKvtY4kCEWG5BWq8pQ62xItfxHg65LibQHp5txXSRUrxySfR6leVcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2cvRYXJoVYRK+0f5ngQwWRK36jjzzRLez3OmZ98EPs=;
	b=ufQ7RTEuTAagZ4WohQdsNpcvr/w0YkRVt1j+F/6vdg0ebM7W2fynURWNlSjJAqHaLUMC
	 jVFNsbBrX1JYKgzZgvaYq+cL47BP9P9QhZhcVgrqtLGIXnLEKaQeZzFVATE2pnOJpizVk
	 TgaKTSGpHL3YqorWqmfyM+vp3GND+2KP8r6o7QHDC+MbIQaOjAHC5nsVW3Nc9m9TkE3QX
	 tBP07jvX1KAdX8d/yBqXErrAJQ2263nDVA8bpz/2nrzlB7tRG5BAO9gg47uANkueEkOVr
	 6G3dcTErVSoOt2ijbQz/PKvi+Jk5sk47ug9vlRegSR+vlDehlS9rWIZ7QIDxykAL9/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPDxORXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0D606A32F;
	Thu, 19 Nov 2026 02:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPDxORXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5741F000C6;
	Thu, 19 Nov 2026 02:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056365;
	bh=m2cvRYXJoVYRK+0f5ngQwWRK36jjzzRLez3OmZ98EPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPDxORXt5WXj8QTIQXzBt1b9N0b9b28EztVoqrcsKQPWaUYdrRpiHejOLuVu6xZgs
	 HQdqqyai9glpa5UwL8RP5FLgRRTQ1q+piqAEjTCODSgnFBWhlL4ksI7spNDMD19qw8
	 vQq0xzB/aoDFeO5CbjcO4ynjZeU0Ruo5frcXF5xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1963/2214] RDMA/rxe: Move AV from rxe_send_wqe to rxe_send_wr
Date: Wed, 18 Nov 2026 16:00:39 +0100
Message-ID: <20261118150129.471273385@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit cfc0312d9c83a5bbb66fa73ba47dd1301d75b2e8 ]

Move the struct rxe_av av from struct rxe_send_wqe to struct rxe_send_wr
placing it in wr.ud at the same offset as it was previously. This has the
effect of increasing the size of struct rxe_send_wr while keeping the size
of struct rxe_send_wqe the same. This better reflects the use of this
field which is only used for UD sends. This change has no effect on ABI
compatibility so the modified rxe driver will operate with older versions
of rdma-core.

Link: https://lore.kernel.org/r/20211007204051.10086-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c | 3 ++-
 include/uapi/rdma/rdma_user_rxe.h     | 4 +++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index da2e867a1ed93..85580ea5eed0d 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -107,5 +107,5 @@ struct rxe_av *rxe_get_av(struct rxe_pkt_info *pkt)
 	if (qp_type(pkt->qp) == IB_QPT_RC || qp_type(pkt->qp) == IB_QPT_UC)
 		return &pkt->qp->pri_av;
 
-	return (pkt->wqe) ? &pkt->wqe->av : NULL;
+	return (pkt->wqe) ? &pkt->wqe->wr.wr.ud.av : NULL;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index e40927cf5772e..d3aef42aaa38f 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -584,7 +584,8 @@ static void init_send_wqe(struct rxe_qp *qp, const struct ib_send_wr *ibwr,
 	if (qp_type(qp) == IB_QPT_UD ||
 	    qp_type(qp) == IB_QPT_SMI ||
 	    qp_type(qp) == IB_QPT_GSI)
-		memcpy(&wqe->av, &to_rah(ud_wr(ibwr)->ah)->av, sizeof(wqe->av));
+		memcpy(&wqe->wr.wr.ud.av, &to_rah(ud_wr(ibwr)->ah)->av,
+		       sizeof(struct rxe_av));
 
 	if (unlikely(ibwr->send_flags & IB_SEND_INLINE))
 		copy_inline_data_to_wqe(wqe, ibwr);
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index e283c2220abaf..2f1ebbe964345 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -98,6 +98,9 @@ struct rxe_send_wr {
 			__u32	remote_qpn;
 			__u32	remote_qkey;
 			__u16	pkey_index;
+			__u16	reserved;
+			__u32	pad[5];
+			struct rxe_av av;
 		} ud;
 		struct {
 			__aligned_u64	addr;
@@ -148,7 +151,6 @@ struct rxe_dma_info {
 
 struct rxe_send_wqe {
 	struct rxe_send_wr	wr;
-	struct rxe_av		av;
 	__u32			status;
 	__u32			state;
 	__aligned_u64		iova;
-- 
2.53.0



