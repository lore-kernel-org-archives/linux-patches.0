Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189D81F7561;
	Tue,  3 Dec 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241926; cv=none; b=LNXDtZv/bDy9DniqclJqrxT4fF+1CVRwSuIRdyaax1ZrW/IEXHcGuFYpmSKwNN+N5Qg8HtCUXLz/iXnHAEACqZ7YtdxD0+rB37BvuQx+dIdxiPwrOtqH6ThceTUUmQ6aR0Vxg7bcOdxoXFsudCyNCFmovGA1VAmUj7B71JF5Nug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241926; c=relaxed/simple;
	bh=FqgsXGfUZ9Cw/qQ7PojtUDEqF0pOKOosjZgR0AwneL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kblpDdcDQ8x19nRb0YramTGB8vbRFNzEWe37T5Z+6DDhqZ3YbH14CLIroGai4fmyKVJMDqq7byVocAtbPD/MuRr5T+9ymxiyrGgB9eq62Cht7A8SpcH8EUHbaO6Jg7XUGhGPbuKOKc/Xc4DgO/eiW2QzLAM/xC8GAAFPllVQh+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqlarwtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqlarwtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B578C4CECF;
	Tue,  3 Dec 2024 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241926;
	bh=FqgsXGfUZ9Cw/qQ7PojtUDEqF0pOKOosjZgR0AwneL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqlarwtXk2lDq653rajy5FS7eQMx3lZPj2p6LPffzFahbGxnaFs+rKis15ffjxH/K
	 oApQgfzJGs1hfxgJqYlmQofM2C/zmTezOqjupk8MZ7o+ihusaI2B7+iT8mCGSOSqwA
	 EjpBvJQG672fKuKjo47paHi6PkeWDRzbtBa49jIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 557/826] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Tue,  3 Dec 2024 15:44:44 +0100
Message-ID: <20241203144805.474017262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f191b6ce8215..531b1b6a37d19 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1652,13 +1652,13 @@ static int lan78xx_set_wol(struct net_device *netdev,
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



