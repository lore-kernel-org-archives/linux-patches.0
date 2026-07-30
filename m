Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DEC43E4BA;
	Thu, 30 Jul 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425592; cv=none; b=XNNbGQekj0rKvfVlTlK+rbfBfG61QOQAy8/Ny+cteROFXgSImOx4xOKxsT1+dSxF0LkuNeNGTMZDvxja7MUmOcaft1LpuBr1WfnFnRG8bh9fN4Fc0jOoV+SlTcp32W1leSu9wUQWF/SomDYHXzL5Sbf1G87Xh//wnWYPWhcp6sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425592; c=relaxed/simple;
	bh=CFPwWMs6MP28KlpFn683TrvpJDX7IE5OeLvKQUdMLa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9LDOf/Xe8m7Pw5+Iz4WpvYFiWQQx0S0gh+XmQlIlsbY9YLIdyMlaYck+KG/UXzVqqSjHJ2fDvWFI9TBr5aepj0Y4SX6p3qxsd5TswIeslNK6jokIB9jQokKwOQ1+0Nqnq+tJZ9onfm/9DrDUcvLHtR2R4eq13mRF8I2pAl4Fb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1PDN0rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1PDN0rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAC61F000E9;
	Thu, 30 Jul 2026 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425591;
	bh=moF0mXX+FhKNzJ6txAMqZaZRRfXKh8cXz1lSv++80QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1PDN0rdexFBOkeZS5GwLIL5k6eFlgYBKqVMH6IH06OWjylgQfpyhc8FZWpOz7K16
	 XKXyP6nJ0UVlvxCBWXqGqlskVfccEks3Han/qL5dwdz0kii+q7wYMvmnBPu0IEcA/k
	 rEJQQgQYcIxOrADqHZ6kDLBSnMeaDfZv66FxwZNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 122/602] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:08:34 +0200
Message-ID: <20260730141438.553799824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2473,7 +2473,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


