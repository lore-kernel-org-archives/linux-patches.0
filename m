Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F90826FA67;
	Tue, 11 Nov 2025 01:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823477; cv=none; b=JKUNGe5XAyFZbV9lzSaYAhAWmjDZ8pBI3wfRPSge0TXHUDgAyjU38Bo49PU1JCF1rfSKikDkEUusENAdQf7OHX5PqGvBXtiJJSPtGAEt1zGJXekgdGysRc/aHWhnMlGEOq3/RXnh1aBE2zAFEzxZkSYxDfaWtag3Qa45reaN67Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823477; c=relaxed/simple;
	bh=5qulNKsku3UAqvQ6ArelGhv53MXJwtRPDgT5E3cdJ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjISwMWLeitZtXJgld24lLsT63w4ytKqqsRnwuS/xo8TXhXqF27HqAyPCEpNkBqYnuWtVIP7Yu8RZma722cuApkzCnWrmpXut26ArJuQ+oshud969mmUNF87CCuPSCwcB1S3K5YV/rAwdq9TAF0V/1CIpICPBoYW/ecMWDuyh7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iENA8Utk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iENA8Utk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205DDC113D0;
	Tue, 11 Nov 2025 01:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823477;
	bh=5qulNKsku3UAqvQ6ArelGhv53MXJwtRPDgT5E3cdJ2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iENA8UtkkJK95hHYWnuUx8F1Gw959YBiRMtilPfoXCRVImZnI8uco9NBzdcAEO2u/
	 4kteZGw2ibQqTiAV31bXq6+9/dO35J6Av6ATGQ/0oKowXRYI6UXq0jcwZVhw8gP2Jh
	 08og7+ybGgy0vyqAFwQanDav1GvzdcSEDAPSgjno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/565] net: phy: fixed_phy: let fixed_phy_unregister free the phy_device
Date: Tue, 11 Nov 2025 09:41:50 +0900
Message-ID: <20251111004532.617378947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a0f849c1cc6df0db9083b4c81c05a5456b1ed0fb ]

fixed_phy_register() creates and registers the phy_device. To be
symmetric, we should not only unregister, but also free the phy_device
in fixed_phy_unregister(). This allows to simplify code in users.

Note wrt of_phy_deregister_fixed_link():
put_device(&phydev->mdio.dev) and phy_device_free(phydev) are identical.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/ad8dda9a-10ed-4060-916b-3f13bdbb899d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/dsa_loop.c  | 9 +++------
 drivers/net/mdio/of_mdio.c  | 1 -
 drivers/net/phy/fixed_phy.c | 1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index c70ed67cc1888..5c7f40acfa391 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -387,13 +387,10 @@ static struct mdio_driver dsa_loop_drv = {
 
 static void dsa_loop_phydevs_unregister(void)
 {
-	unsigned int i;
-
-	for (i = 0; i < NUM_FIXED_PHYS; i++)
-		if (!IS_ERR(phydevs[i])) {
+	for (int i = 0; i < NUM_FIXED_PHYS; i++) {
+		if (!IS_ERR(phydevs[i]))
 			fixed_phy_unregister(phydevs[i]);
-			phy_device_free(phydevs[i]);
-		}
+	}
 }
 
 static int __init dsa_loop_init(void)
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 2f4fc664d2e12..cc6ae8f35b1c2 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -473,6 +473,5 @@ void of_phy_deregister_fixed_link(struct device_node *np)
 	fixed_phy_unregister(phydev);
 
 	put_device(&phydev->mdio.dev);	/* of_phy_find_device() */
-	phy_device_free(phydev);	/* fixed_phy_register() */
 }
 EXPORT_SYMBOL(of_phy_deregister_fixed_link);
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index aef739c20ac4d..4694fb3eaa2ff 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -329,6 +329,7 @@ void fixed_phy_unregister(struct phy_device *phy)
 	phy_device_remove(phy);
 	of_node_put(phy->mdio.dev.of_node);
 	fixed_phy_del(phy->mdio.addr);
+	phy_device_free(phy);
 }
 EXPORT_SYMBOL_GPL(fixed_phy_unregister);
 
-- 
2.51.0



