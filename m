Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0FC449B28;
	Thu, 30 Jul 2026 16:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427412; cv=none; b=XxCQZBMVY6BEE78m88ty200eiai4jjSgpstptQZ2KMPBpSuuLpfjRiZCVhI5I3R+7Z9CGHZ/SV4giggF9pD0z6J/wFuthvevOMhLRAWuBiaamipprxYg27gHceKk5jYu+mPEqk0Ja0paJyK+2nuo/tslOPQCgRCNnX8sDseLg7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427412; c=relaxed/simple;
	bh=yd0jxsOnc6NwrV/vtjhVzoi7jOAmFHbFPy9DTnYhl4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzEH6Tiwth95G8m0/mSGcUQ819qXZbHLZB4+SqQF24yj9WGKmqgSfP6wePckmllTTx0QUfmF8qtvzXZZm5uFxOGrtOnmM+Lf4CaugXajcaewJt7Y6e/D5V6r/PHz/H0qyvhdbA/sqoBKkchuT/jK3mFW+BoYcktB/tl1os4FoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOXREvUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOXREvUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB061F00A3A;
	Thu, 30 Jul 2026 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427411;
	bh=0duoo2YKHPH2JC+oLIB3dbl/LfpKUUAvVACLJEG4uq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOXREvUQCcUYVfs/HYSrLlqynvbqU3vl8A9oKVNaGFypHb1HPCS3OnYztZztmMtpK
	 /bpZ1qOYDNMVOZFOMCe+owodyuoK2zkG4m2duMNDuij0qpkBvEd1ch2uVcjhqwvORI
	 8lD5AmVfuZWFw4VVhtW6fvnv1E9+ojc60pu074Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Oppenlander <patrick.oppenlander@gmail.com>,
	Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/484] amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN
Date: Thu, 30 Jul 2026 16:10:57 +0200
Message-ID: <20260730141426.942913812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 63012119f2c8eb..4e4e0735cb2ada 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -376,9 +376,14 @@ static void xgbe_an37_set(struct xgbe_prv_data *pdata, bool enable,
 
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



