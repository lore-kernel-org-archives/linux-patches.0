Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57B034DCE4;
	Wed, 20 May 2026 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300186; cv=none; b=D7+xK7B48D/zPKup9mA+rL7EF+MdQGzLkHEKzv7JwXFJuz34v+IY3RBuSK3gjKBB1WJxV/qzTYmZ/pJetQ9TOfQsuLFZUEGodGPmdEWH6ONaxeGeO6hyBUjGR/p8WGNq0er6kIW62AHL8D6739qe3CLe/9i6xBo7a1cla5SjqQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300186; c=relaxed/simple;
	bh=mzpXFxfG0QnrFWwHV31pbgxHHWqQjbgl7hSvd8OBkzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN1ODJ/UCs+dNE6ZrfMdBwRv7gJJva1s/leZPX3YPWsCQEApOoplg5nZTg+tgFmDzmOhuAZzHsGQGvPC0IVZYXgowUEwsQ5l9+wl4G9i3DoYHpvI9gW8OtGxdSdtdhg37p1f+XSF9yufYKPjIdboYsvqUkJVB/+GT3cH+XGUsT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNFtu83z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNFtu83z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C741F00893;
	Wed, 20 May 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300184;
	bh=gAE/pLK2CL+xnTPhoaU1eAPf6sSjOouvRMyJcNTXzTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNFtu83zTV9ZH13d0IuUwYaFnJaxTd0lUXq/XD8Ha5b2bbMSVmvuESiR/CmVir6VZ
	 Fljw1BHPhCLfvgWQHSSyzJj5OH5pUABCNBgU2kIvWxZ0+5YsEa9jzjt9UONiAmA+sg
	 O6FmIaq71jX5wJmWdlT0xMO+ypaH/uIdf2nTQjkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/666] dpaa2: add independent dependencies for FSL_DPAA2_SWITCH
Date: Wed, 20 May 2026 18:14:08 +0200
Message-ID: <20260520162112.042778940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



