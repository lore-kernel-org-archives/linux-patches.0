Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A79E359FBE;
	Fri,  9 Jan 2026 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960536; cv=none; b=o8dB9bbwO3HnXIXbgJBwBz1X16SEs8dk6BtWEDuA7voPhHIQcsttpomOAsUSxuHHgFZg5b6Y6n8QpMjAdkMzgHMbw6FOBj81r07boD/063V+snNUNXxqnjsgLQHYihYvYUUD1w4YXEg1+k3u47TYnUllXCyo/nVhJhl74HrdGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960536; c=relaxed/simple;
	bh=CHFBoOUwdEMK6vRatCMLy+q5iHu07JFkn97DNw+RuN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmzOPhB10qACjHFlnh50INjXmaK3LMJJwoAbRlJaPCgLy8z4pd3AmJYzvl/5XxYsLNGvja/ZikWFs0Hl0JGkx9/lR3SLOkUyZtvB7uTtAbIVdrAcUmnMx8Vw1PI7q19bLS4ynj8aS6tgYqPYuxIruzCFENVbmTtgkELt86GVMd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ/bvDjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ/bvDjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE1C16AAE;
	Fri,  9 Jan 2026 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960536;
	bh=CHFBoOUwdEMK6vRatCMLy+q5iHu07JFkn97DNw+RuN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQ/bvDjg3sUzO7GNn5dO7oey7dJK+DLgE/aE+sSWe3iket+VhMmNkRonnCUbHfq3A
	 OpPtymKLH6Wg+ysDwmx14cKPX2Jma+jJcrgZXRrJA036Ega9hJgI6PlqQ17j5sFBlL
	 5bV3KZm1ekUXChlnu0aJhE5RBs0TcNPBdxrpSYgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Udipto Goswami <udipto.goswami@oss.qualcomm.com>
Subject: [PATCH 6.6 439/737] usb: dwc3: keep susphy enabled during exit to avoid controller faults
Date: Fri,  9 Jan 2026 12:39:38 +0100
Message-ID: <20260109112150.505078585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Udipto Goswami <udipto.goswami@oss.qualcomm.com>

commit e1003aa7ec9eccdde4c926bd64ef42816ad55f25 upstream.

On some platforms, switching USB roles from host to device can trigger
controller faults due to premature PHY power-down. This occurs when the
PHY is disabled too early during teardown, causing synchronization
issues between the PHY and controller.

Keep susphy enabled during dwc3_host_exit() and dwc3_gadget_exit()
ensures the PHY remains in a low-power state capable of handling
required commands during role switch.

Cc: stable <stable@kernel.org>
Fixes: 6d735722063a ("usb: dwc3: core: Prevent phy suspend during init")
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Udipto Goswami <udipto.goswami@oss.qualcomm.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251126054221.120638-1-udipto.goswami@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    2 +-
 drivers/usb/dwc3/host.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4807,7 +4807,7 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 	if (!dwc->gadget)
 		return;
 
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -168,7 +168,7 @@ void dwc3_host_exit(struct dwc3 *dwc)
 	if (dwc->sys_wakeup)
 		device_init_wakeup(&dwc->xhci->dev, false);
 
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	platform_device_unregister(dwc->xhci);
 	dwc->xhci = NULL;
 }


