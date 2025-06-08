Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2020E328;
	Sun,  8 Jun 2025 12:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387297; cv=none; b=ic88NVDCYLnSFdWIBfzukB2dM6uZOzrNwLd9767qFJ9TAqxQzfrvWKDDu+lsYsJUJFUzAavFJ/N2pxq2K9ViAQvcyVa3Df9Np10X8whvhuEActERMoPuXojYxL0tQSG2qji8pCJ2DZT737Oe0Qjq03Vh4apORQBGDivQbE/C2XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387297; c=relaxed/simple;
	bh=y8zNO5ZlgQghuwgH6Bx9L5vaMjZKgqaTzZd6btl07MQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F5BURPpO/b6ejWOK7BTorVvzi5AFgpwJIDtJF9zHFWQmt0mquZjIKDM4pu3S1f3/yEWShkg41oJkD3vnL16ekY36ZI77njMaVDHZXsur/RaRE1j86+J4tIDhYqdwaLo4OnwFJ59ea/eiMObnnYUm5UXNw5MQml/2NBAn+a/qKts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Za+iVOTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Za+iVOTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7727EC4CEF5;
	Sun,  8 Jun 2025 12:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387297;
	bh=y8zNO5ZlgQghuwgH6Bx9L5vaMjZKgqaTzZd6btl07MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za+iVOTxAll4DPhn/Ym/L6rcYEGE4rX+KY7K/TU79g4CG5lYXhVUJmnBF2XBWpC6y
	 0ac/Uiruxu4nx9dzVwIV0ckcmApiLPtcNooVY6CEcZSHmEj+cLE6QxZCCHQXN9iLQ0
	 NiS+KlMSKPazSVjxvdrYJaxu0XCDwCZE4y5SKW+nyulb3NH5jMHMXhRbQY2G+Fhiah
	 vEv+IuKpEBCwWxkO4jgZ5I9xtWYS45DffoaidiAprU+04Ez5a3lSBzLZ/bV+ctJGaJ
	 TkfTU1zD9aLbiTrzNyykD12iSEE76/MsVwQRa0QU9+QNCQdU+Zvn8+ENgoE62YLByB
	 tIrukM4ITW0FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 05/10] Revert "iommu/amd: Prevent binding other PCI drivers to IOMMU PCI devices"
Date: Sun,  8 Jun 2025 08:54:42 -0400
Message-Id: <20250608125447.933686-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608125447.933686-1-sashal@kernel.org>
References: <20250608125447.933686-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Transfer-Encoding: 8bit

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

**YES**

This commit should be backported to stable kernel trees.

**Extensive Analysis:**

**1. Context and Purpose:**
This commit is part of a coordinated series of reverts addressing
regressions introduced by commit 991de2e59090 ("PCI, x86: Implement
pcibios_alloc_irq() and pcibios_free_irq()") which broke system
suspend/resume on AMD platforms in v4.3. The original issue was fixed by
two independent commits, one of which (cbbc00be2ce3) added the line
`iommu->dev->match_driver = false;` to prevent other PCI drivers from
binding to IOMMU devices.

**2. Code Change Analysis:**
The commit removes exactly one line from
`drivers/iommu/amd/init.c:2034`:
```c
/* Prevent binding other PCI device drivers to IOMMU devices */
iommu->dev->match_driver = false;
```

This line was setting the `match_driver` field of `struct pci_dev`,
which the commit message correctly identifies as "internal to the PCI
core and not supposed to be touched by arbitrary drivers."

**3. Why This Should Be Backported:**

**a) Part of Coordinated Fix Series:** This revert is the logical
completion of a series of reverts that fixed major regressions. Looking
at the similar commits provided as examples:
- Similar Commit #1 (YES): Revert of x86/PCI pcibios-irq allocation
- Similar Commit #2 (YES): Revert of PCI IRQ management helpers
- Similar Commit #5 (YES): Revert of the original problematic
  pcibios_alloc_irq implementation

All these related reverts were marked for backporting, making this
commit part of the same logical fix series.

**b) Removes Inappropriate Code:** The commit eliminates code that
violates kernel design principles by accessing internal PCI core
structures from a driver. The `match_driver` field is not meant to be
manipulated by individual drivers.

**c) Cleanup After Main Fix:** Once the root cause (commit 991de2e59090)
was reverted by commit 6c777e8799a9, the workaround became unnecessary.
Keeping unnecessary workaround code, especially code that
inappropriately accesses internal structures, is problematic.

**d) Minimal Risk:** The change is extremely small and low-risk - it
simply removes one line that was setting an internal field
inappropriately.

**e) Consistency and Completeness:** Since the other reverts in this
series addressing the 991de2e59090 regressions were backported, this
should be included for consistency and to ensure the cleanup is
complete.

**4. Stable Tree Criteria Met:**
- ✅ Fixes inappropriate driver behavior (accessing internal PCI
  structures)
- ✅ Small and contained change
- ✅ Part of a series addressing known regressions
- ✅ Minimal risk of introducing new issues
- ✅ Consistent with backporting decisions for related commits

The commit represents necessary cleanup after a coordinated regression
fix and should be backported to maintain consistency with the related
reverts and to remove code that inappropriately accesses internal kernel
structures.

 drivers/iommu/amd/init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index fb82f8035c0f2..9debf20bdf869 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2038,9 +2038,6 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 	if (!iommu->dev)
 		return -ENODEV;
 
-	/* Prevent binding other PCI device drivers to IOMMU devices */
-	iommu->dev->match_driver = false;
-
 	/* ACPI _PRT won't have an IRQ for IOMMU */
 	iommu->dev->irq_managed = 1;
 
-- 
2.39.5

