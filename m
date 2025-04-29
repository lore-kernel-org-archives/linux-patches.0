Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC73A2517AB;
	Tue, 29 Apr 2025 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947823; cv=none; b=LNPDqHAcMOnKxF+UsN7nnlHEKG2J05Nat86x/z7pSByxr5aCRnnwpTfQ2ll9eyiCuoEvZ3ZWM7BgqXz5XYsukLw1lSikUbHGPB5SnNSCz3+a6jmNmlKmzpBVCLvR2MW3xT4Gq1I16MThkTVqcqtv0M/0HZuMa7pO7HN9kJReQwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947823; c=relaxed/simple;
	bh=h9bLTjeC0qWt/f8J+TLepWxHjrzZ8GOhymSmZ+CaSXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocnBHxnUlOWyFRIdeuiXZXw5ZuHikWlwtdzqSugSa3/bYEW/V4N5qWx+D8ac1Uxq/7/fFpr9kLx4yBORG3p39aaVnNioM9iv1BuBHKJeTBi4AWEnWpGtIfRqhV8Xjaqrn+T3JoXEUf6tO4JuwQb0l6MAAKgvD8nK05YpzVvfHqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9us2C/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9us2C/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21A4C4CEE9;
	Tue, 29 Apr 2025 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947823;
	bh=h9bLTjeC0qWt/f8J+TLepWxHjrzZ8GOhymSmZ+CaSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9us2C/+1FgPc+bq6jHQA01QrD5TxkqOHvIFLyixqYCRqqX2uOPOLVuJ5NsnDmd0/
	 29zkfv7Hcl7XN7ME9QAt1RzPnsT2V7fYyUOoMFtlfw0McqdILUVk5Afr3lUVqgFsO6
	 ZoV0GBVXAYur354EUAwLSoJ/KC0MUVJFct2GKL/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Robert Richter <rrichter@amd.com>
Subject: [PATCH 6.12 114/280] cxl/core/regs.c: Skip Memory Space Enable check for RCD and RCH Ports
Date: Tue, 29 Apr 2025 18:40:55 +0200
Message-ID: <20250429161119.778297066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

commit 078d3ee7c162cd66d76171579c02d7890bd77daf upstream.

According to CXL r3.2 section 8.2.1.2, the PCI_COMMAND register fields,
including Memory Space Enable bit, have no effect on the behavior of an
RCD Upstream Port. Retaining this check may incorrectly cause
cxl_pci_probe() to fail on a valid RCD upstream Port.

While the specification is explicit only for RCD Upstream Ports, this
check is solely for accessing the RCRB, which is always mapped through
memory space. Therefore, its safe to remove the check entirely. In
practice, firmware reliably enables the Memory Space Enable bit for
RCH Downstream Ports and no failures have been observed.

Removing the check simplifies the code and avoids unnecessary
special-casing, while relying on BIOS/firmware to configure devices
correctly. Moreover, any failures due to inaccessible RCRB regions
will still be caught either in __rcrb_to_component() or while
parsing the component register block.

The following failure was observed in dmesg when the check was present:
	cxl_pci 0000:7f:00.0: No component registers (-6)

Fixes: d5b1a27143cb ("cxl/acpi: Extract component registers of restricted hosts from RCRB")
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Robert Richter <rrichter@amd.com>
Link: https://patch.msgid.link/20250407192734.70631-1-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/regs.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -513,7 +513,6 @@ resource_size_t __rcrb_to_component(stru
 	resource_size_t rcrb = ri->base;
 	void __iomem *addr;
 	u32 bar0, bar1;
-	u16 cmd;
 	u32 id;
 
 	if (which == CXL_RCRB_UPSTREAM)
@@ -535,7 +534,6 @@ resource_size_t __rcrb_to_component(stru
 	}
 
 	id = readl(addr + PCI_VENDOR_ID);
-	cmd = readw(addr + PCI_COMMAND);
 	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
 	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
 	iounmap(addr);
@@ -550,8 +548,6 @@ resource_size_t __rcrb_to_component(stru
 			dev_err(dev, "Failed to access Downstream Port RCRB\n");
 		return CXL_RESOURCE_NONE;
 	}
-	if (!(cmd & PCI_COMMAND_MEMORY))
-		return CXL_RESOURCE_NONE;
 	/* The RCRB is a Memory Window, and the MEM_TYPE_1M bit is obsolete */
 	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
 		return CXL_RESOURCE_NONE;


