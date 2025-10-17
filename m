Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5164336EED;
	Fri, 17 Oct 2025 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715655; cv=none; b=dbCnFK3PGiZbabMIqnsmF2MpWedNCsyaFyzFXH/QYN8AXOH7iRp7i130Bqt+AkoOlWMhtANoDesPwROdIbUc/aO7ylfa5uFR+bzR3gRUIHsOwt15ElykCzVV+CgfUme8BVwuhZDOilQX4qIQ3Pzg3QZl+fSQPl41F5DHZrLhZok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715655; c=relaxed/simple;
	bh=7E5lc2AF/30sGbCExlSkNJEU892Fs8dupgVfKHUOemY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnYGyGfmj7ufstGKtbH5XuXAj2MzEvgB8u8dcdDKNltUcX+QZZt1mKYXklQzZDwq/xdFXAhTKGdrrrx4G06dPB7VQTtVXUuEyTm+D9oleI9Kwh+62P7+lmW7in2qrOMwbp7xcViT501Mr7CjvEhlifSHbkIVTTEAgrIGuEwUfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOy70Hj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOy70Hj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2EDC4CEE7;
	Fri, 17 Oct 2025 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715654;
	bh=7E5lc2AF/30sGbCExlSkNJEU892Fs8dupgVfKHUOemY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOy70Hj9tVlUGUZBfqUF/O+nSvam88MiWXg3GHCwTXv4O0xMskBxrgVGqyRahC0LA
	 aJY4YgteidHEXQmy/pcrXL0UbYskxvu/ulvLHK+80RrOx6lkoF2Inu5pybPRPS4FGv
	 XgrwOCc++xcVmtem0K9RA3q77NRkSMqCBysy6FAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.17 291/371] PCI/pwrctrl: Fix device leak at registration
Date: Fri, 17 Oct 2025 16:54:26 +0200
Message-ID: <20251017145212.598980728@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 39f9be6aba3ae4d6fdd4b8554f1184d054d7a713 upstream.

Make sure to drop the reference to the pwrctrl device taken by
of_find_device_by_node() when registering a PCI device.

Fixes: b458ff7e8176 ("PCI/pwrctl: Ensure that pwrctl drivers are probed before PCI client drivers")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org	# v6.13
Link: https://patch.msgid.link/20250721153609.8611-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/bus.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -361,11 +361,15 @@ void pci_bus_add_device(struct pci_dev *
 	 * before PCI client drivers.
 	 */
 	pdev = of_find_device_by_node(dn);
-	if (pdev && of_pci_supply_present(dn)) {
-		if (!device_link_add(&dev->dev, &pdev->dev,
-				     DL_FLAG_AUTOREMOVE_CONSUMER))
-			pci_err(dev, "failed to add device link to power control device %s\n",
-				pdev->name);
+	if (pdev) {
+		if (of_pci_supply_present(dn)) {
+			if (!device_link_add(&dev->dev, &pdev->dev,
+					     DL_FLAG_AUTOREMOVE_CONSUMER)) {
+				pci_err(dev, "failed to add device link to power control device %s\n",
+					pdev->name);
+			}
+		}
+		put_device(&pdev->dev);
 	}
 
 	if (!dn || of_device_is_available(dn))


