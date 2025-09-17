Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5138818A6CF;
	Wed, 17 Sep 2025 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112983; cv=none; b=F9PualjGbZb+IO2kHg15y9hzadmLOeWxSnZS7aTHNL7Hds2g2uBs4cW8c1hcVzkRouEV+UqmDtkNP8n9JA1NwwJYuifsDVEW8Z9iKJbnhT+sHfBMOoSpNdj7jBW44cwYGfYOaD70HvYHq8Vc6tuXom7+WJb2xJlG5oPQjKtN7r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112983; c=relaxed/simple;
	bh=COgEk5K3pVHP4sn9pRfGi7ZKXbpG6W+na3fgae1Wxws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL0oemZ2S31k6MkaXNiNjXmjghKjzTpPMr9jL5VJugVyFWHExM1xYifpCK5nA0s2Kd3eS1A9+UXJq1gGzbRHDiRsVyFEHeTDbleF9/SSxz2Pn6P9XyP9qVX4IXpgeJCJ5sIqxNO6FXOLU9Dw1SZ5Q1pIw293z9gZwI5S/6iYUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCqgX6Tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCqgX6Tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF6DC4CEF0;
	Wed, 17 Sep 2025 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112982;
	bh=COgEk5K3pVHP4sn9pRfGi7ZKXbpG6W+na3fgae1Wxws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCqgX6TtBapnaPCjUut4fJ7kn7cF+3eaiK79hjUaL3vLRn3Qrxv+k8LayjZDciIgZ
	 GzMen1alk8VFX0TWuMiXUGsKCHSVF+ryapOZufmjc8Rn1+Uk6qPG0A6FZmmX9FaWc5
	 wFOPhLxf+N+EPanR43krNmBEEIiff9EECkiqU1HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Palus <jpalus@fastmail.com>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tony Dinh <mibodhi@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 134/189] PCI: mvebu: Fix use of for_each_of_range() iterator
Date: Wed, 17 Sep 2025 14:34:04 +0200
Message-ID: <20250917123355.134137107@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Klaus Kudielka <klaus.kudielka@gmail.com>

[ Upstream commit b816265396daf1beb915e0ffbfd7f3906c2bf4a4 ]

5da3d94a23c6 ("PCI: mvebu: Use for_each_of_range() iterator for parsing
"ranges"") simplified code by using the for_each_of_range() iterator, but
it broke PCI enumeration on Turris Omnia (and probably other mvebu
targets).

Issue #1:

To determine range.flags, of_pci_range_parser_one() uses bus->get_flags(),
which resolves to of_bus_pci_get_flags(), which already returns an
IORESOURCE bit field, and NOT the original flags from the "ranges"
resource.

Then mvebu_get_tgt_attr() attempts the very same conversion again.  Remove
the misinterpretation of range.flags in mvebu_get_tgt_attr(), to restore
the intended behavior.

Issue #2:

The driver needs target and attributes, which are encoded in the raw
address values of the "/soc/pcie/ranges" resource. According to
of_pci_range_parser_one(), the raw values are stored in range.bus_addr and
range.parent_bus_addr, respectively. range.cpu_addr is a translated version
of range.parent_bus_addr, and not relevant here.

Use the correct range structure member, to extract target and attributes.
This restores the intended behavior.

Fixes: 5da3d94a23c6 ("PCI: mvebu: Use for_each_of_range() iterator for parsing "ranges"")
Reported-by: Jan Palus <jpalus@fastmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220479
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tony Dinh <mibodhi@gmail.com>
Tested-by: Jan Palus <jpalus@fastmail.com>
Link: https://patch.msgid.link/20250907102303.29735-1-klaus.kudielka@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index a4a2bac4f4b27..2f8d0223c1a6d 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -1168,12 +1168,6 @@ static void __iomem *mvebu_pcie_map_registers(struct platform_device *pdev,
 	return devm_ioremap_resource(&pdev->dev, &port->regs);
 }
 
-#define DT_FLAGS_TO_TYPE(flags)       (((flags) >> 24) & 0x03)
-#define    DT_TYPE_IO                 0x1
-#define    DT_TYPE_MEM32              0x2
-#define DT_CPUADDR_TO_TARGET(cpuaddr) (((cpuaddr) >> 56) & 0xFF)
-#define DT_CPUADDR_TO_ATTR(cpuaddr)   (((cpuaddr) >> 48) & 0xFF)
-
 static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 			      unsigned long type,
 			      unsigned int *tgt,
@@ -1189,19 +1183,12 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 		return -EINVAL;
 
 	for_each_of_range(&parser, &range) {
-		unsigned long rtype;
 		u32 slot = upper_32_bits(range.bus_addr);
 
-		if (DT_FLAGS_TO_TYPE(range.flags) == DT_TYPE_IO)
-			rtype = IORESOURCE_IO;
-		else if (DT_FLAGS_TO_TYPE(range.flags) == DT_TYPE_MEM32)
-			rtype = IORESOURCE_MEM;
-		else
-			continue;
-
-		if (slot == PCI_SLOT(devfn) && type == rtype) {
-			*tgt = DT_CPUADDR_TO_TARGET(range.cpu_addr);
-			*attr = DT_CPUADDR_TO_ATTR(range.cpu_addr);
+		if (slot == PCI_SLOT(devfn) &&
+		    type == (range.flags & IORESOURCE_TYPE_BITS)) {
+			*tgt = (range.parent_bus_addr >> 56) & 0xFF;
+			*attr = (range.parent_bus_addr >> 48) & 0xFF;
 			return 0;
 		}
 	}
-- 
2.51.0



