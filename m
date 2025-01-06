Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA9156237;
	Mon,  6 Jan 2025 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178862; cv=none; b=T3+m3y80pLAJ+95HbF472RIweB9xT29ObkXN7qFwm5EE02nzmvDamlfnYZEsfRHN2aqJjTlu322fzzKKHut+gZWuCLSVL1IkYhvVTDREFP3OzMjOine7oZmaSHC3WiaEChU8/93rV0I23e9g+xTZU1hsLLYdMKSF8MDEch+VyQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178862; c=relaxed/simple;
	bh=6MdLPq+1r7bBcBd5sNVF1YpSuLAwB1bn1e5Tx+//Too=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uysGr9C8MOSoEyZpYOKoJaJgZaNaeshtZGnVxjP75XxoYa3ukFASmReiipOmgfTXI79XIc0THp4697Dj4QiVgp6iPxFrSdcfSpnG08QBzbC2fAW/dNa4MbiP5TQR15+g0EGDjzHCTxE3ca3ZJhYynUinjWmSWLCoODjYa1HgDj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPIk2GB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPIk2GB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFEAC4CED2;
	Mon,  6 Jan 2025 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178862;
	bh=6MdLPq+1r7bBcBd5sNVF1YpSuLAwB1bn1e5Tx+//Too=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPIk2GB2oqHoiI57HL2dCvFVqkU4LPoguj7M5G8cJVp0FyThONWLjmW7mzUL+DnFV
	 B+LtuCVYFQiBOPSJ2W83+FdRmLr0lq5c7yr+tVLnunmV7eiMindOkw7l5RtkrYGj03
	 jGQZEUNMKiMnRXWngySojL7ApHB9XlHYEZJnLwnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/168] RDMA/bnxt_re: Add check for path mtu in modify_qp
Date: Mon,  6 Jan 2025 16:17:06 +0100
Message-ID: <20250106151142.907433099@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 798653a0ee30d3cd495099282751c0f248614ae7 ]

When RDMA app configures path MTU, add a check in modify_qp verb
to make sure that it doesn't go beyond interface MTU. If this
check fails, driver will fail the modify_qp verb.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241211083931.968831-3-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 26 +++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0ce7bdcf988e..3839e794de22 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1935,18 +1935,20 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		}
 	}
 
-	if (qp_attr_mask & IB_QP_PATH_MTU) {
-		qp->qplib_qp.modify_flags |=
-				CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
-		qp->qplib_qp.path_mtu = __from_ib_mtu(qp_attr->path_mtu);
-		qp->qplib_qp.mtu = ib_mtu_enum_to_int(qp_attr->path_mtu);
-	} else if (qp_attr->qp_state == IB_QPS_RTR) {
-		qp->qplib_qp.modify_flags |=
-			CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
-		qp->qplib_qp.path_mtu =
-			__from_ib_mtu(iboe_get_mtu(rdev->netdev->mtu));
-		qp->qplib_qp.mtu =
-			ib_mtu_enum_to_int(iboe_get_mtu(rdev->netdev->mtu));
+	if (qp_attr->qp_state == IB_QPS_RTR) {
+		enum ib_mtu qpmtu;
+
+		qpmtu = iboe_get_mtu(rdev->netdev->mtu);
+		if (qp_attr_mask & IB_QP_PATH_MTU) {
+			if (ib_mtu_enum_to_int(qp_attr->path_mtu) >
+			    ib_mtu_enum_to_int(qpmtu))
+				return -EINVAL;
+			qpmtu = qp_attr->path_mtu;
+		}
+
+		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
+		qp->qplib_qp.path_mtu = __from_ib_mtu(qpmtu);
+		qp->qplib_qp.mtu = ib_mtu_enum_to_int(qpmtu);
 	}
 
 	if (qp_attr_mask & IB_QP_TIMEOUT) {
-- 
2.39.5



