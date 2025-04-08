Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F028126B0A9;
	Tue,  8 Apr 2025 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114373; cv=none; b=gBjqzkM0WNopRLZN0ib+O6ndTELy6Es3iktmRMKBFocBT70grtkhS/7bCXWPOvpZqOsYq8DMJiF87n3SGA9eN8ZAr21Afwq2FC7Len+mvmkeGMUBU2fg3C0FCT1hKtI+eILYGozOFj3S5uKiqorFzEONru8KaJqkiO3eEh1QyTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114373; c=relaxed/simple;
	bh=A7D3IXYFJf0zhs7gjQSCtYK5dIuREplWtY7BTGljpAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRfwhy6+dyIleyxfaiMXufkdqAhmxHXwNLIKeDwNlQKRtiyH70YItoD22gaOuDL/wvx1S2M9WKzsSvyh/v8LsXfXblXB4yLA4TKTIo8nEXFHWwxsq3EuYfEtO5qhQPQ78WbsmXUPU2TAmvFNLTvvqLXdExEbm13ipU8OsWSvQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ3hKc+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ3hKc+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815F4C4CEE5;
	Tue,  8 Apr 2025 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114372;
	bh=A7D3IXYFJf0zhs7gjQSCtYK5dIuREplWtY7BTGljpAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZ3hKc+a5yyIYkYMqqHn3704Zlg/X3W3AvOxRx5Mmud9Iose1gb8TojpIehTvdmvb
	 1XcXPRCsxxf0dXHYCSYh3mISMI14oc+x7U07hZN35VvPHn/zQC42a/SP3Ij2NrhXoU
	 HurIF897XINFW9d+ugaCQuqV2v/3YCosFFvGdWnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 080/499] PCI/ACS: Fix pci=config_acs= parameter
Date: Tue,  8 Apr 2025 12:44:52 +0200
Message-ID: <20250408104853.221082028@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Dave <tdave@nvidia.com>

[ Upstream commit 9cf8a952d57b422d3ff8a9a0163f8adf694f4b2b ]

Commit 47c8846a49ba ("PCI: Extend ACS configurability") introduced bugs
that fail to configure ACS ctrl to the value specified by the kernel
parameter. Essentially there are two bugs:

1) When ACS is configured for multiple PCI devices using 'config_acs'
   kernel parameter, it results into error "PCI: Can't parse ACS command
   line parameter". This is due to a bug that doesn't preserve the ACS
   mask, but instead overwrites the mask with value 0.

   For example, using 'config_acs' to configure ACS ctrl for multiple BDFs
   fails:

      Kernel command line: pci=config_acs=1111011@0020:02:00.0;101xxxx@0039:00:00.0 "dyndbg=file drivers/pci/pci.c +p"
      PCI: Can't parse ACS command line parameter
      pci 0020:02:00.0: ACS mask  = 0x007f
      pci 0020:02:00.0: ACS flags = 0x007b
      pci 0020:02:00.0: Configured ACS to 0x007b

   After this fix:

      Kernel command line: pci=config_acs=1111011@0020:02:00.0;101xxxx@0039:00:00.0 "dyndbg=file drivers/pci/pci.c +p"
      pci 0020:02:00.0: ACS mask  = 0x007f
      pci 0020:02:00.0: ACS flags = 0x007b
      pci 0020:02:00.0: ACS control = 0x005f
      pci 0020:02:00.0: ACS fw_ctrl = 0x0053
      pci 0020:02:00.0: Configured ACS to 0x007b
      pci 0039:00:00.0: ACS mask  = 0x0070
      pci 0039:00:00.0: ACS flags = 0x0050
      pci 0039:00:00.0: ACS control = 0x001d
      pci 0039:00:00.0: ACS fw_ctrl = 0x0000
      pci 0039:00:00.0: Configured ACS to 0x0050

