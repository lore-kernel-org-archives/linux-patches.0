Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FA17A2E8;
	Mon, 10 Mar 2025 18:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629632; cv=none; b=ntLohgOd6xAI2Fs4jc+VhN7f0uBbX4iia1G1qepO9LVWqCc2Yn5SbPGebQtiaI9bZb3+koRubQUj4/2az9yCwPvp5FUQ1hx6SJVzsUghZ/3MY5YbvDq1rMo1+ZJPm4AacgDKgxmNY7osFeX1z21bo9gAn7Aaw0M70vzOcJlQo58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629632; c=relaxed/simple;
	bh=DkXxAOu/gTR6DxPkQTl/Vo7xaA6SUri0r7M2rADV/Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jr4nCv7u//wYO3DIc6pnmr3r2egQNE5eUl+pcNlxC9KOEepNvQJw28aiP1dzuafOh7upCoIaCIvcJwtoaxjRwzIfs8fqexlTZc930fpAgSt1rz6yFvfZ84CQ6gnR2ATAo18yJJaafQ71Mpx12oy3aPzzXg4K2vRCob9VnjbxDIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/njUvnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/njUvnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF854C4CEE5;
	Mon, 10 Mar 2025 18:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629632;
	bh=DkXxAOu/gTR6DxPkQTl/Vo7xaA6SUri0r7M2rADV/Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/njUvnU1OOvCqY4Y3DelPDr356n3BHjqm/IIT6e6Kp9xVvITc0qX6g/5vB89QKTI
	 p+56nhF7wqQZCwioYAZs62NmH7EomIQxY8XJ5wOxojVFcEonRpBXL3ITWg4W+yUCn4
	 3403VtyovE7NUZj3hxiuZA17mYE5dHont5t+trek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 5.15 362/620] usb: dwc2: gadget: remove of_node reference upon udc_stop
Date: Mon, 10 Mar 2025 18:03:28 +0100
Message-ID: <20250310170559.897908965@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


