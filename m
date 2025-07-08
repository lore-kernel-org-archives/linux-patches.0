Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D0E23DE;
	Tue,  8 Jul 2025 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993222; cv=none; b=VhpQbnSYZsTODI+PduKCNtB3OF6s/M3L++OGU1xDV/vjJ+yngxJopi43CeCcdXtm0un1U/0xC2SFSMmBotxU333nlMoCNRFfwAOX/4FM76wVPh+pm1wqU2BzFcTK30enn9RQrT3aVLFnJmXgedVyk/NAJHWv3c4Nl6vv3Vx1W5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993222; c=relaxed/simple;
	bh=BF7WYtOKD1bq84jL9E+PIISO/YaPiDUeAuOd1y32pjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK559MMf3Bm8g0sx40AeI+E+NNpkSDG27Rvgdox3zgMiM8K8RI+Z2o2FZkn3l5AwakY5itCpM+0hzSUdHMcwPIVSWYQ1wKsunKRPPDQOeYckIeJEbUDxBU6Br2vcdur5O3n3O6WH0ZCTYlswfeGK+4wygL399QSJssgc2OVbA/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNFJ8ktY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNFJ8ktY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F4C4CEED;
	Tue,  8 Jul 2025 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993222;
	bh=BF7WYtOKD1bq84jL9E+PIISO/YaPiDUeAuOd1y32pjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNFJ8ktYrkq0JAS78I7xArLNPN+ApcIXKh+flZjUUqN2X8wQDsxbiuGaKY0kpfu4A
	 HLBAiU8rh4HArqi6LbgX/ZKk+vii23xafFMpXWbAGp7PK0HohHDpw/CcrXhesVbYmP
	 SVtqnnnJwbXtFhWSO5yFs6LtJ0LdDwlRHkEby7cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@intel.com>,
	Roy Luo <royluo@google.com>
Subject: [PATCH 6.12 199/232] usb: xhci: Skip xhci_reset in xhci_resume if xhci is being removed
Date: Tue,  8 Jul 2025 18:23:15 +0200
Message-ID: <20250708162246.645412558@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Luo <royluo@google.com>

commit 3eff494f6e17abf932699483f133a708ac0355dc upstream.

xhci_reset() currently returns -ENODEV if XHCI_STATE_REMOVING is
set, without completing the xhci handshake, unless the reset completes
exceptionally quickly. This behavior causes a regression on Synopsys
DWC3 USB controllers with dual-role capabilities.

Specifically, when a DWC3 controller exits host mode and removes xhci
while a reset is still in progress, and then attempts to configure its
hardware for device mode, the ongoing, incomplete reset leads to
critical register access issues. All register reads return zero, not
just within the xHCI register space (which might be expected during a
reset), but across the entire DWC3 IP block.

This patch addresses the issue by preventing xhci_reset() from being
called in xhci_resume() and bailing out early in the reinit flow when
XHCI_STATE_REMOVING is set.

Cc: stable <stable@kernel.org>
Fixes: 6ccb83d6c497 ("usb: xhci: Implement xhci_handshake_check_state() helper")
Suggested-by: Mathias Nyman <mathias.nyman@intel.com>
Signed-off-by: Roy Luo <royluo@google.com>
Link: https://lore.kernel.org/r/20250522190912.457583-2-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1094,7 +1094,10 @@ int xhci_resume(struct xhci_hcd *xhci, p
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_zero_64b_regs(xhci);
-		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
+		if (xhci->xhc_state & XHCI_STATE_REMOVING)
+			retval = -ENODEV;
+		else
+			retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
 		if (retval)
 			return retval;


