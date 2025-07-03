Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7692EE29F;
	Thu,  3 Jul 2025 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553910; cv=none; b=u3nfIrmHK9BL58asXHk7CLo+7Gheiq6EKJOCvhBsOebi74ICHAwo64MDHvMVmuAqHQpTNjnpmqVYzIYHD6sZ+h/pqjkKP7rrpfthGXPuV2FkoJv/QNwq5wNLS+Fn+eqi/MSnc8ZozcwdrDTDmCYYot3nC3rsN5eNhLE5Ki5nL+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553910; c=relaxed/simple;
	bh=IOfyN11FxBvRUTkiziqYajUsVPa8xXVHrVIiQuJi8l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBOEc/CITmnsCrvwcDreWG9rE6lG3NMbZEuMAK4YPdyAn94KIrYh6P1Ml3fOJoaTy3TWJ5VDzXAGzmByt8nLmWf9+ZAjReDMwhje13gUCvhsTvcRM7YFosLGbvNCVxYwwpbKX6i4I66vqvXRDCkglRvA9fII9f2F66rDX0tbaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYfOvDz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYfOvDz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5586C4CEED;
	Thu,  3 Jul 2025 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553910;
	bh=IOfyN11FxBvRUTkiziqYajUsVPa8xXVHrVIiQuJi8l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYfOvDz4DM7c3JX18mSsvNeCDL/jwIxXMqDjBe5GlHDCTNOv35+abGpkZ2QTJ0g2V
	 jz27dU6eFY2iNoc/Awuz/2MwnwjidhqR1N9lYVuDDb6jAXhih3OF08+AV4EH0/LKKM
	 FkgyOUnyxsbwfuzzbVCsv9aXErosTh9mfVimLFl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/218] Revert "iommu/amd: Prevent binding other PCI drivers to IOMMU PCI devices"
Date: Thu,  3 Jul 2025 16:39:28 +0200
Message-ID: <20250703143956.766086832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3be5fa236649da6404f1bca1491bf02d4b0d5cce ]

Commit 991de2e59090 ("PCI, x86: Implement pcibios_alloc_irq() and
pcibios_free_irq()") changed IRQ handling on PCI driver probing.
It inadvertently broke resume from system sleep on AMD platforms:

  https://lore.kernel.org/r/20150926164651.GA3640@pd.tnic/

This was fixed by two independent commits:

* 8affb487d4a4 ("x86/PCI: Don't alloc pcibios-irq when MSI is enabled")
* cbbc00be2ce3 ("iommu/amd: Prevent binding other PCI drivers to IOMMU PCI devices")

The breaking change and one of these two fixes were subsequently reverted:

* fe25d078874f ("Revert "x86/PCI: Don't alloc pcibios-irq when MSI is enabled"")
* 6c777e8799a9 ("Revert "PCI, x86: Implement pcibios_alloc_irq() and pcibios_free_irq()"")

This rendered the second fix unnecessary, so revert it as well.  It used
the match_driver flag in struct pci_dev, which is internal to the PCI core
and not supposed to be touched by arbitrary drivers.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Joerg Roedel <jroedel@suse.de>
Link: https://patch.msgid.link/9a3ddff5cc49512044f963ba0904347bd404094d.1745572340.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ff11cd7e5c068..b8b10140d41b2 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2026,9 +2026,6 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 	if (!iommu->dev)
 		return -ENODEV;
 
-	/* Prevent binding other PCI device drivers to IOMMU devices */
-	iommu->dev->match_driver = false;
-
 	/* ACPI _PRT won't have an IRQ for IOMMU */
 	iommu->dev->irq_managed = 1;
 
-- 
2.39.5



