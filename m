Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA4164CC0;
	Thu, 11 Apr 2024 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831948; cv=none; b=ZlH3IoJng7U3YbfOfPp3BQcfQ1cuMzBGUscFwBygKafFDvWpbdvjrdC6/bK8Og4Rsd8ASum7IykYHorQgKIOOs3XFI+SnTWXFn6TzLl1HHwW2PSCTo+mKAWqigklBqiAoNYSZDFcVwnYk4C4+mNsaGIHoIpbBJMKKAeo5qCcTq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831948; c=relaxed/simple;
	bh=hMJNWuA7/PBmqOJzCCbgKwahYVOzBx7cUaXbJs39ym8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdPFY8eWolvR07ujz4BS5Xu5VNj3TcSShrmJRPg3heLEq60WuU+Wk7d+T+KAY/v2hg4igpXtTmIdNxn417htHtU6RRm8r+wEdN89k1wyFRkKX6eyV/4yL1yk3aqD0GYiO4PXZ3oixRNPTCQmjCSqu8TRn86GnduCK3yv+TAsIng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTt1QXP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTt1QXP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB28CC43390;
	Thu, 11 Apr 2024 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831948;
	bh=hMJNWuA7/PBmqOJzCCbgKwahYVOzBx7cUaXbJs39ym8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTt1QXP1SnnkYJRQk5TELOGshs0xGi0hK+gYWLCOQT1SGMVwbEkNO4II3WqfgsMmx
	 0h6x+iflJgoGPSN2JcWfPNevBEXmZXu5K6kyxQoLdWNeKY/Sq/3k3SDpIWaLfHmB6I
	 QfNG/lJitjn3DQqfvWbY1vNEOpx5TVqWm/2b/aQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Blakeney <mark.blakeney@bullet-systems.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 179/294] PCI/DPC: Quirk PIO log size for Intel Ice Lake Root Ports
Date: Thu, 11 Apr 2024 11:55:42 +0200
Message-ID: <20240411095441.014720326@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 3b8803494a0612acdeee714cb72aa142b1e05ce5 upstream.

Commit 5459c0b70467 ("PCI/DPC: Quirk PIO log size for certain Intel Root
Ports") added quirks for Tiger and Alder Lake Root Ports but missed that
the same issue exists also in the previous generation, Ice Lake.

Apply the quirk for Ice Lake Root Ports as well.  This prevents kernel
complaints like:

  DPC: RP PIO log size 0 is invalid

and also enables the DPC driver to dump the RP PIO Log registers when DPC
is triggered.

[bhelgaas: add dmesg warning and RP PIO Log dump info]
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=209943
Link: https://lore.kernel.org/r/20230511121905.73949-1-mika.westerberg@linux.intel.com
Reported-by: Mark Blakeney <mark.blakeney@bullet-systems.net>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5912,8 +5912,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 
 #ifdef CONFIG_PCIE_DPC
 /*
- * Intel Tiger Lake and Alder Lake BIOS has a bug that clears the DPC
- * RP PIO Log Size of the integrated Thunderbolt PCIe Root Ports.
+ * Intel Ice Lake, Tiger Lake and Alder Lake BIOS has a bug that clears
+ * the DPC RP PIO Log Size of the integrated Thunderbolt PCIe Root
+ * Ports.
  */
 static void dpc_log_size(struct pci_dev *dev)
 {
@@ -5936,6 +5937,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x462f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x463f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x466e, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x8a1d, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x8a1f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x8a21, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x8a23, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a23, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a25, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a27, dpc_log_size);


