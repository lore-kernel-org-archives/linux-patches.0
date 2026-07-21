Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142BE35201C;
	Tue, 21 Jul 2026 20:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666780; cv=none; b=sjVJqg/DwY+L0UguUTgITfgdQ7M23n0TnxXFiqA6wos4H4nnoybAScsxIwpGh9S8BBLpL2QX3ycWUEDBjAcG0h6YyHIBIBloJZT2dSlmcwsVgj/7DSmDtQwfwXh7iczgqW1c7y1Ivd786rSSxH2ch7QnTqjgFAnIZzB3tZHVQrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666780; c=relaxed/simple;
	bh=pcd0hktVsrdIoqakOLbbifzeNH0x8XubVHlE63sdn5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK1fIak5Kp9T9r72aygo/ZnDrMTA+WEYLOWA5x/FKnSP5a9YP7RUdGw7prvx5Qo9ZFwuY2h9o4XUumLaMAJ9PZpgv2Up0jQ3RJ54b7Yi2ek0TsS9NrMVwbt1x7kvDaghOja5hkiwMozPi9O6clpBoVtkGw/jqXx0rUtIZ3UoONk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e26/+N3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e26/+N3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704021F000E9;
	Tue, 21 Jul 2026 20:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666778;
	bh=mvo516WANLk+kJkuujQ9Ry1Z2H5sdLI+6KegK7ZlIZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e26/+N3jW1XQ+/7G/0iDLKUnsOBKPtTmKo7SrxAiBoDA4SCBjVFLYAoPV0hEUVyyz
	 nECRcwpKfAl1k4qWbV4T2hT60WWFrc30+M4VjKQDqv3lYQGDYpm5mxTIw0wniQD0jr
	 QQ7jLc79f39FJV2K02tWVJEK4YTJF7GiBrN4aBCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0811/1266] net: phy: sfp: free mii_bus in sfp_i2c_mdiobus_destroy
Date: Tue, 21 Jul 2026 17:20:48 +0200
Message-ID: <20260721152500.007352298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 165c624c985fd5..e352ceb2f7cba4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -747,6 +747,7 @@ static int sfp_i2c_mdiobus_create(struct sfp *sfp)
 static void sfp_i2c_mdiobus_destroy(struct sfp *sfp)
 {
 	mdiobus_unregister(sfp->i2c_mii);
+	mdiobus_free(sfp->i2c_mii);
 	sfp->i2c_mii = NULL;
 }
 
-- 
2.53.0



