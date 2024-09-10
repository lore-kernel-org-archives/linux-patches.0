Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB849190496;
	Tue, 10 Sep 2024 10:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963386; cv=none; b=W5BJ7G/yKTxKFa7/pvxJGNOzY2ocwkDjwDKKGUKxfYs9RPbIgRYpxwkJoEUZFKWBIAZA82GgCnCt4PliShGYWLdrydPV/Wwy6VxvGzaRDd/RHK2zdeKizhNxBXh0NiJ0dJWK3IOo2zTCIoUMZdmKJ4ZMRgyB6fV98jEvbSwryr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963386; c=relaxed/simple;
	bh=SbM5QXbHwyVJ1VsDbSv6Vwl7uVigReiXGdVQIz13A/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pn0XBBHCuFHGlxxQ3qklgpV2mbE5mrDKJ+tKDJI1nLvSALZzA5UEb6RLoWIwzj7UxvMWQM4zfBOaxAZcIRxB9cUhsSwH+OHFjV8MdMkBywNt2RUB1n38rG27O3C7YBvfD0aX1ayyk8UUuCw675gn3/H8Q4zJ2Gy89oretLxexR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O12Pv5aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O12Pv5aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F391C4CEC3;
	Tue, 10 Sep 2024 10:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963385;
	bh=SbM5QXbHwyVJ1VsDbSv6Vwl7uVigReiXGdVQIz13A/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O12Pv5aZL1MZ4VLJ6c0Cbtf98Ae8TPEM9WPDemXx6MvMh50G1ilX1jfGOHW+N7PK9
	 EMvbWWjM+0A5s2q9N7aE/CJqdbGK3rKU4Z1BAmzigd5oFFbqrzFk5PkV8rUiL6Sz30
	 Xv1pyY7LX6uB4syn735j72L0v43IvA1ewTOD34YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/214] PCI: al: Check IORESOURCE_BUS existence during probe
Date: Tue, 10 Sep 2024 11:31:02 +0200
Message-ID: <20240910092600.414330920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit a9927c2cac6e9831361e43a14d91277818154e6a ]

If IORESOURCE_BUS is not provided in Device Tree it will be fabricated in
of_pci_parse_bus_range(), so NULL pointer dereference should not happen
here.

But that's hard to verify, so check for NULL anyway.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-pci/20240503125705.46055-1-amishin@t-argos.ru
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-al.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-al.c b/drivers/pci/controller/dwc/pcie-al.c
index e8afa50129a8..60a0d59a533f 100644
--- a/drivers/pci/controller/dwc/pcie-al.c
+++ b/drivers/pci/controller/dwc/pcie-al.c
@@ -242,18 +242,24 @@ static struct pci_ops al_child_pci_ops = {
 	.write = pci_generic_config_write,
 };
 
-static void al_pcie_config_prepare(struct al_pcie *pcie)
+static int al_pcie_config_prepare(struct al_pcie *pcie)
 {
 	struct al_pcie_target_bus_cfg *target_bus_cfg;
 	struct pcie_port *pp = &pcie->pci->pp;
 	unsigned int ecam_bus_mask;
+	struct resource_entry *ft;
 	u32 cfg_control_offset;
+	struct resource *bus;
 	u8 subordinate_bus;
 	u8 secondary_bus;
 	u32 cfg_control;
 	u32 reg;
-	struct resource *bus = resource_list_first_type(&pp->bridge->windows, IORESOURCE_BUS)->res;
 
+	ft = resource_list_first_type(&pp->bridge->windows, IORESOURCE_BUS);
+	if (!ft)
+		return -ENODEV;
+
+	bus = ft->res;
 	target_bus_cfg = &pcie->target_bus_cfg;
 
 	ecam_bus_mask = (pcie->ecam_size >> PCIE_ECAM_BUS_SHIFT) - 1;
@@ -287,6 +293,8 @@ static void al_pcie_config_prepare(struct al_pcie *pcie)
 	       FIELD_PREP(CFG_CONTROL_SEC_BUS_MASK, secondary_bus);
 
 	al_pcie_controller_writel(pcie, cfg_control_offset, reg);
+
+	return 0;
 }
 
 static int al_pcie_host_init(struct pcie_port *pp)
@@ -305,7 +313,9 @@ static int al_pcie_host_init(struct pcie_port *pp)
 	if (rc)
 		return rc;
 
-	al_pcie_config_prepare(pcie);
+	rc = al_pcie_config_prepare(pcie);
+	if (rc)
+		return rc;
 
 	return 0;
 }
-- 
2.43.0



