Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7D57F7FE;
	Mon,  8 Apr 2024 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584926; cv=none; b=smOAhXaFmyaloGlGhlbpAS6DgSYYbdBnWtSHEKBbWEL0HNlR9RcpkfCSVBFbMTRiGEqpIGqtd+nf/ApCZFsSpgyvLplic78mv7zDWewdx4ARiAmFnv2WZN9d68Qq6oBocPetk4v5/2QwP2ryAH+V2J47TN8t0GGRRAlkccziWpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584926; c=relaxed/simple;
	bh=FM9H5mB9Z8nsXkrj9vXKWDsabvg87F/CHwAokWlRmEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVdqTf5jMDT4S1Y+aq9mDfmCV/oYxZa05Ho7ZBowWlIm2Q0CX46xsLT9f77QvKQpf9fn1Cpda+0sltW+3iDKH1mkbEJfutbybQUl6vA8hRLA/l3cLYy4MFWvNURsBEIaNfNcCoMASwWfjkJE51DZegF0NZBiUv7xpK+hS7bqC4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q15SVlCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q15SVlCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF1FC433F1;
	Mon,  8 Apr 2024 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584926;
	bh=FM9H5mB9Z8nsXkrj9vXKWDsabvg87F/CHwAokWlRmEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q15SVlCFVszIwv9e7XX+dXdS8zP59ObmL5VoMugT5kT8bGtulBeoHbWTqkTJSmiBt
	 Dh9cfTMhJrXvRBJ4N3tCEkn2wEbaZUJDXOBCz/2hHfe9YOxN0tyFw1V1psONA0TzD7
	 jC1pvZ3e2fjXrVslecRA/MmQhsgLelz3BMivUPEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Blakeney <mark.blakeney@bullet-systems.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 603/690] PCI/DPC: Quirk PIO log size for Intel Ice Lake Root Ports
Date: Mon,  8 Apr 2024 14:57:49 +0200
Message-ID: <20240408125421.445924263@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5953,8 +5953,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 
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
@@ -5977,6 +5978,10 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
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


