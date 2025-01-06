Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5CC126C05;
	Mon,  6 Jan 2025 15:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176730; cv=none; b=nVXNN4NvABBdEzbWFcOuF11pMqIzdhIIcyb2vEVvh2wRD5Ffmm9LigHbbPI4juI79GiC5KXoc2GwyxQi/iIAjF1rAWo6V4T68aFB4HMD7kyfeEyqzA36v6qoOx9oq7BvqMz0RmJdbId5xtuRVUc2jzG4luZAS8FA0zo8+57KY4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176730; c=relaxed/simple;
	bh=jgV0I5poU1EHnVr35W5c8s7Mu2KNKh9x515snaTZQbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiuRXEk9DUVNwznRTgWuESUZ5jcjieeenX2pfR12CE2YHvnhEx4IDkFwxkyZD7QWmz5M08Gf+HXZtQRke+Tcu4Hvzshq7hTJw7vPwMi42W2bzJcIMkc0Brf33KmSEpTKsuLjiDcYrqoFTcJdBcLs7E0gHN292ik5wcpwfOoL7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0UgGG5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0UgGG5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA435C4CED2;
	Mon,  6 Jan 2025 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176730;
	bh=jgV0I5poU1EHnVr35W5c8s7Mu2KNKh9x515snaTZQbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0UgGG5prXDHkdYZidtl5BKBGfW2c00DRidDO0VGrh6eAQbCjLZ2dlu3CwTDYJaHf
	 NOL/bHFyx1rfUNIfF1H0BIO1REGpGrXI+ENgbd+H/4nAsYbIrczf9UChVrTuCydQJM
	 VPke3msx9eTZ5qr6yemmgK6omoo96cWCQ9xUrDxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/81] RDMA/bnxt_re: Add check for path mtu in modify_qp
Date: Mon,  6 Jan 2025 16:15:45 +0100
Message-ID: <20250106151129.939929615@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13102ba93847..01883d67a48e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1940,18 +1940,20 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
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



