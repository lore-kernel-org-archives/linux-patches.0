Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9683D349F;
	Mon, 17 Aug 2026 14:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975514; cv=none; b=r04ua1ab9Ru1XQB98oDPPhFJEB02oxKJVRp7YQjuiCwPEamrGkW9q5mWZgmxauUqL2k8mcwAzu2T6KPWqH8iI1pYzo0A17yzBQER9fLIRYEpImhIQCOEIwFbe9Fos4kRp6dBtIj70p6AcrIpw1QzczYoxTNr7p3kuHppjVYEz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975514; c=relaxed/simple;
	bh=pmbI2v6x2V7AbEvp0oo985spxIQkm+SKBAUqGRK6cvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVGDmsdNqxHPtMVmpsRouEkqWfBX67aMEL5Zh+Zw4EPR4ZjZDr7GNMVafCmCJWkpX3SBc8dZbEYnSlENcRkDSGbY2Cgb+jZPBFtouBh6u4oOp5DVo8C3vMhalcnajVQ1ff4WRr+FF6zlkIOz2XirNb23kWaSFLll5XI9FJEUbOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jaru6+aW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jaru6+aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B8F1F000E9;
	Mon, 17 Aug 2026 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975512;
	bh=Xpua4+EDSSZoPE63jCxxnnHjfzQShCZtyI0W3q0nhio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jaru6+aWRO2zmOshN7T7GLnKGh9ZwjdwDmPZR93Rspx78InwzbeErbNcn2al4agby
	 BmJ0wJMq7kcZMxVZKoF6Xxbttf5jcvNQZrp0RpHugjr6uk0AeD1ZdZ1Iv8EH89solG
	 DjY2vAVgkRxJhXA//XoPcePOo7GRhM8gwMqSWA1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 052/389] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Mon, 17 Aug 2026 15:28:11 +0200
Message-ID: <20260817132541.084611653@linuxfoundation.org>
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
@@ -2480,7 +2480,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


