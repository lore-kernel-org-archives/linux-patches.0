Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F9947A6C;
	Tue, 14 May 2024 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686602; cv=none; b=PuonhqmNo2vzJi+dnoC/BAFqWOpJEuiUqbvKtuoDnOtfefSEIjFm0pmh1PdJ3aIc/NzcFTGdQsnR7WD38YitofZ6MuRqIz10dpoduRwWg3XwWDBagq2c06yldY/DEbtDhE6epCsJek8Hva0YGQ2LD7/azvFAMWwU/kA15DshjEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686602; c=relaxed/simple;
	bh=ggQhrOxZoVZMuScWlFvigtLcT6FjG8Thli5Q9o6QoQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvrwLIESSnlZ4P4zFd4moV+qApzNLiMj8hMB2L3Gxf5b2u8MbvArPVzFY+dOGij6r9PzAUbijVlA5ZvJshN6v55PGNPgCt2I/D6P5RAPe5PBVa73Xy4SwHLl8K2WHyp50rFBj2PkoHJrUbq1bPt9J1I8RkNFej7k02pLcZVsYqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKhjleFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKhjleFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE25C2BD10;
	Tue, 14 May 2024 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686601;
	bh=ggQhrOxZoVZMuScWlFvigtLcT6FjG8Thli5Q9o6QoQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKhjleFOxUO+vsKwB8P4NYCiyCyZ04dq4KtpWDynBsD45+Igkyk+FJ9gE6yJeavkQ
	 NJnsE0MfRtCGxQ2QQVCOFd3q/1Bmt9EV8tqQ6ICCOtEp2urqO2DmXTqVkSOiqKo3ZI
	 7llK8zMslrGKpwJVdBTMs+ehFJ0upo9joxVHT/MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	David Laight <David.Laight@aculab.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 195/236] usb: ohci: Prevent missed ohci interrupts
Date: Tue, 14 May 2024 12:19:17 +0200
Message-ID: <20240514101027.770694934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


