Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6541D372228;
	Sat, 28 Feb 2026 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301477; cv=none; b=dITRx0erhgL7you/MDNkSoBZxgKLETIiyuHq9RzGVNsN8Y3dsVsmDGIamTQ6Y7ECVXVl4q4GsEM93Gs0eZ7JICrE/vIVjz8D4tfL06/mTloQpW5phrDSwnYjrSArbIFtxGQHNRGoZiL5u40gnS94m86ggPwEOKjdepZ7Qc+4rq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301477; c=relaxed/simple;
	bh=POVVDLSYNt4aqCKww6t4rhfVjfjD+cYHX5CfY2Bk1SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyFn6B8QZieG3+9nYhrHioPUWf+DhVE6MCXVT5dmcitgbVaSQF1s88zQDjdFZdhJJmxW6Mlx1CzOZ9WOQIt9cxbLWf3y8QOxax4UV/uTfJA7SLntfT60IaG+OVAZdMkKy9jwCv6bznick3raD1zrku8vUv+YQ/Er2v8e4kfbBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSx10ZQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSx10ZQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D08C116D0;
	Sat, 28 Feb 2026 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301477;
	bh=POVVDLSYNt4aqCKww6t4rhfVjfjD+cYHX5CfY2Bk1SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSx10ZQc04LVd9/DjiS2w+XCGKJAoq3iXACtiCq+THRoMX8xiscYhoE2WBvGv3jC9
	 DEbtmDMHNF4SvmDoZSb47eVgc817bhR6l3KqBomXVHQRFiOnOkGj9c2q8QaKbkTDEv
	 RMkuJb0sngoSVodbEqdCuWaeHj9L9Ux6xyIlP0EzvKH33rxK4zQC0gJaydp6sEvIJR
	 +8HXH25Tr6F2coVPpL81y/5dWlfb+z3hHbVynRxW/cS/jKVZns04i03saFreqprmy/
	 YcHzcHO9ExWGo4Ca1j8Yo34B50H/f7i62hZCIrwSPw50qYnykj+lYen7N2cLq4F5RR
	 R62vLKIKdh4jQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Rong Zhang <rongrong@oss.cipunited.com>,
	stable@vger.kernel.org,
	Beiyan Yun <root@infi.wang>,
	Yao Zi <me@ziyao.cc>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 662/752] MIPS: Loongson2ef: Use pcibios_align_resource() to block io range
Date: Sat, 28 Feb 2026 12:46:13 -0500
Message-ID: <20260228174750.1542406-662-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rong Zhang <rongrong@oss.cipunited.com>

[ Upstream commit 32ec465103527ede09b640cd0ab0636dc58827fb ]

Loongson2ef reserves io range below 0x4000 (LOONGSON_PCI_IO_START) while
ISA-mode only IDE controller on the south bridge still has a hard
dependency on ISA IO ports.

The reservation was done by lifting loongson_pci_io_resource.start onto
0x4000. Prior to commit ae81aad5c2e1 ("MIPS: PCI: Use
pci_enable_resources()"), the arch specific pcibios_enable_resources()
did not check if the resources were claimed, which diverges from what
PCI core checks, effectively hiding the fact that IDE IO resources were
not properly within the resource tree. After starting to use
pcibios_enable_resources() from PCI core, enabling IDE controller fails:

  pata_cs5536 0000:00:0e.2: BAR 0 [io  0x01f0-0x01f7]: not claimed; can't enable device
  pata_cs5536 0000:00:0e.2: probe with driver pata_cs5536 failed with error -22

MIPS PCI code already has support for enforcing lower bounds using
PCIBIOS_MIN_IO in pcibios_align_resource() without altering the IO
window start address itself. Make Loongson2ef PCI code use
PCIBIOS_MIN_IO too.

Fixes: ae81aad5c2e1 ("MIPS: PCI: Use pci_enable_resources()")
Cc: stable@vger.kernel.org
Tested-by: Beiyan Yun <root@infi.wang>
Tested-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Rong Zhang <rongrong@oss.cipunited.com>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson2ef/common/pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/mips/loongson2ef/common/pci.c b/arch/mips/loongson2ef/common/pci.c
index 55524f9a7b96b..0f11392104bfd 100644
--- a/arch/mips/loongson2ef/common/pci.c
+++ b/arch/mips/loongson2ef/common/pci.c
@@ -17,7 +17,7 @@ static struct resource loongson_pci_mem_resource = {
 
 static struct resource loongson_pci_io_resource = {
 	.name	= "pci io space",
-	.start	= LOONGSON_PCI_IO_START,
+	.start	= 0x00000000UL, /* See loongson2ef_pcibios_init(). */
 	.end	= IO_SPACE_LIMIT,
 	.flags	= IORESOURCE_IO,
 };
@@ -77,6 +77,15 @@ void __init loongson2ef_pcibios_init(void)
 {
 	setup_pcimap();
 
+	/*
+	 * ISA-mode only IDE controllers have a hard dependency on ISA IO ports.
+	 *
+	 * Claim them by setting PCI IO space to start at 0x00000000, and set
+	 * PCIBIOS_MIN_IO to prevent non-legacy PCI devices from touching
+	 * reserved regions.
+	 */
+	PCIBIOS_MIN_IO = LOONGSON_PCI_IO_START;
+
 	loongson_pci_controller.io_map_base = mips_io_port_base;
 	register_pci_controller(&loongson_pci_controller);
 }
-- 
2.51.0

