Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEFA1465A5;
	Thu, 11 Apr 2024 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830701; cv=none; b=GlEtEKWqQHkvdSedNn6A/GGhgMYHK3PM9xTB+CdW4kiX9XDSxJCAHCkhdu4FLAk1d+vArQNhKkZq7XoeTzCzpNH5vicuSWgYrmdBUC1Ht7953SzlB1B8vvpHqL0LAG3hFZCpY8u5zhnWvctIFNT3gl/+CH8124L+2JzsH7gDCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830701; c=relaxed/simple;
	bh=yWF7K26YXu9kxGVaPc4aomgSr52+tLO1UlfZXGshNC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwIqvnzE+7UM2Gvxvsw3kQzyJgRTUA1KMKthcvCzx+6iC+nWjxRg77wNmbRWZJO3FpgNTDfjPm88TuF8hAQaokK2JQmZ7vhE+bTzFm8m5t2aBjFNFwUsvDMC7iGJqYd+PO8ch8sXVb/utDFgrn1VSGUUWxFH962P5EPfdZ13yow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo3MxGLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo3MxGLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F15C433F1;
	Thu, 11 Apr 2024 10:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830700;
	bh=yWF7K26YXu9kxGVaPc4aomgSr52+tLO1UlfZXGshNC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wo3MxGLBSbGZpj0icS117tSK8vUyhYZApLio/8/QZ+cuBp7wZarM5G/276CzUhNxu
	 lTRje6nLKNv+QuruCdzAzI55OOgWANKcA+wi++CC9lX4t8XuUDIz2sbbeB8DU0rBai
	 yRF20w0o5miDix2tOAB0pIQnYeD149OAH+7Om284=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 088/215] usb: port: Dont try to peer unused USB ports based on location
Date: Thu, 11 Apr 2024 11:54:57 +0200
Message-ID: <20240411095427.549402181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 69c63350e573367f9c8594162288cffa8a26d0d1 upstream.

Unused USB ports may have bogus location data in ACPI PLD tables.
This causes port peering failures as these unused USB2 and USB3 ports
location may match.

Due to these failures the driver prints a
"usb: port power management may be unreliable" warning, and
unnecessarily blocks port power off during runtime suspend.

This was debugged on a couple DELL systems where the unused ports
all returned zeroes in their location data.
Similar bugreports exist for other systems.

Don't try to peer or match ports that have connect type set to
USB_PORT_NOT_USED.

Fixes: 3bfd659baec8 ("usb: find internal hub tier mismatch via acpi")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218465
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218486
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/linux-usb/5406d361-f5b7-4309-b0e6-8c94408f7d75@molgen.mpg.de
Cc: stable@vger.kernel.org # v3.16+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218490
Link: https://lore.kernel.org/r/20240222233343.71856-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -450,7 +450,7 @@ static int match_location(struct usb_dev
 	struct usb_hub *peer_hub = usb_hub_to_struct_hub(peer_hdev);
 	struct usb_device *hdev = to_usb_device(port_dev->dev.parent->parent);
 
-	if (!peer_hub)
+	if (!peer_hub || port_dev->connect_type == USB_PORT_NOT_USED)
 		return 0;
 
 	hcd = bus_to_hcd(hdev->bus);
@@ -461,7 +461,8 @@ static int match_location(struct usb_dev
 
 	for (port1 = 1; port1 <= peer_hdev->maxchild; port1++) {
 		peer = peer_hub->ports[port1 - 1];
-		if (peer && peer->location == port_dev->location) {
+		if (peer && peer->connect_type != USB_PORT_NOT_USED &&
+		    peer->location == port_dev->location) {
 			link_peers_report(port_dev, peer);
 			return 1; /* done */
 		}


