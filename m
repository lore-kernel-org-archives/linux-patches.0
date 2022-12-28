Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97011C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB88C433D2;
	Wed, 28 Dec 2022 16:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244516;
	bh=ikyY7hFQfAoJfSwW7zG90mcxPo1soDF1kPd7nODLl9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNnt+lnhF2HdQiuA0BSzomt6TA1SD6gjCgp2InZWwVZilrqNVHTvuRtsN6yu+s9Ii
	 +13sAWVbwSvT6GO6iu4sXNnxQrgrZYzALU5xHUVCAvevWoJxBwKUzslCMvQ7XRB8fu
	 51oEWRfK0l5QWdaJ5A/aBP5a+jjE/V+DKQEK0RXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0678/1146] RISC-V: Fix MEMREMAP_WB for systems with Svpbmt
Date: Wed, 28 Dec 2022 15:36:57 +0100
Message-Id: <20221228144348.561014264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit b91676fc16cd384a81e3af52c641aa61985cc231 ]

Currently, the memremap() called with MEMREMAP_WB maps memory using
the generic ioremap() function which breaks on system with Svpbmt
because memory mapped using _PAGE_IOREMAP page attributes is treated
as strongly-ordered non-cacheable IO memory.

To address this, we implement RISC-V specific arch_memremap_wb()
which maps memory using _PAGE_KERNEL page attributes resulting in
write-back cacheable mapping on systems with Svpbmt.

Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
Co-developed-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20221114090536.1662624-2-apatel@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/io.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/io.h b/arch/riscv/include/asm/io.h
index 92080a227937..42497d487a17 100644
--- a/arch/riscv/include/asm/io.h
+++ b/arch/riscv/include/asm/io.h
@@ -135,4 +135,9 @@ __io_writes_outs(outs, u64, q, __io_pbr(), __io_paw())
 
 #include <asm-generic/io.h>
 
+#ifdef CONFIG_MMU
+#define arch_memremap_wb(addr, size)	\
+	((__force void *)ioremap_prot((addr), (size), _PAGE_KERNEL))
+#endif
+
 #endif /* _ASM_RISCV_IO_H */
-- 
2.35.1



