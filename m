Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0782FDC59;
	Tue, 12 Aug 2025 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024305; cv=none; b=LCCGf0dkBnce58kMFLRqtpQbj0jWnuKMkcGjmasVE6paO6fTvx7mzR8G93+KenNF2kaGgA/QyD9WFoO0kOCUTBcSabnrVqa3rGOAoez4WZnTmC6ZU1kQC5H4l9PRVDsVn3rOszgusl0PbNF93GO4O/MJX7nzvtmqjHFOP2qSL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024305; c=relaxed/simple;
	bh=BLOs1Lk5Tdbk71oqsWiH33L+YoUx16yruVSLF3OB+YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lajjdlhr3rYYUIzsmk8S4fjFR2RKzQXV5bGG1RKgKVsDuWy2uE/PZdbc5AalUMxEULX06/5XrNRFBTptqkP3/94hJP2rOc5BIWvJOTl4M2LOU5z/u2yDACaRXfrMxJivwzG4h4KLaDDfabtXImjurzP3ywfUpeav6QiUWPzYFFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1LUfO3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1LUfO3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36327C4CEF0;
	Tue, 12 Aug 2025 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024304;
	bh=BLOs1Lk5Tdbk71oqsWiH33L+YoUx16yruVSLF3OB+YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1LUfO3PHUJBTmjpriQhscVkWpdBim5AM5JepmKSnZUb8Q2PJtAE+cTWqXwI3KfAf
	 9QF0KsjWxdBer4mSI/1DqHjEADOHtZZyEvolGVLAJTlF+BoNaXukG+L3bzevFBMwAL
	 AyRMS9yBvdD/Fc5moTeEcFE8L0D472OgtCHV6TFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Laszlo Fiat <laszlo.fiat@proton.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 333/627] PCI: dw-rockchip: Wait PCIE_RESET_CONFIG_WAIT_MS after link-up IRQ
Date: Tue, 12 Aug 2025 19:30:28 +0200
Message-ID: <20250812173431.957296566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c7eb9c5e1498882951b7583c56add0b77bfc162e ]

Per PCIe r6.0, sec 6.6.1, software must generally wait a minimum of
100ms (PCIE_RESET_CONFIG_WAIT_MS) after Link training completes before
sending a Configuration Request.

Prior to ec9fd499b9c6 ("PCI: dw-rockchip: Don't wait for link since
we can detect Link Up"), dw-rockchip used dw_pcie_wait_for_link(),
which waited between 0 and 90ms after the link came up before we
enumerate the bus, and this was apparently enough for most devices.

After ec9fd499b9c6, rockchip_pcie_rc_sys_irq_thread() started
enumeration immediately when handling the link-up IRQ, and devices
(e.g., Laszlo Fiat's PLEXTOR PX-256M8PeGN NVMe SSD) may not be ready
to handle config requests yet.

Delay PCIE_RESET_CONFIG_WAIT_MS after the link-up IRQ before starting
enumeration.

Fixes: 0e898eb8df4e ("PCI: rockchip-dwc: Add Rockchip RK356X host controller driver")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: Laszlo Fiat <laszlo.fiat@proton.me>
Link: https://patch.msgid.link/20250625102347.1205584-12-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-dw-rockchip.c b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
index 93171a392879..108d30637920 100644
--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -458,6 +458,7 @@ static irqreturn_t rockchip_pcie_rc_sys_irq_thread(int irq, void *arg)
 
 	if (reg & PCIE_RDLH_LINK_UP_CHGED) {
 		if (rockchip_pcie_link_up(pci)) {
+			msleep(PCIE_RESET_CONFIG_WAIT_MS);
 			dev_dbg(dev, "Received Link up event. Starting enumeration!\n");
 			/* Rescan the bus to enumerate endpoint devices */
 			pci_lock_rescan_remove();
-- 
2.39.5



