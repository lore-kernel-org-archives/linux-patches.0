Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3E1741D8;
	Wed,  3 Jul 2024 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003586; cv=none; b=VoMNjdSGsF/4MzuETAlidECguoLBBAyI96UP7PbEeDSIJmMOC0VUrEo58iLPZBbWsx9zOxPHA2bQCC+EfCT9w/Xfc5w11SaQu5Feuq/9vfO44n5lZUw8QTiHujRnDx0R9loC+8jM3Z8muN3X7awa7gkcGspxYl6Gr1YaNLPP8pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003586; c=relaxed/simple;
	bh=optgjZAkQpmcLmllpEd/GguJcV7faTXEiqbm/FvAfos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FusHFuyMnUahVVVn0s96ZQQPUQrgiOn+Pl0ICCZg4z49s2jJIZJP3ZOt5ipksSe7JqXNHIX+8oyHhoPvcIzl7Qswnb+u0SEpSN2w/EscSOLVLcj6BpcTs/CVw4b4lfF54YZzNofIw9Lhj+Kzc9z9JzoDwC9+irvJDah85JqEcao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlYObcmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlYObcmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC717C2BD10;
	Wed,  3 Jul 2024 10:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003586;
	bh=optgjZAkQpmcLmllpEd/GguJcV7faTXEiqbm/FvAfos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlYObcmGUqvj0aZBBkL1zHT4WcKj9igunl4vB/sGc5eMgVDqFWXHr4rVWJQYfMsJH
	 tehN77ItcMo9216OWF9CViRaVZkYosqn5kJ7DotrXpqZzW0jGKPfmxpCNUGZl8xdbA
	 7ZCIkcpM060oAVZfuUs53UG0pRWHEVcHGwAFDZAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernhard <bernhard.gebetsberger@gmx.at>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 098/139] usb: xhci: do not perform Soft Retry for some xHCI hosts
Date: Wed,  3 Jul 2024 12:39:55 +0200
Message-ID: <20240703102834.141077004@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit a4a251f8c23518899d2078c320cf9ce2fa459c9f upstream.

On some systems rt2800usb and mt7601u devices are unable to operate since
commit f8f80be501aa ("xhci: Use soft retry to recover faster from
transaction errors")

Seems that some xHCI controllers can not perform Soft Retry correctly,
affecting those devices.

To avoid the problem add xhci->quirks flag that restore pre soft retry
xhci behaviour for affected xHCI controllers. Currently those are
AMD_PROMONTORYA_4 and AMD_PROMONTORYA_2, since it was confirmed
by the users: on those xHCI hosts issue happen and is gone after
disabling Soft Retry.

[minor commit message rewording for checkpatch -Mathias]

Fixes: f8f80be501aa ("xhci: Use soft retry to recover faster from transaction errors")
Cc: <stable@vger.kernel.org> # 4.20+
Reported-by: Bernhard <bernhard.gebetsberger@gmx.at>
Tested-by: Bernhard <bernhard.gebetsberger@gmx.at>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202541
Link: https://lore.kernel.org/r/20210311115353.2137560-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c  |    5 +++++
 drivers/usb/host/xhci-ring.c |    3 ++-
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -280,6 +280,11 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == 0x9026)
 		xhci->quirks |= XHCI_RESET_PLL_ON_DISCONNECT;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+	    (pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_2 ||
+	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
+		xhci->quirks |= XHCI_NO_SOFT_RETRY;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2291,7 +2291,8 @@ static int process_bulk_intr_td(struct x
 		td->urb->actual_length = sum_trb_lengths(xhci, ep_ring, ep_trb);
 		goto finish_td;
 	case COMP_USB_TRANSACTION_ERROR:
-		if ((ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		if (xhci->quirks & XHCI_NO_SOFT_RETRY ||
+		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 		*status = 0;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1880,6 +1880,7 @@ struct xhci_hcd {
 #define XHCI_RESET_PLL_ON_DISCONNECT	BIT_ULL(34)
 #define XHCI_SNPS_BROKEN_SUSPEND    BIT_ULL(35)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
+#define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


