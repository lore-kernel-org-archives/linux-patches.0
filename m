Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF03B33D4E2;
	Thu, 30 Jul 2026 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421566; cv=none; b=YvZoj5V57tVjT6pJSikJSlQypOUBLBg4AUhJfTMc7UtYeUgUnTwuqQW73f1955BOOymT9wqhuXeHybCSPVrjmQcDgxNyB1xngZVSHhkiigXLiYKMIXLNsQBWS8MPZsu4BglGxDvmwNH1/9yv1gSyhyB828Vsgq8dPdB/DznLmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421566; c=relaxed/simple;
	bh=DQl3gSPhy86vJc1ue88HDhfSK6hHKU89oA0FlNMpGuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYZq+HCFt2tfuQEoC6itnIBGt4Bol3/CfWflbCRAcgiSqs3Abh2xyR+QEzPfrXSWh9yINPi1fKopSMYz0tCcNRWRmKTKrI9C6mBQA3eNkPMY9Fv6h/wbvd+tE9aKikbBU1tkqq+CEwjKBVTn85EFWTAFvIbZoUAz2UZrhTDjac0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FlHZm9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FlHZm9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EE51F000E9;
	Thu, 30 Jul 2026 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421565;
	bh=pAggcWFRmbxEQwWjeWvDYUgoa42DEIZaEwpLJY6UlXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FlHZm9B4hrz83Y4hdTwdvm8bkJmDDXKTuYJqiHix0EJp26pXxYWPh6hh1g+ebMSw
	 XpEl9iVFUjmdjHNoCoDPJ+LLCNgv74sVS5M4swaYPL8kn1d3vzI6jOZ8MdKNSDZAjh
	 Hji4FMjojkbWxjHQ+xDC4EkPxWkfUkFK4oy4ajrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 147/744] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:07:00 +0200
Message-ID: <20260730141447.410597505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


