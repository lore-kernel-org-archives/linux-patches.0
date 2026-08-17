Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C6E2C1594;
	Mon, 17 Aug 2026 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975508; cv=none; b=jGuXXoTu/RVeN/DJKUjHUqeY3IdnJje4kvl553qjNYO9Oc2WGdTZbawUOjy3kpd/zMdmrGp2s3P0vpVGo29Uo+I/2qYKZIx0LRMLJMfk0RoVMWvQ2MPgaBjjHV4mcwd0ts8cyu7+NZ277X8OhJXBYeX1K8CZK9Qm4JcM+e0wGaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975508; c=relaxed/simple;
	bh=cZSJNmCM0fVKlttu3EUOAyVsNYMZsPDpznR/LXBw4yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvCnWOaWM2Eh9hPvX0vE0wSvK6e9RmBZA5VcV7cPgySqeVpSn7nmkN5pWqw+gHcTgHv+wVXnTHY9CBBFWqj9amIgw+Wm9H5q+g7iOdUJecMJmZxPrk0rG6guB49QCT6EGh5C44NXjya6rkJUf1KVNP2Q020QN/4U4dxM/uSNJYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGQrxsaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGQrxsaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BC91F000E9;
	Mon, 17 Aug 2026 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975506;
	bh=jQdG8AWWMkIJl/PnxQa6DQre+B0VurgCnAGf72HLyi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGQrxsaAyH2YKEH8QZ9tpHx6aufKbNQU/arK5JzDBzoQosEBQX+QIgDHJFNBZ4qYJ
	 TjpLace/2vGRD6MjESEa0hCq62rXc0rwfptSgzcl+Qb9iiv2p5+KEA8hNFdWKFzyCx
	 anMWJQKlKfth6v6jZWcXHS70Ds9IBB8Y7rlcM+6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 051/389] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:28:10 +0200
Message-ID: <20260817132541.045712313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 29a142d3e8b35ebc9e0bcc78f4bc26c9b6a9ac0b upstream.

The gadget device name is set by UDC core when registering the gadget
and must not be set before to avoid leaking the name in intermediate
error paths (e.g. when detecting an older chip revision).

Fixes: 12ad0fcaf2fb ("usb: gadget: amd5536udc: let udc-core manage gadget->dev")
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260702141536.90887-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -3158,7 +3158,6 @@ int udc_probe(struct udc *dev)
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
 
-	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.name = name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 


