Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3892A1FCCFB;
	Fri,  6 Dec 2024 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497816; cv=none; b=tRJ6Jh8qDZeeLZf8FOeR1HUp2h2WHIl7oe3b87mncIRq3fY/W/DF4slcfZ13CeMQ3y3/nmdHvb7jZgXvJDNfD971NPOPE2lQLh7LpZCLtELmLSjvFoGK3w6k9Qxe8apnP6/7HxBEsnCoYYlWtdQaDJ7YSV9+ZnNwZk+BzDjlQBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497816; c=relaxed/simple;
	bh=iw2SGvr01Ft/p+RcgZchUelcOQt+DZbMwqv+9PwnoFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny3ByHBGtHqHEvT/9wMUvOkQVVKa89f96PStQ+wUsDBQlSiLXCInCjNZQy5Higvjn2X9LoNrYm+xpKPjCWljPhtxN9N0xq4GBFAjgVgDWOIV3paEoOoliGgAemi4ojwl63hIUYFJszaWxMMx0o3mUSueD8oI5UHHwFmquOMrtJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygDBIfNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygDBIfNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9998CC4CED1;
	Fri,  6 Dec 2024 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497816;
	bh=iw2SGvr01Ft/p+RcgZchUelcOQt+DZbMwqv+9PwnoFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygDBIfNb0rMAXhQ1uMXU8PcrfWWri62ddcUcz4suc+vxUo0e9Zm1PFRHAVamoVtoF
	 sOA7UKLoTE+DMdw78sSSp3akej00S6stbmKFU8rISwUoeyodqvg3ricxIUp0IyGHIW
	 Vk9r/nGu2Jx2bV6ktkdE+TrdqEsOLYFl3XhYrQ84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 401/676] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Fri,  6 Dec 2024 15:33:40 +0100
Message-ID: <20241206143709.012711059@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e02f17beb09d..09173d7b87ed5 100644
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



