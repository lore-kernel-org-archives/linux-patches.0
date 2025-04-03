Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27644250BF8;
	Thu,  3 Apr 2025 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693817; cv=none; b=LeDO7DDwuJErbTX1mWYiFQEvoENBodQ4SCn8Tk7qmzUGNOYaTo+Q7iAtctXJ2iDXX3x2b9vER3ITtoI4Jm6rJl8CNXmZDFO3cj52lTx/Sju8oV88r4pH03G9ltP/CndMkOgIP6EFdbslhGLhH+NkuJ1dnk0t0VLFb7SEdnUNmMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693817; c=relaxed/simple;
	bh=W/dIKav3ta7YPzY5+OVMyR0fI7l0U8eN49go4eYjsV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+1Nu9ZLO2M3GJfWDelQeE3QsEJ35C6fepAPGkV8q2E9TxyWO+K7dhQbuoJ6JeyqqVAejFY6PRCmdZ94bAL2I9O+crFBpriebpnpQpYVGnuELoz2+CW4OxFYxbeUGWVn9KUrnyYbmKMqaeLOPqPLEgWJFZRXezKjjsypK9trP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlrJHrYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlrJHrYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C58C4CEE3;
	Thu,  3 Apr 2025 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693817;
	bh=W/dIKav3ta7YPzY5+OVMyR0fI7l0U8eN49go4eYjsV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlrJHrYq3nHSohW44Y+8dCbTALY5zCZ26UAaWbJ0GUciA3OcIO4rgfPJOfDJLXERf
	 R5r3ufTpuqWWOAm2kOFxh8+bhvXFZO7VTiLFnh1cMgNEz9jXHIzUdwjQPwgtJygehL
	 yFs9ARAINMVAlngdK/3nqHI3RlouDeKjt9/7S+Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 15/21] net: usb: usbnet: restore usb%d name exception for local mac addresses
Date: Thu,  3 Apr 2025 16:20:19 +0100
Message-ID: <20250403151621.568019842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 2ea396448f26d0d7d66224cb56500a6789c7ed07 upstream.

commit 8a7d12d674ac ("net: usb: usbnet: fix name regression") assumed
that local addresses always came from the kernel, but some devices hand
out local mac addresses so we ended up with point-to-point devices with
a mac set by the driver, renaming to eth%d when they used to be named
usb%d.

Userspace should not rely on device name, but for the sake of stability
restore the local mac address check portion of the naming exception:
point to point devices which either have no mac set by the driver or
have a local mac handed out by the driver will keep the usb%d name.

(some USB LTE modems are known to hand out a stable mac from the locally
administered range; that mac appears to be random (different for
mulitple devices) and can be reset with device-specific commands, so
while such devices would benefit from getting a OUI reserved, we have
to deal with these and might as well preserve the existing behavior
to avoid breaking fragile openwrt configurations and such on upgrade.)

Link: https://lkml.kernel.org/r/20241203130457.904325-1-asmadeus@codewreck.org
Fixes: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
Cc: stable@vger.kernel.org
Tested-by: Ahmed Naseef <naseefkm@gmail.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250326-usbnet_rename-v2-1-57eb21fcff26@atmark-techno.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/usbnet.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -178,6 +178,17 @@ int usbnet_get_ethernet_addr(struct usbn
 }
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
 
+static bool usbnet_needs_usb_name_format(struct usbnet *dev, struct net_device *net)
+{
+	/* Point to point devices which don't have a real MAC address
+	 * (or report a fake local one) have historically used the usb%d
+	 * naming. Preserve this..
+	 */
+	return (dev->driver_info->flags & FLAG_POINTTOPOINT) != 0 &&
+		(is_zero_ether_addr(net->dev_addr) ||
+		 is_local_ether_addr(net->dev_addr));
+}
+
 static void intr_complete (struct urb *urb)
 {
 	struct usbnet	*dev = urb->context;
@@ -1762,13 +1773,11 @@ usbnet_probe (struct usb_interface *udev
 		if (status < 0)
 			goto out1;
 
-		// heuristic:  "usb%d" for links we know are two-host,
-		// else "eth%d" when there's reasonable doubt.  userspace
-		// can rename the link if it knows better.
+		/* heuristic: rename to "eth%d" if we are not sure this link
+		 * is two-host (these links keep "usb%d")
+		 */
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
-		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
-		     /* somebody touched it*/
-		     !is_zero_ether_addr(net->dev_addr)))
+		    !usbnet_needs_usb_name_format(dev, net))
 			strscpy(net->name, "eth%d", sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)


