Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537A1BE22A;
	Tue,  2 Jul 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940404; cv=none; b=HRBGa7DkS7K4nY8OSaM8a0H42MS9E1qTTN07w0CLNuNFYNH8eC9EWwjOKkCT+9fHG3R5tS6I95Uga3nkqdw5P6gfO4cH8wTdqjwL/wX3NGlsWMYIUcDr7IzfuoLheY+pBBZyrDCT74oQvxbwrchxrLaqKfD+nKusKwkydBhPI3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940404; c=relaxed/simple;
	bh=0OKdO11sn89e3wjmvSgF/fCvYvZv9Ob7x4SnkK0sEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjOG/GTnRn1Kyv/zFBd/bpO+d1lp2sVqtiCg9oWpBcyRG7gQ027gcn0vRvNWPI6M5T8MS+aBV2Gg5in3Dk0T6LHZL1qUhuif1ex2k6IKnXvaji1tiwn72/vgvlSFyriuKWAA6hQ0RvcS2r+2V5PVFZAl6YqECbIRx6Qn2ox09Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNmxUefc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNmxUefc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F59C116B1;
	Tue,  2 Jul 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940404;
	bh=0OKdO11sn89e3wjmvSgF/fCvYvZv9Ob7x4SnkK0sEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNmxUefcZoD4kpIVFa4VlDawbVgRHNKVqgMlrAg0tISl7WBHZZGsGQzMWD6zXSpyD
	 dy2Md9AVrSwyAvjFP5Mholx2g2Y6J520KtOmyYSmrnjAQKR9gtqaj5QfRNVyCOU9YL
	 HSdwmLsWyetWEpKOiOVI1lQvkNvT4nw0OT/ioyBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.9 143/222] net: usb: ax88179_178a: improve link status logs
Date: Tue,  2 Jul 2024 19:03:01 +0200
Message-ID: <20240702170249.444667675@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -326,7 +326,8 @@ static void ax88179_status(struct usbnet
 
 	if (netif_carrier_ok(dev->net) != link) {
 		usbnet_link_change(dev, link, 1);
-		netdev_info(dev->net, "ax88179 - Link status is: %d\n", link);
+		if (!link)
+			netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 	}
 }
 
@@ -1540,6 +1541,7 @@ static int ax88179_link_reset(struct usb
 			 GMII_PHY_PHYSR, 2, &tmp16);
 
 	if (!(tmp16 & GMII_PHY_PHYSR_LINK)) {
+		netdev_info(dev->net, "ax88179 - Link status is: 0\n");
 		return 0;
 	} else if (GMII_PHY_PHYSR_GIGA == (tmp16 & GMII_PHY_PHYSR_SMASK)) {
 		mode |= AX_MEDIUM_GIGAMODE | AX_MEDIUM_EN_125MHZ;
@@ -1577,6 +1579,8 @@ static int ax88179_link_reset(struct usb
 
 	netif_carrier_on(dev->net);
 
+	netdev_info(dev->net, "ax88179 - Link status is: 1\n");
+
 	return 0;
 }
 


