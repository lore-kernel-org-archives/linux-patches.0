Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A8F227BA9;
	Tue, 29 Apr 2025 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950403; cv=none; b=RsgRfwGwSGz93yqC1VbYk4V+MR8sTbzz7F59ErO0nBmwjai2aGEIAffR8HYqhzKNLgol+WACOhnRFIZgOkx+il0r/bf5FgwITQ1WHdmwON8eNYlbyo0USBYhzwopcCi93uIqGGr9RciLV/90wEqwVuzhn4np79XdKmW6qTK1wYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950403; c=relaxed/simple;
	bh=dS2L08jzrW9BI7ZjF2B+XyH+VAMgK4LHIrEvSL8G5d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPMtSR6j3vZ9bBFMEuzKCxh/WrnSAAc/w9T7lJcCZLWxDLFiN+hsIbgkQhLdJ8VdO4AWsBc78OtFH7USRv0noh8e611PdZsNO5fX2AFDVXriYr4oRhF3Y7lXnDaanXtyf08Az2Te2ds1lfOPPxW+bS668xHz22izFMMJFJBZUXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntk7JM48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntk7JM48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F2C4CEE3;
	Tue, 29 Apr 2025 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950402;
	bh=dS2L08jzrW9BI7ZjF2B+XyH+VAMgK4LHIrEvSL8G5d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntk7JM48p5jYqs4bxXT/dOZMydQdZoN/QKjf3c0r5kOqw/PKEVVjEFBC/jBFfZ/K4
	 XNleLu6tA5w72TV2/f03nKbCrKWk8y+jMdX3QYTAKK1fiT4UPiv2XEjSgX2QIsWlar
	 EB6cudLNkKEV9BZhkPIIpJtDNkxTaJX9FrltAvxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Robert Richter <rrichter@amd.com>
Subject: [PATCH 6.6 084/204] cxl/core/regs.c: Skip Memory Space Enable check for RCD and RCH Ports
Date: Tue, 29 Apr 2025 18:42:52 +0200
Message-ID: <20250429161102.858409279@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -478,7 +478,6 @@ resource_size_t __rcrb_to_component(stru
 	resource_size_t rcrb = ri->base;
 	void __iomem *addr;
 	u32 bar0, bar1;
-	u16 cmd;
 	u32 id;
 
 	if (which == CXL_RCRB_UPSTREAM)
@@ -500,7 +499,6 @@ resource_size_t __rcrb_to_component(stru
 	}
 
 	id = readl(addr + PCI_VENDOR_ID);
-	cmd = readw(addr + PCI_COMMAND);
 	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
 	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
 	iounmap(addr);
@@ -515,8 +513,6 @@ resource_size_t __rcrb_to_component(stru
 			dev_err(dev, "Failed to access Downstream Port RCRB\n");
 		return CXL_RESOURCE_NONE;
 	}
-	if (!(cmd & PCI_COMMAND_MEMORY))
-		return CXL_RESOURCE_NONE;
 	/* The RCRB is a Memory Window, and the MEM_TYPE_1M bit is obsolete */
 	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
 		return CXL_RESOURCE_NONE;


