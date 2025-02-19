Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21A01DE3BB;
	Wed, 19 Feb 2025 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955046; cv=none; b=A7HlZ5I+pOB5IgTI69fBoMI/TGc5xYTQ+brp7XdvZqiAg73kh37qavufZ7FHnNoSs9yTJG0YDCs/T+ZJ0vBs1mIrDLZ9uUvEmfxwbICnQMxERklhzRAk//E2cHGWYc03IBb+UuZ5A46x6dRwB8lZhsizsS8kpJrd0GHBuvNYH6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955046; c=relaxed/simple;
	bh=QMAQqeVzfXgk1SGkyKnKAEjm46pGI1QkalfbO7yX8z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jep/j8alxJYeAKifdH9RCb+BQOPry1/xRjO1Oh6pN1Aks6QkjMGgto/WMq5aXUeUp8iev9HqwWhDFhaiHFyhbLL4L+k5K1vIt1yy/JyIdzVRF8kJfU8k6SX/iIR+7CuQP3cmNxshu5x8yCQbiqYCmHU+AhNRdw6lTnBw+aDRet0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsAwjarr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsAwjarr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA5C4CEE6;
	Wed, 19 Feb 2025 08:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955046;
	bh=QMAQqeVzfXgk1SGkyKnKAEjm46pGI1QkalfbO7yX8z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsAwjarrWQ6EmGG8QDRJBvFBEGZAS0D4hJal+hD4esPgC40BXPMwtYDqyIG/u1Kcy
	 cMpKDfPTV/O0Af11CoJlhCRkSYyLj2Fa5APj2cq1fdyFog7Fs1RPYTOgqiyml1vi6J
	 xcGktUFoqVFvkT5WbL7daZwDUIHvUfs/ZLNPkckQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>
Subject: [PATCH 6.12 114/230] usb: xhci: Restore xhci_pci support for Renesas HCs
Date: Wed, 19 Feb 2025 09:27:11 +0100
Message-ID: <20250219082606.148082092@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -656,8 +656,8 @@ put_runtime_pm:
 }
 EXPORT_SYMBOL_NS_GPL(xhci_pci_common_probe, xhci);
 
-static const struct pci_device_id pci_ids_reject[] = {
-	/* handled by xhci-pci-renesas */
+/* handled by xhci-pci-renesas if enabled */
+static const struct pci_device_id pci_ids_renesas[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, 0x0014) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, 0x0015) },
 	{ /* end: all zeroes */ }
@@ -665,7 +665,8 @@ static const struct pci_device_id pci_id
 
 static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	if (pci_match_id(pci_ids_reject, dev))
+	if (IS_ENABLED(CONFIG_USB_XHCI_PCI_RENESAS) &&
+			pci_match_id(pci_ids_renesas, dev))
 		return -ENODEV;
 
 	return xhci_pci_common_probe(dev, id);


