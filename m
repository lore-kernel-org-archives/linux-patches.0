Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041744;
	b=MZNn/K3Ob0dEDMIcKM6jVycaLo6Hby9aPUETycavsk8vaMl84csYj+vsBG+LIbF7dfjo
	 9QHTWhUy6siEUuOmT3QcyAnFQy2g+42nNAG7GRHa+ETGkMsOiE+4GPJLm1fUrMU2rGcfG
	 0LloFoqDr8jmCLpWYKhEbmJrsinbKnq/PRap0+3sq76lvzm5wtPwhcdu+oHSJNFfQelIN
	 /lWEhE4J+PsKTEurnWFOz9NI5fJGe7gnqFC6enGr3dQIntGmAzZVFAA71XVWNkL8c1XIw
	 4k0BV8ooK+9eEMD0AF4IzmYT6armIxb3/8VL79BoguP97dC16CSu2tGyxF5sUww22hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ow+DgsygGvC3vcHtbuDVsWKdTndJGp80bWz3EEmge7w=;
	b=ayZFr2S7OZq7anhm2D4RhEL+3+oHf518fOiwKmIXiGx9DYpxn5y/QDCVOpn0EgO9t08a
	 sJaHkgs27AzXFrKEIprIraUBZaXPHHWmloIZXFunm9DzPGizo5escrEkgcdUFzdKAJITJ
	 MJZ42mNHN02/OOZQSv4ireyMizzQ1eymCiMoxKtA3Gpf38Dn6C4O4vsyl8TymIWTSQ2PB
	 Qy90ndijmbELVxrcY/5QstnYrTpFpv1x2nCFFErFUPCtJR3C8mqpqIu0Pp4DV11quPQFn
	 DJ5X+6N53ngAJ313/TkloIJvOLoqe5WDNOsg2924Gi1t626BjjDkN7oYHexCF7B/tLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtFFDxhg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB20606A325;
	Wed, 18 Nov 2026 22:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtFFDxhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1ED1F000C4;
	Wed, 18 Nov 2026 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041743;
	bh=ow+DgsygGvC3vcHtbuDVsWKdTndJGp80bWz3EEmge7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtFFDxhg+cQkLcyqLYxH+4wMAKbBf76hYfFvL6XtVIQcHGsnGgyPON7qBhUEsr0yi
	 GsMAqc05jGSs8jJNGmEdUCimxKoyvAM1EOdCw2ibXcQF6vlAnNDIlTbeOmYQNmmvZv
	 n2TFW9RTnbaKltRs0myjnYUBs+3CmKK+S/QdSZRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2922/3318] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150448.073028765@linuxfoundation.org>
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

From: Honggang LI <honggangli@163.com>

[ Upstream commit 56a27df6cedd4f3918969d61c7b9d3cc177b2d1b ]

When RDMA READ request for 2GiB in single WR, res->read.resid is u32
0x80000000, which is INT_MIN (-2147483648).

    payload = min_t(int, res->read.resid, mtu);

The `min_t` function will return -2147483648 for payload. The wrong
size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
-> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
invalid size. The passive side failed to emit response packet for RDMA
READ request.

After fixed it, the active side of RDMA READ failed with error code
"IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.

   int resid	= dma->resid;

This conversion set resid to -2147483648. `copy_data` abort as length
greater than resid.

RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://patch.msgid.link/20261002142250.657151-1-honggangli@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 51d0121a7aa3e..f86778678cce7 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -66,7 +66,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
 int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		unsigned int length, enum rxe_mr_copy_dir dir);
 int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
-	      void *addr, int length, enum rxe_mr_copy_dir dir);
+	      void *addr, u32 length, enum rxe_mr_copy_dir dir);
 int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
 int rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
@@ -90,7 +90,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt);
+				u32 paylen, struct rxe_pkt_info *pkt);
 void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 26d70dde8ea5d..4fafc10a90e4e 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -417,13 +417,13 @@ int copy_data(
 	int			access,
 	struct rxe_dma_info	*dma,
 	void			*addr,
-	int			length,
+	u32			length,
 	enum rxe_mr_copy_dir	dir)
 {
-	int			bytes;
+	u32			bytes;
 	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
-	int			offset	= dma->sge_offset;
-	int			resid	= dma->resid;
+	u32			offset	= dma->sge_offset;
+	u32			resid	= dma->resid;
 	struct rxe_mr		*mr	= NULL;
 	u64			iova;
 	int			err;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 816636d3701f9..9c2223d9018b6 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -510,7 +510,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 }
 
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt)
+				u32 paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index defcc8a62dcc6..c85b3f3f4f570 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -610,7 +610,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 }
 
 static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
-				     int data_len)
+				     u32 data_len)
 {
 	int err;
 
@@ -810,20 +810,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
 static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 					  struct rxe_pkt_info *ack,
 					  int opcode,
-					  int payload,
+					  u32 payload,
 					  u32 psn,
 					  u8 syndrome)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct sk_buff *skb;
-	int paylen;
-	int pad;
+	u32 paylen;
+	u32 pad = 0;
 	int err;
 
 	/*
 	 * allocate packet
 	 */
-	pad = (-payload) & 0x3;
+	if (payload % 4)
+		pad = 4 - payload % 4;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
 	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
@@ -917,9 +918,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 {
 	struct rxe_pkt_info ack_pkt;
 	struct sk_buff *skb;
-	int mtu = qp->mtu;
+	u32 mtu = qp->mtu;
 	enum resp_states state;
-	int payload;
+	u32 payload;
 	int opcode;
 	int err;
 	struct resp_res *res = qp->resp.res;
@@ -965,7 +966,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min(res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-- 
2.53.0



