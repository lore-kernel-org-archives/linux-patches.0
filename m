Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C15B21D5BE;
	Tue, 20 May 2025 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750636; cv=none; b=F251Kl7U0b7M5s8lsa9UMBrHmXgaIAMIItNwL2vYG+fSbs4WQwWaZe2RX3GZChCRjPLCCnurPYhWLKlfSLM88EwTdZXjGFh8i1sUHrEA43H/tZNooBVuKJaI72DIjLO8MwzIxpr7gvj4ZaxmzjoNzadRioWvhImNMegqJIpKOaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750636; c=relaxed/simple;
	bh=vncJMeIXYIcJrPKIE+kBGhQDRGf0fcmG2HoHGtTbAdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFaUbpqfUufdihb4CQm6U8yKliZNNeRLzS2ZAR98SnMa1GIF3fgqsgPo7FKKdwJo1JPRayfod7T5L/OWMHKCalH6UzIh4Le1Yv3+ehFkOMhfvLp2AWJQ23NnGOY9ZvZTV5I2x3pLjeajKoa1spHfRgI+H/6S/kaHy9GKiuiqFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKCs/LFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKCs/LFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF7EC4CEE9;
	Tue, 20 May 2025 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750636;
	bh=vncJMeIXYIcJrPKIE+kBGhQDRGf0fcmG2HoHGtTbAdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKCs/LFt5B12Y9qyotoM1aFG+fBAL0WRox/tOwIrYQm36jn8WJ2ok3LLapYUsFYyH
	 2Aa0qgNPN2FqAc1Y/WLjalY3gEpW6V7rYLgkfULPjGgSFSa4Hussi4QH2/Mm44rMzH
	 mKyGPZDt8pOuMLVFJ9HpUMoeW47VdSWLohJWg4WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 045/145] qlcnic: fix memory leak in qlcnic_sriov_channel_cfg_cmd()
Date: Tue, 20 May 2025 15:50:15 +0200
Message-ID: <20250520125812.339489652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 9d8a99c5a7c7f4f7eca2c168a4ec254409670035 ]

In one of the error paths in qlcnic_sriov_channel_cfg_cmd(), the memory
allocated in qlcnic_sriov_alloc_bc_mbx_args() for mailbox arguments is
not freed. Fix that by jumping to the error path that frees them, by
calling qlcnic_free_mbx_args(). This was found using static analysis.

Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250512044829.36400-1-abdun.nihaal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index 28d24d59efb84..d57b976b90409 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -1484,8 +1484,11 @@ static int qlcnic_sriov_channel_cfg_cmd(struct qlcnic_adapter *adapter, u8 cmd_o
 	}
 
 	cmd_op = (cmd.rsp.arg[0] & 0xff);
-	if (cmd.rsp.arg[0] >> 25 == 2)
-		return 2;
+	if (cmd.rsp.arg[0] >> 25 == 2) {
+		ret = 2;
+		goto out;
+	}
+
 	if (cmd_op == QLCNIC_BC_CMD_CHANNEL_INIT)
 		set_bit(QLC_BC_VF_STATE, &vf->state);
 	else
-- 
2.39.5



