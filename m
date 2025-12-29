Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BDB330332;
	Mon, 29 Dec 2025 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025104; cv=none; b=iqeQqD50qLcf5C8vMHLYhBofnxDuaKacBEiK1/gbkzbYSLjE3Am7uomJqrzbI6vnHwPNT3qJzXTowrO6gcLsVoXS7OjVD+OvaaSI1S+NqowitMcY6IvFeCUMdYvyitoAPJo3Oplr6f9zAHUSpltMMEql2Qt/dkycPJ154JIPTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025104; c=relaxed/simple;
	bh=kiT8YO+thGuPQTQN9u8Sjx50enSQlVHqwBlRB14+UT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDdWeNSRJKxV1RFPRmnINbW0kaLwToHEZjSbRcFrpXrtvHq+S/e3UqHCJH5jzxJL4QisIfXuwJ/iq1htWnA8Z6l2l8LR6Tbc1Tf+KeCsT9pGmZYwN2vGHvzVKg1fVC6tJa+BMIHnO64jMHPCoFp2IMmWbkWHD4B9yBK6MAXusLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhTCCbwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhTCCbwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1566C4AF09;
	Mon, 29 Dec 2025 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025104;
	bh=kiT8YO+thGuPQTQN9u8Sjx50enSQlVHqwBlRB14+UT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhTCCbwqcPaV0EwZC7HL0HGxz+HfxGw+sDe8+qR/P/Djr3HmxOxOAwKkXHOWICBHq
	 v17pZyxOFjO18WGEgII/1lyWMLn+v2N7ezd+W2ruz83KB96shluShMzVXyZTsskiWZ
	 yUbn7ZIZjiIhQs4LPqm7PC0Xucv+ef+FJ22vckWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Galkin <ivan.galkin@axis.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/430] net: phy: RTL8211FVD: Restore disabling of PHY-mode EEE
Date: Mon, 29 Dec 2025 17:07:45 +0100
Message-ID: <20251229160726.685571426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ivan Galkin <ivan.galkin@axis.com>

[ Upstream commit 4f0638b12451112de4138689fa679315c8d388dc ]

When support for RTL8211F(D)(I)-VD-CG was introduced in commit
bb726b753f75 ("net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG")
the implementation assumed that this PHY model doesn't have the
control register PHYCR2 (Page 0xa43 Address 0x19). This
assumption was based on the differences in CLKOUT configurations
between RTL8211FVD and the remaining RTL8211F PHYs. In the latter
commit 2c67301584f2
("net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present")
this assumption was expanded to the PHY-mode EEE.

I performed tests on RTL8211FI-VD-CG and confirmed that disabling
PHY-mode EEE works correctly and is uniform with other PHYs
supported by the driver. To validate the correctness,
I contacted Realtek support. Realtek confirmed that PHY-mode EEE on
RTL8211F(D)(I)-VD-CG is configured via Page 0xa43 Address 0x19 bit 5.

Moreover, Realtek informed me that the most recent datasheet
for RTL8211F(D)(I)-VD-CG v1.1 is incomplete and the naming of
control registers is partly inconsistent. The errata I
received from Realtek corrects the naming as follows:

| Register                | Datasheet v1.1 | Errata |
|-------------------------|----------------|--------|
| Page 0xa44 Address 0x11 | PHYCR2         | PHYCR3 |
| Page 0xa43 Address 0x19 | N/A            | PHYCR2 |

This information confirms that the supposedly missing control register,
PHYCR2, exists in the RTL8211F(D)(I)-VD-CG under the same address and
the same name. It controls widely the same configs as other PHYs from
the RTL8211F series (e.g. PHY-mode EEE). Clock out configuration is an
exception.

Given all this information, restore disabling of the PHY-mode EEE.

Fixes: 2c67301584f2 ("net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present")
Signed-off-by: Ivan Galkin <ivan.galkin@axis.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251202-phy_eee-v1-1-fe0bf6ab3df0@axis.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 2c661346050f1..7c3d277efaf07 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -664,10 +664,6 @@ static int rtl8211f_config_aldps(struct phy_device *phydev)
 
 static int rtl8211f_config_phy_eee(struct phy_device *phydev)
 {
-	/* RTL8211FVD has no PHYCR2 register */
-	if (phydev->drv->phy_id == RTL_8211FVD_PHYID)
-		return 0;
-
 	/* Disable PHY-mode EEE so LPI is passed to the MAC */
 	return phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
 				RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
-- 
2.51.0



