Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44CF19E7F9;
	Tue, 27 May 2025 16:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364703; cv=none; b=DO1nVhinXUnCKalwymxvJH92dbaX6OvXUFV/4e9UXl48H3orYnd5NiWMbZSJN7DUE0XpnMUOjIvgn1b0gzEGGyDBKVHcXEe2xdeEElftvyi0+nSfyThTL79QPTpuzHSHV699ydPGtTd6isLQq5kW4UrLyjKbAylCLi/3D0dEn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364703; c=relaxed/simple;
	bh=N4IYj2ToIyL37awS/jarbWkf7Cw7rwi+36uJNrL8I9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfPK8j4L94qLDTbHqITsCsr23+YhzhPKeW96WTF2nGCbG/HPAczTe6eUe1+9z2IuBAF8vV1WEzpkEmkrplA5DHTk4B0fVQpdVjdj41+6SR6vNXkNmBdYhG9FJy1WvHmNOrxDXUfLQ+wTbEm3hmQl0aIJN11SpYkcpX+XPnU4qgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz5uoP3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz5uoP3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525BDC4CEE9;
	Tue, 27 May 2025 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364702;
	bh=N4IYj2ToIyL37awS/jarbWkf7Cw7rwi+36uJNrL8I9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lz5uoP3c1+lmQM8syauDQHfoN3lEpP6rlx4e0LQQ5t0LUkGsgIuko+QBP8TvR/jBC
	 Fj5JDTFfy2X+0uz+bZQd3WcYLYXsDolTIni/lHUfJ/IDLPGzxyy+vXBPqdltte0g7T
	 wmBYLOzO7pwsnW+qnRtcHz++vwDg9ejSNRNwHHZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/626] PCI: dwc: Use resource start as ioremap() input in dw_pcie_pme_turn_off()
Date: Tue, 27 May 2025 18:20:32 +0200
Message-ID: <20250527162450.680502112@linuxfoundation.org>
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

[ Upstream commit 8f4a489b370e6612700aa16b9e4373b2d85d7503 ]

The msg_res region translates writes into PCIe Message TLPs. Previously we
mapped this region using atu.cpu_addr, the input address programmed into
the ATU.

"cpu_addr" is a misnomer because when a bus fabric translates addresses
between the CPU and the ATU, the ATU input address is different from the
CPU address.  A future patch will rename "cpu_addr" and correct the value
to be the ATU input address instead of the CPU physical address.

Map the msg_res region before writing to it using the msg_res resource
start, a CPU physical address.

Link: https://lore.kernel.org/r/20250315201548.858189-2-helgaas@kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 120e2aca5164a..d428457d9c432 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -902,7 +902,7 @@ static int dw_pcie_pme_turn_off(struct dw_pcie *pci)
 	if (ret)
 		return ret;
 
-	mem = ioremap(atu.cpu_addr, pci->region_align);
+	mem = ioremap(pci->pp.msg_res->start, pci->region_align);
 	if (!mem)
 		return -ENOMEM;
 
-- 
2.39.5



