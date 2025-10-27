Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5D7328B62;
	Mon, 27 Oct 2025 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591759; cv=none; b=t8AEG/mfWii8h0uPNyl94UFr45z2XyXVL1g2I+7e6rAfeot65CHiom17F6+nTI6gkBQYP5OEGItDHjclglDKDeNuLqYsaOrUPkxOaE+6bHN0cAzMUml+tRIxKw7COquH0p4inXyRS4nn/GK369raUYBSe1c9iHRzWiA0kxEkYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591759; c=relaxed/simple;
	bh=YTe3DgW/gnqG0xVNFO+BENWG/JK02ydyUOEqLA8PXiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpzDktN4FF+Ijx6TJLpq67rQTs7PL8FUlmoA/hY7XSegbSogIPb/skb8JN8ujtfxrguihaV5gW4NnfcwKqRIahbazX3f1DE54wCL1MaT9tPOQ8XNXxC1TnxNzDLb/f0PGi6PlR2M1g0j51gNNXi9PJaV7gMXrPGMjjRb8S+tdiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m102FCj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m102FCj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2723C4CEF1;
	Mon, 27 Oct 2025 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591759;
	bh=YTe3DgW/gnqG0xVNFO+BENWG/JK02ydyUOEqLA8PXiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m102FCj0CRThVODS4o7nH+pegh2PjjzrDOilTQ+HldAfgrATUwOR0T2t3Q5hf/Umy
	 Aq2yBRFDU4boBaOJ/pAW3N8NsZxmSGz5ar11eSNLK2vzepIaqtay4jtGU3BnPxEbEO
	 wtZ0J4uKZnMocnLLo8Spk8g52beQnRcrx5L1bmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/332] PCI: Add sysfs attribute for device power state
Date: Mon, 27 Oct 2025 19:36:13 +0100
Message-ID: <20251027183533.312071326@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 80a129afb75cba8434fc5071bd6919172442315c ]

While PCI power states D0-D3hot can be queried from user-space via lspci,
D3cold cannot.  lspci cannot provide an accurate value when the device is
in D3cold as it has to restore the device to D0 before it can access its
power state via the configuration space, leading to it reporting D0 or
another on-state. Thus lspci cannot be used to diagnose power consumption
issues for devices that can enter D3cold or to ensure that devices properly
enter D3cold at all.

Add a new sysfs device attribute for the PCI power state, showing the
current power state as seen by the kernel.

[bhelgaas: drop READ_ONCE(), see discussion at the link]
Link: https://lore.kernel.org/r/20201102141520.831630-1-luzmaximilian@gmail.com
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 48991e493507 ("PCI/sysfs: Ensure devices are powered for config reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-bus-pci |    9 +++++++++
 drivers/pci/pci-sysfs.c                 |   10 ++++++++++
 2 files changed, 19 insertions(+)

--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -377,3 +377,12 @@ Contact:	Heiner Kallweit <hkallweit1@gma
 Description:	If ASPM is supported for an endpoint, these files can be
 		used to disable or enable the individual power management
 		states. Write y/1/on to enable, n/0/off to disable.
+
+What:		/sys/bus/pci/devices/.../power_state
+Date:		November 2020
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		This file contains the current PCI power state of the device.
+		The value comes from the PCI kernel device state and can be one
+		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
+		The file is read only.
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -124,6 +124,15 @@ static ssize_t cpulistaffinity_show(stru
 }
 static DEVICE_ATTR_RO(cpulistaffinity);
 
+static ssize_t power_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%s\n", pci_power_name(pdev->current_state));
+}
+static DEVICE_ATTR_RO(power_state);
+
 /* show resources */
 static ssize_t resource_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
@@ -603,6 +612,7 @@ static ssize_t driver_override_show(stru
 static DEVICE_ATTR_RW(driver_override);
 
 static struct attribute *pci_dev_attrs[] = {
+	&dev_attr_power_state.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,


