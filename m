Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE1331B13C;
	Mon, 18 Aug 2025 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524660; cv=none; b=shmesKrFYceIa3I4FkwAOOdb0U1t2qOxBTqwci0BZXt8l4dtBIXU21SI5Z2hpf7ENKL7dcV5XlVFbbSeYU33EeRBIEbmnGLsGCT0AHiggpev26G97RX7VgzD867GeaRylThlEwFRmfQDDpAL3sYvsOv8ApLtvcRXB+5JjwRzKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524660; c=relaxed/simple;
	bh=1l20gXdHbeBZJSC3kyeLBHdGpra/YQZBJM13z7guUCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI7Jwk6vz+QOiFKez71BpTDZ1fwW/FgsJ9+V01oWaSfeGBwyjCA3tt1bx0n4rILPMjLzOHA4OY3k11lJ9708241ybFX91uA8h5njrLvWTlVLWXi6qgr1Ina3weSrOykTedJvcLGr/TPh0W8p5Diejv8fF/Igw2Vx9J+mPKz9TMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwMurazu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwMurazu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515ECC113D0;
	Mon, 18 Aug 2025 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524660;
	bh=1l20gXdHbeBZJSC3kyeLBHdGpra/YQZBJM13z7guUCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwMurazuHQuZ7kyvbgVVk8z2vN8zjQvW4vPxHeL0SUa7zYBGop6w1NEUuysP948+V
	 Aod60kOJcMKu6qlLdAK1tqzZ0pa21I+Jk3VsROD9VMsdu0gbHShZaWDfKGX0RGeqKK
	 IyCQkbYPKXceQH1XAFvtpS40jKWK/+ojtytf/BTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 023/570] net: ftgmac100: fix potential NULL pointer access in ftgmac100_phy_disconnect
Date: Mon, 18 Aug 2025 14:40:10 +0200
Message-ID: <20250818124506.690231963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit e88fbc30dda1cb7438515303704ceddb3ade4ecd upstream.

After the call to phy_disconnect() netdev->phydev is reset to NULL.
So fixed_phy_unregister() would be called with a NULL pointer as argument.
Therefore cache the phy_device before this call.

Fixes: e24a6c874601 ("net: ftgmac100: Get link speed and duplex for NC-SI")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Link: https://patch.msgid.link/2b80a77a-06db-4dd7-85dc-3a8e0de55a1d@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1730,16 +1730,17 @@ err_register_mdiobus:
 static void ftgmac100_phy_disconnect(struct net_device *netdev)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
+	struct phy_device *phydev = netdev->phydev;
 
-	if (!netdev->phydev)
+	if (!phydev)
 		return;
 
-	phy_disconnect(netdev->phydev);
+	phy_disconnect(phydev);
 	if (of_phy_is_fixed_link(priv->dev->of_node))
 		of_phy_deregister_fixed_link(priv->dev->of_node);
 
 	if (priv->use_ncsi)
-		fixed_phy_unregister(netdev->phydev);
+		fixed_phy_unregister(phydev);
 }
 
 static void ftgmac100_destroy_mdio(struct net_device *netdev)


