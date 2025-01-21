Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21EA1F666C;
	Tue, 21 Jan 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482985; cv=none; b=f9LZGEQp5pLLSdMdgZeddKr7YBb7Nig9WHfYCRVeDJHfdxtlcvW5GeUKN6s4U+U3+oRURBYugA/Ivc3jmamLhmVQcJI1RXPCSY+CfSfmhM1m0koMzGnzin0lytGvEQoJ3bN43kpJZfEmonaMsLECMOEi2nRj5FdXu/ZSoU7AnvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482985; c=relaxed/simple;
	bh=XzVTT46amEJkyj5zYaocMDNYwdnhXT1ssF2akmjEouc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfKfmd3PAFg3eLvn3PjSlVSO2FoQSvbzwBJJqCRln1IiyGT8yPLukuMhMdNeyH3BqljISOhHKoHPwJiuKx4e+bXeu5o1I1VuBfa12ZayLD8OvtpxzG3V4NjJgyvEkWQ8C23AGZDoevMPk1GG20bVgDU/VpvInIUoulwGc5wgrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBVNxAXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBVNxAXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107B5C4CEDF;
	Tue, 21 Jan 2025 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482985;
	bh=XzVTT46amEJkyj5zYaocMDNYwdnhXT1ssF2akmjEouc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBVNxAXFHM9+MwlTD6n4QDsv13SClsfT/TVJtDO/T057lLYIMtWVmBL0SLygPuFjs
	 hWVv68ekhNAYNGygyucjOg7bj0kcWNvxWsQFHEMraqEmsO/CMwxte0cOTsoqo7fBt3
	 ehA7yVpzkSBzwwkR+eanASMztz/7YvmPWcUygue4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/127] of: address: Store number of bus flag cells rather than bool
Date: Tue, 21 Jan 2025 18:52:21 +0100
Message-ID: <20250121174532.329825444@linuxfoundation.org>
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
index b8e015af59df..123a75a19bc1 100644
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
@@ -751,7 +751,7 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 	int na = parser->na;
 	int ns = parser->ns;
 	int np = parser->pna + na + ns;
-	int busflag_na = 0;
+	int busflag_na = parser->bus->flag_cells;
 
 	if (!range)
 		return NULL;
@@ -761,10 +761,6 @@ struct of_pci_range *of_pci_range_parser_one(struct of_pci_range_parser *parser,
 
 	range->flags = parser->bus->get_flags(parser->range);
 
-	/* A extra cell for resource flags */
-	if (parser->bus->has_flags)
-		busflag_na = 1;
-
 	range->bus_addr = of_read_number(parser->range + busflag_na, na - busflag_na);
 
 	if (parser->dma)
-- 
2.39.5



