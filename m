Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB2E1B2183;
	Tue, 15 Oct 2024 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998558; cv=none; b=D87q4QgxjjGCNlCuIrkcgR5wZ4Zl+Xjxig0nIIIgOcxPPLGjugujdECKDBo/4CA4AVq7N0Flpy/toAZImrHjiUJrXThVLLLrdGzk/7AC+RVqAQNWKr94KVvI4VgHGS2S4DTuHjRLRU9QtugaHGsehLKHgck3Y6XZJq9EyAlQj5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998558; c=relaxed/simple;
	bh=O+TLqMM9zMARr9o4FNIMi7tR3YGIV+ZrBxRkdmAkqaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIPWpBc23gK1RKjwvsceIf9uqPVNSbvXkkrrVsLpoLNW7ngdxL+Y5xq9iyM5H80Ryrh9RGy2UiuUxyBXAYkt68RO4/vvtErIK6jqKSC6AxdE++UEzbWq3xPxmInJR7WgLfMJNErAeIx4DISMSnI/rJEnKsjzGSUGs7L3mjr6v2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXzff56x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXzff56x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A347C4CEC6;
	Tue, 15 Oct 2024 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998558;
	bh=O+TLqMM9zMARr9o4FNIMi7tR3YGIV+ZrBxRkdmAkqaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXzff56xu+K4d9vkglMSi+Eo14pn+iQnlf7Aoqe5shId1Xy6KPHtqZfrOXXCcmxm4
	 JnI1Ei03pHJtmReyaLU/yQnYupkhXCHVV8IbaiGrVKnynYwTBVDPZFn+kGiWJSxx/B
	 w1IpjPquArZWZ5om5Mfo9/SWQcHr9taUl/kb38Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Alberto Reguero <jose.alberto.reguero@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 505/518] usb: xhci: Fix problem with xhci resume from suspend
Date: Tue, 15 Oct 2024 14:46:49 +0200
Message-ID: <20241015123936.482453057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,6 +71,7 @@
 #define PCI_DEVICE_ID_ASMEDIA_1042A_XHCI		0x1142
 #define PCI_DEVICE_ID_ASMEDIA_1142_XHCI			0x1242
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
+#define PCI_DEVICE_ID_ASMEDIA_3042_XHCI			0x3042
 #define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
 static const char hcd_name[] = "xhci_hcd";
@@ -324,6 +325,10 @@ static void xhci_pci_quirks(struct devic
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI)
 		xhci->quirks |= XHCI_ASMEDIA_MODIFY_FLOWCONTROL;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+	    pdev->device == PCI_DEVICE_ID_ASMEDIA_3042_XHCI)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+
 	if (pdev->vendor == PCI_VENDOR_ID_TI && pdev->device == 0x8241)
 		xhci->quirks |= XHCI_LIMIT_ENDPOINT_INTERVAL_7;
 


