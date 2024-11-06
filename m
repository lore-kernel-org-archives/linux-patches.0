Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C011F1303;
	Wed,  6 Nov 2024 12:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897586; cv=none; b=U1U5GdGYi3kbvhcHjcZFcdAPjcQ6kYADjZBzvczM0gijelocCcjN+cSLD3IwE1cnq5+cQpexatnoUbDrngvtSWqRU38nNXHyMR69aMiP4PrORLmVaOl6vJPCpmC/fpqvMrqNQfsaUnpbRke+Sqf7+sKVZ+CgFeVqgFKpUJb2n48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897586; c=relaxed/simple;
	bh=k6UWyZ6eZGEipO04OngS/HQo6kvsP8Ezel0egGxEQYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDkxrdbY6lAN9w07FtofohsVeE8qc5ULK6Us12t+6olN4tg4ghYWKlA+pXpB3OCdU1BsPakXXyHlRr5rLYrgb3IvLpakCTxh5zvhUwSU3AukmEhEUg5Rr3XCq/C8sV7DBoDBUqSw0XB1DX42CTF3i1joG7/AzaTvV2D/X72ob4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2ua8FUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2ua8FUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08D4C4CECD;
	Wed,  6 Nov 2024 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897586;
	bh=k6UWyZ6eZGEipO04OngS/HQo6kvsP8Ezel0egGxEQYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2ua8FUj0UvEoCC5FkSdrKJ9xnu0v5mRPOzCh6EdOPSiiPxPTGZebaFoVPdCOyCKO
	 tSspq8Tv09BSsEb7xZ1YXBcdzdA/HsbzkOpv9ZoqMp66cymnwgPVNYUA7mL7Tl74Bz
	 kfymfLl1oLtJOXzk+S1bjXfM+P/q/AH0gzWlv5Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 102/151] RISC-V: ACPI: fix early_ioremap to early_memremap
Date: Wed,  6 Nov 2024 13:04:50 +0100
Message-ID: <20241106120311.683428494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -204,7 +204,7 @@ void __init __iomem *__acpi_map_table(un
 	if (!size)
 		return NULL;
 
-	return early_ioremap(phys, size);
+	return early_memremap(phys, size);
 }
 
 void __init __acpi_unmap_table(void __iomem *map, unsigned long size)
@@ -212,7 +212,7 @@ void __init __acpi_unmap_table(void __io
 	if (!map || !size)
 		return;
 
-	early_iounmap(map, size);
+	early_memunmap(map, size);
 }
 
 void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)


