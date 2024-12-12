Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D8D211A34;
	Thu, 12 Dec 2024 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022571; cv=none; b=aD/htbZ+OajxWO/mwLyWyVNFrJPDA9qXa+PpY0dHhKFaG06tmoroOQo3QtJ1rL9/bukGK7QyWHIwvwDaTAw0R8BlCmv51pRPCRexJ2wEowZmeatbZ2Q3nB5mY3ajd03U+kSQJeU/B8vZfpdHE8oyItF3MjQc0GTKLskdelVdSj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022571; c=relaxed/simple;
	bh=sxrbsKVpHRORoQWuuRDg9aMYXYeoFp66+ngkL9YtPEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/uf7Kbmvjxfx8nL3mwQKDr+JVv/Kl0f+hFWSRNwwbCvqjfG1WCwvdOLIBFYM6+T2ozL4vfEV+vDeHGpQJmR6xuD/ct5MVVBSXFaIxXgxE/bFIgT9jzNX8zw4B/NqaPIpp4vlg0P7zpu7HwqaGuF3vfFWqymUyFfLF5STK+jUy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNbHVsJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNbHVsJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3324C4CECE;
	Thu, 12 Dec 2024 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022571;
	bh=sxrbsKVpHRORoQWuuRDg9aMYXYeoFp66+ngkL9YtPEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNbHVsJ0GeUYC/xx4wPG9v2cI9kxdTQIla/hKPk5GTDpKs4kR9VQD6hyp5ZFfpKrm
	 iRuCL7Nrf4CNTCSAe0HxFVtuI0goJ6diHeRgyFJlxn0obm1zK3Nb5lbLjvb9YhiY/v
	 p5U03tX1xfVrgyIg7yTQhhYD9ZlxQfrcV4rR5BAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/565] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Thu, 12 Dec 2024 15:57:52 +0100
Message-ID: <20241212144322.407047603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d0d67e11eb14..2279a4b8cd4e3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1490,13 +1490,13 @@ static int lan78xx_set_wol(struct net_device *netdev,
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



