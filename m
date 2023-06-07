Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353E34CF6;
	Wed,  7 Jun 2023 20:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFC7C4339B;
	Wed,  7 Jun 2023 20:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169250;
	bh=00iCl4bqdVstjkAl+RaZcwQs98xts3crNbxHDEZdYqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6CYzpv4SwBv7wtCsMHoxmI4HXsQx7jDllt56AQomozBfzXGD//94r/hlVwQcGXPj
	 LLaj3BJnl9PAEgLuDV8Qm5rmmOvPbMPxaMn75OumC5vdFHNXT43q0e3DGi0PEUtt2H
	 dDlNd3Wf8pMpdO94DxKbDvWF23GJFAlBCsHctHlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev,
	Conor Dooley <conor@kernel.org>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 010/286] iommu: Make IPMMU_VMSA dependencies more strict
Date: Wed,  7 Jun 2023 22:11:49 +0200
Message-ID: <20230607200923.333906281@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e332003bb216a9f91e08004b9e2de0745f321290 ]

On riscv64, linux-next-20233030 (and for several days earlier),
there is a kconfig warning:

WARNING: unmet direct dependencies detected for IOMMU_IO_PGTABLE_LPAE
  Depends on [n]: IOMMU_SUPPORT [=y] && (ARM || ARM64 || COMPILE_TEST [=n]) && !GENERIC_ATOMIC64 [=n]
  Selected by [y]:
  - IPMMU_VMSA [=y] && IOMMU_SUPPORT [=y] && (ARCH_RENESAS [=y] || COMPILE_TEST [=n]) && !GENERIC_ATOMIC64 [=n]

and build errors:

riscv64-linux-ld: drivers/iommu/io-pgtable-arm.o: in function `.L140':
io-pgtable-arm.c:(.init.text+0x1e8): undefined reference to `alloc_io_pgtable_ops'
riscv64-linux-ld: drivers/iommu/io-pgtable-arm.o: in function `.L168':
io-pgtable-arm.c:(.init.text+0xab0): undefined reference to `free_io_pgtable_ops'
riscv64-linux-ld: drivers/iommu/ipmmu-vmsa.o: in function `.L140':
ipmmu-vmsa.c:(.text+0xbc4): undefined reference to `free_io_pgtable_ops'
riscv64-linux-ld: drivers/iommu/ipmmu-vmsa.o: in function `.L0 ':
ipmmu-vmsa.c:(.text+0x145e): undefined reference to `alloc_io_pgtable_ops'

Add ARM || ARM64 || COMPILE_TEST dependencies to IPMMU_VMSA to prevent
these issues, i.e., so that ARCH_RENESAS on RISC-V is not allowed.

This makes the ARCH dependencies become:
	depends on (ARCH_RENESAS && (ARM || ARM64)) || COMPILE_TEST
but that can be a bit hard to read.

Fixes: 8292493c22c8 ("riscv: Kconfig.socs: Add ARCH_RENESAS kconfig option")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev
Cc: Conor Dooley <conor@kernel.org>
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20230330165817.21920-1-rdunlap@infradead.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 889c7efd050bc..18e68fbaec884 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -287,6 +287,7 @@ config EXYNOS_IOMMU_DEBUG
 config IPMMU_VMSA
 	bool "Renesas VMSA-compatible IPMMU"
 	depends on ARCH_RENESAS || COMPILE_TEST
+	depends on ARM || ARM64 || COMPILE_TEST
 	depends on !GENERIC_ATOMIC64	# for IOMMU_IO_PGTABLE_LPAE
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
-- 
2.39.2



