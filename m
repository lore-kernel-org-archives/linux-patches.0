Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6218280CE5;
	Mon, 17 Aug 2026 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976792; cv=none; b=mN9DKzxlHf3hkFEfaGeqZXrBdQc9Ux5Nhk5XFAL9BGavqWtLNLePBUymhGHFpVkSiKwkndwLaBUbpA7XRS61aXGFvgPC6ZVLWzpYv4MGQ85P/hVP57j0RHMy+HZz9ux+El/m0FOYWmovZaB46QH7DwHvAoSX8i5uh5LM9KVRzZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976792; c=relaxed/simple;
	bh=4M/P+FHmromCI1NdFCt7BnTksZCbiKiHvBhJcHeuvO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFBzhS6z+PPR4tNU7JI3HMEdwy5GEgOyP9rvnBc7arrcZ+pvWR9ZbZUICoZ7C7TOMzch2WaVnqJEDKa1c+mpdtnLcezV84yVIP1OiARu4rVnummxraYRSk7AWVQdbjWwgtqNutshAtncQOkOKvErh6fchFmgKQM+UKUQ10YTWpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yz+kMTbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yz+kMTbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2F91F000E9;
	Mon, 17 Aug 2026 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976790;
	bh=D0kaotHXvqu13kpAPr/ycRO4b8JDjp33yLvLv1d0iX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yz+kMTbRowA7XYTWEmrgMI2OYackhyxt3ExMjS6HBANiA7nHhvDPF1jRocexAe5l6
	 gXDPBFMcLsSoufIkOT+uaQF/2AbMPnRmGb10ocToCpczsJsXXjNfkoerW6IPReTI+9
	 IXS5sBgpVjoixbrolzLJ2R+3iQg6FBU3YOMR4R4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 066/456] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:27:36 +0200
Message-ID: <20260817132542.630192011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6b874d00c466e73c6448a89856407fe46b2f50e4 upstream.

The gadget device name is set by UDC core when registering the gadget
and must not be set before to avoid leaking the name in intermediate
error paths (e.g. on dma pool creation failure).

Fixes: eab35c4e6d95 ("usb: gadget: fsl_udc_core: let udc-core manage gadget->dev")
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260702141536.90887-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2464,7 +2464,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


