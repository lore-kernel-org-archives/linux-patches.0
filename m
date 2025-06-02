Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AAA22A7E5;
	Mon,  2 Jun 2025 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876773; cv=none; b=umlC+PzDhWWHP58x4a0JaPhEbLnKXn6LGv7CkyIetflLk6kLB2j84iZZFQ+LVjlxQSPMy89WO6oG7jES4lKoWnZ6Gti+yuxj79VgrKRjNyc2fFfC7cQWekQlPhT5gCdLIKP4QGpzOK/HyTd8LtXQCy0zbU8HbISd6XykfooUVtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876773; c=relaxed/simple;
	bh=gCigCg7p8OAvWKrGxmq79QrN1or2qcOExuVYTOimGAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxiPhp2QEc6MX7O8oJ8Vrd7faSACzVgH33cldY5wm+sUjQoa8iQ/efEGRhQGd12/A0PyXbiik7L5Af8xd7EwPtdCU0hq6bqrxERqnesOmfNwQ/cjGKx4tAF2OXOygChM1Wtl8134jM4hjeCH8iR8mufIF5MJi4nInLjJAHPu9Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwuz+qCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwuz+qCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C0EC4CEEB;
	Mon,  2 Jun 2025 15:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876773;
	bh=gCigCg7p8OAvWKrGxmq79QrN1or2qcOExuVYTOimGAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwuz+qCn5QgV83O/kXcDYDgRBprGNpUFM8LBkPQPJ15buLF41I/OvP4wqxbpnJyCM
	 AhPzjUMKfFTqUm8NPlV6Ok7acwrPAjTxhySyGH2CDqg+BniUOpid6JnYimtqeIAPi5
	 1HmPqmXv9yuEGTj7IOAmWLVeiXcOVwA7F11RjikA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/325] PCI: dwc: ep: Ensure proper iteration over outbound map windows
Date: Mon,  2 Jun 2025 15:45:18 +0200
Message-ID: <20250602134321.460841127@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit f3e1dccba0a0833fc9a05fb838ebeb6ea4ca0e1a ]

Most systems' PCIe outbound map windows have non-zero physical addresses,
but the possibility of encountering zero increased after following commit
("PCI: dwc: Use parent_bus_offset").

'ep->outbound_addr[n]', representing 'parent_bus_address', might be 0 on
some hardware, which trims high address bits through bus fabric before
sending to the PCIe controller.

Replace the iteration logic with 'for_each_set_bit()' to ensure only
allocated map windows are iterated when determining the ATU index from a
given address.

Link: https://lore.kernel.org/r/20250315201548.858189-12-helgaas@kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 449ad709495d3..3b3f079d0d2dd 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -283,7 +283,7 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	u32 index;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	for (index = 0; index < pci->num_ob_windows; index++) {
+	for_each_set_bit(index, ep->ob_window_map, pci->num_ob_windows) {
 		if (ep->outbound_addr[index] != addr)
 			continue;
 		*atu_index = index;
-- 
2.39.5



