Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A246BFAC;
	Tue, 14 May 2024 10:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683817; cv=none; b=uwRcQ2DsNCjC28pwtjWYJtSW79gTHCcgakWyDrf42aIA5FO3TQGflEcuXA9Qyvp6+h8/Zqtkzx1+UHAhSlJxAoDvIz5+yOHkfQK9NaIFfafFWlLYfUEr1cHw+FOim5paS16MsHK3jgsSWw+vtv2rQAc9GrEdgNyChwQ97RVvxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683817; c=relaxed/simple;
	bh=L3bO2XzDsaH84akNwcK/OU/jtv/oIhR0PglE6P/EKfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCLl+KO0ASYMl3WA4jErlOcX/HtOY9FU6Si8ntTqEVfnNxJCYSkQnyRPUULCNJKZLLzLGc7et64ceEh0jCJrF581AQyjiZesjEV2OaW+Io4xxq4ZuaKyzBRBgonRO/aQWMMFkqic9DbWfCGubkAjCcIJVGNSs65ql82rs+TPHdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXy/NOGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXy/NOGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31464C2BD10;
	Tue, 14 May 2024 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683817;
	bh=L3bO2XzDsaH84akNwcK/OU/jtv/oIhR0PglE6P/EKfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXy/NOGcMb35cuTtE2lnry6nolW8FDoz5dOOO5FD2g/fJpaCPWHArcudgnTB97zeM
	 ThJ7DqsujlUMyZStEXZ+26Rrdk2SywvTkrClNDMaDWpAbXiBPizgXbsDw6zVfgtn+G
	 Qt36okSFxslTCxPeklWkvXjlyYkGzwmejCSp4ErM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	David Laight <David.Laight@aculab.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.8 248/336] usb: ohci: Prevent missed ohci interrupts
Date: Tue, 14 May 2024 12:17:32 +0200
Message-ID: <20240514101047.983146013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit fe81f354841641c7f71163b84912b25c169ed8ec upstream.

Testing ohci functionality with qemu's pci-ohci emulation often results
in ohci interface stalls, resulting in hung task timeouts.

The problem is caused by lost interrupts between the emulation and the
Linux kernel code. Additional interrupts raised while the ohci interrupt
handler in Linux is running and before the handler clears the interrupt
status are not handled. The fix for a similar problem in ehci suggests
that the problem is likely caused by edge-triggered MSI interrupts. See
commit 0b60557230ad ("usb: ehci: Prevent missed ehci interrupts with
edge-triggered MSI") for details.

Ensure that the ohci interrupt code handles all pending interrupts before
returning to solve the problem.

Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: David Laight <David.Laight@aculab.com>
Cc: stable@vger.kernel.org
Fixes: 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI devices")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Gerd Hoffmann <kraxel@redhat.com>
Link: https://lore.kernel.org/r/20240429154010.1507366-1-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-hcd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -888,6 +888,7 @@ static irqreturn_t ohci_irq (struct usb_
 	/* Check for an all 1's result which is a typical consequence
 	 * of dead, unclocked, or unplugged (CardBus...) devices
 	 */
+again:
 	if (ints == ~(u32)0) {
 		ohci->rh_state = OHCI_RH_HALTED;
 		ohci_dbg (ohci, "device removed!\n");
@@ -982,6 +983,13 @@ static irqreturn_t ohci_irq (struct usb_
 	}
 	spin_unlock(&ohci->lock);
 
+	/* repeat until all enabled interrupts are handled */
+	if (ohci->rh_state != OHCI_RH_HALTED) {
+		ints = ohci_readl(ohci, &regs->intrstatus);
+		if (ints && (ints & ohci_readl(ohci, &regs->intrenable)))
+			goto again;
+	}
+
 	return IRQ_HANDLED;
 }
 


