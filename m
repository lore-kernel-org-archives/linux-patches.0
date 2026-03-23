Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9879B248F6F;
	Mon, 23 Mar 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278503; cv=none; b=OHzbrI8D3OGmgHXQKU4AG9y+0Rwq1Gn9KVasB/LgLc/0dwdSI0DCsC0SlFkL91dmCz0hcU8Z8qzcdH2u3BDZoaWLLObWAvZclXP7YAIr5Oiy+ui/gskPc1+jGfq6zgIEu/QKjhe5qdbxjxIX0dl3d8gSdE1TupDmAbDUUQ7YpnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278503; c=relaxed/simple;
	bh=s7rosTRlsNzHNIW/CN/bJtRTlWOOhg4NFIGL671gKv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqdEaDU26ijZ/D/tDFrHpKMUZX1J0EPVChtNraBYYWgBpXSc9Kbsfz0+KIxQbctqs0EeabPbitz+28rgLFfAZMiX9BykLkleMcnDgir8oTxXJjoYRTZa9nhoeW/+1d8HIZx2OtwETpHI8jdG6WdvuSFdRI+B2bzCzhcBm8Tf5AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSHY11cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSHY11cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4FBC4CEF7;
	Mon, 23 Mar 2026 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278503;
	bh=s7rosTRlsNzHNIW/CN/bJtRTlWOOhg4NFIGL671gKv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSHY11cwWtVDjEQ8dsyoYyHeKe+eq9X26CF6YrH5RnGW+saSSNTrjnbK7fPahxsQS
	 6gB7Y170NTYEgmxGu9DKkhBGR2QbfWP9Sb8iN4beF+A2pT4Fhsa0Kb/6GsC8RIJSuw
	 fN3SzfukwMpueEI1x6TOvd1jFr6T/3tQbVFaMhys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.6 284/567] usb: renesas_usbhs: fix use-after-free in ISR during device removal
Date: Mon, 23 Mar 2026 14:43:24 +0100
Message-ID: <20260323134540.854186411@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 3cbc242b88c607f55da3d0d0d336b49bf1e20412 upstream.

In usbhs_remove(), the driver frees resources (including the pipe array)
while the interrupt handler (usbhs_interrupt) is still registered. If an
interrupt fires after usbhs_pipe_remove() but before the driver is fully
unbound, the ISR may access freed memory, causing a use-after-free.

Fix this by calling devm_free_irq() before freeing resources. This ensures
the interrupt handler is both disabled and synchronized (waits for any
running ISR to complete) before usbhs_pipe_remove() is called.

Fixes: f1407d5c6624 ("usb: renesas_usbhs: Add Renesas USBHS common code")
Cc: stable <stable@kernel.org>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260303073344.34577-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -800,6 +800,15 @@ static void usbhs_remove(struct platform
 
 	usbhs_platform_call(priv, hardware_exit, pdev);
 	reset_control_assert(priv->rsts);
+
+	/*
+	 * Explicitly free the IRQ to ensure the interrupt handler is
+	 * disabled and synchronized before freeing resources.
+	 * devm_free_irq() calls free_irq() which waits for any running
+	 * ISR to complete, preventing UAF.
+	 */
+	devm_free_irq(&pdev->dev, priv->irq, priv);
+
 	usbhs_mod_remove(priv);
 	usbhs_fifo_remove(priv);
 	usbhs_pipe_remove(priv);


