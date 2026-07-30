Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4730C618;
	Thu, 30 Jul 2026 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423737; cv=none; b=eo8NoGp3c3eKhFYo30lvWklSYvajcqvxJR+H2oZJfe2YEDvM7OWAQ6fxv6V7ouUgzgQxEvyx+b9qJct521b7yTFMSHz233xQv0s1RV/iSmQF+fFpgVE/n5dm2X1DQquQGtOgnUREAMAwOWtTzMuF6jKoF8KdOEiDDKL3mmBPvzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423737; c=relaxed/simple;
	bh=XFRsFuS+C2nS2+T1nqI4I5O2Lqt/uBQXc+M+bKyb90I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFPSi4w45R1KrvhPS6D3C8Uw/NeDDRaXBSFX+0EUaGoGk5h2otneYf57dCADi7UKWy9QmInFIs7n10FLZGwCvGfvzTs4iSE2bCHzBEbRE2puh1YnvqgzfEFjXt1DyoSY4gDsHkQnbQAp6w2QBC6BCBKwhg8jH4jes4/SIS8HS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlf0MQwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlf0MQwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F181F000E9;
	Thu, 30 Jul 2026 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423735;
	bh=fGFSBaaTGJnwxvKQ0PGv3HXM1Izx4VUNJKUWQUzW7rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlf0MQwetpb2aanwg4GYx7AwQ/GtQo2QxFg5u6fI54j2U1cYVRqdvT2TQocIZjvsR
	 As+L0wBOl5evoM8/HwRfwZDZ3/BVPI8SS0f5G2CQRmVDWdmWLVRlIvhTHyHxqmWwd7
	 cf2TXuczdju8f+/Yuoysqr0Gd0EksVUQtvOwbG3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 148/675] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:07:58 +0200
Message-ID: <20260730141448.283324123@linuxfoundation.org>
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
@@ -3133,7 +3133,6 @@ int udc_probe(struct udc *dev)
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
 
-	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.name = name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 


