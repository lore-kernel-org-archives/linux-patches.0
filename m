Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B801DFE27;
	Wed,  6 Nov 2024 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898874; cv=none; b=uCD6OqyclJhO4oi3bmmVQPBtsD0xVrZUnuHNn1F4oNgQLeb6F2x8hBvUFyaJX5lfpCCrYz4Ha7hDMIqGOTvLwWd+zxt6TJayt/zo2K7XWiHsxRP7LEpK0hifpZaUeKXJ7bYRk16uw5yvvVLNvNXUPP88Bk7LtRUWJE8TKzjbGMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898874; c=relaxed/simple;
	bh=m5KTVjS0FilRVKwYPKEazNcM9YiixsgD3k040ckqyA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb4Iu46bZdqoqPHcYgcBHZFj79fyGkGEsDNU0LmHY8DS9cWTb0qSJTX4zZmF/aoDNE2npSqom5qwno3nrQ2mFkIZy31owVcmxWPosM7IbNLuDYe69/3ENq2jTnSoBEVObfx5t1OS1c3UIpHsgxo1yAxfQ/4zuYPONv20I9GRk+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjVnDB/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjVnDB/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C9AC4CECD;
	Wed,  6 Nov 2024 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898873;
	bh=m5KTVjS0FilRVKwYPKEazNcM9YiixsgD3k040ckqyA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjVnDB/YyY1Pag0MCxilFCM7RdTG7hHR+FpvbcTMTt3S1oBJ93iEA8VoNf+SqTU6m
	 CeDcAL1RS7m5YcYfsCPVQTkmM+kT+fKYiEJbXMUh26oyVAL7/cBjF9DzO8aHOTuu/w
	 kQ3vdspCXH7dSXGEvf2JPkub0RD8c41C3OjLA6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Alberto Reguero <jose.alberto.reguero@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 347/462] usb: xhci: Fix problem with xhci resume from suspend
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120340.096318235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>

commit d44238d8254a36249d576c96473269dbe500f5e4 upstream.

I have a ASUS PN51 S mini pc that has two xhci devices. One from AMD,
and other from ASMEDIA. The one from ASMEDIA have problems when resume
from suspend, and keep broken until unplug the  power cord. I use this
kernel parameter: xhci-hcd.quirks=128 and then it works ok. I make a
path to reset only the ASMEDIA xhci.

Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240919184202.22249-1-jose.alberto.reguero@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -73,6 +73,7 @@
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
+#define PCI_DEVICE_ID_ASMEDIA_3042_XHCI			0x3042
 #define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
 static const char hcd_name[] = "xhci_hcd";
@@ -305,6 +306,10 @@ static void xhci_pci_quirks(struct devic
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_ASMEDIA_MODIFY_FLOWCONTROL;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+	    pdev->device == PCI_DEVICE_ID_ASMEDIA_3042_XHCI)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_TI && pdev->device == 0x8241)
 		xhci->quirks |= XHCI_LIMIT_ENDPOINT_INTERVAL_7;
 


