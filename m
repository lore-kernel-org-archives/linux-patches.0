Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BE24C067;
	Tue, 29 Apr 2025 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945948; cv=none; b=qFu2zUVR2xySopHkzStg+i37aq/ZgOsg3ipr9n4NMl3vNkaXQS4ru0tPKs/6s0D3xWVj6o97UpIoTghmlWMOZzZ91L1VSyB9mnvbogeUBYJw5Iu63yq9Fy8YE4iEo9UxOwSn9QoHjJPgSZIURY2wta/jytoeXJlBFvHh+xIW80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945948; c=relaxed/simple;
	bh=ndmEapnTDP13AN2FN77owguUnyEbtLSdi7D8V5kMHnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaxjNPIahuHCdClDQaGeEFTgZH/ytYpdFpXCbjmkq9S3RTVAPYWmR6XMVJiiWgL+/nddhZQISfu51JWgZMrxbNoH+egSdWLdg4V7pgS0dEj+C7x8voUwXZU+KeotEl+FdZLSewgDKmG0IErtDBUbv+tLxLLX5XBZ3iIbfbcd8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcEUKPP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcEUKPP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C599C4CEEA;
	Tue, 29 Apr 2025 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945948;
	bh=ndmEapnTDP13AN2FN77owguUnyEbtLSdi7D8V5kMHnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcEUKPP9ATfhXyIcqwvLpl8e1Q2a7IXXv3wq+RHWT3P8B8Hf1FeYTi0ENB2CG3uYW
	 X0dT9lLo2WbeRjgsUa6nvbKnZ1lYjDBjeGUr7gjIoOHsVdxv8Tuyby69xGDEWkaIzJ
	 cIWMr7o74lw8Bmf9Ie+mA7z4mcfYc8D5ePn490k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.14 103/311] net: stmmac: simplify phylink_suspend() and phylink_resume() calls
Date: Tue, 29 Apr 2025 18:39:00 +0200
Message-ID: <20250429161125.256081202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit f732549eb303d7e382f5101b82bb6852ad4ad642 upstream.

Currently, the calls to phylink's suspend and resume functions are
inside overly complex tests, and boil down to:

	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
		call phylink
	} else {
		call phylink and
		if (device_may_wakeup(priv->device))
			do something else
	}

This results in phylink always being called, possibly with differing
arguments for phylink_suspend().

Simplify this code, noting that each site is slightly different due to
the order in which phylink is called and the "something else".

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/E1tpQL1-005St4-Hn@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7813,13 +7813,11 @@ int stmmac_suspend(struct device *dev)
 	mutex_unlock(&priv->lock);
 
 	rtnl_lock();
-	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
-		phylink_suspend(priv->phylink, true);
-	} else {
-		if (device_may_wakeup(priv->device))
-			phylink_speed_down(priv->phylink, false);
-		phylink_suspend(priv->phylink, false);
-	}
+	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
+		phylink_speed_down(priv->phylink, false);
+
+	phylink_suspend(priv->phylink,
+			device_may_wakeup(priv->device) && priv->plat->pmt);
 	rtnl_unlock();
 
 	if (stmmac_fpe_supported(priv))
@@ -7909,13 +7907,9 @@ int stmmac_resume(struct device *dev)
 	}
 
 	rtnl_lock();
-	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
-		phylink_resume(priv->phylink);
-	} else {
-		phylink_resume(priv->phylink);
-		if (device_may_wakeup(priv->device))
-			phylink_speed_up(priv->phylink);
-	}
+	phylink_resume(priv->phylink);
+	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
+		phylink_speed_up(priv->phylink);
 	rtnl_unlock();
 
 	rtnl_lock();


