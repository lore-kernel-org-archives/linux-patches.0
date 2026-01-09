Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59690359F99;
	Fri,  9 Jan 2026 12:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960400; cv=none; b=rOHoAbf7uiN+g6I3FFg7rXmzfjNxUTKBC3XBP/YhOZyHZAq+2XPBlxSU+3w/PFU+RRwDoGEOSsFzhZU+YscNp36WoEwfcZ/G9g0FTsY7TCFRarB8SdOi8sY30HOxPl9LCAO71QKUx28Wnz072+kQSqUHuyv+nXGVMahDdbtCUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960400; c=relaxed/simple;
	bh=obkef75NRodlE4i3ScSRpVG+u/eSEegHMnddeUXQ+Wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFkvkmNKMFY+qiKgpE738SeBYbufwBTc3PJyqmhQVqgw2eTl4rk8Cg0qaGMzucYevq0IqhDq7UV4b6ojYbV3nEsHDHeUMxq/e/5e0Xg7E+QQg2lSojWHJMzISbUS7sqh3FDszLwHnY022l/BRGxx7KOdmR/YkFH1F2PPUnNTlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zflqiDh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zflqiDh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A763FC4CEF1;
	Fri,  9 Jan 2026 12:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960400;
	bh=obkef75NRodlE4i3ScSRpVG+u/eSEegHMnddeUXQ+Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zflqiDh35jLHQM1w8F291oDlh6owEXLfAHRFo60MQZTMuTVVGGX+qiT/wbn8zTW3O
	 FxZa2VUT2wGeU5p8uApEBamil1zftwKQcW/iWLq/xB+mhoOxiYBYpEeK2ZJZVy2AzZ
	 k9ySHoV73m3IvIOcDt5vzAcqmSikFunqGPwxv6Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/737] net: enetc: do not transmit redirected XDP frames when the link is down
Date: Fri,  9 Jan 2026 12:38:16 +0100
Message-ID: <20260109112147.425574267@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 2939203ffee818f1e5ebd60bbb85a174d63aab9c ]

In the current implementation, the enetc_xdp_xmit() always transmits
redirected XDP frames even if the link is down, but the frames cannot
be transmitted from TX BD rings when the link is down, so the frames
are still kept in the TX BD rings. If the XDP program is uninstalled,
users will see the following warning logs.

fsl_enetc 0000:00:00.0 eno0: timeout for tx ring #6 clear

More worse, the TX BD ring cannot work properly anymore, because the
HW PIR and CIR are not equal after the re-initialization of the TX
BD ring. At this point, the BDs between CIR and PIR are invalid,
which will cause a hardware malfunction.

Another reason is that there is internal context in the ring prefetch
logic that will retain the state from the first incarnation of the ring
and continue prefetching from the stale location when we re-initialize
the ring. The internal context is only reset by an FLR. That is to say,
for LS1028A ENETC, software cannot set the HW CIR and PIR when
initializing the TX BD ring.

It does not make sense to transmit redirected XDP frames when the link is
down. Add a link status check to prevent transmission in this condition.
This fixes part of the issue, but more complex cases remain. For example,
the TX BD ring may still contain unsent frames when the link goes down.
Those situations require additional patches, which will build on this
one.

Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251211020919.121113-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 7accf3a3e9f0d..e3ab6f4f8dbba 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1429,7 +1429,8 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 	int xdp_tx_bd_cnt, i, k;
 	int xdp_tx_frm_cnt = 0;
 
-	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags)))
+	if (unlikely(test_bit(ENETC_TX_DOWN, &priv->flags) ||
+		     !netif_carrier_ok(ndev)))
 		return -ENETDOWN;
 
 	enetc_lock_mdio();
-- 
2.51.0



