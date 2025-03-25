Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0E2571AC;
	Tue, 25 Mar 2025 12:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906098; cv=none; b=EP9sdH/VVPNtdWF3Zw0I4veHcs5xIF0pV4Fld2OTJkWqjXjH5soiXhmXPY8+UKY9qYTEYblDEDfGfo2nxRrEWOPbcCLGOOytBH8t/Y7yfossEXr7hXsSdU3uvuNFVVJWXMA1WwVnCi2KQ8JdlX8YcngeyTvHY/OpHhydCOKRGdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906098; c=relaxed/simple;
	bh=rXnogmdeCHokgsxtKtwvCIOr0Lva8IPBBMDwqIgzIGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjKYfXiZg2EH/GCqWW0KrObP9e0Idho5OeoAwibUer0ayHr+VW7aWvefiOXWvlhfB9I2tuko+RTejAlTUDr3S0QTWw9+p5Q+dsTav/HhO1AyCJ63HzDfL4LgHRa3mE47PXHi+KWIG1+mpkdEVFV8d1frugCPn0amIkWDuYGs4ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJnhmuLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJnhmuLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1470C4AF0B;
	Tue, 25 Mar 2025 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906098;
	bh=rXnogmdeCHokgsxtKtwvCIOr0Lva8IPBBMDwqIgzIGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJnhmuLV/GaGPcz9G8Jt2n8KA1oJjtnlnaEMvu1c0mx4XhwUMhty6VltQDjvwO0te
	 JNQ4ARJ0U7e4BcuAv/kCmLd7Sg03p5e6qqIod5XRx/qVq5zkumdIadPNC2waUrkCuj
	 h6rCBDhTBeHvaDnp8c3J3EncXlKF0Xqty3gDtpos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/77] RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path
Date: Tue, 25 Mar 2025 08:22:09 -0400
Message-ID: <20250325122144.708946225@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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
index c4f10498c79d8..68ea4ed0b171b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1197,8 +1197,6 @@ static void __modify_flags_from_init_state(struct bnxt_qplib_qp *qp)
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



