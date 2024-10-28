Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A018CC1F;
	Mon, 28 Oct 2024 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096889; cv=none; b=Xpew0BCVXMQNLO+f/xCU4dZTxOOnDsFt2S+17Azks7ZEaWy/VAjzpqc6+CGWuI/MPkMiHVPiQrJknlGGvsZgwK1qLHdn4kn3/gzSuvpXSkGf+xdszozu0PHB2XsiV1lpD+gvGMlC9bSPYNwXkbGSk/mRTVvlePT2bzx3QU4LKR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096889; c=relaxed/simple;
	bh=2Mp+f1Ue9vbC1lqLZlvzi9g6eMK5Qw7gD5HRmHP3IVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgmPBh4XxrMDJ69NlNIHvFgoxfxNCmMc2g9IGhWEMEebOtk5bv5T97EsbKdGexcptPgAls5SVNSnWKT0BKLCR7jpbxo5ypCsP26uMIWUhNA2i2fGKQnlHvyZfbGABzvCPnXa6SxR4mj1DahCxtOpuamIhMsHVNyJ14ZRiIyjX4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFABQS+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFABQS+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A7EC4CEC3;
	Mon, 28 Oct 2024 06:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096888;
	bh=2Mp+f1Ue9vbC1lqLZlvzi9g6eMK5Qw7gD5HRmHP3IVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFABQS+APyC8fK1+cJ+f2hcclMm/Uc453egPS4wGSFC4n+x4alF4yWSbJ1S5lkGiv
	 v+kqKezNkEAZCJDR8KtueUWmNY5m1NnTTGzwykOqDShDMNYTxe/15T8ynrtEWunTH8
	 80k0ELagodKNIomxLFE7lP+9iHvwdOVAi2+Es5Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/80] RDMA/bnxt_re: Fix incorrect AVID type in WQE structure
Date: Mon, 28 Oct 2024 07:24:43 +0100
Message-ID: <20241028062252.711491268@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 9ab20f76ae9fad55ebaf36bdff04aea1c2552374 ]

Driver uses internal data structure to construct WQE frame.
It used avid type as u16 which can accommodate up to 64K AVs.
When outstanding AVID crosses 64K, driver truncates AVID and
hence it uses incorrect AVID to WR. This leads to WR failure
due to invalid AV ID and QP is moved to error state with reason
set to 19 (INVALID AVID). When RDMA CM path is used, this issue
hits QP1 and it is moved to error state

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://patch.msgid.link/r/1726715161-18941-3-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 4f1a845f9be6c..57a3dae87f659 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -169,7 +169,7 @@ struct bnxt_qplib_swqe {
 			};
 			u32		q_key;
 			u32		dst_qp;
-			u16		avid;
+			u32		avid;
 		} send;
 
 		/* Send Raw Ethernet and QP1 */
-- 
2.43.0



