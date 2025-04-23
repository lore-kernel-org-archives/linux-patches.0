Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26528CF4F;
	Wed, 23 Apr 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421893; cv=none; b=NIsgDgZsDUbVp3ZCVPXjLLhSIzCIqIsML7aDa6hgorpYEIIwepSLiFTrLoHrfLKcoShdUmJxehqcmQ+b1tH7R0FUHffXMlvDmcKoGR1yWAhd8npFmY56EZEHwPYzPCkdXtcLrYJj3PJnGNYEkOZC4nmpZ+zYcN/37oIC7S3VwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421893; c=relaxed/simple;
	bh=YFErP7mXY/mUSJEWBTCK5kziebZsFLtmJIFquAQrSQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cpt8LiJzlHd770OMcvMSIlRfcCWHIbHlSyNLdUxhjHytEs1tWZvH/3ugAZjFPLn7FEp5otR9SwvSRMU+94gMf6Wu5bwiKCasqRU+LF00mPA4Fgo9QIXiXTs+/LlciLD/r54bvYH6sf/GmKgvNda96Q9bEQ9NwV8ABn+RTMmA1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De1+QLKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De1+QLKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C20C4CEE2;
	Wed, 23 Apr 2025 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421892;
	bh=YFErP7mXY/mUSJEWBTCK5kziebZsFLtmJIFquAQrSQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De1+QLKJXrX5Abyix3Fwf29dug8QWoSI8GYpI2VoxZ1R75ACeORCvLHWqVhDfIFrp
	 7jJZJUseYbEa3DZQzpBEmEXvj1N5nPraBgzzUzupoNYgDZXOsB6kEXgnrUjsGklgoz
	 3GGmOU3TctgpV2cY/Hf4YFArKpymVu24WsA9jtFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/291] riscv: Properly export reserved regions in /proc/iomem
Date: Wed, 23 Apr 2025 16:43:03 +0200
Message-ID: <20250423142632.309499230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit e94eb7ea6f206e229791761a5fdf9389f8dbd183 ]

The /proc/iomem represents the kernel's memory map. Regions marked
with "Reserved" tells the user that the range should not be tampered
with. Kexec-tools, when using the older kexec_load syscall relies on
the "Reserved" regions to build the memory segments, that will be the
target of the new kexec'd kernel.

The RISC-V port tries to expose all reserved regions to userland, but
some regions were not properly exposed: Regions that resided in both
the "regular" and reserved memory block, e.g. the EFI Memory Map. A
missing entry could result in reserved memory being overwritten.

It turns out, that arm64, and loongarch had a similar issue a while
back:

  commit d91680e687f4 ("arm64: Fix /proc/iomem for reserved but not memory regions")
  commit 50d7ba36b916 ("arm64: export memblock_reserve()d regions via /proc/iomem")

Similar to the other ports, resolve the issue by splitting the regions
in an arch initcall, since we need a working allocator.

Fixes: ffe0e5261268 ("RISC-V: Improve init_resources()")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250409182129.634415-1-bjorn@kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/setup.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index 2acf51c235673..f4c3252abce41 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -76,6 +76,9 @@ static struct resource bss_res = { .name = "Kernel bss", };
 static struct resource elfcorehdr_res = { .name = "ELF Core hdr", };
 #endif
 
+static int num_standard_resources;
+static struct resource *standard_resources;
+
 static int __init add_resource(struct resource *parent,
 				struct resource *res)
 {
@@ -149,7 +152,7 @@ static void __init init_resources(void)
 	struct resource *res = NULL;
 	struct resource *mem_res = NULL;
 	size_t mem_res_sz = 0;
-	int num_resources = 0, res_idx = 0;
+	int num_resources = 0, res_idx = 0, non_resv_res = 0;
 	int ret = 0;
 
 	/* + 1 as memblock_alloc() might increase memblock.reserved.cnt */
@@ -213,6 +216,7 @@ static void __init init_resources(void)
 	/* Add /memory regions to the resource tree */
 	for_each_mem_region(region) {
 		res = &mem_res[res_idx--];
+		non_resv_res++;
 
 		if (unlikely(memblock_is_nomap(region))) {
 			res->name = "Reserved";
@@ -230,6 +234,9 @@ static void __init init_resources(void)
 			goto error;
 	}
 
+	num_standard_resources = non_resv_res;
+	standard_resources = &mem_res[res_idx + 1];
+
 	/* Clean-up any unused pre-allocated resources */
 	if (res_idx >= 0)
 		memblock_free(mem_res, (res_idx + 1) * sizeof(*mem_res));
@@ -241,6 +248,33 @@ static void __init init_resources(void)
 	memblock_free(mem_res, mem_res_sz);
 }
 
+static int __init reserve_memblock_reserved_regions(void)
+{
+	u64 i, j;
+
+	for (i = 0; i < num_standard_resources; i++) {
+		struct resource *mem = &standard_resources[i];
+		phys_addr_t r_start, r_end, mem_size = resource_size(mem);
+
+		if (!memblock_is_region_reserved(mem->start, mem_size))
+			continue;
+
+		for_each_reserved_mem_range(j, &r_start, &r_end) {
+			resource_size_t start, end;
+
+			start = max(PFN_PHYS(PFN_DOWN(r_start)), mem->start);
+			end = min(PFN_PHYS(PFN_UP(r_end)) - 1, mem->end);
+
+			if (start > mem->end || end < mem->start)
+				continue;
+
+			reserve_region_with_split(mem, start, end, "Reserved");
+		}
+	}
+
+	return 0;
+}
+arch_initcall(reserve_memblock_reserved_regions);
 
 static void __init parse_dtb(void)
 {
-- 
2.39.5



