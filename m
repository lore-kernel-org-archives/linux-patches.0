Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601F62E9EC7;
	Thu, 30 Jul 2026 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427247; cv=none; b=T/J9FVMt1dojzYQBP7BGvP5kBBESJimyKltxzVPmLXIdfc5xs/Q5wgCj5Ok0Tc+EdKP/HbH7kr9TxueH1cXHg4d0ZFNoR0xWevxsX4eWK+nI55TpD7nqOM1ra0EdtwYLKuXrsm8S5Zzd0XXr8X7LhT7QtsYZets81WYMjWXV2b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427247; c=relaxed/simple;
	bh=dr0A8ZxNDNGLknKpoMLR1779//ODNnDIb8tDxtWnqfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5lbyiodSGLFWcJ5FjpxNgqXZe6th+yKP512mvdTVg8aD4XxoMKJu6pS4nsPlogzTwK5rP7667AmX8JtI3U/60KMcsdD8FLxa3JTiKw4W3y5OHdsg9JZ7FpfRGzYAuHYoS7Y8Mb+z9o5/whjWpBzenHv8VyzFpbXP5lAowCZFhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tkw41uS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tkw41uS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CF71F00ACF;
	Thu, 30 Jul 2026 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427246;
	bh=b5ROt/hEVBNN5kqGNo6uMK8mpxuvjoHlaOUzGS6cuKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tkw41uS4EqNWtc4dHgfQsfXYdWGqQZbsAIubRDsL+bcIPeoeIBzAQ1LIJ9OjqW4u2
	 6treArVnVsQ4MIB4TF1dF+3P2s588VAxGMf2Ofxqn4QL+xC/37hP2uwk0JhkjuRnZM
	 zAlNOhFSvgFxY0cJyIL1hEMlXrEuAJTC8BSnzNxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 103/484] USB: gadget: fsl-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:10:00 +0200
Message-ID: <20260730141425.696039672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2465,7 +2465,6 @@ static int fsl_udc_probe(struct platform
 	udc_controller->gadget.name = driver_name;
 
 	/* Setup gadget.dev and register with kernel */
-	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))


