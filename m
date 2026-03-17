Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DAB3F7E8D;
	Tue, 17 Mar 2026 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766660; cv=none; b=WQ56sKU2gtF0JIcYvDUfzEz/hX5qSj4lPm/5KF4vH0l2zMYZwLlEPM1qABeiaGsZ6TVv5fIYHUD1PCpZsEjge/i9jfyGxdBxXzs0lDe2VLFE4v5IoxZzHvg36W+Lc0y9UR9pkkZJTAC6VxpOZnDhQ2Hv9lcqLHILzWNiWfgoISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766660; c=relaxed/simple;
	bh=fxE/6O+N7XYFVt7ru6RjfX9Esbgf38slIKL91Lm2BfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCFZC6vPneHgbSA2M04LtAvqsBjYGT6jU4U8nIioqWbGeXWETAUYTXsdOHTY7kj6YpE2a3FzGoOfj5RaOfH/cPq/nLSQd+v1dt3BCEvnbq72fMGchAVS/I83jabhXXbkf8Y3WnpRpS9myMADkULnBxyE2BiJFc0LVuwrY4Kn0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpDAXafY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpDAXafY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF9DC2BC86;
	Tue, 17 Mar 2026 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766660;
	bh=fxE/6O+N7XYFVt7ru6RjfX9Esbgf38slIKL91Lm2BfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpDAXafYGGFQlKqayFNbfwJMDPdqlsKZQ5yHW3HfI7v5glbqZchekMpc8F3CrVE/c
	 gGSraa8RGWO6OhlHUW11BkksLVZp5F0iTbdRovaful1voG1Hvz/h0aItT+vztPYE9/
	 i+cW2JTGpcFTWDaKjgfhdkXFqFyTpkw/9zhvat5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 294/378] net: mctp: fix device leak on probe failure
Date: Tue, 17 Mar 2026 17:34:11 +0100
Message-ID: <20260317163017.825007925@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 224a0d284c3caf1951302d1744a714784febed71 upstream.

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

This driver takes a reference to the USB device during probe but does
not to release it on probe failures.

Drop the redundant device reference to fix the leak, reduce cargo
culting, make it easier to spot drivers where an extra reference is
needed, and reduce the risk of further memory leaks.

Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Cc: stable@vger.kernel.org	# 6.15
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260305104549.16110-1-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mctp/mctp-usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -329,7 +329,7 @@ static int mctp_usb_probe(struct usb_int
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	dev = netdev_priv(netdev);
 	dev->netdev = netdev;
-	dev->usbdev = usb_get_dev(interface_to_usbdev(intf));
+	dev->usbdev = interface_to_usbdev(intf);
 	dev->intf = intf;
 	usb_set_intfdata(intf, dev);
 
@@ -365,7 +365,6 @@ static void mctp_usb_disconnect(struct u
 	mctp_unregister_netdev(dev->netdev);
 	usb_free_urb(dev->tx_urb);
 	usb_free_urb(dev->rx_urb);
-	usb_put_dev(dev->usbdev);
 	free_netdev(dev->netdev);
 }
 


