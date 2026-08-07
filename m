Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990944684F;
	Fri,  7 Aug 2026 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117334; cv=none; b=LI4uJYYft80nZaEuchK+mtGcW2v+FS7/fDPox9loKwaUMFzkBMlNM5gesf/yawvU1apThN5xKV4r+zp/GV0XQXDd4RDlqEOzuPAMNylCeETbDXkYdluzpglyt896TBV9pjtyTDtvX/tC7c+J7BL9YLmwDDrenBx/fbDeeKHruvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117334; c=relaxed/simple;
	bh=whtfurcB8qSJRfOcJmDlTASdxFKex49M1Vh9FeChJSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYcg/F515F0clIiBjSRtwJ5FkzMx7eR5S7VOU3ix2PY32A18+ySST1yexJwE1bKuOlUnitXlJfx8M5hOL8E3zCP0E/2l0HYW7aj+yuWqzBpqcbmXSrnAFZ9INxfIZdVZbdWf3tu5V7YqZXnHJAqbHJbyTHZ7KxUxqOqukhcwN2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgIO/yYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgIO/yYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855EC1F000E9;
	Fri,  7 Aug 2026 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117333;
	bh=bP2GE1oIFa8tbJgNKZDL7Pn1RYWvUkTvEVMG4zKMl/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgIO/yYtLUC9kJO3iJXFOtYmPwj4LcVLoM2pmrENEDsGUueQiRMy18HzokT9B1XRd
	 2r3m6h2AwsPLNTvoPMw2FSJvJHZuLF64ODNwcNqJO+txBl7w+/yvOSIHNXRuWlwvrf
	 2LGVBcA9pyO3AqpEX8W2jKeDM9rw0MQ8IvQfJ3v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.1 282/438] of/address: Fix NULL bus dereference in of_pci_range_parser_one()
Date: Fri,  7 Aug 2026 16:37:58 +0200
Message-ID: <20260807143433.992590596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlo Caione <ccaione@baylibre.com>

commit bba13ad17b1a11b3f1ed9b3a5d556191d7755a59 upstream.

The bus matching rework made of_match_bus() return NULL for nodes with
ranges/dma-ranges but no local #address-cells. parser_init() stored that
NULL bus, and the range iterator later dereferenced it.

Reject such nodes in parser_init(), leaving an explicit empty
iterator for callers that ignore the init return, and make
of_dma_get_max_cpu_address() honour the init failure so a rejected node
cannot clamp the DMA limit.

Fixes: 64ee3cf096ac ("of/address: Rework bus matching to avoid warnings")
Cc: stable@vger.kernel.org
Signed-off-by: Carlo Caione <ccaione@baylibre.com>
Link: https://patch.msgid.link/20260727-of-range-parser-null-bus-v3-1-be01b708a4ce@baylibre.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -753,6 +753,7 @@ EXPORT_SYMBOL(of_property_read_reg);
 static int parser_init(struct of_pci_range_parser *parser,
 			struct device_node *node, const char *name)
 {
+	const __be32 *range;
 	int rlen;
 
 	parser->node = node;
@@ -761,12 +762,20 @@ static int parser_init(struct of_pci_ran
 	parser->ns = of_bus_n_size_cells(node);
 	parser->dma = !strcmp(name, "dma-ranges");
 	parser->bus = of_match_bus(node);
+	parser->range = NULL;
+	parser->end = NULL;
 
-	parser->range = of_get_property(node, name, &rlen);
-	if (parser->range == NULL)
+	range = of_get_property(node, name, &rlen);
+	if (!range)
 		return -ENOENT;
 
-	parser->end = parser->range + rlen / sizeof(__be32);
+	if (!parser->bus ||
+	    !OF_CHECK_COUNTS(parser->na, parser->ns) ||
+	    !OF_CHECK_ADDR_COUNT(parser->pna))
+		return -EINVAL;
+
+	parser->range = range;
+	parser->end = range + rlen / sizeof(__be32);
 
 	return 0;
 }
@@ -792,7 +801,7 @@ struct of_pci_range *of_pci_range_parser
 	int na = parser->na;
 	int ns = parser->ns;
 	int np = parser->pna + na + ns;
-	int busflag_na = parser->bus->flag_cells;
+	int busflag_na;
 
 	if (!range)
 		return NULL;
@@ -800,6 +809,8 @@ struct of_pci_range *of_pci_range_parser
 	if (!parser->range || parser->range + np > parser->end)
 		return NULL;
 
+	busflag_na = parser->bus->flag_cells;
+
 	range->flags = parser->bus->get_flags(parser->range);
 
 	range->bus_addr = of_read_number(parser->range + busflag_na, na - busflag_na);
@@ -976,8 +987,7 @@ phys_addr_t __init of_dma_get_max_cpu_ad
 		np = of_root;
 
 	ranges = of_get_property(np, "dma-ranges", &len);
-	if (ranges && len) {
-		of_dma_range_parser_init(&parser, np);
+	if (ranges && len && !of_dma_range_parser_init(&parser, np)) {
 		for_each_of_range(&parser, &range)
 			if (range.cpu_addr + range.size > cpu_end)
 				cpu_end = range.cpu_addr + range.size - 1;


