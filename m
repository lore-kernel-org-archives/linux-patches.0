Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB1618E350;
	Mon, 28 Oct 2024 06:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097514; cv=none; b=kfmYmQP6fFHvs2cMmXdwSAglcIyUNsgcsbFBCOVAIRAotBrB2eEVRA8L2OTDUdrFSX+gYLvbBelg92oAkLX+4Rwpev8cigcHhdQ9PVhicq58Pzn5jZf+ZI4m9g/8dqDUcz+Ya6OtsJR9MWrJVrcX1zQ/86l9THjhHGlawEJ0AFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097514; c=relaxed/simple;
	bh=AHTBypOv4snPwgS/aXzp2uDZ8JQKAPJ4RAVMALkOt/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeRiaGoMo8eaEY8GLnU/Bp8aCLPv28B0Ycv9dPJzOFgYxAbCEs+f7kVN5sH548GA4+7Nlh6vQNjTWfK3Fu18JyCcuzRxCfD5U8biEFfCy80/Hzl6D3hQ5FU6jOfOo/CJEsTptDapvitY99SBuJbwecuuNxqCWmjWcVi/k0a+Roc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0O6fdC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0O6fdC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7D0C4CEC3;
	Mon, 28 Oct 2024 06:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097514;
	bh=AHTBypOv4snPwgS/aXzp2uDZ8JQKAPJ4RAVMALkOt/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0O6fdC9fhScdOc4S7WjenxPcBSVwh5IF/NIfxT9PxJEEJfN3HCuaherioISbpSbf
	 4B/kET+EeqEhDesyOaIC0/31F0CsRxCfThv+IaDOwb+guDEyLGw0ECd+VdaOyrt7er
	 VYp4AuVGBUDVjA0FseQkI6jPUyZD4ySpti4NnFD8=
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
Subject: [PATCH 6.6 008/208] RDMA/bnxt_re: Fix incorrect AVID type in WQE structure
Date: Mon, 28 Oct 2024 07:23:08 +0100
Message-ID: <20241028062306.861241881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index a6f38d8f12efe..56ddff96b5083 100644
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



