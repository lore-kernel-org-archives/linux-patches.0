Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E904A2058;
	Wed, 23 Sep 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174577; cv=none; b=IirWnj3luxeGVH+zWeQ+y187GzItDmCZ4jyJLCghQ2gTUrzChDHETP8WU1qOX0jEyxMO84W25nrnzTwT//XfCc9U9arY+d8vQtIr2uebA3c+/G2jUnHTqOm9ifm+L0zuc1N0fMC1t+rDdAUmNl7Kp4zwEK8wY8d6hIygFqQy0mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174577; c=relaxed/simple;
	bh=BfZ3Cxs/5Tb1LLB0NxSOV/z54h9M/AdkueDLsQinFos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CduaiEHFsQCUuPEETI1BtjM2L7tCeTxHLosGCzqVlsncK8g796lIZ25qhVaCcjYLCWVljGO2Z9sAlR/V0rlIG1NR9oXTSKVvJCTEOVlRGLXHdVRQN9q86LXBZ8DhIIbIaQwMBC5GMbDleDCIocotg1NzSad4ZEMiX/suOQfEs8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8LCi0Tk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8LCi0Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA35E1F00893;
	Wed, 23 Sep 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174576;
	bh=tbuXOnlBYpzCCV8KsjSIoPXMBwaV87IXR96cGhWjM0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8LCi0TkM9kudsNS6q9stFCYR3XQps+6VwFM2PcEarkQIYxBjlQXzSWX41P9b+Mk7
	 XlsuNx2pSqOEbx4mfSCfdDlfMmhdppswQC1QWT21j6lvhdRbtWnfKI+ImT0K5ty8re
	 d2+GUdEGVTk7n/04iAI193r6KmX7FZz9QNfRCr+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/398] net: stmmac: do not overwrite phc_index when no PTP clock is registered
Date: Wed, 23 Sep 2026 16:03:53 +0200
Message-ID: <20260923140647.555343125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit f0ef4b1eaed000a304726a43091588e8426ba08a ]

stmmac_get_ts_info() reports phc_index as 0 when hardware timestamping
is supported but no PTP clock has been registered yet (e.g. while the
interface is down). Zero is a valid PHC index and would make userspace
resolve the wrong clock; the absence of a clock should be reported as
-1.

The ethtool core already initializes phc_index to -1 before invoking
the get_ts_info callback (ethtool_init_tsinfo()), so just drop the
erroneous assignment.

Fixes: 9364fa7fcf12 ("net: stmmac: Remove setting of RX software timestamp")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260914-stmmac-fix-phc_index-v2-1-bf3d90373fe4@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 81d4039e1c082..741e3864f5094 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -1059,8 +1059,6 @@ static int stmmac_get_ts_info(struct net_device *dev,
 
 		if (priv->ptp_clock)
 			info->phc_index = ptp_clock_index(priv->ptp_clock);
-		else
-			info->phc_index = 0;
 
 		info->tx_types = (1 << HWTSTAMP_TX_OFF) | (1 << HWTSTAMP_TX_ON);
 
-- 
2.53.0



