Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DAF270545;
	Thu, 30 Jul 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425884; cv=none; b=Icvkzs5Ckbe1KumLVH10Nng/Zo7Mdovw/2cajsu39H6hIKYyfBsQV9owCoBKQCkwZ4fuTntmvHG3tVkw3MwpzKIDzslbZjWHJxfGX836amscCvqp2z+r9z2Gzd412vqjB9zdzICAYtWeC8JUSAx6TgPblfWJHAx6VAJcBel4fyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425884; c=relaxed/simple;
	bh=KM8cbkAdjdJ/KLoNZpHAzMnHu7JbL9pNP+oxRCbA0Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THCBf+ieBWGjSrLvpQJ425qBafozMj1XrivyJPWSCw/+Q55zrX4OKbA/b5KT0Y+bJof6+TaPSxc2Ww6Qr8Vwt0VJU7itQVTeSCQNHoZtOMs7a7hKV7DJ+AS8Yb4xomJTLfAbWuqNHgJKDKHbVkhQfo8NYZXERmneMwzd6TnL2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbObRTfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbObRTfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC791F00A3A;
	Thu, 30 Jul 2026 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425883;
	bh=FIpzQ3kINEmc7uMqUXE1JrFThNTncPM/M3MGZUcFR6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbObRTfpt7V1h50q85N2GDhWp+3kE6QfiokKA9aP8oAEbqtNrY537LMt2qev5rzrJ
	 FmT4OtimbQX3crCpuwnEkZGGPGRSkuccl1FwkEIciFaZ7Lrgf1MJSI40T656URIATA
	 ddpJ8+0AvtpLvMAe3n6PSbA4xgTBsnZT7YQfddiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Oppenlander <patrick.oppenlander@gmail.com>,
	Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/602] amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN
Date: Thu, 30 Jul 2026 16:09:40 +0200
Message-ID: <20260730141439.911554552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 75e9cb3fc7aa66..804945ea602790 100644
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



