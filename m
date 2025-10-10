Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD582F531A;
	Fri, 10 Oct 2025 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102593; cv=none; b=NnaTrDs0y/uXQQojsIVl6OVdFZLMOYbyPJ83F6FHiW6nIaytgJ1CISaUBxqZPVS+DnsIANlprT7ZlHd6ofdUfHuSAu8NcisO6C9b5qbMeIXOgX9H1rMgAPUngLofNZi95hZIhF6nmELPlUAjs3IyynTvI+y8756/bQ0bX3gesx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102593; c=relaxed/simple;
	bh=nGZcLgpQaPcq0P9UT52S8oFoyef5ctUAXIUhuOfKw8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFT2LMAZXCpoeyQg8eZvBKBeIeZDwRBaneAPvh6hQP7yO4MZ9F6BP9GOf2DimMgVE1iW3jRE28CLdd19vDKxAG1p2c+jPRffkv6GdK5jwi1m3UjBJe//g6hRFupL0GAfw9kCVWD+mZdayeJw9t50vld08M5wgjQWzRL0KH7wuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx7l/w66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx7l/w66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35446C116C6;
	Fri, 10 Oct 2025 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102593;
	bh=nGZcLgpQaPcq0P9UT52S8oFoyef5ctUAXIUhuOfKw8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xx7l/w66xcMS9eicT7C6IEySupHxHIMid4NP5B8bH2WZSvnLWZYF553jRfsrPBEBc
	 5XaXh8ioCUSDb0vDswuLCxkmmaFu3w3ukcicHKBbxAxKgwnKL/Oo7S/eq+gvoZup0f
	 p37dEloYwZZeR2BIMWgr/3q/fY5lT2gvuM4pxQ3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Han Gao <rabenda.cn@gmail.com>
Subject: [PATCH 6.6 25/28] riscv: mm: Do not restrict mmap address based on hint
Date: Fri, 10 Oct 2025 15:16:43 +0200
Message-ID: <20251010131331.281312603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

commit 2116988d5372aec51f8c4fb85bf8e305ecda47a0 upstream.

The hint address should not forcefully restrict the addresses returned
by mmap as this causes mmap to report ENOMEM when there is memory still
available.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: b5b4287accd7 ("riscv: mm: Use hint address in mmap if available")
Fixes: add2cc6b6515 ("RISC-V: mm: Restrict address space for sv39,sv48,sv57")
Closes: https://lore.kernel.org/linux-kernel/ZbxTNjQPFKBatMq+@ghost/T/#mccb1890466bf5a488c9ce7441e57e42271895765
Link: https://lore.kernel.org/r/20240826-riscv_mmap-v1-3-cd8962afe47f@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[ Adjust removed lines ]
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Tested-by: Han Gao <rabenda.cn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -15,30 +15,12 @@
 
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\
-	unsigned long mmap_end;					\
-	typeof(addr) _addr = (addr);				\
-	if ((_addr) == 0 ||					\
-	    (IS_ENABLED(CONFIG_COMPAT) && is_compat_task()) ||	\
-	    ((_addr + len) > BIT(VA_BITS - 1)))			\
-		mmap_end = STACK_TOP_MAX;			\
-	else							\
-		mmap_end = (_addr + len);			\
-	mmap_end;						\
+	STACK_TOP_MAX;						\
 })
 
 #define arch_get_mmap_base(addr, base)				\
 ({								\
-	unsigned long mmap_base;				\
-	typeof(addr) _addr = (addr);				\
-	typeof(base) _base = (base);				\
-	unsigned long rnd_gap = DEFAULT_MAP_WINDOW - (_base);	\
-	if ((_addr) == 0 ||					\
-	    (IS_ENABLED(CONFIG_COMPAT) && is_compat_task()) ||	\
-	    ((_addr + len) > BIT(VA_BITS - 1)))			\
-		mmap_base = (_base);				\
-	else							\
-		mmap_base = (_addr + len) - rnd_gap;		\
-	mmap_base;						\
+	base;							\
 })
 
 #ifdef CONFIG_64BIT


