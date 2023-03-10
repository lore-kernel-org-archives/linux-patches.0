Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552878481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4B0C4339B;
	Fri, 10 Mar 2023 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457305;
	bh=RDJmZDRanIDkLcwex34c2+qm5+RPJMT4/fVPl7NaEME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMBNnemarkpxcNukeiQZQ4aTTchDCduo/f6Xcs5E5R2XxPmqmvL+ddshViBp0n0a8
	 GhUjt1SrAeh94sfQ+kXUKTGIstDs6am0Goi7uSDC1GZACVgFMTiaGrt+8nus6nv2lo
	 eO1m+mmHQT42Led1EzrYGnBCpX+4jn/h82lSXpCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/200] net: dsa: felix: fix internal MDIO controller resource length
Date: Fri, 10 Mar 2023 14:38:18 +0100
Message-Id: <20230310133719.911663059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit 940af261321307cd1dd0fe8f9c34a6129f9d4bdc ]

The blamed commit did not properly convert the resource start/end format
into the DEFINE_RES_MEM_NAMED() start/length format, resulting in a
resource for vsc9959_imdio_res which is much longer than expected:

$ cat /proc/iomem
1f8000000-1f815ffff : pcie@1f0000000
  1f8140000-1f815ffff : 0000:00:00.5
    1f8148030-1f815006f : imdio

vs (correct)

$ cat /proc/iomem
1f8000000-1f815ffff : pcie@1f0000000
  1f8140000-1f815ffff : 0000:00:00.5
    1f8148030-1f814803f : imdio

Luckily it's not big enough to exceed the size of the parent resource
(pci_resource_end(pdev, VSC9959_IMDIO_PCI_BAR)), and it doesn't overlap
with anything else that the Linux driver uses currently, so the larger
than expected size isn't a practical problem that I can see. Although it
is clearly wrong in the /proc/iomem output.

Fixes: 044d447a801f ("net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 26a35ae322d10..cc89cff029e1f 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -513,7 +513,7 @@ static const char * const vsc9959_resource_names[TARGET_MAX] = {
  * SGMII/QSGMII MAC PCS can be found.
  */
 static const struct resource vsc9959_imdio_res =
-	DEFINE_RES_MEM_NAMED(0x8030, 0x8040, "imdio");
+	DEFINE_RES_MEM_NAMED(0x8030, 0x10, "imdio");
 
 static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
-- 
2.39.2