2) In the bit manipulation logic, we copy the bit from the firmware
   settings when mask bit 0.

   For example, 'disable_acs_redir' fails to clear all three ACS P2P redir
   bits due to the wrong bit fiddling:

      Kernel command line: pci=disable_acs_redir=0020:02:00.0;0030:02:00.0;0039:00:00.0 "dyndbg=file drivers/pci/pci.c +p"
      pci 0020:02:00.0: ACS mask  = 0x002c
      pci 0020:02:00.0: ACS flags = 0xffd3
      pci 0020:02:00.0: Configured ACS to 0xfffb
      pci 0030:02:00.0: ACS mask  = 0x002c
      pci 0030:02:00.0: ACS flags = 0xffd3
      pci 0030:02:00.0: Configured ACS to 0xffdf
      pci 0039:00:00.0: ACS mask  = 0x002c
      pci 0039:00:00.0: ACS flags = 0xffd3
      pci 0039:00:00.0: Configured ACS to 0xffd3

   After this fix:

      Kernel command line: pci=disable_acs_redir=0020:02:00.0;0030:02:00.0;0039:00:00.0 "dyndbg=file drivers/pci/pci.c +p"
      pci 0020:02:00.0: ACS mask  = 0x002c
      pci 0020:02:00.0: ACS flags = 0xffd3
      pci 0020:02:00.0: ACS control = 0x007f
      pci 0020:02:00.0: ACS fw_ctrl = 0x007b
      pci 0020:02:00.0: Configured ACS to 0x0053
      pci 0030:02:00.0: ACS mask  = 0x002c
      pci 0030:02:00.0: ACS flags = 0xffd3
      pci 0030:02:00.0: ACS control = 0x005f
      pci 0030:02:00.0: ACS fw_ctrl = 0x005f
      pci 0030:02:00.0: Configured ACS to 0x0053
      pci 0039:00:00.0: ACS mask  = 0x002c
      pci 0039:00:00.0: ACS flags = 0xffd3
      pci 0039:00:00.0: ACS control = 0x001d
      pci 0039:00:00.0: ACS fw_ctrl = 0x0000
      pci 0039:00:00.0: Configured ACS to 0x0000

Link: https://lore.kernel.org/r/20250207030338.456887-1-tdave@nvidia.com
Fixes: 47c8846a49ba ("PCI: Extend ACS configurability")
Signed-off-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0ae4bc1a1bee..db437572be472 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -955,8 +955,10 @@ struct pci_acs {
 };
 
 static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
-			     const char *p, u16 mask, u16 flags)
+			     const char *p, const u16 acs_mask, const u16 acs_flags)
 {
+	u16 flags = acs_flags;
+	u16 mask = acs_mask;
 	char *delimit;
 	int ret = 0;
 
@@ -964,7 +966,7 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 		return;
 
 	while (*p) {
-		if (!mask) {
+		if (!acs_mask) {
 			/* Check for ACS flags */
 			delimit = strstr(p, "@");
 			if (delimit) {
@@ -972,6 +974,8 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 				u32 shift = 0;
 
 				end = delimit - p - 1;
+				mask = 0;
+				flags = 0;
 
 				while (end > -1) {
 					if (*(p + end) == '0') {
@@ -1028,10 +1032,14 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 
 	pci_dbg(dev, "ACS mask  = %#06x\n", mask);
 	pci_dbg(dev, "ACS flags = %#06x\n", flags);
+	pci_dbg(dev, "ACS control = %#06x\n", caps->ctrl);
+	pci_dbg(dev, "ACS fw_ctrl = %#06x\n", caps->fw_ctrl);
 
-	/* If mask is 0 then we copy the bit from the firmware setting. */
-	caps->ctrl = (caps->ctrl & ~mask) | (caps->fw_ctrl & mask);
-	caps->ctrl |= flags;
+	/*
+	 * For mask bits that are 0, copy them from the firmware setting
+	 * and apply flags for all the mask bits that are 1.
+	 */
+	caps->ctrl = (caps->fw_ctrl & ~mask) | (flags & mask);
 
 	pci_info(dev, "Configured ACS to %#06x\n", caps->ctrl);
 }
-- 
2.39.5



