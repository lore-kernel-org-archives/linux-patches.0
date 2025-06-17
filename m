Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62AB2F94A6;
	Tue, 17 Jun 2025 16:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177575; cv=none; b=KMG9fR0Bviy13u3cUQJZfq01464TtCoJlkjfbJcZJomUSQFSWlWSkdb80J/iDWICOdnb+aeuLre34+r3tef4byvxJtEPZvQkk+NFGQPSEExz2DFcCjfGcI3QIl3zUTGuqyaQK6uzAwGuJkMeM9O1QjwVio+bP0W5szmJ2S0ySl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177575; c=relaxed/simple;
	bh=0pVOQCgGUx8VO6aaBkJaG0KPrMO5lFAFdD1xJ3dcmCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POUW1g6tY0kEDlV9bokGDYqug7SdwqRaxBTyOB7UO5+iwdlMs1bkWdTH6ZFTX0tYeySf2R9wKP/CBLVVqhjS02ok/J4fGNbNBnfWdm3GbpIYOXvNKsTvZvIlDIMomSkFpqM+gA7VHUa0WtLKyqcoHfkxN/QjZMRP2uqdTCZU05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9dd1riq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9dd1riq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142CFC4CEE3;
	Tue, 17 Jun 2025 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177575;
	bh=0pVOQCgGUx8VO6aaBkJaG0KPrMO5lFAFdD1xJ3dcmCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9dd1riqsQxuJmC8SBtE8ax0W/dyxBctPuldssoJoVxUYlK2/U2ilkhHTmZVf2gHX
	 S6Dxte7J84EFSRmuNU1L8fiTn4ilPZ/SR39uvhuuAHsWc4yJVeD/1wVzSQ3Np+kP+b
	 5haI7kmc5v3809y3KQvSfvFQf64z5a5Lp3pQlLvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 326/780] net: phy: clear phydev->devlink when the link is deleted
Date: Tue, 17 Jun 2025 17:20:34 +0200
Message-ID: <20250617152504.725307366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 0795b05a59b1371b18ffbf09d385296b12e9f5d5 ]

There is a potential crash issue when disabling and re-enabling the
network port. When disabling the network port, phy_detach() calls
device_link_del() to remove the device link, but it does not clear
phydev->devlink, so phydev->devlink is not a NULL pointer. Then the
network port is re-enabled, but if phy_attach_direct() fails before
calling device_link_add(), the code jumps to the "error" label and
calls phy_detach(). Since phydev->devlink retains the old value from
the previous attach/detach cycle, device_link_del() uses the old value,
which accesses a NULL pointer and causes a crash. The simplified crash
log is as follows.

[   24.702421] Call trace:
[   24.704856]  device_link_put_kref+0x20/0x120
[   24.709124]  device_link_del+0x30/0x48
[   24.712864]  phy_detach+0x24/0x168
[   24.716261]  phy_attach_direct+0x168/0x3a4
[   24.720352]  phylink_fwnode_phy_connect+0xc8/0x14c
[   24.725140]  phylink_of_phy_connect+0x1c/0x34

Therefore, phydev->devlink needs to be cleared when the device link is
deleted.

Fixes: bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250523083759.3741168-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc1bfd22fb812..7d5e76a3db0e9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1727,8 +1727,10 @@ void phy_detach(struct phy_device *phydev)
 	struct module *ndev_owner = NULL;
 	struct mii_bus *bus;
 
-	if (phydev->devlink)
+	if (phydev->devlink) {
 		device_link_del(phydev->devlink);
+		phydev->devlink = NULL;
+	}
 
 	if (phydev->sysfs_links) {
 		if (dev)
-- 
2.39.5



