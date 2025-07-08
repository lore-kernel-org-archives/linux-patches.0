Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38AE202F70;
	Tue,  8 Jul 2025 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993724; cv=none; b=R8W3Bk6M0C+E44TGfXsUxkn3CfkgyBlLPrdCIulrY+VHx09zBDjL+o+qCUAg3yC7Gwm/cftrQlmm7kO9njRVrU/Y85d4017NTBeJiEGR3Zvv4k0PTcXvx+8mjjOe3MvntyCAG3k+s7aQqV58LF6dXTrFTiZkfz+8m3RKcrs4Dmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993724; c=relaxed/simple;
	bh=wh71M4b7UsgmUqjavSd646IP2NLfQNJjfen1OKZ7/S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv7TGUq7lhPsv/GWlR3EEYE3Mym/P+PE8++h2AWZgFcWFeZ9Uu/UBwV8Y80I+xw+Cww9A5luHka37UuuIx3A5USXrHUKzHZjOl9TPhYyBUKlYUl0V0rl80fbA6lER2V0Wvtw+us5CRXFt5eNcqZZ7KZBXDJGd2pgkOtGCGidPFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwZwYvaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwZwYvaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D314C4CEED;
	Tue,  8 Jul 2025 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993724;
	bh=wh71M4b7UsgmUqjavSd646IP2NLfQNJjfen1OKZ7/S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwZwYvajkwplCpuUIV55zberN8xhJs2vrGeUW9PABBxQJ60uX0axI2YnbAJefnS1A
	 llHyqVSZNIBljny5ip38/PsYSFGkaxTN8qaNYZRYRshAiO0QlMim8mzA5mU6zZrEQs
	 mIkTTxbaP3c0UVu9M1H7AogPf/ibZul//LVh6fQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@intel.com>,
	Roy Luo <royluo@google.com>
Subject: [PATCH 6.15 141/178] usb: xhci: Skip xhci_reset in xhci_resume if xhci is being removed
Date: Tue,  8 Jul 2025 18:22:58 +0200
Message-ID: <20250708162240.223170682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1084,7 +1084,10 @@ int xhci_resume(struct xhci_hcd *xhci, b
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


