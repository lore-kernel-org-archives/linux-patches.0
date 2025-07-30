Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C42273D95;
	Wed, 30 Jul 2025 09:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869363; cv=none; b=lO8uKDojxFvNCp/DozY/XTC1tQruDv4Kf9jUK63B0o8r1JyWbsWl64afuXFL/xzJqKI5B6z7jPnjPyW3XGDt3MR1Ls1V3RiKKN5vQlaNNjT5nPL8LlCv0DeXavvr+DqkV5eyW/H+VveXFpvcGWrhijw30frS3+hCFjis2o45cSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869363; c=relaxed/simple;
	bh=11BuEVkEi7LECS9QnpVEnD1+c2NjRqPjj8mIRidjvWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq3wU1iPLsN19NE06L711kOXSD2E+0fMFeQ+706QQWjdCRi4Q+wBbB9SDPeGMIH8eEiEqahug15Tj8SBCcw6oZHsYkYNfppndOCyzrqaor6IST2dOpmsAGqYb1JsJGgXmUiHLBczjlTSGkdMr0X6mBeJ9UWGIBzy+/gEN4gqdlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDlXOxsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDlXOxsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3565CC4CEE7;
	Wed, 30 Jul 2025 09:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869363;
	bh=11BuEVkEi7LECS9QnpVEnD1+c2NjRqPjj8mIRidjvWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDlXOxsdKQ5hsHf/+dMersOID+l6KXPJHo4ixZB49qNyuSKEcA4xF45sOEyWYRZHF
	 CgczhmAn1J9kX1VR1OlEA6BE2xp11Q7+hG0PGib2xzn9Y0vy4aQTp4v++aBzT7Mtse
	 Zby6osaXvuWg3SkKrPCxI8OPPug/wbEEGONa9Cdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.15 73/92] PCI/pwrctrl: Create pwrctrl devices only when CONFIG_PCI_PWRCTRL is enabled
Date: Wed, 30 Jul 2025 11:36:21 +0200
Message-ID: <20250730093233.587000394@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 8c493cc91f3a1102ad2f8c75ae0cf80f0a057488 upstream.

If devicetree describes power supplies related to a PCI device, we
unnecessarily created a pwrctrl device even if CONFIG_PCI_PWRCTL was not
enabled.

We only need pci_pwrctrl_create_device() when CONFIG_PCI_PWRCTRL is
enabled.  Compile it out when CONFIG_PCI_PWRCTRL is not enabled.

When pci_pwrctrl_create_device() creates and returns a pwrctrl device,
pci_scan_device() doesn't enumerate the PCI device. It assumes the pwrctrl
core will rescan the bus after turning on the power. However, if
CONFIG_PCI_PWRCTRL is not enabled, the rescan never happens, which breaks
PCI enumeration on any system that describes power supplies in devicetree
but does not use pwrctrl.

Jim reported that some brcmstb platforms break this way.  The brcmstb
driver is still broken if CONFIG_PCI_PWRCTRL is enabled, but this commit at
least allows brcmstb to work when it's NOT enabled.

Fixes: 957f40d039a9 ("PCI/pwrctrl: Move creation of pwrctrl devices to pci_scan_device()")
Reported-by: Jim Quinlan <james.quinlan@broadcom.com>
Link: https://lore.kernel.org/r/CA+-6iNwgaByXEYD3j=-+H_PKAxXRU78svPMRHDKKci8AGXAUPg@mail.gmail.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org	# v6.15
Link: https://patch.msgid.link/20250701064731.52901-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2508,6 +2508,7 @@ bool pci_bus_read_dev_vendor_id(struct p
 }
 EXPORT_SYMBOL(pci_bus_read_dev_vendor_id);
 
+#if IS_ENABLED(CONFIG_PCI_PWRCTRL)
 static struct platform_device *pci_pwrctrl_create_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_host_bridge *host = pci_find_host_bridge(bus);
@@ -2537,6 +2538,12 @@ static struct platform_device *pci_pwrct
 
 	return pdev;
 }
+#else
+static struct platform_device *pci_pwrctrl_create_device(struct pci_bus *bus, int devfn)
+{
+	return NULL;
+}
+#endif
 
 /*
  * Read the config data for a PCI device, sanity-check it,


