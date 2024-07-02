Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357F178381;
	Tue,  2 Jul 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940537; cv=none; b=iCJkKkV9yiDpu6aWsYkX1VLS5G3csKUtGRO43/JtaGcJdpYKgkVwB+gs5LItybrQc0e6poKo/U2UC+ijmgT1Rq7fDtwQNKEw+upnGcXzRrek5jTHf7QIyNaFu+pEUZFarF10rAlh6qgUBsxqY1xFcf/Gsjil0eNXZiYkjmG2/GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940537; c=relaxed/simple;
	bh=6QOvTFE3adh0cvWzuI4KzWlW1YsuiucrPjQMPozDwEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdgSntNJRHOG1pxFHrB2AnDR0THnzBTjpJiypfBK3QFiUCoazaX+V5jv3JxB7KE3fdOxRxHSgKm+xtZdW0Z+ug6Nlm0BDRSNfroURL7lU7v2PUFWhbEOpO9xg/+lkcWBzKb8+usNvBZg7+7yuA2b3i/W6uZK4GbrZMwcjbh9iNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZCjKtJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZCjKtJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7867BC116B1;
	Tue,  2 Jul 2024 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940537;
	bh=6QOvTFE3adh0cvWzuI4KzWlW1YsuiucrPjQMPozDwEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZCjKtJNmkn3JOqvNcc0mANecwnCn5JTFgn+tMw64fuun676tGpLzLPj9LZlexauC
	 EFVo99PSH9oK/7fVc3AAK4ok0QBaf/3EjyRx7CK7Gjbys9ING4EzFlEzQ5FVk/MmDl
	 VGnDlWKyZYuDKi5WSIIDQlWm3bqIPPlCyOK/D4BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 6.9 152/222] Revert "usb: gadget: u_ether: Replace netif_stop_queue with netif_device_detach"
Date: Tue,  2 Jul 2024 19:03:10 +0200
Message-ID: <20240702170249.787319635@linuxfoundation.org>
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

From: Ferry Toth <ftoth@exalondelft.nl>

commit c50814a288dcee687285abc0cf935e9fe8928e59 upstream.

This reverts commit f49449fbc21e7e9550a5203902d69c8ae7dfd918.

This commit breaks u_ether on some setups (at least Merrifield). The fix
"usb: gadget: u_ether: Re-attach netif device to mirror detachment" party
restores u-ether. However the netif usb: remains up even usb is switched
from device to host mode. This creates problems for user space as the
interface remains in the routing table while not realy present and network
managers (connman) not detecting a network change.

Various attempts to find the root cause were unsuccesful up to now. Therefore
revert until a solution is found.

Link: https://lore.kernel.org/linux-usb/20231006141231.7220-1-hgajjar@de.adit-jv.com/
Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reported-by: Ferry Toth <fntoth@gmail.com>
Fixes: f49449fbc21e ("usb: gadget: u_ether: Replace netif_stop_queue with netif_device_detach")
Cc: stable@vger.kernel.org
Signed-off-by: Ferry Toth <fntoth@gmail.com>
Link: https://lore.kernel.org/r/20240620204832.24518-3-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -1200,7 +1200,7 @@ void gether_disconnect(struct gether *li
 
 	DBG(dev, "%s\n", __func__);
 
-	netif_device_detach(dev->net);
+	netif_stop_queue(dev->net);
 	netif_carrier_off(dev->net);
 
 	/* disable endpoints, forcing (synchronous) completion


