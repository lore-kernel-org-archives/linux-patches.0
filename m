Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8448E1E89C;
	Tue, 27 May 2025 17:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366513; cv=none; b=X5/fVIv7quKhFJgtdpe5CEqlxPpAUDb9CwwfbPfssXjclx87Om+VSXplK+zTSa4S3dvF4lWv1n1ZD8yGK1BbDsMGwFGydH/K+0mOJ5N+z9/25tixUABHyE0L6nx49mX9azIFoA35fcCd4Min/auB5gZ2dCcz2O6tQtyRSxRxP7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366513; c=relaxed/simple;
	bh=++VtEZadR+0SyJFUAlsmPuFBtPsm5+ztgHjJZUISE9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHR6YTxpmYCsXG10KfXhIRctYjHKa/NhtuZGbn3NnwdAGXQbqqtdZwGd3hRzd6+JJ6osOaHKYsw+9pSoCKYI3FaVw3wE6d3rWc9Ezx9SrBpYSpNg92ntlCu6GLT6AMkvxc1C2xYh3KK8XygupGgH8nqIsgecO3KideaS8WtIh8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C449aioS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C449aioS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A5C4CEE9;
	Tue, 27 May 2025 17:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366513;
	bh=++VtEZadR+0SyJFUAlsmPuFBtPsm5+ztgHjJZUISE9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C449aioShd+n7l/KIPNO5wBXxaxlIMOiagvGoByJ6ObAgdcJ1IAtO715EB6kIXd6X
	 Gg86n3EyhEAy4dycTqGw3TvOPX4V8yoCTXQPd5/TzQIkWKi/Xd8JUzGA/B29YRFn6J
	 1Wsr3uyFXiwfE+3mgz2aHYGVCcWuXXRKXJZODRV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 093/783] PCI: dwc: ep: Ensure proper iteration over outbound map windows
Date: Tue, 27 May 2025 18:18:10 +0200
Message-ID: <20250527162516.927941961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e41479a9ca027..c91d095024689 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -282,7 +282,7 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	u32 index;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	for (index = 0; index < pci->num_ob_windows; index++) {
+	for_each_set_bit(index, ep->ob_window_map, pci->num_ob_windows) {
 		if (ep->outbound_addr[index] != addr)
 			continue;
 		*atu_index = index;
-- 
2.39.5



