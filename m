Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E944A2D613;
	Wed, 23 Apr 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419798; cv=none; b=pyONLNTvOuisw8zeUcYlo0mOwReDLLIdCygLdzGf5PTI6ckNN+D4zKF72kCBfIx98B/JK4YyhwI1rE4hpqEx5rL6aeYehawWbAU5ETcUllVaNFyGA+jgQwgLaDi6PpxcfmMH5B0Hr7JLNHx/vziXDt1pKOT37/ftUaXdeMkyCyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419798; c=relaxed/simple;
	bh=7cKmZExJ80Y5M+NbHmpypRGCe+Ww/m1Zk7iXLRWrUDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOCDrf+IxYUbW71/b7QP80tZ/I72m3VK43yi5sdU72m/cJSXSdHvthIENsPdaFOs4bIAXpUOp1eUHSYiSOfS7rVuRPTJc8mTZYnyIGtEGIVfYTRm007951yglTekE1HJwjeHO1dg7sJ2iiDi6kQtGqBs5DkjoKaBwcw7iBCx6AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uB/pyUTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uB/pyUTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD1FC4CEE2;
	Wed, 23 Apr 2025 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419797;
	bh=7cKmZExJ80Y5M+NbHmpypRGCe+Ww/m1Zk7iXLRWrUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB/pyUTmDzw0h6hIuURaW717HtwfGmnHwwLuPNWhXa1umz0iFluJRtZTI2nI2AcDO
	 t+XAVpwrGjT3AYtLePDtqNGWr5rTQXOAZTZUKOUjd0IPMVxVlObVXnmSOcNMsEviAv
	 GVKQwfvJTH+DCm/RhDrBdsm1rAIlyoDNpwzLrZ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/223] net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered
Date: Wed, 23 Apr 2025 16:42:15 +0200
Message-ID: <20250423142619.701926311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c84f6ce918a9e6f4996597cbc62536bbf2247c96 ]

Russell King reports that a system with mv88e6xxx dereferences a NULL
pointer when unbinding this driver:
https://lore.kernel.org/netdev/Z_lRkMlTJ1KQ0kVX@shell.armlinux.org.uk/

The crash seems to be in devlink_region_destroy(), which is not NULL
tolerant but is given a NULL devlink global region pointer.

At least on some chips, some devlink regions are conditionally registered
since the blamed commit, see mv88e6xxx_setup_devlink_regions_global():

		if (cond && !cond(chip))
			continue;

These are MV88E6XXX_REGION_STU and MV88E6XXX_REGION_PVT. If the chip
does not have an STU or PVT, it should crash like this.

To fix the issue, avoid unregistering those regions which are NULL, i.e.
were skipped at mv88e6xxx_setup_devlink_regions_global() time.

Fixes: 836021a2d0e0 ("net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region")
Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414212850.2953957-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index a08dab75e0c0c..f57fde02077d2 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -743,7 +743,8 @@ void mv88e6xxx_teardown_devlink_regions_global(struct dsa_switch *ds)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++)
-		dsa_devlink_region_destroy(chip->regions[i]);
+		if (chip->regions[i])
+			dsa_devlink_region_destroy(chip->regions[i]);
 }
 
 void mv88e6xxx_teardown_devlink_regions_port(struct dsa_switch *ds, int port)
-- 
2.39.5



