Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39FE1A314B;
	Wed, 19 Feb 2025 08:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954222; cv=none; b=cRmZ7rKs+Wl9LZjEMVc6PLB8ZfW7Vghyf3G0ata+zxMve72ZZ+F7gWYtsd4ENsa68TNryCr36GcbD+gPt5T0WxSthw1ktJvbf3qXVpX9nCCncs+yJjrjU+LOONS5K6ERRC2PRHSX0nE2515ciS/xmqpfr1OndV0hPLZr4FYlCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954222; c=relaxed/simple;
	bh=17B6ScSwk8OgVQTUCsuKPlDF86Mwm29kB7kh48v3+rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHtle/CmA4/rUEHd/jG21RMdSKL9D5Orlc0z0PuNsLPD/YslamGSAl7J+6F3MIZfbwqVPHGupigmRrn7j8hsY/V7H4z7+QPO71WfaivK8Aw7lourM6LMKIvwKCF6WpsjJnAnC09bmp6qkA7DVrRuuQznrl70WcaIqwgt14L/Wl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaRwzwKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaRwzwKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93ACC4CED1;
	Wed, 19 Feb 2025 08:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954222;
	bh=17B6ScSwk8OgVQTUCsuKPlDF86Mwm29kB7kh48v3+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaRwzwKvX4aX1f9rjJ65VoxHU40/1dBn3R72T5OTh2pltnvUuPuIJv5xmAFky8ai4
	 ZyNF6LTr8muyzeufL33GEQPxQ6eB9OhplQrkP9l4J83UJNhUx0aSz/Ahva2wlrSfu6
	 qa6A6KEe4lkDrNI6eohq0RFVsnMTsfFWsOS1L+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>
Subject: [PATCH 6.13 134/274] usb: xhci: Restore xhci_pci support for Renesas HCs
Date: Wed, 19 Feb 2025 09:26:28 +0100
Message-ID: <20250219082614.852720113@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit c81d9fcd5b9402166048f377d4e5e0ee6f9ef26d upstream.

Some Renesas HCs require firmware upload to work, this is handled by the
xhci_pci_renesas driver. Other variants of those chips load firmware from
a SPI flash and are ready to work with xhci_pci alone.

A refactor merged in v6.12 broke the latter configuration so that users
are finding their hardware ignored by the normal driver and are forced to
enable the firmware loader which isn't really necessary on their systems.

Let xhci_pci work with those chips as before when the firmware loader is
disabled by kernel configuration.

Fixes: 25f51b76f90f ("xhci-pci: Make xhci-pci-renesas a proper modular driver")
Cc: stable <stable@kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219616
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219726
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://lore.kernel.org/r/20250128104529.58a79bfc@foxbook
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -653,8 +653,8 @@ put_runtime_pm:
 }
 EXPORT_SYMBOL_NS_GPL(xhci_pci_common_probe, "xhci");
 
-static const struct pci_device_id pci_ids_reject[] = {
-	/* handled by xhci-pci-renesas */
+/* handled by xhci-pci-renesas if enabled */
+static const struct pci_device_id pci_ids_renesas[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, 0x0014) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, 0x0015) },
 	{ /* end: all zeroes */ }
@@ -662,7 +662,8 @@ static const struct pci_device_id pci_id
 
 static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	if (pci_match_id(pci_ids_reject, dev))
+	if (IS_ENABLED(CONFIG_USB_XHCI_PCI_RENESAS) &&
+			pci_match_id(pci_ids_renesas, dev))
 		return -ENODEV;
 
 	return xhci_pci_common_probe(dev, id);


