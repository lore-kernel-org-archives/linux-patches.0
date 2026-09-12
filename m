Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CADBCA6F;
	Sat, 12 Sep 2026 11:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211557; cv=none; b=L0R8eu4wqVHoRg1fexHLVfHkig3atIaD2ZpmErRcjHrTdfQ2uGhVmwQ5qY2iprFnwZT8Dio+a1jPkBVxv8YgR2tMUJj0/KpP8E9fxmhPdzCtdBcB/2whVGB482b9TaXLUbnLUVm//L5rbZ+b0k+Sshu1b7MHjsg5NVcdDx1bmHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211557; c=relaxed/simple;
	bh=hA0kXd1nt/tj9kwi4xzg0eBfJ/y8wBELO0lLjo6sD44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdS3HM1z/9k91vyxFpsC8LPZjXGbTgwzL8bwVhd1Jw5m+XuTzAvcs/ZVGGO4R9w5zo8G1B9JWw5KIUuZGYhf4Ovxx4q3TpMSk6+eCqht5qWFbZ3EqlrxvyzeqzPWcCKuIBdnOZoWfu4t/0eq83SwRMXZ7WIS7K59SZhRub40JgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA/vL4DM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA/vL4DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4251F000FF;
	Sat, 12 Sep 2026 11:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211555;
	bh=DL5h4j9rxGR+ztuX61ScCVSmMGaxzo/eGztH0XxnHyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA/vL4DMPqt7ZCQzcDuGMTTEjeF5NuUUxQ2u6v4at9cnSoerKb2knuAMTfB7ZI/Ia
	 NJlwzhOy7uGmq9lZFiH408CmatNh4x7uv3F5kHgxOw70YCt+buqPWE6TzTnC9metNj
	 SVinDUpHQayWEdiUeFC31tluanKl5qjubssWDZqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1256/1518] octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()
Date: Sat, 12 Sep 2026 08:57:05 +0200
Message-ID: <20260912065651.923821016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4b92a3710d4a1d850ed6421c773e735cdca69b07 ]

rvu_mcs_set_lmac_bmap() declares lmac_bmap without initializing it and
only sets bits for valid lmacs with set_bit(), which ORs into the word
without clearing it first. Bits for invalid or skipped ports keep
whatever was on the stack, and the garbage is stored into
mcs->hw->lmac_bmap.

Initialize lmac_bmap to 0 so only valid lmacs are marked.

Found with Clang's -Wconditional-uninitialized.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812060730.6181-1-kmehltretter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index a80c8e7c94f28..d6c69ea7f10d7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -856,7 +856,7 @@ int rvu_mbox_handler_mcs_ctrl_pkt_rule_write(struct rvu *rvu,
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
-	unsigned long lmac_bmap;
+	unsigned long lmac_bmap = 0;
 	int cgx, lmac, port;
 
 	for (port = 0; port < mcs->hw->lmac_cnt; port++) {
-- 
2.53.0



