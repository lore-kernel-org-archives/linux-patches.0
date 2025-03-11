Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28163EA76;
	Tue, 11 Mar 2025 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707120; cv=none; b=o05iCUyz1rXroPuIpLKH8dxi4hNrly72xx6FwBtFTX1gVsicBGSw0gCIgsXPstKNfBwDPaBAHuZeRmDu7kIYCiuCjdxLbb+gi1wriPvjUNPWd5BolE5gazbyC65Guk+61ANGkTiEa4QNWmiOrByipw6SWsneawmtgZdJlkq6CdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707120; c=relaxed/simple;
	bh=23oQ845EIW2ByqLewdz0uXTXUcL/fa1BWPmfgeZXUsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnYmUWtG0OVC/wM1QehKdGZwupEcOBZcz+HDjyYLQ7im9M2xWp4MUT8aHnSCdtya+HK+stJYdEgjNh6bD4L1CDL/4pEEGU1CyAvVeldyepR8Q8644aWJ2RYUSLVqUP6tn2CGp7CYGf6saGaMU5deljUlMGGkMkdJuC+hmLsfK2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZ4D5yKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZ4D5yKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BD0C4CEEC;
	Tue, 11 Mar 2025 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707120;
	bh=23oQ845EIW2ByqLewdz0uXTXUcL/fa1BWPmfgeZXUsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ4D5yKXpnWoJjt65xyT5O7eKmgi/AtrncbtVH7N7Eyvl8b5OiejVX5pXUok60yJT
	 8nRBIX2E7NIp9W514611VTBbXwK1K7d+8ZbhMuwZy6e0j30/bdFuA9Y8393cJm/kco
	 6uj+IyhsIWYuDvErXdJBTrmNq6mLLOtY32LgdjA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.10 249/462] usb: dwc2: gadget: remove of_node reference upon udc_stop
Date: Tue, 11 Mar 2025 15:58:35 +0100
Message-ID: <20250311145808.201028270@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 58cd423820d5b5610977e55e4acdd06628829ede upstream.

In dwc2_hsotg_udc_start(), e.g. when binding composite driver, "of_node"
is set to hsotg->dev->of_node.

It causes errors when binding the gadget driver several times, on
stm32mp157c-ev1 board. Below error is seen:
"pin PA10 already requested by 49000000.usb-otg; cannot claim for gadget.0"

The first time, no issue is seen as when registering the driver, of_node
isn't NULL:
-> gadget_dev_desc_UDC_store
  -> usb_gadget_register_driver_owner
    -> driver_register
    ...
      -> really_probe -> pinctrl_bind_pins (no effect)

Then dwc2_hsotg_udc_start() sets of_node.

The second time (stop the gadget, reconfigure it, then start it again),
of_node has been set, so the probing code tries to acquire pins for the
gadget. These pins are hold by the controller, hence the error.

So clear gadget.dev.of_node in udc_stop() routine to avoid the issue.

Fixes: 7d7b22928b90 ("usb: gadget: s3c-hsotg: Propagate devicetree to gadget drivers")
Cc: stable <stable@kernel.org>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20250124173325.2747710-1-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4581,6 +4581,7 @@ static int dwc2_hsotg_udc_stop(struct us
 	spin_lock_irqsave(&hsotg->lock, flags);
 
 	hsotg->driver = NULL;
+	hsotg->gadget.dev.of_node = NULL;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 	hsotg->enabled = 0;
 


