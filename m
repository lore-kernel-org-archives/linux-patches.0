Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FA1B4F21;
	Wed, 19 Feb 2025 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955616; cv=none; b=XRLLXwIlzftT3uHthdwyBmrWHaU+u1m7sf+tnRiiEf9g0nKNR/XtNkTdhCBe+Ys+w1n1ZAaudDlZaS+ZyBEU4r7a+mEWTzsLzRNafV+SQMSeFW80q8xXnht7i6s58SBMUuGAiPRWTunYStolGKXZjJwJrHBcTYq5/n9Ef5B3hhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955616; c=relaxed/simple;
	bh=djB94WU2n0ifvJ1hG18QoDDVCx/ucPMEefk3xbeqIxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0ZJJHLu3t6lm+1FNEagJyZ7m/qCJSJrE8HHT5oblYkDiO0llcj9lvIvAVGhMO4wxplEqkEhmLOmT0DEm1yj8KwNZaYzY0G1Sk+ZUjLoocPbLzMS+ycpLsf+7gQKKfe1gkNhGoIvV3GvIeuZGqyoSZTFpkLm0JR7HGjppREplJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKeQeDHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKeQeDHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10987C4CED1;
	Wed, 19 Feb 2025 09:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955616;
	bh=djB94WU2n0ifvJ1hG18QoDDVCx/ucPMEefk3xbeqIxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKeQeDHMREHlOVuoL9ktibaSy8aOvNwYyJsKL+eW/nip4Fi1Bl5elOIQz6Uq+yReN
	 Bnmu9/JePqJiH0Usa2usJODqEbB/UCBZK8pz+usc+XhVUpXuBGECo3SI27hKzFXSDj
	 e+/BMXIa/CYOxakQh5K1CRqtuFAIVEN8u0v/cD1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 6.6 060/152] usb: dwc2: gadget: remove of_node reference upon udc_stop
Date: Wed, 19 Feb 2025 09:27:53 +0100
Message-ID: <20250219082552.419218607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4612,6 +4612,7 @@ static int dwc2_hsotg_udc_stop(struct us
 	spin_lock_irqsave(&hsotg->lock, flags);
 
 	hsotg->driver = NULL;
+	hsotg->gadget.dev.of_node = NULL;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 	hsotg->enabled = 0;
 


