Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493461E2601;
	Wed,  6 Nov 2024 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896595; cv=none; b=gNSGhZtvgBsJxFP+N4s0EdnDPf9vj+Bf8YAZWjnaRwYc5HwXwg/iXSwYBgp7tBjNR7WHXbxs1qxnni/J9RTOYHoxBXjNVcvysNlsXpTGz9zgV73VbI3XE2Rk1l2cfzWfyQjXxfXa1/VDF/VFNKof+Vq4QjP8gr28s+JGE7N5Vfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896595; c=relaxed/simple;
	bh=HPNJZnRfpTYsVgdKafdc/NX4yNh6ALd6WkQX5qQ+NP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS5sXOzlnPmOzHuDVPl+m2nls73e1srCLVbqIS4Vbnyuab9Xde3IfGm4YJ9P1SivRiLhs6Jug5UNzfNHGq1+Q2pTTWgFJUJ9FaOP1VN6PNd5s8oU6qohNm39fDbbzLprfruAstP5KHNkWl1007u9QFoTxnI2+XOsgV2okGx52zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmKwWVFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmKwWVFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D77EC4CED4;
	Wed,  6 Nov 2024 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896595;
	bh=HPNJZnRfpTYsVgdKafdc/NX4yNh6ALd6WkQX5qQ+NP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmKwWVFpZrLKS3tkTK2ijrQSffj61F3c9qkQ6RN7XB+yVaAyLRpMiMlkwLuA9yxLg
	 VhmeT2MYIUOM3jUliwdoAQjq5h3L46/VokwJfMt9Oba5L+PkY0sKdB9nHTAOi/D7my
	 dmxpvDW/wT0RbBd41+ILlrtQHOFRSN9GJ5Off07I=
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
Subject: [PATCH 5.10 001/110] RDMA/bnxt_re: Fix incorrect AVID type in WQE structure
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120303.180286044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f112f013df7d9..01cb48caa9dbd 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -167,7 +167,7 @@ struct bnxt_qplib_swqe {
 			};
 			u32		q_key;
 			u32		dst_qp;
-			u16		avid;
+			u32		avid;
 		} send;
 
 		/* Send Raw Ethernet and QP1 */
-- 
2.43.0



