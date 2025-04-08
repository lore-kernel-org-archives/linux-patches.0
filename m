Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A96264614;
	Tue,  8 Apr 2025 11:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111100; cv=none; b=b4H3v1VpZUxtAhm5nWsWf3tzdh6PmUaBvnR/N98Ke026NJDmi0EaNFfdnA5ODzeY/hywElUDaZqxHl/ogCFQ63R5xaD5GbTDEquSRxUsvoEosS1fl3vC7a9TlgLnDb8ZSksvSuZCFBCD8UDz0VhWsno5vd/kCiMpCIhw6Sp7umg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111100; c=relaxed/simple;
	bh=MKeP33v8MfBJCf5qoaSju+O8jaEEV1a3MxcD2HGf/3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PGtg5YwzQGOu2SB2jGWVw+6gkADpOcMdTFjc2PgBKLIuFl+/yl5SEBnFHWIQpXFJrxfBwwpFidUZv/gPUNZyE2mhmLeodT6dwz2DPIoD5TJauzoOuDMk9QpZjN3nPY1wnim1Gk21alZ7osiO2kUV7PPBPeyXST9YSJNOh9/ygsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqk11jFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqk11jFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515FC4CEE5;
	Tue,  8 Apr 2025 11:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111099;
	bh=MKeP33v8MfBJCf5qoaSju+O8jaEEV1a3MxcD2HGf/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqk11jFTjHk8put8zfRGDgfMe0q6BLFwYBOjN6IDTdK1Zm3oGCz3Jdb4EWHy1cLvU
	 xA728rB0TixAZHRZ4vzwy0fUbO5zL5+uMUt3NRzdMLVdFhO2CD7tPhGImILKkaQ0FN
	 n8qbVqWbmxyawCR53pG617RryVe/UlTX+JspM6lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 309/731] PCI: brcmstb: Fix potential premature regulator disabling
Date: Tue,  8 Apr 2025 12:43:26 +0200
Message-ID: <20250408104921.464452244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit b7de1b60ecab2f7b6f05d8116e93228a0bbb8563 ]

The platform supports enabling and disabling regulators only on
ports below the Root Complex.

Thus, we need to verify this both when adding and removing the bus,
otherwise regulators may be disabled prematurely when a bus further
down the topology is removed.

Fixes: 9e6be018b263 ("PCI: brcmstb: Enable child bus device regulators from DT")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250214173944.47506-6-james.quinlan@broadcom.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 1495d770b4c2c..3d7dbfcd689e3 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1392,7 +1392,7 @@ static void brcm_pcie_remove_bus(struct pci_bus *bus)
 	struct subdev_regulators *sr = pcie->sr;
 	struct device *dev = &bus->dev;
 
-	if (!sr)
+	if (!sr || !bus->parent || !pci_is_root_bus(bus->parent))
 		return;
 
 	if (regulator_bulk_disable(sr->num_supplies, sr->supplies))
-- 
2.39.5



