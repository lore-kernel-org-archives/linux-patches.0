Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5BF16DEBB;
	Mon,  6 Jan 2025 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177193; cv=none; b=aokUgyjiGnFu12KoOivESzZ+RbU+YLapQqX9WvCcPDInN8Ae3vczCS7bYbSKYY8dioRbdjvE32WA8vbpz1djcI4csB2SAakElMvQKrJRucFac2+08rrbIU4X+3920SrsEiezA07md3ICRaI8RMrixQ97zcR3Z6xJ87rMV0s8QAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177193; c=relaxed/simple;
	bh=dARvEaCIfmDH6Y1hNKu8XLF2RMPGlY6DUp81fKYtSt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ithqznFv3GoLmdrUpEdw+Asm+f5a4+Ns6GK3/7IHP1RgbJRKqLpeIoDYo6ygRSnaTvfnBv1O4oE9l2kIdhY3tmJUWjwCpuCtvyfesTWaFLh4g6V9DW9uC6trK+ipH/HpqeTX1f0pLvhvqcT54J9B5cJh4JU2NR15rngaWEBuCO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPEkEZK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPEkEZK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54670C4CED2;
	Mon,  6 Jan 2025 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177192;
	bh=dARvEaCIfmDH6Y1hNKu8XLF2RMPGlY6DUp81fKYtSt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPEkEZK2Ap0AQziaMTwoFUFQuEhOLncJlZ7Cdp6kDs9TvAqGrps/6y9XIx0kXxb4K
	 9D4vWaFCVTikYNuJbh3ORcFzd9FDs/SikjK4BDk6LShapmeJ2kDW0+2TwLlFdRISLP
	 G81Kvu+5yM50UyBbNGC9rotNSaf4thNm3qgtcDh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/222] of: address: Store number of bus flag cells rather than bool
Date: Mon,  6 Jan 2025 16:14:46 +0100
Message-ID: <20250106151153.705372476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 88696db08b7efa3b6bb722014ea7429e78f6be32 ]

It is more useful to know how many flags cells a bus has rather than
whether a bus has flags or not as ultimately the number of cells is the
information used. Replace 'has_flags' boolean with 'flag_cells' count.

Acked-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20231026135358.3564307-2-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 7f05e20b989a ("of: address: Preserve the flags portion on 1:1 dma-ranges mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index cfe5a11b620a..cdefe5a89e5d 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -46,7 +46,7 @@ struct of_bus {
 	u64		(*map)(__be32 *addr, const __be32 *range,
 				int na, int ns, int pna);
 	int		(*translate)(__be32 *addr, u64 offset, int na);
-	bool	has_flags;
+	int		flag_cells;
 	unsigned int	(*get_flags)(const __be32 *addr);
 };
 
@@ -371,7 +371,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_pci_count_cells,
 		.map = of_bus_pci_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_pci_get_flags,
 	},
 #endif /* CONFIG_PCI */
@@ -383,7 +383,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_isa_count_cells,
 		.map = of_bus_isa_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_isa_get_flags,
 	},
 	/* Default with flags cell */
@@ -394,7 +394,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_default_count_cells,
 		.map = of_bus_default_flags_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_default_flags_get_flags,
 	},
 	/* Default */
@@ -827,7 +827,7 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 	int na = parser->na;
 	int ns = parser->ns;
 	int np = parser->pna + na + ns;
-	int busflag_na = 0;
+	int busflag_na = parser->bus->flag_cells;
 
 	if (!range)
 		return NULL;
@@ -837,10 +837,6 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 
 	range->flags = parser->bus->get_flags(parser->range);
 
-	/* A extra cell for resource flags */
-	if (parser->bus->has_flags)
-		busflag_na = 1;
-
 	range->bus_addr = of_read_number(parser->range + busflag_na, na - busflag_na);
 
 	if (parser->dma)
-- 
2.39.5



