Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E2A366567;
	Sat, 30 May 2026 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160840; cv=none; b=Ri8EnsmLcz0fduiMwE/S4jhZFMrfb432XHYBznEyzqG1fpJn0BG3aqnQbN1RVsQyB9cl87lAddjX5lzUbDGRb1B1DozHtjiGydDg5PsHsMl96Qatgdx7TARoUuF+WL1FeuWOkX7yk9l98F7QfQClmaeRJKhEAeX17d2nVT4dMLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160840; c=relaxed/simple;
	bh=thb2GH04hDVpLPc5Ig2zbBpmQN3qQmFum8dXMmhpt3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5VaLf4DsJhxfWHuVXijTgPPGLpVX8BU3qv/6YIlDVP4AFanpTFGMlL1o0LJyMkgnBDlRus2WScCmcwgzVSGaXllCIhcvCElwwDwCGbOt4ePQnZbOHiyszXAUNzlNycUtcSuLMqkk1W9jILqUr3Dz4Hih1STJTuMFFRLkpQ/sF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecKT6Ikj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecKT6Ikj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684AF1F00893;
	Sat, 30 May 2026 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160839;
	bh=CEV2+0SF4poX+ZBxJgQ6m/KJOK7shxX6iUeejaMgWus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecKT6IkjaZ6PoyXrSiVCfCXfPtsI7zvkcHmDDlUErU+Z6HPa8L81YzznpeKLoYAm2
	 g7wzdZ6tKtfB4pxmb5adh3WKCHKKFPVN6b8vJrr+tj/8EIQHX/x0JIJ7Lr96GRV7QS
	 WyJUgYGxuYolAUCr1DtFlSfNQ5NLwBX1AGblCjMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 450/969] dpaa2: add independent dependencies for FSL_DPAA2_SWITCH
Date: Sat, 30 May 2026 17:59:34 +0200
Message-ID: <20260530160312.705117553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 12589892f41c4c645c80ef9f036f7451a6045624 ]

Since the commit 84cba72956fd ("dpaa2-switch: integrate
the MAC endpoint support") included dpaa2-mac.o in the driver,
but it didn't select PCS_LYNX, PHYLINK and FSL_XGMAC_MDIO. it
will lead to link error, such as
undefined reference to `phylink_ethtool_ksettings_set'
undefined reference to `lynx_pcs_create_fwnode'

And the same reason as the commit d2624e70a2f53 ("dpaa2-eth: select
XGMAC_MDIO for MDIO bus support"), enable the FSL_XGMAC_MDIO Kconfig
option in order to have MDIO access to internal and external PHYs.

Because dpaa2-switch uses fsl_mc_driver APIs, add depends on FSL_MC_BUS
&& FSL_MC_DPIO as FSL_DPAA2_SWITCH do.

FSL_XGMAC_MDIO and FSL_MC_BUS depend on OF, thus the dependence of
FSL_MC_BUS can satisfy FSL_XGMAC_MDIO's OF requirement.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Suggested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Link: https://patch.msgid.link/20260312065907.476663-2-caixinchen1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index d029b69c3f183..36280e5d99e1f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -34,6 +34,10 @@ config FSL_DPAA2_SWITCH
 	tristate "Freescale DPAA2 Ethernet Switch"
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
+	depends on FSL_MC_BUS && FSL_MC_DPIO
+	select PHYLINK
+	select PCS_LYNX
+	select FSL_XGMAC_MDIO
 	help
 	  Driver for Freescale DPAA2 Ethernet Switch. This driver manages
 	  switch objects discovered on the Freeescale MC bus.
-- 
2.53.0



