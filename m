Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E6E2EFD9B;
	Mon, 17 Aug 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979174; cv=none; b=RfL/Bi3Mh6lqbkjbf6BU0pxR3RcfKeRXhnUuVPllr4OblQa40C6Br54oTzeqotA+I8cG6PUiXPsQKQ1o69RINt3iFWXfpjMK3wX7uCUM6cqu3ZEDbX8XE2MjrkL8jRFmDTeuhFzyJMV6/XhAmwgmbcBIKMd5A0C4wfkhi34Gi9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979174; c=relaxed/simple;
	bh=0nOUZAIrdbfX5HgD6A3xFOZzD4yuhVgkBtV6SFsKNHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMraOGOHvd9f02+7YS68m7WVAGWGCeX8YMhSrn0Jl1c1yNFbioISC2MzYZoEY9Dhwrqw6RPoxkMh4y6Mx4RVZ9RWkmB6oxczdcKSf6dDhn/POgmtKoVpQLlu+IvBf9aU5j24y4mGL4zakQaeIth2Fa49LT2OshQXGFKL4a4xLU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxvO3Fk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxvO3Fk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3FA1F000E9;
	Mon, 17 Aug 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979173;
	bh=ZF5TujDmRyhXZNShYDt//R0nlE1Mb+s9KishF39V3x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxvO3Fk9tLl9PpLvlovzUItDSACle5yyZfKr9yju4NhKOlnoCRSpx2bghdlCirHEC
	 38ANZtqcUziVl1vfDsC7R2iQNxspDXjEalQts086zB4+q7YXnZZp0lDfvN6uMn6Nj+
	 AAHOo7WreYMfifMSL5/xALSkpqmIJkeYfFjmPzsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Oppenlander <patrick.oppenlander@gmail.com>,
	Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/609] amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN
Date: Mon, 17 Aug 2026 15:27:10 +0200
Message-ID: <20260817132548.429577914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



