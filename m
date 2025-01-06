Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4686347;
	Mon,  6 Jan 2025 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177348; cv=none; b=tcuj/nLyY4sL0kLDAMpjqjTLQNhy0/KbNrSfwhel1mMIlWu9J93GbvR0pdtpERE+lDXVO4u1kzzujJY7zhJxgeLsvfeuRmRZMQqwjrU/zgRiGAH795ZQtpd0xgOazC4zRuK9cJbyeWomuSLZGnz1keBhHAjL+hfrT+d55RfSPfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177348; c=relaxed/simple;
	bh=pXoM0AwuSiqG50WabOQi6eJAXuqFNbR3WR55UYYnWWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMoheGm0zcQ+d2C5FWYoHM2mi5+tR5eQTLVjgAqKAbp5cKp/WsLr36At+vV0Mgc0odqY4sflYVlkld7BsNJI1E2+SPybfH25F+RLkovkyF6w/PhCXvKkb1gOWpGWHyd2Ll3qGO5zcD5tnTm3fEIxAHM+an97WXRqfg7bKxhlyWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFt88max; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFt88max"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94211C4CED6;
	Mon,  6 Jan 2025 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177347;
	bh=pXoM0AwuSiqG50WabOQi6eJAXuqFNbR3WR55UYYnWWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFt88maxdl4sDsFGbhGSb8Nm3AlElBxKz8F4M/FZcQiHHDd5nLlb//lxEr/WjPWux
	 +1vdxHl/bUJx7gqIX0JkpOPSBJoChEbDc5vbndVfwGYIUGVt8lKO73UUfPVsD84VEX
	 hnQEroNGZFXJt5lkNtgeZgbu1V/2S41piqicR5Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/222] RDMA/bnxt_re: Add check for path mtu in modify_qp
Date: Mon,  6 Jan 2025 16:15:38 +0100
Message-ID: <20250106151155.840430332@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fb6f15bb9d4f..9bf00fb666d7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2055,18 +2055,20 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
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



