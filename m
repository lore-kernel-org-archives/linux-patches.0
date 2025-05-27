Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB18427CB04;
	Tue, 27 May 2025 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364532; cv=none; b=bqRCdCPKiqe9y8OwzNa+zrazguwXh81N4a6ZbX+nrAD8DpVCgYr9mAoI+4GCwqlbV6orEFWhRbEAhZG688C4XGIQZVm2mT6io2QZmKPJM6PUVdcQKHCfhZJ5W4S9L0nocBrUsbM44t0FWuZxtlpCESvmgMUHg6+cGW1fSywAsV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364532; c=relaxed/simple;
	bh=cZq5XeWKLrrBbNyGURlSUbFRK5niGHf/KS20bYSGWKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3jNVNMgb41qmqKz/7IjzUu3MeqTLrT98tKB4Kk59oeBRi0KFKozGsh+NMYPD43SjpniqjdP/7M5k1hO9ff3AoiWCTuu+R1wytpdl71yvyHzq5KeWowFtEQgzRqh8IFMkhM940u4y1/ohVxuyT73DUKQP24Xzj17MaO7pKCv+3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkWYMzui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkWYMzui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19561C4CEE9;
	Tue, 27 May 2025 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364532;
	bh=cZq5XeWKLrrBbNyGURlSUbFRK5niGHf/KS20bYSGWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkWYMzuiOAldA2GS5WwF6wSrxHqajLvTsHWkCyx+4J2IjdEG7ywuvpT1oacMyq4pk
	 Kz1JhbWB+N9u8AO8V5rqoW861vgVl5fwC6uEV0iOaRyYlt4+ab3oxdbM9t7nfwRQI9
	 DC3A/L0fxQdat4bxzURAaOrm4nVdMr1lB/+DCin8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/626] PCI: dwc: ep: Ensure proper iteration over outbound map windows
Date: Tue, 27 May 2025 18:19:40 +0200
Message-ID: <20250527162448.577681730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dea19250598a6..9e7e94f32b436 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -280,7 +280,7 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	u32 index;
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
-	for (index = 0; index < pci->num_ob_windows; index++) {
+	for_each_set_bit(index, ep->ob_window_map, pci->num_ob_windows) {
 		if (ep->outbound_addr[index] != addr)
 			continue;
 		*atu_index = index;
-- 
2.39.5



