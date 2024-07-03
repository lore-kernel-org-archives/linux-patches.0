Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B317E459;
	Wed,  3 Jul 2024 10:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003388; cv=none; b=LUvu8xXgJfoW0UDYpnt6i3DGqHzOMvQ6LDApmQNsiVgtf6JsWLQmIRpYVkIPjqHrCgEFP065P1cXB0Q1uaTir/4VIlwJ+mqibONsD/VF/xPE1D7QloqC48cRGwZdlhzKG2Hzbao6utbwv5qQV1iq/Cpejg3fX4y08IraYEwkUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003388; c=relaxed/simple;
	bh=aTIy21kyL7jucKvr84juf8W1gOSaatwMJYmbMMXcKQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqvgP1GF2bOYkXLdA4WPqcd5d7DZIM6WaDwKwX/1zLyVHcFGpadt8RVBHJAS5xkhwbm2VZaCsueNSO8MCgEYVwrZT695kN/7d8SnUzaHVrjIfz9MuJlb45BzjqjfWFLEm84Gj3JH0/+DlcSAVwZ0UXO/Tff5BbAgmzOHCznxg8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAKb+AGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAKb+AGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D68AC2BD10;
	Wed,  3 Jul 2024 10:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003388;
	bh=aTIy21kyL7jucKvr84juf8W1gOSaatwMJYmbMMXcKQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAKb+AGp5AxVKxx67hWyJ1HjO2z7UEtuhvnjqwnpBRPSSHoDJF5t/82ZUTlQEjZPi
	 O/ftOLVj9C+YcMKZjb8GxgHdUyoEra2JZFmn4c5/Q+nmugFHM6T/KxAzcIz3hVGLfD
	 T6WvaCmDeT4WSrI4PRgnWjDnRBbyMpCCv4ZjmfUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 033/139] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:38:50 +0200
Message-ID: <20240703102831.692482155@linuxfoundation.org>
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

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 91f7a1524a92c70ffe264db8bdfa075f15bbbeb9 upstream.

As described in commit 8f873c1ff4ca ("xhci: Blacklist using streams on the
Etron EJ168 controller"), EJ188 have the same issue as EJ168, where Streams
do not work reliable on EJ188. So apply XHCI_BROKEN_STREAMS quirk to EJ188
as well.

Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240611120610.3264502-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -225,8 +225,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ188)
+			pdev->device == PCI_DEVICE_ID_EJ188) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 	    pdev->device == 0x0014) {


