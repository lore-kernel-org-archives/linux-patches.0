Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF201EBFED;
	Tue, 15 Oct 2024 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994311; cv=none; b=XCkUNBHl3k4bE0SETjTVVhgSMt3kAgmC3ER51LGRUizxQxe/ePPAc2pSzP/cG9kQKIRr6zg/i/3/U3Gqj13oUHbEu3i/o5Bl/M69td4ToNmfAx6EMk1gufiVAyZfE6oQIjBPcvCGxGjRsonDP/S6j3Lu2rf2FHJHRPy3+6cmQz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994311; c=relaxed/simple;
	bh=OFvfC9am2XCZmHTAkX9BEnU/5/aWeICjKMgU0KNtNOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd9X0HfyJNOK0+H38dd7+95HP2uTNa8JD43uZOCbxZjrKX16hiqarwDtUJNy77Z7xAZ1S8dKfMM9Jt4mIpqgHQSPgvv1mQATbwlbZgvbdUI9/MUcNeGDzV4MbTQtpvKPTaqAsv+ei0xcqgBHqvzJ5PGP8ogg+O5nJdiN6p7aulQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrGt0HWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrGt0HWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D459C4CEC6;
	Tue, 15 Oct 2024 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994311;
	bh=OFvfC9am2XCZmHTAkX9BEnU/5/aWeICjKMgU0KNtNOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrGt0HWM0ZElYYUjPRPJz3C/oSyfPtZ7eXDY28wOgz5GYWBEOEBWGD4Sm2wbIu3WV
	 dX5wNJKsoADyTaiWTrE9zC3x/21bb2LWJmiYxX17Eg6ouWd0QQspN6x+1joI9FBnu5
	 TIoYnuF1aYfWJspNqWmVuzazmThxnsnfRcvGUA8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Alberto Reguero <jose.alberto.reguero@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 669/691] usb: xhci: Fix problem with xhci resume from suspend
Date: Tue, 15 Oct 2024 13:30:17 +0200
Message-ID: <20241015112506.875980945@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 #define PCI_DEVICE_ID_CADENCE				0x17CD
@@ -331,6 +332,10 @@ static void xhci_pci_quirks(struct devic
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_ASMEDIA_MODIFY_FLOWCONTROL;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+	    pdev->device == PCI_DEVICE_ID_ASMEDIA_3042_XHCI)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_TI && pdev->device == 0x8241)
 		xhci->quirks |= XHCI_LIMIT_ENDPOINT_INTERVAL_7;
 


