Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B7E411689;
	Thu, 30 Jul 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423925; cv=none; b=dP2Uws4dIdfhICbOS4eUsOz8fs+MonACrUPOsgtyfHSI56WpgHLmcw4ZmlQi1txsQih9747bZHiyKUaMKHwop408tDRguMAwlUX/mpy22cmnmuiFL1Mrhco6oCFE+z51BkL3nXSwxcKmzG5DzwGm8mzDlti6ZW29WRvULzht950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423925; c=relaxed/simple;
	bh=P7SR4OlRu3l5D1meqYrC6RppD8VQodfL6lymHadSqQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxxVKl3KK/GET+cnOMvpk+zsArFG7f30+k+go8JLBl21Xe/EkQZ8dNE24Cxd/eHL3RPjjSb23WNLrvaVmBNxo2r80tHuiFERFM5e839SCAgtwMnCIY8KBnE/FGTZZXlolX9dr2l3S7R9fDg0c7ko1ChzeL+9jCKTcl+B6DKuNF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khWYWTA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khWYWTA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF5B1F000E9;
	Thu, 30 Jul 2026 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423924;
	bh=dcH3FC/ahuA43T/Pcr8S2Z0PA6deTnix2EkYL6c4VP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khWYWTA/YemTgqSNdoscJgrUEjUmG15AoW73WhD4LvFHkEct1KAsXR6oxJTlj49hH
	 JlexsUoIfao4aFMsoKobvbVl+0xC752XdZ/MmSCET4J0B56SxN0tjoHvXpolACVFAn
	 M0I/bnka0kDNCkPamfZ0HfayMtVs5op9Eby87tK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/675] net: phy: marvell: fix return code
Date: Thu, 30 Jul 2026 16:09:02 +0200
Message-ID: <20260730141449.648409416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 7d8ca62d6a9ef593780161586b4efc811ac094fe ]

Return the correct error code, not the value written to the register.

Fixes: a219912e0fec ("net: phy: marvell: implement config_inband() method")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260706120637.1947685-1-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index c248c90510ae51..f191b8c4321887 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -753,7 +753,7 @@ static int m88e1111_config_inband(struct phy_device *phydev, unsigned int modes)
 	err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
 			 MII_M1111_HWCFG_SERIAL_AN_BYPASS, extsr);
 	if (err < 0)
-		return extsr;
+		return err;
 
 	return phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
 				BMCR_ANENABLE, bmcr);
-- 
2.53.0



