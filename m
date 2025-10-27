Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371E35965;
	Mon, 27 Oct 2025 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592294; cv=none; b=m9Wb1OXxAVLv+BPDUECutw9JCvm1QIO+twJ7RcUsZAkzt8IalVrn8tYvAZVGoeBETO7jSdbf5cor5A/lCF+Y+dvMLWMFVuUvR0NXLEFJlYYo8M9LRbiIDc/vKYo3LNLFG1gNZoq5lOrkh32+vTo4ELGvQLe+T2g2LI+BlnEYS/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592294; c=relaxed/simple;
	bh=nasmbJJ+xH0FJk8aNZnqKRemcool/c0fRIX1u/ie+fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBNlsZkYHYDCcfSENqGkI9E/9GcEhX3+KkWkUttlC8SUwqR8QIRmbCli17ZbJTFxHHIHOgCf8E4hZkaAF+MC4yGI87H1cT/4hD3OWN6ap2vvKaURBM9n/H9XPffg6yltSqTnG81m/sKPE6EJqoIrgBPzBY8whcA8+tH4AU05Kcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iN+/fmyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iN+/fmyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E9BC4CEF1;
	Mon, 27 Oct 2025 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592294;
	bh=nasmbJJ+xH0FJk8aNZnqKRemcool/c0fRIX1u/ie+fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN+/fmydIFdi45NMxXovHzgOdmOUI5Qlwn2DqS2LXyzFnGbxWyLgprlcImdedarxj
	 JmPGwUTTmtOYjYO5DQieic2lLzQG7EWoll139Pq4xIr1WVdC6W3nC3SgSbmp1cv/Ge
	 CBLPKX+9z/adb8mTCNLAIEAeHzO7uTgBlwmDPA/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH 6.1 066/157] PCI/sysfs: Ensure devices are powered for config reads (part 2)
Date: Mon, 27 Oct 2025 19:35:27 +0100
Message-ID: <20251027183503.053244443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

Commit 48991e493507 ("PCI/sysfs: Ensure devices are powered for config
reads") was applied to various linux-stable trees. However, prior to
6.12.y, we do not have commit d2bd39c0456b ("PCI: Store all PCIe
Supported Link Speeds"). Therefore, we also need to apply the change to
max_link_speed_show().

This was pointed out here:

  Re: Patch "PCI/sysfs: Ensure devices are powered for config reads" has been added to the 6.6-stable tree
  https://lore.kernel.org/all/aPEMIreBYZ7yk3cm@google.com/

Original change description follows:

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
Link: https://lore.kernel.org/all/aPEMIreBYZ7yk3cm@google.com/
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -186,9 +186,15 @@ static ssize_t max_link_speed_show(struc
 				   struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	ssize_t ret;
 
-	return sysfs_emit(buf, "%s\n",
-			  pci_speed_string(pcie_get_speed_cap(pdev)));
+	/* We read PCI_EXP_LNKCAP, so we need the device to be accessible. */
+	pci_config_pm_runtime_get(pdev);
+	ret = sysfs_emit(buf, "%s\n",
+			 pci_speed_string(pcie_get_speed_cap(pdev)));
+	pci_config_pm_runtime_put(pdev);
+
+	return ret;
 }
 static DEVICE_ATTR_RO(max_link_speed);
 


