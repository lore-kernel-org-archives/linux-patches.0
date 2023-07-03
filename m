Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73241094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30125C433C8;
	Mon,  3 Jul 2023 18:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410606;
	bh=58xNShnEmeXlr7RqfyQbiJrXkOizX1IlJsPO9Mt87mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRe7l4/nn+Ns+U+drf8NIoVHlNGCAm27v8+zFhdXEGgvabakfKvYVy9AoletzOuh7
	 9Z2aPTWXy0JiSAIR/rkMg+7+be7XqzPw8pmqIp/e+TI4vtdInN0L3YLVSBsmO51PRy
	 ennX+3WmcR+C5t70aIKs1uNJFYADjhdAdDekmhLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 04/11] PCI/ACPI: Validate acpi_pci_set_power_state() parameter
Date: Mon,  3 Jul 2023 20:54:23 +0200
Message-ID: <20230703184519.245172509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.121965745@linuxfoundation.org>
References: <20230703184519.121965745@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

commit 5557b62634abbd55bab7b154ce4bca348ad7f96f upstream.

Previously acpi_pci_set_power_state() assumed the requested power state was
valid (PCI_D0 ... PCI_D3cold).  If a caller supplied something else, we
could index outside the state_conv[] array and pass junk to
acpi_device_set_power().

Validate the pci_power_t parameter and return -EINVAL if it's invalid.

Link: https://lore.kernel.org/r/20230621222857.GA122930@bhelgaas
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-acpi.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 052a611081ec..bf545f719182 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -1053,32 +1053,37 @@ int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		[PCI_D3hot] = ACPI_STATE_D3_HOT,
 		[PCI_D3cold] = ACPI_STATE_D3_COLD,
 	};
-	int error = -EINVAL;
+	int error;
 
 	/* If the ACPI device has _EJ0, ignore the device */
 	if (!adev || acpi_has_method(adev->handle, "_EJ0"))
 		return -ENODEV;
 
 	switch (state) {
-	case PCI_D3cold:
-		if (dev_pm_qos_flags(&dev->dev, PM_QOS_FLAG_NO_POWER_OFF) ==
-				PM_QOS_FLAGS_ALL) {
-			error = -EBUSY;
-			break;
-		}
-		fallthrough;
 	case PCI_D0:
 	case PCI_D1:
 	case PCI_D2:
 	case PCI_D3hot:
-		error = acpi_device_set_power(adev, state_conv[state]);
+	case PCI_D3cold:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (state == PCI_D3cold) {
+		if (dev_pm_qos_flags(&dev->dev, PM_QOS_FLAG_NO_POWER_OFF) ==
+				PM_QOS_FLAGS_ALL)
+			return -EBUSY;
 	}
 
-	if (!error)
-		pci_dbg(dev, "power state changed by ACPI to %s\n",
-		        acpi_power_state_string(adev->power.state));
+	error = acpi_device_set_power(adev, state_conv[state]);
+	if (error)
+		return error;
+
+	pci_dbg(dev, "power state changed by ACPI to %s\n",
+	        acpi_power_state_string(adev->power.state));
 
-	return error;
+	return 0;
 }
 
 pci_power_t acpi_pci_get_power_state(struct pci_dev *dev)
-- 
2.41.0



