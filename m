Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750E31A0733;
	Thu, 15 Aug 2024 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732693; cv=none; b=pc0tMqPkjO9mRurik7LrEn6my0R/FdV2vQ1kc770ZPx7TA41s1SKzzIpEVUOxR8ahmN5DkITtxkHRq5pUbK6g83cvVClYx2eeHqy/g6H7u1n+WgeqpBVgM7jAOygX05s/bwR7Z+bcHk8eG1VAo2d0DViImgrAn76x7K3mRwSyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732693; c=relaxed/simple;
	bh=lRMrOls95I6t6IdCESuy6j9BxWAkgbJXhO6vj1vkhJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia5ko7BsG3dXofKMBgSBmTC4Its7NKtRLYlApa/yDrsu6z+JzNjtJuRaM3OpdxKNd2a55SpcCrcgr85yJcTS52RNfBYZN7mcNBcvnC9X8EzdMxht7v5fVQZagf/Q+1eGHLcHky58n1AAQLJUQv6V6i3SlFUcGPGS8w20j+QYqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNGFPcfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNGFPcfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E410BC4AF0D;
	Thu, 15 Aug 2024 14:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732693;
	bh=lRMrOls95I6t6IdCESuy6j9BxWAkgbJXhO6vj1vkhJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNGFPcfLc6k07MNyrpPu8ke4eeIhyDlQ21womMZmRWjCqkwcbqrjgdUhIWBaBRsIe
	 Oxts+3I/9ZOZZjfwf7PVFT1aWQJe96Hzgx/O1avf4hzQa0xF+LMsxwXBbFsQpm1uxx
	 rPGe2P1SaHG890xFyTUMhQutz+nk3T07DQvHNh3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/352] net: dsa: bcm_sf2: Fix a possible memory leak in bcm_sf2_mdio_register()
Date: Thu, 15 Aug 2024 15:25:24 +0200
Message-ID: <20240815131929.416524387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e3862093ee93fcfbdadcb7957f5f8974fffa806a ]

bcm_sf2_mdio_register() calls of_phy_find_device() and then
phy_device_remove() in a loop to remove existing PHY devices.
of_phy_find_device() eventually calls bus_find_device(), which calls
get_device() on the returned struct device * to increment the refcount.
The current implementation does not decrement the refcount, which causes
memory leak.

This commit adds the missing phy_device_free() call to decrement the
refcount via put_device() to balance the refcount.

Fixes: 771089c2a485 ("net: dsa: bcm_sf2: Ensure that MDIO diversion is used")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240806011327.3817861-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index a5849663f65c3..d0f94a5fae5ae 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -558,8 +558,10 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 			of_remove_property(child, prop);
 
 		phydev = of_phy_find_device(child);
-		if (phydev)
+		if (phydev) {
 			phy_device_remove(phydev);
+			phy_device_free(phydev);
+		}
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-- 
2.43.0



