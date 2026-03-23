Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524253B47CC;
	Mon, 23 Mar 2026 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278335; cv=none; b=uInpftkpPAZkN+I0Un9EfjZqlXsA2OCoNAMqoFOlVXQcmCci95X8OO/tNtReLxrk9oJyw7AoPfi5m0ZRxpBj1vVV5l5NXtTr/q5GKA5qB1V+HZHUN0L5yinU9/i9Wqb5fIWzvtwqWxqjRBtedTyjPQjpH1tMWo5rTlW2sOC+z6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278335; c=relaxed/simple;
	bh=U29+0NKCpZycOWQo7KBSOfBCY44nReAHzXqRUZ7HUi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aVWK9XSqLzQQtNe68S/UH4cb9BoErKuO50Si0w5ki0z1LsN/0bIkT6yw+Ay89vaPmRoZ5gZU2FXlGUGbA/ircQu99iKvcwMiu/X24TLClSIrXaX68/7iotSVO2Gurvk1SxIlYn9FUt6OUK3nSjl8uitEetqq2oMCCp24zFCBg9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqRlZckL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqRlZckL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928BAC4CEF7;
	Mon, 23 Mar 2026 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278335;
	bh=U29+0NKCpZycOWQo7KBSOfBCY44nReAHzXqRUZ7HUi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqRlZckLLL+zgimlCRqcxt3mqh7GMfM3F4r0JwjJCkJwPpCZKcVbEZ+ZXYCyqvgRt
	 ObzrpQ8aJRRxpKq3QZmLp6X+eGLZFzcNcZKQ+B9Zvup04s+w22qzQsLvrX21PCb/u+
	 8CEY1Rkyl0XBuwGsxqAsOa9U6hDzvmvbV8izflfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dayu Jiang <jiangdayu@xiaomi.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 273/567] usb: xhci: Prevent interrupt storm on host controller error (HCE)
Date: Mon, 23 Mar 2026 14:43:13 +0100
Message-ID: <20260323134540.585843131@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dayu Jiang <jiangdayu@xiaomi.com>

commit d6d5febd12452b7fd951fdd15c3ec262f01901a4 upstream.

The xHCI controller reports a Host Controller Error (HCE) in UAS Storage
Device plug/unplug scenarios on Android devices. HCE is checked in
xhci_irq() function and causes an interrupt storm (since the interrupt
isn’t cleared), leading to severe system-level faults.

When the xHC controller reports HCE in the interrupt handler, the driver
only logs a warning and assumes xHC activity will stop as stated in xHCI
specification. An interrupt storm does however continue on some hosts
even after HCE, and only ceases after manually disabling xHC interrupt
and stopping the controller by calling xhci_halt().

Add xhci_halt() to xhci_irq() function where STS_HCE status is checked,
mirroring the existing error handling pattern used for STS_FATAL errors.

This only fixes the interrupt storm. Proper HCE recovery requires resetting
and re-initializing the xHC.

CC: stable@vger.kernel.org
Signed-off-by: Dayu Jiang <jiangdayu@xiaomi.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260304223639.3882398-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3219,6 +3219,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd
 
 	if (status & STS_HCE) {
 		xhci_warn(xhci, "WARNING: Host Controller Error\n");
+		xhci_halt(xhci);
 		goto out;
 	}
 


