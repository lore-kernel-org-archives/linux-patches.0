Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5559C12B7E;
	Sat,  3 Feb 2024 04:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933673; cv=none; b=dQNeMJqBW63R3mucFzsvdUuBP4mvlESunzYYqRZpdvKXerr6xiIUut7+nFDSH4n7xqf7E1W0Qjg9WphfLmsFc6cy1J673li5sUCbnbBSKAs8M0VOuLHSdyBsSZ/puJELpRFnqysctNXJPsiV/HgQnvPplCGSUiq3/Uc4J0lwikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933673; c=relaxed/simple;
	bh=B1nc5D2aEBW/981f5YcIqnTIbn7kg8UnPjUIOmbWeFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrRm9D9qyLFE0UlnDkbqNtHQ8ZsAYjGwJXlprAIovC2aTFfab4uerL8gVrCASTeMvJh7h/uyPTSGqem88jQ0FciHyUEH4SuKvTNE8S9pfaHfOAzXcmu0vXphaNmPoUc+LL5LW2DzmqlI2F6cOAjsRHVZb3ATou9xFnBPwXwFM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j6OqYGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j6OqYGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B608C43390;
	Sat,  3 Feb 2024 04:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933673;
	bh=B1nc5D2aEBW/981f5YcIqnTIbn7kg8UnPjUIOmbWeFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j6OqYGtb0B8/xBD3F0y49kjtEczOnAc6MRzbm0efzDguCOh743z6dwPF8+qBRRfv
	 gVqj1teaDgpMji9/z5nEtbFr4y+32GmByzxa/uIYEX6XyHGU3GOloPk74JDBdAQwBo
	 h6rIa7nADT25rS71nCBW6lmVNiuGWWQ9S6px2ufc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/322] PCI: Fix 64GT/s effective data rate calculation
Date: Fri,  2 Feb 2024 20:05:37 -0800
Message-ID: <20240203035406.934711137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ac4f1897fa5433a1b07a625503a91b6aa9d7e643 ]

Unlike the lower rates, the PCIe 64GT/s Data Rate uses 1b/1b encoding, not
128b/130b (PCIe r6.1 sec 1.2, Table 1-1).  Correct the PCIE_SPEED2MBS_ENC()
calculation to reflect that.

Link: https://lore.kernel.org/r/20240102172701.65501-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5484048f457d..99abc4cec0df 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -269,7 +269,7 @@ void pci_bus_put(struct pci_bus *bus);
 
 /* PCIe speed to Mb/s reduced by encoding overhead */
 #define PCIE_SPEED2MBS_ENC(speed) \
-	((speed) == PCIE_SPEED_64_0GT ? 64000*128/130 : \
+	((speed) == PCIE_SPEED_64_0GT ? 64000*1/1 : \
 	 (speed) == PCIE_SPEED_32_0GT ? 32000*128/130 : \
 	 (speed) == PCIE_SPEED_16_0GT ? 16000*128/130 : \
 	 (speed) == PCIE_SPEED_8_0GT  ?  8000*128/130 : \
-- 
2.43.0



