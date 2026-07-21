Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21374265606;
	Tue, 21 Jul 2026 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663127; cv=none; b=j1ymqhfGPQZYPncl3lG1QDRdD3ZBX1DtMAf46DwgzUsNqRkeyh4lvyjSflSQNI9D7s5z70LiKOB6YfMKO3Mx8SabfEp8mWj/9ZYhial4AvowPrPy4l7ll+knz7wTRe4H4Jxa6miYsJVg1Kj0C9mFB3ZOZ8zftfurxweX+rU5EHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663127; c=relaxed/simple;
	bh=boOZM3uE/viPM/5ehjVMC5vb+u7HKsQBUYtRGRc0VqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeCC/NErsJvIhIGbu3F4SFn95rFEkyCcKQmIcd8TvIaXTXMJc2HVMzkvRBAy9i36iuyeFRDFP8tLRukO9N5o21w4QGJualzjA1yggCCn896WaDhpaM0GNhbPRUZsHixd5NG0r2swQ2UQZGygHdB8GIyiMSgbMxSlq531x01BJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPSnpn8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPSnpn8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870471F000E9;
	Tue, 21 Jul 2026 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663126;
	bh=Ov0DWyhmvxD+Hxm5yiSaWHfRKJt/B9PajgGiCb8jw5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPSnpn8ZB652MWXR2gGZ9euqqzXfi2szyBeKRwv9Ap6eVI6ItRbdEp9FIH3uDwo2I
	 Rh/lDiniwwNJETEK/1aqjbevSh4eZDpRSn1nBREOAmV1thFGB+3GiH6jChPn7I/x8S
	 0SJXkYSu390iH1C3efbVwRv9icl46t9FSQf9Yz7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0706/1276] net: phy: sfp: free mii_bus in sfp_i2c_mdiobus_destroy
Date: Tue, 21 Jul 2026 17:19:09 +0200
Message-ID: <20260721152501.894152270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 8f31efff9206f9f0adb853cad6916086aac4d5ef ]

sfp_i2c_mdiobus_create() allocates the I2C MDIO bus with mdio_i2c_alloc(),
a plain (non-devm) allocation, and registers it. sfp_i2c_mdiobus_destroy()
only unregisters the bus and clears sfp->i2c_mii without calling
mdiobus_free(). As the only reference to the bus is then cleared, the
struct mii_bus is leaked.

This is hit whenever a copper/RollBall SFP module that instantiated an MDIO
bus is removed: sfp_sm_main() takes the global teardown path and calls
sfp_i2c_mdiobus_destroy(). sfp_cleanup(), on driver unbind, frees
sfp->i2c_mii directly, which is why the leak only triggered on module
hot-removal and not on unbind.

Free the bus in sfp_i2c_mdiobus_destroy() to match the allocation done in
sfp_i2c_mdiobus_create().

Fixes: e85b1347ace6 ("net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release")
Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/312bde8176fc429aa89524e3be250137f034ba84.1782581445.git.petr.wozniak@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 90ffba8f795209..6eefe98316f536 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -787,6 +787,7 @@ static int sfp_i2c_mdiobus_create(struct sfp *sfp)
 static void sfp_i2c_mdiobus_destroy(struct sfp *sfp)
 {
 	mdiobus_unregister(sfp->i2c_mii);
+	mdiobus_free(sfp->i2c_mii);
 	sfp->i2c_mii = NULL;
 }
 
-- 
2.53.0



