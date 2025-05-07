Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B351482F5;
	Wed,  7 May 2025 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644270; cv=none; b=UO5Eu6hCFIK7h277n7L2B1PWbUBDhcMGPg2P8HejsHegaaZJ14vdI5SotoHTNOgAYmkrh+V5KkqJB51U25TXpR9FjCkaB1DZBXP6/1jwvpn+0YdqJxTYP5MNy1jzAj/xGWIzhv+jPRdUSRHs/SBFvB+pMF+KmSuWr+loXgJuFGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644270; c=relaxed/simple;
	bh=F30zkno1XkseOOvLV/KbVUm3o+7OD2fshNx1Bvtv9ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loNGZAJQ3QXYckjbh+I8MIAD0+qCwPb2zhIWc1WJxPMsc6KSEx2R9nvSSSmrHNbwfDiFDcrHB/1FfQ5MPDl7BN9SSye6TwrWsLLYZeyX5LNScyLxErVk/ftg/hlpCnBVTr9btb0WJEF3KNwGQVa2Xp1Qg/rKLZtquVzmP+MdhrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D88iTnPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D88iTnPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C77C4CEE2;
	Wed,  7 May 2025 18:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644270;
	bh=F30zkno1XkseOOvLV/KbVUm3o+7OD2fshNx1Bvtv9ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D88iTnPzjhDoI9uzB6UnVDJZmG9g78LdGZTpeSgCWmYOQXQtbzwxGjs/2eb93WpjU
	 s+WfMCYAL5mbw/GOymOx81zYEFDHLtMV5LGf3rRX4FuiBtkqSzunOf/ZIZrsX2dxXZ
	 jMkCI5ezwLNPSqR9s6oqMaDoOAWmIlzQNwzxWezo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 146/183] net: vertexcom: mse102x: Add range check for CMD_RTS
Date: Wed,  7 May 2025 20:39:51 +0200
Message-ID: <20250507183830.783391352@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d4dda902dac194e3231a1ed0f76c6c3b6340ba8a ]

Since there is no protection in the SPI protocol against electrical
interferences, the driver shouldn't blindly trust the length payload
of CMD_RTS. So introduce a bounds check for incoming frames.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-4-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 3edf2c3753f0e..2c06d1d05164f 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -337,8 +338,9 @@ static void mse102x_rx_pkt_spi(struct mse102x_net *mse)
 	}
 
 	rxlen = cmd_resp & LEN_MASK;
-	if (!rxlen) {
-		net_dbg_ratelimited("%s: No frame length defined\n", __func__);
+	if (rxlen < ETH_ZLEN || rxlen > VLAN_ETH_FRAME_LEN) {
+		net_dbg_ratelimited("%s: Invalid frame length: %d\n", __func__,
+				    rxlen);
 		mse->stats.invalid_len++;
 		return;
 	}
-- 
2.39.5



