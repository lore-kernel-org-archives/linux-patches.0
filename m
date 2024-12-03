Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DC1F754A;
	Tue,  3 Dec 2024 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239309; cv=none; b=M4chglly1Z7HB4Zv+9xtGqJKqW+D3ACv23H7GVpx+Ko9UiIJ2rClN/YY4Jpo0q+3IjUOzmMhr4Im8kb+bJSbIighWNnlO088MhpmdePVYd5AMvNyG9ivWg+Y3J7H8G3qRa6HybJ42r7iRn2moDkQSQDfCkPb3AqA3PavDQ9yeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239309; c=relaxed/simple;
	bh=5E7+rSiQCMz3GQXAmYEmiaREfrMpN1DD+O3PiOnWBj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgOIwLyxtN5VLRqIRWa8oGREGy2LaUq5cYYfBpWnGbmou0LHt69t+Kr5nQMPcCKCssPkPTy9Vwq7yCZw2rxQJW2W91d/zLiMwiIkcRO6eVhs1FoHaEtnV1LS0m9LjrQj5sGiCnYSsMbMNsEd4fn3CPzW1Z1qH9LdQgQ/BsftOwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihT+lpwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihT+lpwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C51DC4CECF;
	Tue,  3 Dec 2024 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239308;
	bh=5E7+rSiQCMz3GQXAmYEmiaREfrMpN1DD+O3PiOnWBj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihT+lpwIlUywwKfS+Rcavge6jaYL3a9GgyUs9qyczHflT3WELcJu4YLP+ngVqKIZv
	 ZWpgognUzXiDG8YEmOkWJoFsJV/zQkfONmvgY6sAKhPYPhbv83AJz5TIQPoIzWfsff
	 Bg182AFNe6PfN+Bp0TXeOZonc8EE50UwQs9hhc5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 569/817] net: usb: lan78xx: Fix refcounting and autosuspend on invalid WoL configuration
Date: Tue,  3 Dec 2024 15:42:21 +0100
Message-ID: <20241203144018.122218355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



