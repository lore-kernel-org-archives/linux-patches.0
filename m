Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F61798C;
	Mon, 14 Oct 2024 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916479; cv=none; b=bxEDFiqhc69w8yN3hUno4l+9c2SbW8KFYwNMKdbe4UXRdsK7fTmYIvMNTx4AWEUNNCl5YlNV/EljcZj3E3Q8Bpw4S1JKhdCpgAw8s+lqISzVdEXMitp/9o/tyoDyQJYmQsJtYLRv0GAQa9kqFr/dS9vTX5AatSFDIGy6TiF7Auw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916479; c=relaxed/simple;
	bh=WdflzNwmjTcV+HKXj5h9sFIHuvgdzmf5j2y3RmmUlZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlYj24lkkdmYgN98iatim2b2w0TIYwcdJLrMaT+LFGAX5SIXZWoyg3DXytVlBDQsUrHiPBDHAcVro5gxAVKF9a+xQ/wc/DiUK1jeI7atKhL91skCYZgofezKyGRTXGSH1zEALsfGeiArP4lP6tAS8ctMDxXZFYr6Rww20mOyXp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpZofUwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpZofUwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD96C4CEC3;
	Mon, 14 Oct 2024 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916478;
	bh=WdflzNwmjTcV+HKXj5h9sFIHuvgdzmf5j2y3RmmUlZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpZofUwCeRdJ9hVR+nAgdgcVLCHAwYFZ9wXBPVitH6DLPWNeZyrwI9O0fpk2GG1ok
	 R3ZhQ0I7uURk4y2h3umh768iflT3tCWK/HQ/ExTKllHHqAuk+hkD1o0MByWvk6LoX1
	 By4zHJioxdqKtobPPB9QaVJHCrF/gSkFpcouBX5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Alberto Reguero <jose.alberto.reguero@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.11 164/214] usb: xhci: Fix problem with xhci resume from suspend
Date: Mon, 14 Oct 2024 16:20:27 +0200
Message-ID: <20241014141051.383561443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,6 +79,7 @@
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
+#define PCI_DEVICE_ID_ASMEDIA_3042_XHCI			0x3042
 #define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
 #define PCI_DEVICE_ID_CADENCE				0x17CD
@@ -457,6 +458,10 @@ static void xhci_pci_quirks(struct devic
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_ASMEDIA_MODIFY_FLOWCONTROL;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+	    pdev->device == PCI_DEVICE_ID_ASMEDIA_3042_XHCI)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_TI && pdev->device == 0x8241)
 		xhci->quirks |= XHCI_LIMIT_ENDPOINT_INTERVAL_7;
 


