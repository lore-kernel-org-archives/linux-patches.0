Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED71332916;
	Fri, 17 Oct 2025 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713277; cv=none; b=esyE0Rhx6obVnNf74h4QTR3KRxVTGD7j5FkSljRK96MQ7AfR63LTGA/h4eCbb87ipx+fEnwtvR6xUNdZ5yC2f9uw5yIK/y7+H+49f/Dm+b7ZBy6p0Irv/SGldNBcxYnopRfK52zU7YKPTo72x4fRvfhiAM9scqoxH0NjexObDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713277; c=relaxed/simple;
	bh=TfFagqtiJjsm9+utOFMvr//WG17yUAKDg0LdDclKx3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aslmhvpIqePC2Qdsldg1gU7VhGEtOUYz3unjw+EI7AOszvTgKnVCoZkKfzm19zXN6veB+iSrIwZBZlBEM7ppJTtlB49A9+CZgf/3Yr+CZKabkh5YZ96OZ2r2xf7Cupt4bAGTsm9TOq8JNX7bTzkgXqcRXmvCwqS7aijLy+1EcO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rmmw9K77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rmmw9K77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033BAC4CEF9;
	Fri, 17 Oct 2025 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713277;
	bh=TfFagqtiJjsm9+utOFMvr//WG17yUAKDg0LdDclKx3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rmmw9K77/h/iGApyBYKm43thMedS6WbDY/j2GdHlRgpDx5jVCSRUttKtExlIJ4YiX
	 RB91qnnfZaUdt+DXdLSuBYaYUQ9W+zU+X9o0j3AVvlozlNfxvJ9rQxx2UsPPFCLHZT
	 UA6FxPVS2qZ7CJEAzmr/KgaOp21UEsSdMkVK5ljU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 109/168] PCI/sysfs: Ensure devices are powered for config reads
Date: Fri, 17 Oct 2025 16:53:08 +0200
Message-ID: <20251017145133.040559807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@google.com>

commit 48991e4935078b05f80616c75d1ee2ea3ae18e58 upstream.

The "max_link_width", "current_link_speed", "current_link_width",
"secondary_bus_number", and "subordinate_bus_number" sysfs files all access
config registers, but they don't check the runtime PM state. If the device
is in D3cold or a parent bridge is suspended, we may see -EINVAL, bogus
values, or worse, depending on implementation details.

Wrap these access in pci_config_pm_runtime_{get,put}() like most of the
rest of the similar sysfs attributes.

Notably, "max_link_speed" does not access config registers; it returns a
cached value since d2bd39c0456b ("PCI: Store all PCIe Supported Link
Speeds").

Fixes: 56c1af4606f0 ("PCI: Add sysfs max_link_speed/width, current_link_speed/width, etc")
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250924095711.v2.1.Ibb5b6ca1e2c059e04ec53140cd98a44f2684c668@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -196,8 +196,14 @@ static ssize_t max_link_width_show(struc
 				   struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	ssize_t ret;
 
-	return sysfs_emit(buf, "%u\n", pcie_get_width_cap(pdev));
+	/* We read PCI_EXP_LNKCAP, so we need the device to be accessible. */
+	pci_config_pm_runtime_get(pdev);
+	ret = sysfs_emit(buf, "%u\n", pcie_get_width_cap(pdev));
+	pci_config_pm_runtime_put(pdev);
+
+	return ret;
 }
 static DEVICE_ATTR_RO(max_link_width);
 
@@ -209,7 +215,10 @@ static ssize_t current_link_speed_show(s
 	int err;
 	enum pci_bus_speed speed;
 
+	pci_config_pm_runtime_get(pci_dev);
 	err = pcie_capability_read_word(pci_dev, PCI_EXP_LNKSTA, &linkstat);
+	pci_config_pm_runtime_put(pci_dev);
+
 	if (err)
 		return -EINVAL;
 
@@ -226,7 +235,10 @@ static ssize_t current_link_width_show(s
 	u16 linkstat;
 	int err;
 
+	pci_config_pm_runtime_get(pci_dev);
 	err = pcie_capability_read_word(pci_dev, PCI_EXP_LNKSTA, &linkstat);
+	pci_config_pm_runtime_put(pci_dev);
+
 	if (err)
 		return -EINVAL;
 
@@ -242,7 +254,10 @@ static ssize_t secondary_bus_number_show
 	u8 sec_bus;
 	int err;
 
+	pci_config_pm_runtime_get(pci_dev);
 	err = pci_read_config_byte(pci_dev, PCI_SECONDARY_BUS, &sec_bus);
+	pci_config_pm_runtime_put(pci_dev);
+
 	if (err)
 		return -EINVAL;
 
@@ -258,7 +273,10 @@ static ssize_t subordinate_bus_number_sh
 	u8 sub_bus;
 	int err;
 
+	pci_config_pm_runtime_get(pci_dev);
 	err = pci_read_config_byte(pci_dev, PCI_SUBORDINATE_BUS, &sub_bus);
+	pci_config_pm_runtime_put(pci_dev);
+
 	if (err)
 		return -EINVAL;
 


