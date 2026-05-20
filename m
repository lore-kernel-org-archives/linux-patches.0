Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF18372B24;
	Wed, 20 May 2026 16:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295095; cv=none; b=G8bS+UzeLhs0ZiQe9zwDJ1+4qIJ0bAQP6AcDoliZw6bu4/6CIIACCGIk/bqNfYnkiAFNxQniQaABC/eZZiSpmF8yQ6sPhXmrYV5xlomYx5dlPskJVC6utDj7rkpxWaA+WB7dhzPKMYqQOETASEzqsMkNPCPKqs2n7CFkpW4ZxOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295095; c=relaxed/simple;
	bh=xoARVbZwN/xguzliu/lptYh9aJcBzFEalZMmUJJy3xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTatJUql9RQR2Z8Yozk6m9zZLEFCtzuKxi2sr95p99pCSNQ5NMpLvsMFTSnSIcFfeWcaqQXU7P6JxCXvhtPAUIiTtvL5B3ImCji12NzDYw8FKlTNp2U+Zc5pdUlsegucnYHHHwGbpKtluqyCRIhpRUweD4dUqEbewFpeNnk2BX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qpca/dwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qpca/dwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B211F00893;
	Wed, 20 May 2026 16:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295092;
	bh=ux1qQfkXfaKs2FRn2dnNJZo56pPmrB8IImzSaDKMhuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qpca/dwfuc9oIM94xT/18rzEfWwmt8EIvNrZEnw+3ILzPxqe4wOp1JidKmYoqAW1J
	 KIsUHKwgXHbAppweAd3eax37ZvqKC9Me8pnQSyED+rr/s7RfCzFLZWGRd8UVgB37U7
	 1XsibbG1ko8qnjPjTz0yrtF0q6Im/i2P0hrfauMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH 7.0 0287/1146] PCI: rzg3s-host: Reorder reset assertion during suspend
Date: Wed, 20 May 2026 18:08:57 +0200
Message-ID: <20260520162154.711751027@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Madieu <john.madieu.xa@bp.renesas.com>

[ Upstream commit 34735f63748daa2ea27544259c3042b4948376bf ]

Reorder the reset assertion sequence during suspend from
power_resets -> cfg_resets to cfg_resets -> power_resets.
This change ensures the suspend sequence follows the reverse order
of the probe/init sequence, where power_resets are deasserted first
followed by cfg_resets.

Additionally, this ordering is required for RZ/G3E support where
cfg resets are controlled through PCIe AXI registers (offset 0x310h).
According to the RZ/G3E hardware manual (Rev.1.15, section 6.6.6.1.1
"Changing the Initial Values of the Registers"), AXI register access
requires ARESETn to be de-asserted and the clock to be supplied.
Since ARESETn is part of power_resets, cfg_resets must be asserted
before power_resets, otherwise the AXI registers become inaccessible.

Fixes: 7ef502fb35b2 ("PCI: Add Renesas RZ/G3S host controller driver")
Signed-off-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> # RZ/V2N EVK
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20260306143423.19562-3-john.madieu.xa@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index 7a80455aad366..986f0a319b3ce 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -1624,31 +1624,31 @@ static int rzg3s_pcie_suspend_noirq(struct device *dev)
 
 	clk_disable_unprepare(port->refclk);
 
-	ret = reset_control_bulk_assert(data->num_power_resets,
-					host->power_resets);
+	ret = reset_control_bulk_assert(data->num_cfg_resets,
+					host->cfg_resets);
 	if (ret)
 		goto refclk_restore;
 
-	ret = reset_control_bulk_assert(data->num_cfg_resets,
-					host->cfg_resets);
+	ret = reset_control_bulk_assert(data->num_power_resets,
+					host->power_resets);
 	if (ret)
-		goto power_resets_restore;
+		goto cfg_resets_restore;
 
 	ret = regmap_update_bits(sysc, RZG3S_SYS_PCIE_RST_RSM_B,
 				 RZG3S_SYS_PCIE_RST_RSM_B_MASK,
 				 FIELD_PREP(RZG3S_SYS_PCIE_RST_RSM_B_MASK, 0));
 	if (ret)
-		goto cfg_resets_restore;
+		goto power_resets_restore;
 
 	return 0;
 
 	/* Restore the previous state if any error happens */
-cfg_resets_restore:
-	reset_control_bulk_deassert(data->num_cfg_resets,
-				    host->cfg_resets);
 power_resets_restore:
 	reset_control_bulk_deassert(data->num_power_resets,
 				    host->power_resets);
+cfg_resets_restore:
+	reset_control_bulk_deassert(data->num_cfg_resets,
+				    host->cfg_resets);
 refclk_restore:
 	clk_prepare_enable(port->refclk);
 	pm_runtime_resume_and_get(dev);
-- 
2.53.0



