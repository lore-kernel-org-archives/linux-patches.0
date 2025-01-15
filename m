Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF40248BAC;
	Wed, 15 Jan 2025 10:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937807; cv=none; b=fnPm/eFcJpZvAM4+Fbo/080kxlQiP/1xwSOQccCA8il8R8IKrwEh4zGbgeP7PcOil8BlvJ9xi+frl5/6GAkYAy1ubnxGqPTbNsD6Pq/10umJxEDlKbfs1GXdo5ZnObORfrr2OxgR8iNrmKjJtT9cpmCcVPK5siTWdILkAMpCeew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937807; c=relaxed/simple;
	bh=d8Tc9DtV/eu/aAJfuyAp0GgVjfQ9r1wyQa+/nhXNnMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHpprOMF26C9u6FPIsxqRNxhsEYKLGXuNT+Xe20FMxn2DUMGeLfzTRDH7JkAdfflHR+mXZtf8VVFWsfC/BPJB9kiaYejj0oEFh4LoKTqSBubVjGwp/2ETB/K3dHLOTSBFLIE/AFTxFR3eLdrcfNJrVgNRhJ0+XGbVQrkDCtlgzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JG1AT82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JG1AT82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E68C4CEE1;
	Wed, 15 Jan 2025 10:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937807;
	bh=d8Tc9DtV/eu/aAJfuyAp0GgVjfQ9r1wyQa+/nhXNnMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JG1AT82HZp/NJtkURO6WnFjigOmwNMbyEVKwl60elexsDHJqm3AJTT3pT9qbsIbC
	 CEwx36hg4LDnzFontTA/3fUoFnWOL8eNtdv3AauvcPVhfm5uw//AuBmLT0ph2cZxnZ
	 l8LVMa7AE7dLxUz+xy0eD2NmAwhVsDXMQ3mCaghY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 87/92] of: address: Store number of bus flag cells rather than bool
Date: Wed, 15 Jan 2025 11:37:45 +0100
Message-ID: <20250115103551.044103657@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 39abcad30ddb..596381e70c0a 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -50,7 +50,7 @@ struct of_bus {
 	u64		(*map)(__be32 *addr, const __be32 *range,
 				int na, int ns, int pna);
 	int		(*translate)(__be32 *addr, u64 offset, int na);
-	bool	has_flags;
+	int		flag_cells;
 	unsigned int	(*get_flags)(const __be32 *addr);
 };
 
@@ -361,7 +361,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_pci_count_cells,
 		.map = of_bus_pci_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_pci_get_flags,
 	},
 #endif /* CONFIG_PCI */
@@ -373,7 +373,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_isa_count_cells,
 		.map = of_bus_isa_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_isa_get_flags,
 	},
 	/* Default with flags cell */
@@ -384,7 +384,7 @@ static struct of_bus of_busses[] = {
 		.count_cells = of_bus_default_count_cells,
 		.map = of_bus_default_flags_map,
 		.translate = of_bus_default_flags_translate,
-		.has_flags = true,
+		.flag_cells = 1,
 		.get_flags = of_bus_default_flags_get_flags,
 	},
 	/* Default */
@@ -753,7 +753,7 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 	int na = parser->na;
 	int ns = parser->ns;
 	int np = parser->pna + na + ns;
-	int busflag_na = 0;
+	int busflag_na = parser->bus->flag_cells;
 
 	if (!range)
 		return NULL;
@@ -763,10 +763,6 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 
 	range->flags = parser->bus->get_flags(parser->range);
 
-	/* A extra cell for resource flags */
-	if (parser->bus->has_flags)
-		busflag_na = 1;
-
 	range->bus_addr = of_read_number(parser->range + busflag_na, na - busflag_na);
 
 	if (parser->dma)
-- 
2.39.5



