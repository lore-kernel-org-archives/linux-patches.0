Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC6B1A2545;
	Fri,  9 Jan 2026 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962634; cv=none; b=qj+tvs+hXRvRyiqX4k+bK9BrkDrvf22yJBpUId5vGlyXfK+6PM1MyWTFn/8lTWuGze8RXoAVqtbX87yr3Tv4nomwBSmZKOsxfOy9iJX4HdifNm07Woiu1EDPtqSVPfK9/yNjkd9PzoQp0HtjNtuqq8Hv4KmAwodbRTjGpV3PPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962634; c=relaxed/simple;
	bh=wDpGKE/30esVBeQclq0N++/ZUSD3FJvExmxmXOdXd2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iboQQoSRi7ZkYbTvs9MYyeKxeEgUpa8MWsioP5jaVYEqr9oZ4SP878vatAMXZtOA+8Dy0sHOU91ei9aw5vAi+wOHQ24+hgBu/APV9wlI7kggjBFxokQc0k4qQqrE7ULbIceEPFIKopX2ksTo2+kXtf0B38y9GR3IkojByKOgo4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MONQg/a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MONQg/a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FF5C4CEF1;
	Fri,  9 Jan 2026 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962634;
	bh=wDpGKE/30esVBeQclq0N++/ZUSD3FJvExmxmXOdXd2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MONQg/a/JVwJacAJMOUTStOZjGfNqqQzy+TGLjek+FFvK8d7f1tjWK93P9YI1JSA7
	 u/ZFIaFphWZVPuGMTbFxFGGlzr+wuGGuWNOVLcGGOznq8xjhTN4Nx++WcE4U7M/8Hf
	 oFqQ5xqLjHfCyoClkSjB93iVbnTDOpa0lQkoaBRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 435/634] RDMA/bnxt_re: Fix IB_SEND_IP_CSUM handling in post_send
Date: Fri,  9 Jan 2026 12:41:53 +0100
Message-ID: <20260109112133.911316582@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f01765a2361323e78e3d91b1cb1d5527a83c5cf7 ]

The bnxt_re SEND path checks wr->send_flags to enable features such as
IP checksum offload. However, send_flags is a bitmask and may contain
multiple flags (e.g. IB_SEND_SIGNALED | IB_SEND_IP_CSUM), while the
existing code uses a switch() statement that only matches when
send_flags is exactly IB_SEND_IP_CSUM.

As a result, checksum offload is not enabled when additional SEND
flags are present.

Replace the switch() with a bitmask test:

    if (wr->send_flags & IB_SEND_IP_CSUM)

This ensures IP checksum offload is enabled correctly when multiple
SEND flags are used.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251219093308.2415620-1-alok.a.tiwari@oracle.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 94c34ba103ea..edd1457a99b2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2650,14 +2650,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_ROCE_CRC;
 			}
-			switch (wr->send_flags) {
-			case IB_SEND_IP_CSUM:
+			if (wr->send_flags & IB_SEND_IP_CSUM)
 				wqe.rawqp1.lflags |=
 					SQ_SEND_RAWETH_QP1_LFLAGS_IP_CHKSUM;
-				break;
-			default:
-				break;
-			}
 			fallthrough;
 		case IB_WR_SEND_WITH_INV:
 			rc = bnxt_re_build_send_wqe(qp, wr, &wqe);
-- 
2.51.0



