Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8AD1AAA0F;
	Tue,  8 Apr 2025 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113876; cv=none; b=VS4McwfUhY7/iTML9g7/5Df9JtNaKOeyJAKyOvZ/87hoQHyhFj0WeMIoMDJCVOZu+Wg8LG8nPWwOIg6Mto6ptmyLfgzG6jY8uTrHMqt2epJPrrv+QkPlyZ0UW1KVyvXJr3UOm2i/D56yH0/m4Dq47Fx0iMv6Z9I695xi17pGUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113876; c=relaxed/simple;
	bh=K82nsEYfUJqe+CMTYE009Lqz6h3wYxlYGjCicgpHle0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXFZtjafqMuUetoj4aD2q75KVGl2h56Tu7587d6cgx9Itbl22THvSXZ8zUEqVZgvQHTQhkYBXp21SCdPmEWZhl1HxgndJFNS+b9fSiUkZ+YXhiMo5q9y/NHfQ6OjAW+fl+aB9JK3gDOKgrGrhtOv3lRASEfNcsO6AEDC/O4nEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOK+yjan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOK+yjan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BCC4CEE5;
	Tue,  8 Apr 2025 12:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113876;
	bh=K82nsEYfUJqe+CMTYE009Lqz6h3wYxlYGjCicgpHle0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOK+yjanAMRcjDSYM1CSU8+T+ksmkslLqzMcQN4339O9CE/d5uU5bj5+LAlgiteiy
	 j58SPafpNGnPxGnuzVGdoNzOT2hy0yvcpnIwbKi5oS0Bl66U5ZsAdnXec8cpwWHzms
	 rdNOwZv5bjnB7Ten2F1yAkHs+4Q5cj/kieQP5rk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/154] RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path
Date: Tue,  8 Apr 2025 12:49:54 +0200
Message-ID: <20250408104816.980590968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

[ Upstream commit 81c0db302a674f8004ed805393d17fd76f552e83 ]

Driver is always clearing the mask that sets the VLAN ID/Service Level
in the adapter. Recent change for supporting multiple traffic class
exposed this issue.

Allow setting SL and VLAN_ID while QP is moved from INIT to RTR state.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Fixes: c64b16a37b6d ("RDMA/bnxt_re: Support different traffic class")
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1741670196-2919-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 18b579c8a8c55..e14c9f83cf62b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1105,8 +1105,6 @@ static void __modify_flags_from_init_state(struct bnxt_qplib_qp *qp)
 			qp->path_mtu =
 				CMDQ_MODIFY_QP_PATH_MTU_MTU_2048;
 		}
-		qp->modify_flags &=
-			~CMDQ_MODIFY_QP_MODIFY_MASK_VLAN_ID;
 		/* Bono FW require the max_dest_rd_atomic to be >= 1 */
 		if (qp->max_dest_rd_atomic < 1)
 			qp->max_dest_rd_atomic = 1;
-- 
2.39.5



