Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E29146A67;
	Tue, 25 Jun 2024 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309133; cv=none; b=m+pBzsiO2yvmpIg43nXWODP06r+CPDrMQHNHgJ7ae74kuI5oHkgbusxzUx16l2vk/MrnPY2Xwn5+84ahPN58jRyuH0xc1nHvT3d1F+MhcFujc9IDaMthhOgOYsMrvBXrshk844Nrs+iNkQpd/Q/No6YquR3XfJXG/7qweO9+WdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309133; c=relaxed/simple;
	bh=aSFumv/dAw7JyV2mRJhoe6VMW22c3aEgejrXaM/tN+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koBCIdIkCWY1WshS78GN/1G9ZfYOeV8fL0HovXRHPEGZqsd7yJV62fpoZuCeXo0G5tP0bpCAPt/CLR+H3EW8cl/3V/5uHi2J+iqOmoEgux65iXo8IcC3WoXZrgXWfH4ILLxuXcOHWh5L3uo4BoSC0lELLOgW9ucSPvRhH8p2pEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guTpr8cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guTpr8cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E09C32781;
	Tue, 25 Jun 2024 09:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309133;
	bh=aSFumv/dAw7JyV2mRJhoe6VMW22c3aEgejrXaM/tN+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guTpr8csxHZe3cpQRZ+JAMWFG8d4BFXch8Js3362b4RiwCF79S/MUNTNRJvW1stFp
	 wsjuaCpPDtlhpJJRDGvS0COhAe4BuEVS2Nbz1ecbVKCHId6ngbPczbeVglQ0/fOQh1
	 Jq0CGPyL+OR0qm+26fc1j60RtzT1jPCxYij9OS8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/192] RDMA/rxe: Fix responder length checking for UD request packets
Date: Tue, 25 Jun 2024 11:32:58 +0200
Message-ID: <20240625085541.243701978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang LI <honggangli@163.com>

[ Upstream commit f67ac0061c7614c1548963d3ef1ee1606efd8636 ]

According to the IBA specification:
If a UD request packet is detected with an invalid length, the request
shall be an invalid request and it shall be silently dropped by
the responder. The responder then waits for a new request packet.

commit 689c5421bfe0 ("RDMA/rxe: Fix incorrect responder length checking")
defers responder length check for UD QPs in function `copy_data`.
But it introduces a regression issue for UD QPs.

When the packet size is too large to fit in the receive buffer.
`copy_data` will return error code -EINVAL. Then `send_data_in`
will return RESPST_ERR_MALFORMED_WQE. UD QP will transfer into
ERROR state.

Fixes: 689c5421bfe0 ("RDMA/rxe: Fix incorrect responder length checking")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://lore.kernel.org/r/20240523094617.141148-1-honggangli@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index da470a925efc7..c02aa27fe5d81 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -354,6 +354,19 @@ static enum resp_states rxe_resp_check_length(struct rxe_qp *qp,
 	 * receive buffer later. For rmda operations additional
 	 * length checks are performed in check_rkey.
 	 */
+	if ((qp_type(qp) == IB_QPT_GSI) || (qp_type(qp) == IB_QPT_UD)) {
+		unsigned int payload = payload_size(pkt);
+		unsigned int recv_buffer_len = 0;
+		int i;
+
+		for (i = 0; i < qp->resp.wqe->dma.num_sge; i++)
+			recv_buffer_len += qp->resp.wqe->dma.sge[i].length;
+		if (payload + 40 > recv_buffer_len) {
+			rxe_dbg_qp(qp, "The receive buffer is too small for this UD packet.\n");
+			return RESPST_ERR_LENGTH;
+		}
+	}
+
 	if (pkt->mask & RXE_PAYLOAD_MASK && ((qp_type(qp) == IB_QPT_RC) ||
 					     (qp_type(qp) == IB_QPT_UC))) {
 		unsigned int mtu = qp->mtu;
-- 
2.43.0



