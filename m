Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9EEC5;
	Sat, 13 Jan 2024 09:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0F+ISedN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF261C43601;
	Sat, 13 Jan 2024 09:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139824;
	bh=atgPHSSQyfaztTDp377+GYR2/dqPXUWoWRgd1XBUDqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0F+ISedN3uv/Y4V4B17bfqnjsXPDgYTdxG0U9aWWXf/aOIyFDCXK9v7Sg8yx3ZDHQ
	 S1pXgzFy1bv394YLEXJmiywauaoYuE5VyPvFFb42xWXR6DteYtxndPJimvh1KEpWJD
	 quPUwXNpM24XkX8+zPBk+iOFspk9KsLa0xVdv4sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Pawlowski <bartosz.pawlowski@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: [PATCH 5.4 35/38] PCI: Disable ATS for specific Intel IPU E2000 devices
Date: Sat, 13 Jan 2024 10:50:11 +0100
Message-ID: <20240113094207.524416202@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Pawlowski <bartosz.pawlowski@intel.com>

commit a18615b1cfc04f00548c60eb9a77e0ce56e848fd upstream.

Due to a hardware issue in A and B steppings of Intel IPU E2000, it expects
wrong endianness in ATS invalidation message body. This problem can lead to
outdated translations being returned as valid and finally cause system
instability.

To prevent such issues, add quirk_intel_e2000_no_ats() to disable ATS for
vulnerable IPU E2000 devices.

Link: https://lore.kernel.org/r/20230908143606.685930-3-bartosz.pawlowski@intel.com
Signed-off-by: Bartosz Pawlowski <bartosz.pawlowski@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5419,6 +5419,25 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
+
+/*
+ * Intel IPU E2000 revisions before C0 implement incorrect endianness
+ * in ATS Invalidate Request message body. Disable ATS for those devices.
+ */
+static void quirk_intel_e2000_no_ats(struct pci_dev *pdev)
+{
+	if (pdev->revision < 0x20)
+		quirk_no_ats(pdev);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1451, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1452, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1453, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1454, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1455, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1457, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1459, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x145a, quirk_intel_e2000_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x145c, quirk_intel_e2000_no_ats);
 #endif /* CONFIG_PCI_ATS */
 
 /* Freescale PCIe doesn't support MSI in RC mode */


