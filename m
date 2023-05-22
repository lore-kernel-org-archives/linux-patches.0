Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AED2171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1F4C4339B;
	Mon, 22 May 2023 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785110;
	bh=WgFIElB2wtjJ+GQ0NTkR5lCueB/0i2fYffIIj/pXTmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0PFO8UZmqveQSUEyeVnXm4O8TaMJW7i2VhMR4gOfcJ7d8/LsVwTjX/YpuXKPI5Yq
	 sjmUO+NvO0XEtIdaiq3GmKM9H6svbiHEYArFz/N9utExDCmMKE8R+x6t+oYGjofc22
	 hfgJd2xS3epO0fauCwUgt8W8eFoZRTlK9v0p+7zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 284/364] net: pcs: xpcs: fix C73 AN not getting enabled
Date: Mon, 22 May 2023 20:09:49 +0100
Message-Id: <20230522190419.833281720@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c46e78ba9a7a09da4f192dc8df15c4e8a07fb9e0 ]

The XPCS expects clause 73 (copper backplane) autoneg to follow the
ethtool autoneg bit. It actually did that until the blamed
commit inaptly replaced state->an_enabled (coming from ethtool) with
phylink_autoneg_inband() (coming from the device tree or struct
phylink_config), as part of an unrelated phylink_pcs API conversion.

Russell King suggests that state->an_enabled from the original code was
just a proxy for the ethtool Autoneg bit, and that the correct way of
restoring the functionality is to check for this bit in the advertising
mask.

Fixes: 11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")
Link: https://lore.kernel.org/netdev/ZGNt2MFeRolKGFck@shell.armlinux.org.uk/
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 04a6853530418..2b84a46622be4 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -873,7 +873,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
-		if (phylink_autoneg_inband(mode)) {
+		if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
 			if (ret)
 				return ret;
-- 
2.39.2



