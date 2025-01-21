Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D2F1F0E36;
	Tue, 21 Jan 2025 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482959; cv=none; b=ZDwXJQk4ccxjI+WXSyxr4WvfZnM47vfIxOHHE2PVFBwlA9AUHcVbpFoklVR8/ClkAaX7V/cDVYW2qW6vT+8co6Y7Xq7mKB/dl8UR+OMm/gRhwmSwG6IIvCNkMC/q8w8kpOHuUEWQaVNYodIzQnDJX5DGIEsO/FnXWv6lWfhyADk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482959; c=relaxed/simple;
	bh=xwSi6YDx05EgVd7uQK6IpsSolf1ukVkdm8q/Ec9TEfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLxUaYmtkEt1uHXtLyVqTchVGfVE1R6Pdk/RKaeS/W+ufr15AKSfZ4+ocRfHEoxMnHRUr7NAjfKWioWlnjHjn9WwQ8+mAJFOkDO3q1LUwngu+ebVdaNNX+foJM+pdEl+fVH0WHdCf8DlIJT6xoC20LCes+uG6pLYIYMsbCfH4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pS3GD/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pS3GD/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4844C4CEDF;
	Tue, 21 Jan 2025 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482959;
	bh=xwSi6YDx05EgVd7uQK6IpsSolf1ukVkdm8q/Ec9TEfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pS3GD/qmoqn8rPIpsJOvXgcCewfW558Wmacp4L9YNRxZgBi7nQSQn7DPYqE7NJPK
	 VpcLZsWqWJYyLk4q9su3cTGcrxnyBbumxfKKLaTg0eNbWghNcWrXWNOrZtsphRbLl+
	 xp/CF907HZP6DXrzRTYNiZayt5gqVBn+bSepnUtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/127] of/address: Add support for 3 address cell bus
Date: Tue, 21 Jan 2025 18:52:18 +0100
Message-ID: <20250121174532.215689974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 3d5089c4263d3594dc055e0f9c5cb990505cdd64 ]

There's a few custom bus bindings (e.g. fsl,qoriq-mc) which use a
3 cell format with custom flags in the high cell. We can match these
buses as a fallback if we didn't match on PCI bus which is the only
standard bus binding with 3 address cells.

Link: https://lore.kernel.org/r/20230328-dt-address-helpers-v1-3-e2456c3e77ab@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 7f05e20b989a ("of: address: Preserve the flags portion on 1:1 dma-ranges mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c                        | 22 ++++++++
 drivers/of/unittest-data/tests-address.dtsi |  9 +++-
 drivers/of/unittest.c                       | 58 ++++++++++++++++++++-
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 60ead6105471..a95b57cea0d0 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -95,11 +95,17 @@ static int of_bus_default_translate(__be32 *addr, u64 offset, int na)
 	return 0;
 }
 
+static unsigned int of_bus_default_flags_get_flags(const __be32 *addr)
+{
+	return of_read_number(addr, 1);
+}
+
 static unsigned int of_bus_default_get_flags(const __be32 *addr)
 {
 	return IORESOURCE_MEM;
 }
 
+
 #ifdef CONFIG_PCI
 static unsigned int of_bus_pci_get_flags(const __be32 *addr)
 {
@@ -319,6 +325,11 @@ static unsigned int of_bus_isa_get_flags(const __be32 *addr)
 	return flags;
 }
 
+static int of_bus_default_flags_match(struct device_node *np)
+{
+	return of_bus_n_addr_cells(np) == 3;
+}
+
 /*
  * Array of bus specific translators
  */
@@ -348,6 +359,17 @@ static struct of_bus of_busses[] = {
 		.has_flags = true,
 		.get_flags = of_bus_isa_get_flags,
 	},
