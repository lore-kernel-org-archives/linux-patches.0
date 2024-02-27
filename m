Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943362F2D;
	Tue, 27 Feb 2024 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041247; cv=none; b=lZPXGTyetSz8fLZp+4Hfs3Or4fj3pJfLOV2f3T4t7ompj8rK6wqGLWt2zByO9uSR8E66UsTUdwRma04hHn8XIr7OAbY1sgDYebPNsDwH9T2u1O7pz3WxVslxLtTDEeJErCZC9VNjh+9hBZU9ejZJ8100UEzZpF+MIH1S1RaeTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041247; c=relaxed/simple;
	bh=MRAdmzNwqynbQUfc+lyd6RplRoBK5XSRypPsfLAyNO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlsUIXIkLpuDvWv0fX1RdKhzxk4pboh/MR/XMyvOrcaRthftapUSHzJqoFj6cHkBITTYcIlWxbcItUwvkHRLm/EFoMaW0xnsYUVRfF/P5y8/KiSPCXaWovE/kgSNqzw3QL759s7lxG/yG6klwseglj4Na2pgJqbt15CqIsi3o7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRKmvzu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRKmvzu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAACC433F1;
	Tue, 27 Feb 2024 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041247;
	bh=MRAdmzNwqynbQUfc+lyd6RplRoBK5XSRypPsfLAyNO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRKmvzu//AFRyMQbTZ52ogz+AnY+mtK42TNU17+kv0jnLUVxF+m054a/liMPsJI+g
	 GU2nfXfbgQpWmX2LvofaXTolwTR2hGWTEtFsYbQUrYYqdLq5TtVFZEms7lSFbI8lB4
	 r603kdZ4I2VMeCblXGWncV6nCq2CYRCln9l9Yj6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Justin Chen <justin.chen@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 271/334] net: bcmasp: Indicate MAC is in charge of PHY PM
Date: Tue, 27 Feb 2024 14:22:09 +0100
Message-ID: <20240227131639.737999817@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 5b76d928f8b779a1b19c5842e7cabee4cbb610c3 ]

Avoid the PHY library call unnecessarily into the suspend/resume
functions by setting phydev->mac_managed_pm to true. The ASP driver
essentially does exactly what mdio_bus_phy_resume() does.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 53e5428812552..9cae5a3090000 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1048,6 +1048,9 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 			netdev_err(dev, "could not attach to PHY\n");
 			goto err_phy_disable;
 		}
+
+		/* Indicate that the MAC is responsible for PHY PM */
+		phydev->mac_managed_pm = true;
 	} else if (!intf->wolopts) {
 		ret = phy_resume(dev->phydev);
 		if (ret)
-- 
2.43.0



