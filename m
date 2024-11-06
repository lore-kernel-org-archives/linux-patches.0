Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BD14207F;
	Wed,  6 Nov 2024 12:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896233; cv=none; b=BQrw6yEfgGnSKiwGCXYiWBVDF1gz0FKvxZD0yEFJpVuKbIVZFT6e2XFxi3U3M2gOhc1AusIQE4wDRALEwgEeOsxrzUS2bzKZqvOCih7wVcrcERkFRVXZb0Rmh0YTNBfc1NCmS8XL/tFyCAa/Z+jCieQ9KD2lfvp/7ppOsu+r3dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896233; c=relaxed/simple;
	bh=2ByaA5g4rWqgw0THnHOFPL2Vc0LUtm2fLm0FNmAKHX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUphBI+xr3r0Bk3ygbffOrTdwJyPjCPU6xav2UITYVIjUVYOjgaDM0KrcmEZ6Mq1GDKipuOBOjZWjGuxGx6PHjaYUvZHAx64k0+qYydjt89w/o6ebIngPwH39DmZMUpztsjwulO04VkxpZeoknqeaC5NYi9H9gtdKMz2mghadYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duhcVSTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duhcVSTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4A8C4CECD;
	Wed,  6 Nov 2024 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896232;
	bh=2ByaA5g4rWqgw0THnHOFPL2Vc0LUtm2fLm0FNmAKHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duhcVSTdK3+TXvUf1VuZCW8wCh00QYqTgpmkHljCzD2OGHlhKfhRuruCyZvTYjT2X
	 wfmbGbJSaM+yOerqFE811LPQd7Z+XVQtmk1zW8VCbmn5uV18E1pYTbYZzxNqBvJIt6
	 P46tYLex/erfsje5QwIbiGbv2llXCEbIDRi29q/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.11 135/245] RISC-V: ACPI: fix early_ioremap to early_memremap
Date: Wed,  6 Nov 2024 13:03:08 +0100
Message-ID: <20241106120322.551324801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

commit 1966db682f064172891275cb951aa8c98a0a809b upstream.

When SVPBMT is enabled, __acpi_map_table() will directly access the
data in DDR through the IO attribute, rather than through hardware
cache consistency, resulting in incorrect data in the obtained ACPI
table.

The log: ACPI: [ACPI:0x18] Invalid zero length.

We do not assume whether the bootloader flushes or not. We should
access in a cacheable way instead of maintaining cache consistency
by software.

Fixes: 3b426d4b5b14 ("RISC-V: ACPI : Fix for usage of pointers in different address space")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Link: https://lore.kernel.org/r/20241014130141.86426-1-cuiyunhui@bytedance.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/acpi.c
+++ b/arch/riscv/kernel/acpi.c
@@ -210,7 +210,7 @@ void __init __iomem *__acpi_map_table(un
 	if (!size)
 		return NULL;
 
-	return early_ioremap(phys, size);
+	return early_memremap(phys, size);
 }
 
 void __init __acpi_unmap_table(void __iomem *map, unsigned long size)
@@ -218,7 +218,7 @@ void __init __acpi_unmap_table(void __io
 	if (!map || !size)
 		return;
 
-	early_iounmap(map, size);
+	early_memunmap(map, size);
 }
 
 void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)


