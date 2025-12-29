Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF61B6D08;
	Mon, 29 Dec 2025 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025662; cv=none; b=mKrp0AFkbF8T0drKj8KKC8gs70QhPwdzJCh+O55lJhaMywAWxhn44c7sget1dUilK1FkMa8yUBL2YqWCW1nTq/9LFLtWP+RHz8tWH4DY4QwIMWLIFf10h3X5XHCvWo4ayDse0KoIrYF+Wld1YeXknTIDlp2wDxd9x9JNMnvGak0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025662; c=relaxed/simple;
	bh=SUaJDWVrG6PZRg1Ir6Jp9101Lg9gT++f7hGuNFjaD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK2aKhcWdeG9YTgrRgJGFLzA3mEXi7yosTxQqHQDx7iM3aFioLc9Qs0d/aV5R3DH3YYyC5eDfsUWsZ4LElwSUT7WeqdIK/Q8KBgnJaVbD6XS2CxQ+tVxmT8TVBhAIwQIh0tLw/wosQ0F7ptkZV9g5vyom8EbcLMYXJcyc7xUM+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc/4cHFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc/4cHFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8C7C4CEF7;
	Mon, 29 Dec 2025 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025662;
	bh=SUaJDWVrG6PZRg1Ir6Jp9101Lg9gT++f7hGuNFjaD7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kc/4cHFlDKk1PqrDlmjrcF83INSlIwE1yfAXFq/yRxJ/PaBAr7VPfyg3+TvDud2DF
	 J/wDEbkZz4gCamSDhjmg9zOZSmnoMVoVXAmEdwu9dBr+t17kTNGEqDMQu227DmUVpq
	 Cw6J7IbIfgOLpOHJqzF/t/Zb1DRxJJ1jTWBESRT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Udipto Goswami <udipto.goswami@oss.qualcomm.com>
Subject: [PATCH 6.18 292/430] usb: dwc3: keep susphy enabled during exit to avoid controller faults
Date: Mon, 29 Dec 2025 17:11:34 +0100
Message-ID: <20251229160735.087513662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -4825,7 +4825,7 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 	if (!dwc->gadget)
 		return;
 
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -226,7 +226,7 @@ void dwc3_host_exit(struct dwc3 *dwc)
 	if (dwc->sys_wakeup)
 		device_init_wakeup(&dwc->xhci->dev, false);
 
-	dwc3_enable_susphy(dwc, false);
+	dwc3_enable_susphy(dwc, true);
 	platform_device_unregister(dwc->xhci);
 	dwc->xhci = NULL;
 }


