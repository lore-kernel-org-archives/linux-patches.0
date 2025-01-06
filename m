Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D74C1DE2DE;
	Mon,  6 Jan 2025 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179225; cv=none; b=a3gCAmIGbXEXPmDNWZlBTE+Cr79NsLsPoGaNKUljsMc22Ejo6Vb7OBOp9JCnjSriy13Sk1g5qz59xPP81bK1ogCw3QIJFzOHmI+T+x+6hif+4EW7jL3Ct3ZOIRd/1MuYyxLjTJOaoLthlWsSATDeVyr0UKyQMbcomd2mppyrLk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179225; c=relaxed/simple;
	bh=PIzKEPpTIHeTvV5ieL1L+LSNbIvIPGiHZLATKIgEz/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flCZpuRYZj5Nc6VitDL4A1LlTUodY5ssR0HmRARvBn5YDTaJK0XKYh8gOyAtPhK8dOQfLwVNticRKMu1sfzdIuFKB6tbyj2m3eAzsqTmEQGwuquWdpQp9LwVYOHM56Ub7+9d/wfUtaUsmmZTLdQmCal+4qOKpD/vkS01AN4+Dtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XER0N2cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XER0N2cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95692C4CED2;
	Mon,  6 Jan 2025 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179225;
	bh=PIzKEPpTIHeTvV5ieL1L+LSNbIvIPGiHZLATKIgEz/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XER0N2cVAhOSMhxnBeEgOjCOLUTwpwRVbVl1UpRamLz6UwbP8tOFxYKhppXi0y/hT
	 1gob8etiyT+0Feuz+U6wC24Dtw37jDvN2g1HRtbw84dyLbYYKNYdnSnA6H12CY7wbY
	 qSZwgpLUwylVZWi6Qmj/ck6Cskv/allBSBOt/cUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 67/93] RDMA/bnxt_re: Add check for path mtu in modify_qp
Date: Mon,  6 Jan 2025 16:17:43 +0100
Message-ID: <20250106151131.232667312@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index eca36da7f9d4..d0ed8e14e3da 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1852,18 +1852,20 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
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



