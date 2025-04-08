Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC6A227EBD;
	Tue,  8 Apr 2025 11:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112589; cv=none; b=EwH2MsGj8MQ4KN9ofWsNk7DTi1Zf3ZA46xuhXaVWI+b1zm70O3R+j1jGQS0Ly/P1+cW3QdOFuPe2WKQYbTXvhsO8AOhadczbfb5yhJSqJonW0A6JYjU02o3JduGDEaQbItQkMaumMdBa851O/PofAjGRde/5QqOfIAbh0cT31bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112589; c=relaxed/simple;
	bh=t94j+rE5SEUeYEOFFghKv1Wxm4JwjO9tiNLkerBpvhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlgKM7Yp4OIs5NK2uDjmTMQp5rUE0Q3DK7tp0m0dYE2fHmZbSWRQfyUHDauLpGKQcwsLeRAwixuvTsIy8y1o0OBbpZROf+wxR/EVJSN3ndgqCkeuh1OaEAB2Q2kaUCRzyXC+gCpWBRf1m/NuH3wcLFUYhTx6vURcSs4gi4mrXZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD/tDDPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD/tDDPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28DCC4CEE7;
	Tue,  8 Apr 2025 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112589;
	bh=t94j+rE5SEUeYEOFFghKv1Wxm4JwjO9tiNLkerBpvhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD/tDDPJaofN6N8bcK0Ae3kilz7HT0TzIpoNpzN58TANLk5uzQIWgrf5A5alJVCH1
	 1TrRV8SEIjbAZQ38ku9haU8iTc+7nez+MXF3GZ33Xlxtt8lQLkS4oK+nEvHTE/wA2i
	 khVOUyZJqjn7Q7/Dl3nESu/2hmfeyScHtdyDhl78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/279] RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path
Date: Tue,  8 Apr 2025 12:47:47 +0200
Message-ID: <20250408104828.610779678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27cf6e62422aa..3725f05ad297b 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1181,8 +1181,6 @@ static void __modify_flags_from_init_state(struct bnxt_qplib_qp *qp)
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



