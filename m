Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FA5379988;
	Thu, 30 Jul 2026 15:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423739; cv=none; b=kwsP3iO6cVOJAmD3OuAFn1yqHorDAIefhA6DtNTHIQeotyR25l/chrhinVkt+HbGr30tGWw5GMFRCqHWAbiIBZKeVGmuGn+bGO00hESm8lqQu3qi6uAS8Zyg61ZmrwOLjJG4KBXCXvu18iBP7kAZg5Pq6PXDZyHnRPpAuUw++hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423739; c=relaxed/simple;
	bh=M9jA3VVM2UYctwu6Jm96AdnvAEZdmdXrcRybZ7s1ESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag4UIVu0QisjYjm2Igk1tZsonILqGYNRZYqui1VvNanqjIIsv1DzUDdHb79KGa9pehsA3KCDtkhBmMb8+R7QJhy0lmWjDyIYEU3BVq0G6uEB7yTdXCTIkJqincw4Z4uObdI8/9Psbg1dwG2h0iY2zfKUsM3TsLGjUNHOdllVPbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k04vlLwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k04vlLwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2898D1F00A3A;
	Thu, 30 Jul 2026 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423738;
	bh=kDUGn8AqsZLt0sICJXFJlAT1KGCtg7PoAZlCOw1PMOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k04vlLwVtNbu6pwInFevBID0ZpDFLPmOh6T9obBcXGVq/RpQvOmMvyIYnmteJ7mlM
	 8xAF72v1ld596vYr4U7TElv9eGnbY1WyrtyclsJ77kLllufO4/5OekMK2smFBius5C
	 OidUxhsuO9sOXmD+3HPsYwr+WWCSxPIZH+TIalSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 149/675] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:07:59 +0200
Message-ID: <20260730141448.303558043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2474,7 +2474,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


