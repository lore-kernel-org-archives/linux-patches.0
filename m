Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0601B4F21;
	Wed, 19 Feb 2025 09:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957382; cv=none; b=kMWbDJKtnfI/U9L6bhqm8TmNvFBV5o5be0PgmGQPRNQTPgzvdOgP7dvwkDN+W8sGfHkshVQXhCaJoHfmse84CiDMITzo/PY9JYmh31oLh9DpZAOA3Ts5D9ihd1vnS3cPACrkWMX4Z1Y9qacTshe4KXMb44L4XiMOpAk4m5W59AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957382; c=relaxed/simple;
	bh=NHnKdemfEtQaveKIU/KP/iaDSAewpk2a7++WLXgvuxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQEV8dvu6F/8tAXxB/WPjI+i3Y/wRlp8UGfRZ3vmWiyAQWv/j99c9FlD8g61YgvjHU0mZlFcBIdRsibIyXMD5pnX0PpRhI7ixMkPK3vF5xeq8huiJl0aOf7lx4kkvcuAXE1qLJXASy7DWcqYC0mlzsIDAjWg1LdfRMd8BvPXYRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oU7cM5Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oU7cM5Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6D1C4CED1;
	Wed, 19 Feb 2025 09:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957382;
	bh=NHnKdemfEtQaveKIU/KP/iaDSAewpk2a7++WLXgvuxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oU7cM5EzoGMtBc9Zys/OwkncLcidGO9uVMQ3biW9KzBP7KcdapVVvRs19Ki6QdyN5
	 mtzEOno3DdUqJsEZfAyVlNtFR1EuzB2vTnH7Rx1grvk3LTFTLqGPoaP8vBySg9+xYb
	 5KTwkYccvXI1FhncgZphhxt+1voKhwBBVK4fOiJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 6.1 506/578] usb: dwc2: gadget: remove of_node reference upon udc_stop
Date: Wed, 19 Feb 2025 09:28:30 +0100
Message-ID: <20250219082712.888685093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4613,6 +4613,7 @@ static int dwc2_hsotg_udc_stop(struct us
 	spin_lock_irqsave(&hsotg->lock, flags);
 
 	hsotg->driver = NULL;
+	hsotg->gadget.dev.of_node = NULL;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 	hsotg->enabled = 0;
 


