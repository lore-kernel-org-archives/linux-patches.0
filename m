Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6F6F2FE;
	Thu, 12 Dec 2024 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025317; cv=none; b=e/IDwS2IRdot3C1x0DSs4+q1FTbMdEJ1dzGpPKhFQAFDefu6QJZr6WRBlziGZwEdlVlM5/jdOSX0PupOLfb82tXSVgrU6yXpav6GrKk2z5XoJSu0PaTRJIYnYCBNrYSqI8TQ/Q5eyJlhudfbZljd7CR+5L0pYF8FLkESQrJ2nTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025317; c=relaxed/simple;
	bh=F9TZyplcooiU/zR7DYvsgllk2cV5BYZnDav6MmhDB7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byTyq6fp6fGfsWjkHgulaz3NLG4dMsbE85TnuymprEUggRzF+Sl6j4/xNEyb4Lzpqdfp10CJDK8qWgklwIkx07S8ehmsdBq3sgVVq6Ym2DgF0HlFMNHA4i+PYDbUuKG7bwOOIHE1NJtEsF1sgH5xp6QwIzXBUO09nzyr9gmMsFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLHugSym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLHugSym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCB9C4CED3;
	Thu, 12 Dec 2024 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025317;
	bh=F9TZyplcooiU/zR7DYvsgllk2cV5BYZnDav6MmhDB7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLHugSymfFl/qmVMICGKPc72L01aDXE5+mEYqbhaCVrNsGPeRvjcRsonFr7UGt/4H
	 C6m6t2VkAsjlropcRCKlvwppTHO3ZOB7m4AdhcbJaMbetoT6Il40uLcAx/cUh5UrZz
	 5Gg7lTNjNwbIq571YB+ODFlaDT71RjEXGfMyp4OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/321] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Thu, 12 Dec 2024 16:00:47 +0100
Message-ID: <20241212144235.071803646@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0ca3ffeb4983c..219a11e8f8d5d 100644
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



