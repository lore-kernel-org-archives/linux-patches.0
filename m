Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A251EB184;
	Wed, 19 Feb 2025 08:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954290; cv=none; b=WmsHjeXZDuLSFtV5F9Qd1yenRlef4cRCmWz68pWFuSNkQYw6yRk2jcsgTLv5SE2ayYDeC98vWCUL/72WdZWbeXskGifvmXWyTCJUYY/l77efzOUj/KsubLwXaQZDExpzmRj0nn+85lAspg8wgZSuhLU51rwHL9fJo/3Pgbv6M18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954290; c=relaxed/simple;
	bh=K0GrVqAJMl87WwlixZRz+hC5ZsetCDU+9Ru/2TiQjWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpVRWhw2LR/zG+uaI0weRaGYUsHUnh1DuIvbdBBFkAoI9ouUOWYsXCznrvicYUqZxEm/HYbUfUpKQmdiD3F1nnBuZOal0K0CVLxnk2YKrKdv08ZI201DlUotcX73BrkNTH33qVMEsAAuZ/ohrDuJc0umYbzrwKXnS0JVO38FQR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKGxPFzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKGxPFzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BAFC4CEE6;
	Wed, 19 Feb 2025 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954290;
	bh=K0GrVqAJMl87WwlixZRz+hC5ZsetCDU+9Ru/2TiQjWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKGxPFzcgUe6TFesCPBzNzBYUhluVnkVx2xXBIuVS9sGgGw6PweOnKV8Bb5+d1iY9
	 sLfl6gIgqFF8fh09pMNAwc5CHA/9Rq5duEVsYeNJqH7TqIik4G0DvwrNf3yrs5UQvl
	 vugqeJhfeKo8wxsBxtLSzuG0nZQ/jLFrGvL0aU1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
Subject: [PATCH 6.13 157/274] PCI: Avoid FLR for Mediatek MT7922 WiFi
Date: Wed, 19 Feb 2025 09:26:51 +0100
Message-ID: <20250219082615.738407330@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 81f64e925c29fe6e99f04b131fac1935ac931e81 upstream.

The Mediatek MT7922 WiFi device advertises FLR support, but it apparently
does not work, and all subsequent config reads return ~0:

  pci 0000:01:00.0: [14c3:0616] type 00 class 0x028000 PCIe Endpoint
  pciback 0000:01:00.0: not ready 65535ms after FLR; giving up

After an FLR, pci_dev_wait() waits for the device to become ready.  Prior
to d591f6804e7e ("PCI: Wait for device readiness with Configuration RRS"),
it polls PCI_COMMAND until it is something other that PCI_POSSIBLE_ERROR
(~0).  If it times out, pci_dev_wait() returns -ENOTTY and
__pci_reset_function_locked() tries the next available reset method.
Typically this is Secondary Bus Reset, which does work, so the MT7922 is
eventually usable.

After d591f6804e7e, if Configuration Request Retry Status Software
Visibility (RRS SV) is enabled, pci_dev_wait() polls PCI_VENDOR_ID until it
is something other than the special 0x0001 Vendor ID that indicates a
completion with RRS status.

When RRS SV is enabled, reads of PCI_VENDOR_ID should return either 0x0001,
i.e., the config read was completed with RRS, or a valid Vendor ID.  On the
MT7922, it seems that all config reads after FLR return ~0 indefinitely.
When pci_dev_wait() reads PCI_VENDOR_ID and gets 0xffff, it assumes that's
a valid Vendor ID and the device is now ready, so it returns with success.

After pci_dev_wait() returns success, we restore config space and continue.
Since the MT7922 is not actually ready after the FLR, the restore fails and
the device is unusable.

We considered changing pci_dev_wait() to continue polling if a
PCI_VENDOR_ID read returns either 0x0001 or 0xffff.  This "works" as it did
before d591f6804e7e, although we have to wait for the timeout and then fall
back to SBR.  But it doesn't work for SR-IOV VFs, which *always* return
0xffff as the Vendor ID.

Mark Mediatek MT7922 WiFi devices to avoid the use of FLR completely.  This
will cause fallback to another reset method, such as SBR.

Link: https://lore.kernel.org/r/20250212193516.88741-1-helgaas@kernel.org
Fixes: d591f6804e7e ("PCI: Wait for device readiness with Configuration RRS")
Link: https://github.com/QubesOS/qubes-issues/issues/9689#issuecomment-2582927149
Link: https://lore.kernel.org/r/Z4pHll_6GX7OUBzQ@mail-itl
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5521,7 +5521,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
  * AMD Matisse USB 3.0 Host Controller 0x149c
  * Intel 82579LM Gigabit Ethernet Controller 0x1502
  * Intel 82579V Gigabit Ethernet Controller 0x1503
- *
+ * Mediatek MT7922 802.11ax PCI Express Wireless Network Adapter
  */
 static void quirk_no_flr(struct pci_dev *dev)
 {
@@ -5533,6 +5533,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AM
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_MEDIATEK, 0x0616, quirk_no_flr);
 
 /* FLR may cause the SolidRun SNET DPU (rev 0x1) to hang */
 static void quirk_no_flr_snet(struct pci_dev *dev)


