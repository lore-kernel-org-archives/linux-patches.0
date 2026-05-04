Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995F235A3AD;
	Mon,  4 May 2026 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903840; cv=none; b=Bv9dQn0PqM2odpZ20OE3CSB1Zh34blh/YQwafv/Deg098bfRS3qLy4/81ZsOaAtdUOopEL7vZ75iXoJHkSPhGRtLyScOWOdQLLbkwnWin4JZPHFHLOeV3FOeBTObRRIYxUpgSoYZwTmaglIhyvIK/hME8IL717KWjLssk9m/Y8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903840; c=relaxed/simple;
	bh=UBUit4U5UgBIIPMyJnc8InctffwEZT5JZs/xmXCCYxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSugALcJGZcD7VYaMd85rSBjE/2D3cpvDVD0ZNGRMZVNKaLe877D56FWUYH4FRtdM5LaBQ3kzAGEnCtURkA7K+66y7g4psQVyFs+kcHKBx1EmGDjJFxzrLYJ3IJhcUXOoDGyv8RAGBobAIf77gaH7KLIWN/ZPbvgE8Hotjc6Tlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUbLfuPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUbLfuPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B5EC2BCB8;
	Mon,  4 May 2026 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903840;
	bh=UBUit4U5UgBIIPMyJnc8InctffwEZT5JZs/xmXCCYxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUbLfuPy3zGF1aD7rvqXDKuwAu+a4xB672M8+K9h6MLTXgWX4PfntKaJH/J4FDn13
	 ybZJvUOIoeF/J7nsotleRqw9O/1DXevVZPeQfPj84r14tkWkHng0r3nsAI0RU1qKkW
	 jDRdDkm7FcQ1FW01Zi5xAC7w8SY8TowkcnghHO3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.18 081/275] PCI: cadence: Use cdns_pcie_read_sz() for byte or word read access
Date: Mon,  4 May 2026 15:50:21 +0200
Message-ID: <20260504135145.934354592@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

commit d9cf7154deed71a4f23e81101571c79cdc77be00 upstream.

The commit 18ac51ae9df9 ("PCI: cadence: Implement capability search
using PCI core APIs") assumed all the platforms using Cadence PCIe
controller support byte and word register accesses. This is not true
for all platforms (e.g., TI J721E SoC, which only supports dword
register accesses).

This causes capability searches via cdns_pcie_find_capability() to fail
on such platforms.

Fix this by using cdns_pcie_read_sz() for config read functions, which
properly handles size-aligned accesses. Remove the now-unused byte and
word read wrapper functions (cdns_pcie_readw and cdns_pcie_readb).

Fixes: 18ac51ae9df9 ("PCI: cadence: Implement capability search using PCI core APIs")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260402085545.284457-1-a-garg7@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/cadence/pcie-cadence.h |   56 +++++++++++---------------
 1 file changed, 25 insertions(+), 31 deletions(-)

--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -362,37 +362,6 @@ static inline u32 cdns_pcie_readl(struct
 	return readl(pcie->reg_base + reg);
 }
 
-static inline u16 cdns_pcie_readw(struct cdns_pcie *pcie, u32 reg)
-{
-	return readw(pcie->reg_base + reg);
-}
-
-static inline u8 cdns_pcie_readb(struct cdns_pcie *pcie, u32 reg)
-{
-	return readb(pcie->reg_base + reg);
-}
-
-static inline int cdns_pcie_read_cfg_byte(struct cdns_pcie *pcie, int where,
-					  u8 *val)
-{
-	*val = cdns_pcie_readb(pcie, where);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static inline int cdns_pcie_read_cfg_word(struct cdns_pcie *pcie, int where,
-					  u16 *val)
-{
-	*val = cdns_pcie_readw(pcie, where);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static inline int cdns_pcie_read_cfg_dword(struct cdns_pcie *pcie, int where,
-					   u32 *val)
-{
-	*val = cdns_pcie_readl(pcie, where);
-	return PCIBIOS_SUCCESSFUL;
-}
-
 static inline u32 cdns_pcie_read_sz(void __iomem *addr, int size)
 {
 	void __iomem *aligned_addr = PTR_ALIGN_DOWN(addr, 0x4);
@@ -433,6 +402,31 @@ static inline void cdns_pcie_write_sz(vo
 	writel(val, aligned_addr);
 }
 
+static inline int cdns_pcie_read_cfg_byte(struct cdns_pcie *pcie, int where,
+					  u8 *val)
+{
+	void __iomem *addr = pcie->reg_base + where;
+
+	*val = cdns_pcie_read_sz(addr, 0x1);
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static inline int cdns_pcie_read_cfg_word(struct cdns_pcie *pcie, int where,
+					  u16 *val)
+{
+	void __iomem *addr = pcie->reg_base + where;
+
+	*val = cdns_pcie_read_sz(addr, 0x2);
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static inline int cdns_pcie_read_cfg_dword(struct cdns_pcie *pcie, int where,
+					   u32 *val)
+{
+	*val = cdns_pcie_readl(pcie, where);
+	return PCIBIOS_SUCCESSFUL;
+}
+
 /* Root Port register access */
 static inline void cdns_pcie_rp_writeb(struct cdns_pcie *pcie,
 				       u32 reg, u8 value)