+	/* Default with flags cell */
+	{
+		.name = "default-flags",
+		.addresses = "reg",
+		.match = of_bus_default_flags_match,
+		.count_cells = of_bus_default_count_cells,
+		.map = of_bus_default_map,
+		.translate = of_bus_default_translate,
+		.has_flags = true,
+		.get_flags = of_bus_default_flags_get_flags,
+	},
 	/* Default */
 	{
 		.name = "default",
diff --git a/drivers/of/unittest-data/tests-address.dtsi b/drivers/of/unittest-data/tests-address.dtsi
index 6604a52bf6cb..bc0029cbf8ea 100644
--- a/drivers/of/unittest-data/tests-address.dtsi
+++ b/drivers/of/unittest-data/tests-address.dtsi
@@ -14,7 +14,7 @@
 			#size-cells = <1>;
 			/* ranges here is to make sure we don't use it for
 			 * dma-ranges translation */
-			ranges = <0x70000000 0x70000000 0x40000000>,
+			ranges = <0x70000000 0x70000000 0x50000000>,
 				 <0x00000000 0xd0000000 0x20000000>;
 			dma-ranges = <0x0 0x20000000 0x40000000>;
 
@@ -43,6 +43,13 @@
 					     <0x42000000 0x0 0xc0000000 0x20000000 0x0 0x10000000>;
 			};
 
+			bus@a0000000 {
+				#address-cells = <3>;
+				#size-cells = <2>;
+				ranges = <0xf00baa 0x0 0x0 0xa0000000 0x0 0x100000>,
+					 <0xf00bee 0x1 0x0 0xb0000000 0x0 0x200000>;
+			};
+
 		};
 	};
 };
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index a020296fbf41..d6a250cd7a40 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1045,7 +1045,7 @@ static void __init of_unittest_bus_ranges(void)
 			"for_each_of_range wrong flags on node %pOF flags=%x (expected %x)\n",
 			np, range.flags, IORESOURCE_MEM);
 		if (!i) {
-			unittest(range.size == 0x40000000,
+			unittest(range.size == 0x50000000,
 				 "for_each_of_range wrong size on node %pOF size=%llx\n",
 				 np, range.size);
 			unittest(range.cpu_addr == 0x70000000,
@@ -1071,6 +1071,61 @@ static void __init of_unittest_bus_ranges(void)
 	of_node_put(np);
 }
 
+static void __init of_unittest_bus_3cell_ranges(void)
+{
+	struct device_node *np;
+	struct of_range range;
+	struct of_range_parser parser;
+	int i = 0;
+
+	np = of_find_node_by_path("/testcase-data/address-tests/bus@a0000000");
+	if (!np) {
+		pr_err("missing testcase data\n");
+		return;
+	}
+
+	if (of_range_parser_init(&parser, np)) {
+		pr_err("missing ranges property\n");
+		return;
+	}
+
+	/*
+	 * Get the "ranges" from the device tree
+	 */
+	for_each_of_range(&parser, &range) {
+		if (!i) {
+			unittest(range.flags == 0xf00baa,
+				 "for_each_of_range wrong flags on node %pOF flags=%x\n",
+				 np, range.flags);
+			unittest(range.size == 0x100000,
+				 "for_each_of_range wrong size on node %pOF size=%llx\n",
+				 np, range.size);
+			unittest(range.cpu_addr == 0xa0000000,
+				 "for_each_of_range wrong CPU addr (%llx) on node %pOF",
+				 range.cpu_addr, np);
+			unittest(range.bus_addr == 0x0,
+				 "for_each_of_range wrong bus addr (%llx) on node %pOF",
+				 range.pci_addr, np);
+		} else {
+			unittest(range.flags == 0xf00bee,
+				 "for_each_of_range wrong flags on node %pOF flags=%x\n",
+				 np, range.flags);
+			unittest(range.size == 0x200000,
+				 "for_each_of_range wrong size on node %pOF size=%llx\n",
+				 np, range.size);
+			unittest(range.cpu_addr == 0xb0000000,
+				 "for_each_of_range wrong CPU addr (%llx) on node %pOF",
+				 range.cpu_addr, np);
+			unittest(range.bus_addr == 0x100000000,
+				 "for_each_of_range wrong bus addr (%llx) on node %pOF",
+				 range.pci_addr, np);
+		}
+		i++;
+	}
+
+	of_node_put(np);
+}
+
 static void __init of_unittest_parse_interrupts(void)
 {
 	struct device_node *np;
@@ -3377,6 +3432,7 @@ static int __init of_unittest(void)
 	of_unittest_parse_dma_ranges();
 	of_unittest_pci_dma_ranges();
 	of_unittest_bus_ranges();
+	of_unittest_bus_3cell_ranges();
 	of_unittest_match_node();
 	of_unittest_platform_populate();
 	of_unittest_overlay();
-- 
2.39.5



