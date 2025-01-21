Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6D91F3FFE;
	Tue, 21 Jan 2025 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482956; cv=none; b=g83f1o6K2bGZ6xQ5Doldvo6n5xMAQyG6Q3jla3WnbwPlpDDvxONEcntf6LnXGukXdOaC5AHccT9VPiiIkkzoShIX89w03C/8pICGJL4f6fedWxWrlIunFz7Kp6fMGO8lzBYawWyMsDpd+Fy986R58F4nguxD/KotcK37zimXhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482956; c=relaxed/simple;
	bh=DHHYcJ+RoQ6savV9ac+uIg6SauULp+1tk3yfp/ev56Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6uTUj+VhofpjEJDlzTl4fFTZe35D3MGLb3meSqfbayjbWZS81jQuYtczfqXvljG3IU5m949Lc+/AoaK7qJE4NL0gLb5yjLTIZfQx8hqblUdHTvul+8YSx6I66Kl01EDLMwlB+OHse9ASjcRGd6hnEw2gMIbMnIVXFF3SFUOyls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCnzTv1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCnzTv1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2040C4CEDF;
	Tue, 21 Jan 2025 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482956;
	bh=DHHYcJ+RoQ6savV9ac+uIg6SauULp+1tk3yfp/ev56Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCnzTv1a/cJrRITvn+xu9BlYdUAb6WD0OGz3OMU6dR6iZgii5U2PDkyf/Wsz1U0Zc
	 38Q53O4zJoo3YoYlBVswKtVVR5Jag1BElLV5tioXlFljV4TdMgQkPEgmdba+uMZugV
	 sSrtlpetuWlq3Cxg0lbQexKwjkHs+FVcUN5Oo0Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/127] of: unittest: Add bus address range parsing tests
Date: Tue, 21 Jan 2025 18:52:17 +0100
Message-ID: <20250121174532.178032127@linuxfoundation.org>
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

[ Upstream commit 6d32dadb11a6480be62c6ada901bbdcbda1775c9 ]

While there are tests for "dma-ranges" helpers, "ranges" is missing any
tests. It's the same underlying code, but for completeness add a test
for "ranges" parsing iterators. This is in preparation to add some
additional "ranges" helpers.

Link: https://lore.kernel.org/r/20230328-dt-address-helpers-v1-1-e2456c3e77ab@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 7f05e20b989a ("of: address: Preserve the flags portion on 1:1 dma-ranges mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 53 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 5a8d37cef0ba..a020296fbf41 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -1019,6 +1019,58 @@ static void __init of_unittest_pci_dma_ranges(void)
 	of_node_put(np);
 }
 
+static void __init of_unittest_bus_ranges(void)
+{
+	struct device_node *np;
+	struct of_range range;
+	struct of_range_parser parser;
+	int i = 0;
+
+	np = of_find_node_by_path("/testcase-data/address-tests");
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
+		unittest(range.flags == IORESOURCE_MEM,
+			"for_each_of_range wrong flags on node %pOF flags=%x (expected %x)\n",
+			np, range.flags, IORESOURCE_MEM);
+		if (!i) {
+			unittest(range.size == 0x40000000,
+				 "for_each_of_range wrong size on node %pOF size=%llx\n",
+				 np, range.size);
+			unittest(range.cpu_addr == 0x70000000,
+				 "for_each_of_range wrong CPU addr (%llx) on node %pOF",
+				 range.cpu_addr, np);
+			unittest(range.bus_addr == 0x70000000,
+				 "for_each_of_range wrong bus addr (%llx) on node %pOF",
+				 range.pci_addr, np);
+		} else {
+			unittest(range.size == 0x20000000,
+				 "for_each_of_range wrong size on node %pOF size=%llx\n",
+				 np, range.size);
+			unittest(range.cpu_addr == 0xd0000000,
+				 "for_each_of_range wrong CPU addr (%llx) on node %pOF",
+				 range.cpu_addr, np);
+			unittest(range.bus_addr == 0x00000000,
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
@@ -3324,6 +3376,7 @@ static int __init of_unittest(void)
 	of_unittest_dma_get_max_cpu_address();
 	of_unittest_parse_dma_ranges();
 	of_unittest_pci_dma_ranges();
+	of_unittest_bus_ranges();
 	of_unittest_match_node();
 	of_unittest_platform_populate();
 	of_unittest_overlay();
-- 
2.39.5



