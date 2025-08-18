Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D72E33472A;
	Mon, 18 Aug 2025 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522937; cv=none; b=Zl+lpJMTdJvShJZtHUVglI3HlJ21RE+G3zcPptiNpyp6acw8PYwBbQi7uYjR4tZtSomZcUhKXqhzgnfcJIr3AtJ8dpRmHSFP0OetYJMmggXyjwqEmFymPWs4Kxb+Cw0epDgsu/0qyjD2m6i176wCf/j/OOG6lc1tq4wEea5E2ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522937; c=relaxed/simple;
	bh=S/FG8Su7jPuH/1pNy9kFGqA1GgV+HafHDLRnYIwdrDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0Dw9iipmCd95/XRIARQ0fS5cqVUF1HQQ6PtWvfc7405LoV2XbtGdNbBxBIqStlegHbyZl9ksG3mJKL2b3yWl/wLT+Mfj1lNlZwRAIzCwxvt99htPh14YOVT9Z00UBhKePEYgczFLLBEKmUj/wGyYLUFNwVQVs7+pPXiAD1wX2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+rjL9MU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+rjL9MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AECC4CEEB;
	Mon, 18 Aug 2025 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522937;
	bh=S/FG8Su7jPuH/1pNy9kFGqA1GgV+HafHDLRnYIwdrDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+rjL9MUxi+I2+V8VhMGURv7qnErixLIrlO9kdUZJUKjOghUbPy++yt4p5iD8e6rp
	 2yU5Vr/xPl6m7RQYFm498IRg0WMaJ4DaGFONjIAUHS0vzRSyK73h6cmGok9ebvUGZk
	 FPTsnhUwZY0f8Y8hdIA3BW47gJX8By8Uxq2GKT6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 021/515] net: ftgmac100: fix potential NULL pointer access in ftgmac100_phy_disconnect
Date: Mon, 18 Aug 2025 14:40:07 +0200
Message-ID: <20250818124459.283408997@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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


