Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C13211493;
	Thu, 12 Dec 2024 17:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024306; cv=none; b=ASSXK5RsDw+0nUCjRSHBNAEaX1Wq59YMKxeGixBOp4cPRctqZWe3vQ2FNj9FxYctspu/YRt0ALmfBbZDFR3EV6DIRBCl+XRJ1MBDBeq/GGxqf3pYwACb+sxzB1RWD8VKPWDFmtqbrVy+ukGKjblEenIjnP4/4tiZ6uyqGUW2mec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024306; c=relaxed/simple;
	bh=BoCAE6y8R6zoDSXNVR4Jv10MDzsLbt03GCXsdOpqtig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxK9i4EoI0Dx1ycljshazTRXR8MYOVf2ywx56689cSRKBKoQT8wKp8aKIlgM1cE/xKxY6TkvS1UGtqXKEzMBzd49xVdI015uNwGZ7LGPqv+CG5TPD8/A51D1tRRiJDsnP5r1v0tx9aSxjMTJEDd/gIPk4pzyLJGGGJh47XqykG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+oEONXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+oEONXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FD5C4CED0;
	Thu, 12 Dec 2024 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024306;
	bh=BoCAE6y8R6zoDSXNVR4Jv10MDzsLbt03GCXsdOpqtig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+oEONXOp8VXkNO9q10wBjr91vIyI9/pWa8c7WanB4oovCfCdnANRASq/QGzSar88
	 5wSkVG5Pa5Yhf0C/m/JpDTugMuYbZe1qB2sq8bpMpmciUaphA718xDf/05SP9JtKIo
	 24UaFvN5R3k0xHxUZiWnGR/8wjhRD8ZZhjK9ccJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/459] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Thu, 12 Dec 2024 15:59:20 +0100
Message-ID: <20241212144302.342382522@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 757d5c82f3f09..cabe6cdd6903a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1428,13 +1428,13 @@ static int lan78xx_set_wol(struct net_device *netdev,
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



