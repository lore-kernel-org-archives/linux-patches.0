Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B721849D3;
	Wed,  3 Jul 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005081; cv=none; b=h37DiyAeAOiuPmqIYmheAV6IGoqlgzwR0Y5+FZ4fqJYk5W2PQvBQEnpl61VhG1lNBUzSqE/4CJjth3VyP2ow3rs46Ci4+ZrZNZXgF8XMnD3TV3AJeReRDBMSP/Gg/Msfd+hVGCnsM8xYv6C92KCLxHJHFJIWXQ7zwZDf8e+BpVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005081; c=relaxed/simple;
	bh=6kFg1YD8US1+wkWzh1XDrPAwn4/SA6TE3AOtcDz7AOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnHPeq3tkSO2+MSfUNBfquKUKD+oA7mkLe8kgSFP8BxHh52rNlYpEr9C2o9+Iyj+rlCa0UYg41+On1bAY491d4Gqd6FOc0b7SQtuj3IZavaXJxyxopRUZGU4L3d6XAZgVbGimHQSmuN4UoAK23QtpciSdtZp2GWqBQM5kaBF4OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXOaxBcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXOaxBcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F29C2BD10;
	Wed,  3 Jul 2024 11:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005081;
	bh=6kFg1YD8US1+wkWzh1XDrPAwn4/SA6TE3AOtcDz7AOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXOaxBcA9w7EwEBRgIQ/eXz9bVw6PnBrSpkVtbgIFO1RwhFXFkutTGHJdjzDCub2V
	 lQFRcHoPxjCWeCma3tQIyeTMTF+NAdOXf56kBh8gU2BRo8xStnEK5nX3E6AodnS8ov
	 GEUJN/5o13Rx+BtiZG3nDThhgQg4dBStkocbZb9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 253/290] net: usb: ax88179_178a: improve link status logs
Date: Wed,  3 Jul 2024 12:40:34 +0200
Message-ID: <20240703102913.704132528@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 058722ee350c0bdd664e467156feb2bf5d9cc271 upstream.

Avoid spurious link status logs that may ultimately be wrong; for example,
if the link is set to down with the cable plugged, then the cable is
unplugged and after this the link is set to up, the last new log that is
appearing is incorrectly telling that the link is up.

In order to avoid errors, show link status logs after link_reset
processing, and in order to avoid spurious as much as possible, only show
the link loss when some link status change is detected.

cc: stable@vger.kernel.org
Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -346,7 +346,8 @@ static void ax88179_status(struct usbnet
 
 	if (netif_carrier_ok(dev->net) != link) {
 		usbnet_link_change(dev, link, 1);
-		netdev_info(dev->net, "ax88179 - Link status is: %d\n", link);
+		if (!link)
+			netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 	}
 }
 
@@ -1638,6 +1639,7 @@ static int ax88179_link_reset(struct usb
 			 GMII_PHY_PHYSR, 2, &tmp16);
 
 	if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
+		netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 		return 0;
 	} else if (GMII_PHY_PHYSR_GIGA == (tmp16 & GMII_PHY_PHYSR_SMASK)) {
 		mode |= AX_MEDIUM_GIGAMODE | AX_MEDIUM_EN_125MHZ;
@@ -1675,6 +1677,8 @@ static int ax88179_link_reset(struct usb
 
 	netif_carrier_on(dev->net);
 
+	netdev_info(dev->net, "ax88179 - Link status is: 1\n");
+
 	return 0;
 }
 


