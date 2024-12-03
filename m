Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD5B1E3DED;
	Tue,  3 Dec 2024 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239617; cv=none; b=o3ryfrvpcPW1AKQd+qtlGO3hChW0w/0/WnFBRcw5ZykMdsT7uQx7dIzosojUkeZgLkEKFkhMT5ALfh8KskzBnq2MERyASWQ/oXEPP//LOnUVtSJVz0HSYZjKs74u7AAI0qg1r2fCWnkM0lSjersNTJIF3eLYJKysS7WYyec2NOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239617; c=relaxed/simple;
	bh=Gt0K0m38e7Rguw3T9siMpUBjGFVhuuxKVWKUKiX9nNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/CuBfIMt17wNCLlkpgAEDZZqVQ0qpSDzZwhyXCwok17O0qq2lfRvW0QquFxsVKpm4c3OLGnYw9gFA6vOAbpqpiCfmOmipeK8Oy9VedXWHzY4AT+jIt6584KtDYI6RhXPGCp8O/xOyjgMQgK5hLYrQUJlQp3nZij1N7m/jxHPhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcCh9rmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcCh9rmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24060C4CECF;
	Tue,  3 Dec 2024 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239617;
	bh=Gt0K0m38e7Rguw3T9siMpUBjGFVhuuxKVWKUKiX9nNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcCh9rmGZ3bFKjGKvR2aZa5MDiFX61h21fvcl5Ic1sjlfsOuAPBWpGzY/qaYTxaeC
	 3IgNWP0YaJyNIte71O/CpvZtuyardJx8w2G9yUvnPWLHGoHz+hAArO9stG7JIzq+h0
	 WU4DFzkihZNOJFW98MEzzW9qMncWLAO2Wl+s44Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.11 674/817] xhci: Combine two if statements for Etron xHCI host
Date: Tue,  3 Dec 2024 15:44:06 +0100
Message-ID: <20241203144022.266481304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit d7b11fe5790203fcc0db182249d7bfd945e44ccb upstream.

Combine two if statements, because these hosts have the same
quirk flags applied.

[Mathias: has stable tag because other fixes in series depend on this]

Fixes: 91f7a1524a92 ("xhci: Apply broken streams quirk to Etron EJ188 xHCI host")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-18-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -401,12 +401,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ168) {
-		xhci->quirks |= XHCI_RESET_ON_RESUME;
-		xhci->quirks |= XHCI_BROKEN_STREAMS;
-	}
-	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ188) {
+	    (pdev->device == PCI_DEVICE_ID_EJ168 ||
+	     pdev->device == PCI_DEVICE_ID_EJ188)) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}


