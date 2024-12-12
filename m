Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D462210DE;
	Thu, 12 Dec 2024 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019828; cv=none; b=OcXlnf1bErGhc4ej5vAVmsPFxWUgCj/akjkjLuSgfC7jcGzgljB2FYdmAUij65vjHXyybqKdQB0oIM/WpRt+LZ1qMrKPHRI61CrO6XqXaYix10ZVq3MmJfdy6tavV2jGD7riTKXlheuSVH8pR0ZjPTTpqZmez1YjqJ1FA09kIvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019828; c=relaxed/simple;
	bh=s33D+rVaXs5Rr9Ll/lKZ/uUFfmXd+4zkUWghJdHiPYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piHY234hb3Qrq5viJ3a9CjImOxzyLnSIsWxF5mWa3+O7FJmYO8i7w+NHVgbbaKgPr74pVbZ6WiBl/tYvF8uBbYeBL66SILruB8F6F9Q66Xr3eudRKB0M8P26T3YsJcnu5ayUVEbW/fRMouqweE+S6S5daciIL+yuOZEcs/St9Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI4SmcF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI4SmcF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA71DC4CECE;
	Thu, 12 Dec 2024 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019828;
	bh=s33D+rVaXs5Rr9Ll/lKZ/uUFfmXd+4zkUWghJdHiPYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI4SmcF3UfVJ+x4elXO3dvCVR03tg3BwfkyCLRb7J8fGQAfrn+bs6QpLXEubsJ2Xg
	 vvwf4u0i5x9W8JKwsKHm4Ka5J5cxWQiFIMV/EsGiYI21zFZuGITGiJ0m/3oDSHx8+H
	 ex5w1bwNrQ/IkTopBObg+N6XL0ljNjHch/Y1TvTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 308/772] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Thu, 12 Dec 2024 15:54:13 +0100
Message-ID: <20241212144402.623081597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e863ff806f72098bccaf8fa89c80d9ad6187c3b0 ]

Validate Wake-on-LAN (WoL) options in `lan78xx_set_wol` before calling
`usb_autopm_get_interface`. This prevents USB autopm refcounting issues
and ensures the adapter can properly enter autosuspend when invalid WoL
options are provided.

Fixes: eb9ad088f966 ("lan78xx: Check for supported Wake-on-LAN modes")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://patch.msgid.link/20241118140351.2398166-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index ee3c13bbf6c02..feff1265cad6f 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1657,13 +1657,13 @@ static int lan78xx_set_wol(struct net_device *netdev,
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
 	int ret;
 
+	if (wol->wolopts & ~WAKE_ALL)
+		return -EINVAL;
+
 	ret = usb_autopm_get_interface(dev->intf);
 	if (ret < 0)
 		return ret;
 
-	if (wol->wolopts & ~WAKE_ALL)
-		return -EINVAL;
-
 	pdata->wol = wol->wolopts;
 
 	device_set_wakeup_enable(&dev->udev->dev, (bool)wol->wolopts);
-- 
2.43.0



