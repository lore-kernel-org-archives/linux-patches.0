Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69E82571DB;
	Tue, 25 Mar 2025 12:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905925; cv=none; b=dOfK5w5K9yXYsSYL4vE4mflTSjKfuNDGmiI9FDsLGp1sciQ0yJRLfP5L70I0S6Oa3oSwsfJiLpKw91a3PwwGYcBW4CF9rDAyCY0/A/gtdhiggPHyYxIPUjYIyrRyUhjOnVgJAKry4p+LC1LgQ6T+iZqEFM46qlHy8ARoxrgJ4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905925; c=relaxed/simple;
	bh=8iovvrGktmPR/ZGQUiyynB/T5ggQtzd69SvGbu3uIUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkMmsLUX2d7xQBqrJucjh2nZuuStll+zXSUnU6k0Dtx8Fu5f2Fw0q+r/wO3YK+VE+8qheE9o7g4+pX274CyvT0onr1bOlzGqb/m9TE+WR0AmMi/pbs+JG18svexXhjRvnEbzKgAEVNhcUhiQqQpm6vWfcbRhcZYLA/DC9RxY0X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHAReDK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHAReDK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5281FC4CEE4;
	Tue, 25 Mar 2025 12:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905925;
	bh=8iovvrGktmPR/ZGQUiyynB/T5ggQtzd69SvGbu3uIUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHAReDK7tmGxxtJw505XvMktnwlKTkX8Ya05jNsj1RamnR7sHSFNW1D/j8CKGmLZM
	 w4sPMfFXC8iOM+6Hu23hY4ftcDkoMim0LNvB/FaFykOweRTEu44MJcTIpBF5Jwu6RU
	 QGhv/jmLSzsmU7/wTKaWlnsSG8OGHsN0jmgIso5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 022/119] RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path
Date: Tue, 25 Mar 2025 08:21:20 -0400
Message-ID: <20250325122149.637155525@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5336f74297f81..457eecb99f969 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1217,8 +1217,6 @@ static void __modify_flags_from_init_state(struct bnxt_qplib_qp *qp)
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



