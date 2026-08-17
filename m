Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59FD3F1ABE;
	Mon, 17 Aug 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976801; cv=none; b=ZECiacgeh0R/lCzwYbiDmKdIlz0YgJXz8VEZgb1BpOV7AgxHzKoVf7HLjtl1P8PVRhixlCDiUlwFH9gB+4otzrADcawGjzk9pnYvAxnA4NQ/InRYeW3ycUqqVdvdVlveXKJq8dwO5jdop2TL8/AjF3g9XMkHBjHRBQN5srA2wUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976801; c=relaxed/simple;
	bh=9ALhicD3vO97VKd2hMZFlTGaNTztLDAA9qYt8iq0JXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sue2mg8oOzG/Pg8+g4rZJbVmIbzF73UXnli2k7LvMd5YV/HfEcVcRBvjTATX2FeMqadgZqw1zTbrYXrUPInbKs2Xipq5KtdxubtRfprwp8c8fgPN6yTLrt86vJKylKhotzaExbhybsLs8gtblhH2P0Baudp98XRoRyyCh3/JjBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hL0TMW4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hL0TMW4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52BB1F000E9;
	Mon, 17 Aug 2026 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976799;
	bh=b3bF6jR1niKwNI0INst46wugZf1CDYFLfJJCV0D3jv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hL0TMW4nEsGXriev1mvDrwMODZFbirO6249hmNQXAD0w/lkvGWezIwzQ1m6cPcpnN
	 llnWvBjHuCt1c0dRtACOBgATAO4cNowEp1D+X05A9HBWIMvVNHjhMvjMVAyI3dBgix
	 i8z6xHqvS0DW/OWCmB+TiK4EdOBv/Qwv7vKIgAyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Oppenlander <patrick.oppenlander@gmail.com>,
	Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/456] amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN
Date: Mon, 17 Aug 2026 15:28:19 +0200
Message-ID: <20260817132544.354533776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>

[ Upstream commit 4bf22afe53a1de4b44b04cf677fd5199089cbdff ]

MAC_AUTO_SW (VR_MII_DIG_CTRL1 bit 9) enables automatic XPCS speed
mode switching after CL37 auto-negotiation and is only meaningful in
SGMII MAC mode. The original code unconditionally set this bit on
every call to xgbe_an37_set(), including when called from
xgbe_an37_disable() with enable=false. This left MAC_AUTO_SW=1 after
AN was disabled, causing the XPCS to autonomously switch speed from
stale AN state during subsequent mode changes, breaking SGMII speed
negotiation on 1G copper SFP modules.

Patrick: This was breaking negotiation for all 1G SFP modules,
not just copper modules.

Fixes: 42fd432fe6d3 ("amd-xgbe: align CL37 AN sequence as per databook")
Reported-by: Patrick Oppenlander <patrick.oppenlander@gmail.com>
Link: https://lore.kernel.org/netdev/CAEg67GmFS0Q4oSZkz8zWdOzckSth9_vBPiOy6a7-d697C2w2Xg@mail.gmail.com
Signed-off-by: Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>
Tested-by: Patrick Oppenlander <patrick.oppenlander@gmail.com>
Link: https://patch.msgid.link/20260709095006.3683940-1-prashanthkumar.k.r@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index ebb8b3e5b9a882..01c37ffc9ceb81 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -364,9 +364,14 @@ static void xgbe_an37_set(struct xgbe_prv_data *pdata, bool enable,
 
 	XMDIO_WRITE(pdata, MDIO_MMD_VEND2, MDIO_CTRL1, reg);
 
-	reg = XMDIO_READ(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL);
-	reg |= XGBE_VEND2_MAC_AUTO_SW;
-	XMDIO_WRITE(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL, reg);
+	if (pdata->an_mode == XGBE_AN_MODE_CL37_SGMII) {
+		reg = XMDIO_READ(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL);
+		if (enable)
+			reg |= XGBE_VEND2_MAC_AUTO_SW;
+		else
+			reg &= ~XGBE_VEND2_MAC_AUTO_SW;
+		XMDIO_WRITE(pdata, MDIO_MMD_VEND2, MDIO_PCS_DIG_CTRL, reg);
+	}
 }
 
 static void xgbe_an37_restart(struct xgbe_prv_data *pdata)
-- 
2.53.0



