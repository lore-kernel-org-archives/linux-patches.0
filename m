Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82327424D6D;
	Mon, 17 Aug 2026 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979016; cv=none; b=G+/0EnbhoHpdZwu0njrRE7WkEA7nGij4t12Z+U3HNvvh447oS8vQQDO1uP8z+f3Hhvisn2DCzHPNWSwcdpZMPc8dRd7l8YHzA+Mo3z0Jzrk+2/PcXEsHU8BHID49TbdY+XN+5/Z/p7FRdCU6yFNCNNsSYLvxW2jdXbEOqiLxYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979016; c=relaxed/simple;
	bh=Kt9cDpxou/bImx5rvyj+WpWwXJRw/4tUGoEai1w56gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVp00N5YGCeTTxGiuzhFG+RUuti7AsBo1OWKz1I2CCKUzn/B7VFjIBsukh2nqilBmoYeblFO55PtBW5PTAKN2Efh4TKs7soXvz2ZAUDsF1XqXfLycEF+ONR4QszkNYiV4MgwHcO0UvzBumW+mLk1rvyLKk/UCX/a2MhLXFi5cXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hNk9Upa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hNk9Upa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2601F000E9;
	Mon, 17 Aug 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979015;
	bh=oBdy4ZUZxojsW2oOUjYd7wwDa/s+zcEtP4aFZWpoGAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hNk9Upa7zJnT4zGw0JGAYFYmvbTevxGcQifRvuRPI6ExjgRiAw2vzJZvqjYc0cXV
	 Vr1Mqcn/t6gucw7E9SPB6+BoK6j2+JME7Xrtt6UcsyIRPYgYVSlYA8oykDN1VT+GNj
	 AypsGrzgC6AhipcR/ZVenQqYHVqUwkJJkPXoaA+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 080/609] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:26:16 +0200
Message-ID: <20260817132546.244948236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2466,7 +2466,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


