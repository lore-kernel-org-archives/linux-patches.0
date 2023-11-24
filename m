Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3CD39FC3;
	Fri, 24 Nov 2023 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vdD2TxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD19C433C8;
	Fri, 24 Nov 2023 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850025;
	bh=tlpC8D7pfzobnbe9b4jRCtYJvMFv76TddVO2agJwz7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vdD2TxJsB6jloC8P5xFZ5BIAq0NV+IqfAl7hc5rilxdf8/3AfUMtn91peDrl+WJw
	 3wPX3f3yAN5lzHvXSE9rtYxwdU9cJZYlF3riT1jO7F6FPqjtVLtGx1gspGnqXoEUpA
	 oZSzCSDIb4NfoNOEWsusE5RWbFWptXs7Cf984ODg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 6.6 416/530] xhci: Enable RPM on controllers that support low-power states
Date: Fri, 24 Nov 2023 17:49:42 +0000
Message-ID: <20231124172040.729708738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit a5d6264b638efeca35eff72177fd28d149e0764b upstream.

Use the low-power states of the underlying platform to enable runtime PM.
If the platform doesn't support runtime D3, then enabling default RPM will
result in the controller malfunctioning, as in the case of hotplug devices
not being detected because of a failed interrupt generation.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-16-mathias.nyman@linux.intel.com
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -695,7 +695,9 @@ static int xhci_pci_probe(struct pci_dev
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
 
-	if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
+	if (pci_choose_state(dev, PMSG_SUSPEND) == PCI_D0)
+		pm_runtime_forbid(&dev->dev);
+	else if (xhci->quirks & XHCI_DEFAULT_PM_RUNTIME_ALLOW)
 		pm_runtime_allow(&dev->dev);
 
 	dma_set_max_seg_size(&dev->dev, UINT_MAX);


